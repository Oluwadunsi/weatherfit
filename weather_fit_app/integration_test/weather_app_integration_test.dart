import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:weather_fit_app/main.dart' as app;
import 'package:weather_fit_app/test/mocks/mock_weather_service.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Weather App Integration Tests', () {
    final mockService = MockWeatherService();

    testWidgets('Fetch and display weather data for a valid city', (tester) async {
      app.main(service: mockService);
      await tester.pumpAndSettle();

      expect(find.text('Weather Styles'), findsOneWidget);

      final cityInputField = find.byType(TextField);
      await tester.enterText(cityInputField, 'Test City');
      await tester.pumpAndSettle();

      final searchIcon = find.byIcon(Icons.search).first;
      await tester.tap(searchIcon);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Test City'), findsOneWidget);
      expect(find.text('Clear'), findsOneWidget);
    });



    testWidgets('Navigate from favorite locations and display data for selected location', (tester) async {
      app.main(service: mockService);
      await tester.pumpAndSettle();

      final favoriteIcon = find.byIcon(Icons.favorite_border).first;
      await tester.tap(favoriteIcon);
      await tester.pumpAndSettle();

      final favoritesButton = find.text('Favorites').first;
      await tester.tap(favoritesButton);
      await tester.pumpAndSettle();

      final favoriteLocation = find.text('Test City').first;
      expect(favoriteLocation, findsOneWidget, reason: 'Favorite location should be displayed.');

      await tester.tap(favoriteLocation);
      await tester.pumpAndSettle();

      expect(find.text('Test City'), findsOneWidget, reason: 'Selected location data should be displayed on the home page.');
      expect(find.text('Clear'), findsOneWidget, reason: 'Selected location weather condition should be displayed.');
    });
  });
}
