import 'dart:convert';

import 'package:my_app/core/backend/ddp_client.dart';
import 'package:my_app/core/backend/method_names.dart';

/// DataSource gọi trực tiếp Meteor Methods qua DDP
class CourseRemoteDataSource {
  final DdpClient _ddp;
  CourseRemoteDataSource(this._ddp);

  /// Lấy danh sách course cho trang home
  /// category: danh sách slug category (tạm thời truyền rỗng để server tự xử lý nếu cho phép)
  Future<List<Map<String, dynamic>>> getHomeCourses({List<String> category = const []}) async {
    final result = await _ddp.callMethod(
      MethodNames.getHomeCourses,
      params: {
        'category': category,
      },
    );
    if (!result.isSuccess) {
      throw result.error!;
    }
    final data = result.result;
    if (data is List) {
      return data.map((e) => _asMap(e)).toList();
    }
    // fallback nếu payload dạng {list: [...]}
    if (data is Map && data['list'] is List) {
      return (data['list'] as List).map((e) => _asMap(e)).toList();
    }
    return [];
  }

  Map<String, dynamic> _asMap(dynamic e) {
    if (e is Map<String, dynamic>) return e;
    if (e is Map) return e.map((k, v) => MapEntry(k.toString(), v));
    // cố thử parse nếu là json string (ít gặp)
    if (e is String) {
      try {
        final decoded = json.decode(e);
        if (decoded is Map<String, dynamic>) return decoded;
      } catch (_) {}
    }
    return {};
  }
}
