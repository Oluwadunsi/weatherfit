import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:weather_fit_app/main.dart' as app;
import 'package:weather_fit_app/test/mocks/mock_weather_service_integration.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Weather App Integration Tests', () {
    final mockService = MockWeatherServiceIntegration();

    setUp(() async {
      GeolocatorPlatform.instance = MockGeolocatorPlatformIntegration(); // Inject the mock geolocator
    });

    // 1. Fetch and display weather data for a valid city
    testWidgets('Fetch and display weather data for a valid city', (tester) async {
      app.main(service: mockService); // Launch app with mocked service
      await tester.pumpAndSettle(); // Wait for initial UI to render

      // Verify app title
      final appTitle = find.text('Weather Styles');
      expect(appTitle, findsOneWidget, reason: 'The app title should be displayed');

      // Enter a valid city name
      final cityInputField = find.byType(TextField);
      await tester.enterText(cityInputField, 'New York');
      await tester.pumpAndSettle();

      // Tap the search button
      final searchIcon = find.byIcon(Icons.search);
      await tester.tap(searchIcon);
      await tester.pumpAndSettle();

      // Verify weather data for "New York"
      expect(find.text('New York'), findsOneWidget, reason: 'City name should be displayed');
      expect(find.text('Clouds'), findsOneWidget, reason: 'Weather condition should be displayed');
    });

    // 2. Display error for an invalid city name
    testWidgets('Display error for an invalid city name', (tester) async {
      app.main(service: mockService); // Launch app with mocked service
      await tester.pumpAndSettle(); // Wait for initial UI to render

      // Verify the app title
      expect(find.text('Weather Styles'), findsOneWidget);

      // Enter an invalid city name
      final cityInputField = find.byType(TextField);
      await tester.enterText(cityInputField, 'Invalid City');
      await tester.pumpAndSettle();

      // Tap the search button
      final searchIcon = find.byIcon(Icons.search);
      await tester.tap(searchIcon);
      await tester.pumpAndSettle();

      // Verify the Snackbar message is displayed
      expect(find.text('Location does not exist. Please try again.'), findsOneWidget);

      // Verify the latest location weather data is still displayed
      expect(find.text('New York'), findsOneWidget); // Replace 'New York' with your latest location if different
      expect(find.text('Clouds'), findsOneWidget);  // Replace 'Clouds' with your actual condition if different
    });

    // 3. Add and remove favorite locations
    testWidgets('Add and remove favorite locations', (tester) async {
      app.main(service: mockService);
      await tester.pumpAndSettle();

      // Add to favorites
      final heartIcon = find.byIcon(Icons.favorite_border);
      await tester.tap(heartIcon);
      await tester.pumpAndSettle();

      // Open the drawer to verify "New York" in favorites
      final drawerButton = find.byIcon(Icons.menu);
      await tester.tap(drawerButton);
      await tester.pumpAndSettle();

      // Verify "New York" appears in favorites
      final favoriteLocation = find.text('New York').at(1); // Use position if ambiguous
      expect(favoriteLocation, findsOneWidget);

      // Remove "New York" from favorites
      final deleteButton = find.descendant(
        of: find.ancestor(of: favoriteLocation, matching: find.byType(ListTile)),
        matching: find.byIcon(Icons.delete),
      );
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Verify "New York" is removed from favorites
      expect(find.text('New York'), findsNWidgets(1)); // Ensure one remains in a different context
    });

    // 4. Navigate to a favorite location
    testWidgets('Navigate to a favorite location', (tester) async {
      app.main(service: mockService); // Relaunch app to reset state
      await tester.pumpAndSettle(); // Wait for initial UI to render

      // Add "New York" back to favorites for testing navigation
      final heartIcon = find.byIcon(Icons.favorite_border);
      await tester.tap(heartIcon);
      await tester.pumpAndSettle();

      // Open the drawer
      final drawerButton = find.byIcon(Icons.menu);
      expect(drawerButton, findsOneWidget, reason: 'Drawer button should be present');
      await tester.tap(drawerButton);
      await tester.pumpAndSettle();

      // Verify "New York" is in the favorites list
      final favoriteLocationFinder = find.descendant(
        of: find.byType(ListTile),
        matching: find.text('New York'),
      );
      expect(favoriteLocationFinder, findsOneWidget, reason: 'Favorite location should be displayed');

      // Tap "New York" in the favorites list
      await tester.tap(favoriteLocationFinder);
      await tester.pumpAndSettle();

      // Verify weather data for "New York"
      expect(find.text('New York'), findsOneWidget, reason: 'City name should be displayed');
      expect(find.text('Clouds'), findsOneWidget, reason: 'Weather condition should be displayed');
    });
  });
}
