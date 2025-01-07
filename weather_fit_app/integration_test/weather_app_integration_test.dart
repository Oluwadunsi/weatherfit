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

      // Verify the error message is displayed
      expect(find.text('Invalid City'), findsOneWidget);
      expect(find.text('City not found'), findsOneWidget); // Assuming the app shows this message
    });

    //   testWidgets('Navigate from favorite locations and display data for selected location', (tester) async {
  //     await tester.pumpAndSettle();
  //
  //     // Navigate to favorite locations
  //     final favoriteIcon = find.byIcon(Icons.favorite_border).first;
  //     await tester.tap(favoriteIcon);
  //     await tester.pumpAndSettle();
  //
  //     // Assuming 'Favorites' is a button on the current page after tapping favorite icon
  //     final favoritesButton = find.text('Favorites').first;
  //     await tester.tap(favoritesButton);
  //     await tester.pumpAndSettle();
  //
  //     // Assuming 'Test City' is a text widget in the list of favorite locations
  //     final favoriteLocation = find.text('Test City').first;
  //     expect(favoriteLocation, findsOneWidget, reason: 'Favorite location should be displayed.');
  //
  //     // Tap on the favorite location and check if it navigates correctly
  //     await tester.tap(favoriteLocation);
  //     await tester.pumpAndSettle();
  //
  //     expect(find.text('Test City'), findsOneWidget, reason: 'Selected location data should be displayed on the home page.');
  //     expect(find.text('Clear'), findsOneWidget, reason: 'Selected location weather condition should be displayed.');
  //   });

  });
}
