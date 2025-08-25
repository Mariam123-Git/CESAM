import 'package:flutter/material.dart';
import 'package:cesam_app/features/auth/presentation/pages/login_page.dart';
import 'package:cesam_app/features/auth/presentation/pages/otp_page.dart';
import 'package:cesam_app/features/auth/presentation/pages/signup_page.dart';
import 'package:cesam_app/features/home/presentation/pages/home_page.dart';
import 'package:cesam_app/features/home/presentation/pages/network_admin_page.dart';
import 'package:cesam_app/features/home/presentation/pages/opportunities_page.dart';
import 'package:cesam_app/features/home/presentation/pages/courses_page.dart';
import 'package:cesam_app/features/home/presentation/pages/Eventdetails.dart';
import 'package:cesam_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:cesam_app/features/auth/presentation/pages/reset_password_page.dart';
import 'package:cesam_app/features/profile/presentation/pages/profile_page.dart';
import 'package:cesam_app/features/auth/presentation/pages/startup_page.dart';
import 'package:cesam_app/features/auth/presentation/pages/chatBot.dart';
import 'package:cesam_app/Dashboard.dart';

class AppRouter {
  static const String startup = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String dashboard = '/dashboard';
  static const String chatbot = '/chatbot';
  static const String courses = '/courses';
  static const String opportunities = '/opportunities';
  static const String networkAdmin = '/network-admin';
  static const String eventDetails = '/event-details';
  static const String forgotPassword = '/forgot_password';
  static const String resetPassword = '/reset_password';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case startup:
        return MaterialPageRoute(builder: (_) => const StartupPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case otp:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) =>
              OtpPage(email: args?['email'], message: args?['message']),
        ); // <-- point-virgule ajouté ici
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case dashboard:
        return MaterialPageRoute(builder: (_) => DashboardPage());
      case chatbot:
        return MaterialPageRoute(builder: (_) => const ChatbotScreen());
      case courses:
        return MaterialPageRoute(builder: (_) => const CoursesPage());

      case opportunities:
        return MaterialPageRoute(builder: (_) => const OpportunitiesPage());

      case networkAdmin:
        return MaterialPageRoute(builder: (_) => const NetworkAdminPage());
      case eventDetails:
        return MaterialPageRoute(builder: (_) => const EventsPage());

      // page "mot de passe oublié"
      case forgotPassword:
      return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());

    // page "reset password"
    case resetPassword:
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => ResetPasswordPage(email: args['email']),
      );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
