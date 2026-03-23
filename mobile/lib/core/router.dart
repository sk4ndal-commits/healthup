import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_app/auth/auth_notifier.dart';
import 'package:mobile_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:mobile_app/features/auth/presentation/pages/login_page.dart';
import 'package:mobile_app/features/auth/presentation/pages/register_page.dart';
import 'package:mobile_app/features/home/presentation/home_page.dart';
import 'package:mobile_app/features/todo/presentation/pages/todo_list_page.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final status = authState.value?.status;

      if (status == null || status == AuthStatus.initial) return null;

      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register' || state.matchedLocation == '/forgot-password';

      if (status == AuthStatus.unauthenticated) {
        return isLoggingIn ? null : '/login';
      }

      if (status == AuthStatus.authenticated && isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/todos',
        builder: (context, state) => const TodoListPage(),
      ),
    ],
  );
}
