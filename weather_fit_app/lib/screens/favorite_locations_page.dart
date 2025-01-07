import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_fit_app/screens/weather_home_page.dart';

import '../bloc/app_state.dart';

class FavoriteLocationsPage extends ConsumerWidget {
  const FavoriteLocationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var app = ref.watch(appState);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favourite Locations",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<String>>(
        future: SharedPreferences.getInstance()
            .then((prefs) => prefs.getStringList("favourite") ?? []),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final favorites = snapshot.data ?? [];

          return favorites.isEmpty
              ? Center(
            child: Text(
              "No favorite locations added yet.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final location = favorites[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Colors.blue,
                  ),
                  title: Text(
                    location,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.blueGrey),
                    onPressed: () {
                      app.removeFavourite(location);
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => WeatherHomePage(
                          city: location,
                        ),
                      ),
                          (route) => false,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
