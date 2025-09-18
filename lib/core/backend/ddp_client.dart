import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

/// Trạng thái kết nối DDP
enum DdpConnectionState { disconnected, connecting, connected }

/// Sự kiện kết nối đơn giản cho listener
class DdpConnectionEvent {
  final DdpConnectionState state;
  final String? reason;
  const DdpConnectionEvent(this.state, {this.reason});
}

/// Kết quả gọi method
class DdpMethodResult {
  final dynamic result;
  final DdpMethodError? error;
  const DdpMethodResult({this.result, this.error});
  bool get isSuccess => error == null;
}

class DdpMethodError implements Exception {
  final int? code; // Meteor error code
  final String? reason;
  final dynamic details;
  final String? message;
  DdpMethodError({this.code, this.reason, this.details, this.message});
  @override
  String toString() => 'DdpMethodError(code: $code, reason: $reason, message: $message, details: $details)';
}

/// DDP Client tối giản (method calls) – chưa hỗ trợ subscription
class DdpClient {
  final String rootUrl; // vd: coding.hoola.vn
  final Duration connectTimeout;
  final Duration methodTimeout;
  final bool secure; // wss nếu true

  WebSocketChannel? _channel;
  int _nextId = 0;
  final _pending = <String, Completer<DdpMethodResult>>{};
  final _connectionController = StreamController<DdpConnectionEvent>.broadcast();
  Timer? _reconnectTimer;
  bool _manuallyClosed = false;

  DdpClient({
    required this.rootUrl,
    this.connectTimeout = const Duration(seconds: 10),
    this.methodTimeout = const Duration(seconds: 20),
    this.secure = true,
  });

  Stream<DdpConnectionEvent> get connectionStream => _connectionController.stream;
  bool get isConnected => _channel != null;

  Future<void> connect() async {
    if (isConnected) return;
    _manuallyClosed = false;
    _emit(DdpConnectionState.connecting);
    final scheme = secure ? 'wss' : 'ws';
    final uri = Uri.parse('$scheme://$rootUrl/websocket');
    try {
      final channel = WebSocketChannel.connect(uri);
      _channel = channel;
      channel.stream.listen(_handleMessage, onDone: _onDone, onError: (e, st) {
        _emit(DdpConnectionState.disconnected, reason: e.toString());
        _scheduleReconnect();
      });
      // Gửi gói connect theo spec DDP
      _sendJson({
        'msg': 'connect',
        'version': '1',
        'support': ['1', 'pre2', 'pre1']
      });
      // Chờ ready (msg: connected)
      await _waitForConnected();
      _emit(DdpConnectionState.connected);
    } catch (e) {
      _emit(DdpConnectionState.disconnected, reason: e.toString());
      _scheduleReconnect();
      rethrow;
    }
  }

  Future<void> _waitForConnected() async {
    // Timeout nếu không nhận được msg connected
    final completer = Completer<void>();
    late StreamSubscription sub;
    sub = connectionStream.listen((event) {
      if (event.state == DdpConnectionState.connected && !completer.isCompleted) {
        completer.complete();
      }
    });
    // Nếu server phản hồi 'connected' trước khi lắng nghe => đã emit – kiểm tra nhanh
    if (_channel == null) {
      sub.cancel();
      throw StateError('Channel closed unexpectedly');
    }
    return completer.future.timeout(connectTimeout, onTimeout: () {
      sub.cancel();
      throw TimeoutException('DDP connect timeout');
    }).whenComplete(() => sub.cancel());
  }

  void _emit(DdpConnectionState state, {String? reason}) {
    _connectionController.add(DdpConnectionEvent(state, reason: reason));
  }

  Future<DdpMethodResult> callMethod(String method, {dynamic params}) async {
    if (!isConnected) {
      await connect();
    }
    final id = (++_nextId).toString();
    final payload = {
      'msg': 'method',
      'method': method,
      'id': id,
      if (params != null) 'params': params is List ? params : [params],
    };
    final completer = Completer<DdpMethodResult>();
    _pending[id] = completer;
    _sendJson(payload);
    return completer.future.timeout(methodTimeout, onTimeout: () {
      if (!completer.isCompleted) {
        _pending.remove(id);
        completer.complete(DdpMethodResult(error: DdpMethodError(reason: 'Timeout', message: 'Method $method timeout')));
      }
      return completer.future; // value ignored
    });
  }

  void _handleMessage(dynamic data) {
    try {
      if (data is String) {
        final msg = json.decode(data);
        if (msg is Map<String, dynamic>) {
          final type = msg['msg'];
          switch (type) {
            case 'connected':
              // already handled by _waitForConnected listener via emit
              // But ensure emit (in case connect came before listener)
              _emit(DdpConnectionState.connected);
              break;
            case 'result':
              final id = msg['id']?.toString();
              final completer = _pending.remove(id);
              if (completer != null && !completer.isCompleted) {
                if (msg['error'] != null) {
                  final err = msg['error'];
                  completer.complete(DdpMethodResult(
                    error: DdpMethodError(
                      code: err['error'] is int ? err['error'] : null,
                      reason: err['reason']?.toString(),
                      details: err['details'],
                      message: err['message']?.toString(),
                    ),
                  ));
                } else {
                  completer.complete(DdpMethodResult(result: msg['result']));
                }
              }
              break;
            case 'updated':
              // ignore for now (ack of methods)
              break;
            case 'ping':
              _sendJson({'msg': 'pong', if (msg['id'] != null) 'id': msg['id']});
              break;
            case 'error':
              // General error frame (rare) – log
              break;
            default:
              // ignore other (added/changed/removed) – subscriptions not implemented yet
              break;
          }
        }
      }
    } catch (e) {
      // swallow parse errors for now; could propagate via a logger
    }
  }

  void _onDone() {
    _channel = null;
    if (!_manuallyClosed) {
      _emit(DdpConnectionState.disconnected, reason: 'Socket closed');
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_manuallyClosed) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), () {
      if (!_manuallyClosed) {
        connect();
      }
    });
  }

  void _sendJson(Map<String, dynamic> map) {
    final text = json.encode(map);
    _channel?.sink.add(text);
  }

  Future<void> close() async {
    _manuallyClosed = true;
    _reconnectTimer?.cancel();
    try {
      await _channel?.sink.close(status.normalClosure);
    } catch (_) {}
    _channel = null;
    // Fail pending
    for (final c in _pending.values) {
      if (!c.isCompleted) {
  c.complete(DdpMethodResult(error: DdpMethodError(reason: 'Client closed')));
      }
    }
    _pending.clear();
    _emit(DdpConnectionState.disconnected, reason: 'Closed by client');
  }
}
