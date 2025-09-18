import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStatusProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  return repo.isLoggedIn();
});

class LoginController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _repo;
  LoginController(this._repo) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _repo.login(email: email, password: password);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      await _repo.loginWithGoogle();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, AsyncValue<void>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LoginController(repo);
});
