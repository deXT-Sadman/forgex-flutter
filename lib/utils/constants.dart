class ApiConfig {
  // TODO: replace with wherever your friend's backend is actually running —
  // see "How to actually connect" below for the right value depending on
  // emulator / physical device / deployed server.
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String signupEndpoint = '$baseUrl/auth/signup';
  static const String forgotPasswordEndpoint =
      '$baseUrl/auth/forget-password'; // 👈 matches backend spelling
  static const String updateProfileEndpoint =
      '$baseUrl/users/me'; // 👈 no userId suffix now

  static const String tasksEndpoint = '$baseUrl/tasks';

  static const Duration requestTimeout = Duration(seconds: 12);
}

/// SharedPreferences keys used across the app for offline support.
class PrefsKeys {
  static const String authToken = 'auth_token';
  static const String currentUser = 'current_user';
  static const String cachedTasks = 'cached_tasks';
  static const String themeMode = 'theme_mode';
  static const String pendingTaskOps = 'pending_task_ops';
}

class AppStrings {
  static const String appName = 'ForgeX';
  static const String tagline = 'Plan it. Do it. ForgeX.';
}
