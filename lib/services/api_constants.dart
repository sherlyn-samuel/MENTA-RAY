class ApiConstants {
  static const String auth = '/auth';
  static const String players = '/players';
  static const String progress = '/progress';
  static const String user = '/user';
  static const String admin = '/admin';

  // Auth
  static const String login = '$auth/login';
  static const String register = '$auth/register';

  // User
  static const String userProfile = '$user/profile';
  static const String userDashboard = '$user/dashboard';

  // Admin
  static const String adminDashboard = '$admin/dashboard';
  static const String manageUsers = '$admin/manage-users';
}