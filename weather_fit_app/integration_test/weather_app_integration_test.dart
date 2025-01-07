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

    setUpAll(() {
      GeolocatorPlatform.instance = MockGeolocatorPlatformIntegration(); // Inject the mock geolocator
    });

    testWidgets('Fetch and display weather data for a valid city', (tester) async {
      app.main(service: mockService); // Pass the mocked service
      await tester.pumpAndSettle();

      // Verify the app title
      expect(find.text('Weather Styles'), findsOneWidget);

      // Enter a valid city name
      final cityInputField = find.byType(TextField);
      await tester.enterText(cityInputField, 'New York');
      await tester.pumpAndSettle();

      // Tap the search button
      final searchIcon = find.byIcon(Icons.search);
      await tester.tap(searchIcon);
      await tester.pumpAndSettle();

      // Verify the weather data for New York
      expect(find.text('New York'), findsOneWidget);
      expect(find.text('Clouds'), findsOneWidget);
    });

    testWidgets('Display error for an invalid city name', (tester) async {
      app.main(service: mockService); // Pass the mocked service
      await tester.pumpAndSettle();

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

    testWidgets('Add and remove favorite locations', (tester) async {
      app.main(service: mockService); // Pass the mocked service
      await tester.pumpAndSettle();

      // Add the current location to favorites
      final favoriteIcon = find.byIcon(Icons.favorite_border);
      expect(favoriteIcon, findsOneWidget);

      await tester.tap(favoriteIcon);
      await tester.pumpAndSettle();

      // Verify the location is now a favorite
      final favoritedIcon = find.byIcon(Icons.favorite);
      expect(favoritedIcon, findsOneWidget);

      // Open the Favorite Locations page
      final drawerButton = find.byTooltip('Open navigation menu');
      await tester.tap(drawerButton);
      await tester.pumpAndSettle();

      final favoritesPageTitle = find.text('Favourite Locations');
      expect(favoritesPageTitle, findsOneWidget);

      // Verify the favorite location is listed
      final favoriteLocation = find.text('New York');
      expect(favoriteLocation, findsOneWidget);

      // Remove the location from favorites
      final deleteButton = find.byIcon(Icons.delete).first;
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Ensure the location is removed
      expect(find.text('New York'), findsNothing);
    });

    testWidgets('Navigate to a favorite location', (tester) async {
      app.main(service: mockService); // Pass the mocked service
      await tester.pumpAndSettle();

      // Open the Favorite Locations page
      final drawerButton = find.byTooltip('Open navigation menu');
      await tester.tap(drawerButton);
      await tester.pumpAndSettle();

      final favoritesPageTitle = find.text('Favourite Locations');
      expect(favoritesPageTitle, findsOneWidget);

      // Tap on a favorite location
      final favoriteLocation = find.text('New York');
      await tester.tap(favoriteLocation);
      await tester.pumpAndSettle();

      // Verify navigation to the WeatherHomePage with the selected location
      final locationTitle = find.text('New York');
      expect(locationTitle, findsOneWidget);
    });
  });
}
