import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_app/auth/auth_repository.dart';

part 'auth_notifier.g.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
}

class AuthState {
  final AuthStatus status;
  final String? error;

  AuthState({required this.status, this.error});

  AuthState copyWith({AuthStatus? status, String? error}) {
    return AuthState(
      status: status ?? this.status,
      error: error,
    );
  }
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<AuthState> build() async {
    final isAuthenticated = await ref.read(authRepositoryProvider).isAuthenticated();
    return AuthState(
      status: isAuthenticated ? AuthStatus.authenticated : AuthStatus.unauthenticated,
    );
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).login(email, password);
      return AuthState(status: AuthStatus.authenticated);
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).logout();
      return AuthState(status: AuthStatus.unauthenticated);
    });
  }

  Future<void> register(String email, String password, String accountName) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).register(email, password, accountName);
      // After registration, we might want to log in automatically or redirect to login
      return AuthState(status: AuthStatus.unauthenticated);
    });
  }

  Future<void> forgotPassword(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).forgotPassword(email);
      return state.value!;
    });
  }
}
