/// Route constants and app-wide configuration constants.
class AppRoutes {
  AppRoutes._();

  static const String feed = '/';
  static const String search = '/search';
  static const String createListing = '/create-listing';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
}

/// App metadata, API endpoints, and UI text constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'Expert Listing';
  static const String sharePrompt = 'Share a property, Make a request or say something...';
  static const String yourStoryLabel = 'Your Story';
  static const String filtersLabel = 'Filters';
  static const String defaultLocation = 'Lekki Phase 1, Lagos';
  static const String logoPath = 'assets/images/logo.png';

  /// Node.js Backend Base API URL (configurable via `--dart-define=API_BASE_URL=...`)
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://realtor-backend-service.onrender.com/api',
  );

  /// Default test user ID for authenticated assessment interactions
  static const String defaultUserId = '11111111-1111-1111-1111-111111111111';
}
