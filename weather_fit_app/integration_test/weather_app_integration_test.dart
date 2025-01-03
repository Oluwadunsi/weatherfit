import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:weather_fit_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Weather App Integration Tests', () {
    testWidgets('Fetch and display weather data for a valid city', (tester) async {
      // Start the app with mock service
      app.main();
      await tester.pumpAndSettle();

      // Check if the main screen is displayed
      expect(find.text('Weather Styles'), findsOneWidget);

      // Enter a valid city name
      final cityInputField = find.byType(TextField);
      await tester.enterText(cityInputField, 'Test City');
      await tester.pumpAndSettle();

      // Trigger fetch
      final searchIcon = find.byIcon(Icons.search).first;
      await tester.tap(searchIcon);
      await tester.pumpAndSettle();

      // Check that weather data is displayed
      expect(find.text('Test City'), findsOneWidget);
      expect(find.text('Clear'), findsOneWidget);
    });
  });
}
