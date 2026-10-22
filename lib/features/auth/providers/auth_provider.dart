import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final User? user;

  AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
  });
}
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(AuthState());

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = AuthState(isLoading: true);
    try {
      final user = await _authRepository.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );
      state = AuthState(user: user);
    } catch (e) {
      state = AuthState(errorMessage: e.toString());
    }
  }
  Future<void> login({required String email, required String password}) async {
    state = AuthState(isLoading: true);
    try {
      final user = await _authRepository.login(email: email, password: password);
      state = AuthState(user: user);
    } catch (e) {
      state = AuthState(errorMessage: e.toString());
    }
  }
  Future<void> logout() async {
    await _authRepository.logout();
    state = AuthState();
  }
}
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthNotifier(authRepository);
});

