import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_app/auth/auth_notifier.dart';
import 'package:mobile_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:mobile_app/features/auth/presentation/pages/login_page.dart';
import 'package:mobile_app/features/auth/presentation/pages/register_page.dart';
import 'package:mobile_app/features/home/presentation/home_page.dart';
import 'package:mobile_app/features/profile/presentation/pages/create_profile_page.dart';
import 'package:mobile_app/features/profile/presentation/pages/profile_page.dart';
import 'package:mobile_app/features/profile/presentation/profile_notifier.dart';
import 'package:mobile_app/features/plan/presentation/plan_notifier.dart';
import 'package:mobile_app/features/plan/presentation/pages/plan_confirmation_page.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final authState = ref.watch(authNotifierProvider);
  final profileState = ref.watch(profileNotifierProvider);
  final planState = ref.watch(planNotifierProvider);

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

      // Redirect to profile creation if no profile exists yet
      final isCreatingProfile = state.matchedLocation == '/profile/create';
      if (!isCreatingProfile && profileState.hasValue && profileState.value == null) {
        return '/profile/create';
      }

      // If profile exists but no plan, redirect to confirmation (which should generate it)
      // US-F2.1 Acceptance Criteria: Every onboarded user gets a generated weekly plan.
      final isPlanConfirmation = state.matchedLocation == '/profile/plan-confirmation';
      if (profileState.value != null && planState.hasValue && planState.value == null && !isPlanConfirmation && !isCreatingProfile) {
        return '/profile/plan-confirmation';
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
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/profile/create',
        builder: (context, state) => const CreateProfilePage(),
      ),
      GoRoute(
        path: '/profile/plan-confirmation',
        builder: (context, state) => const PlanConfirmationPage(),
      ),
    ],
  );
}
