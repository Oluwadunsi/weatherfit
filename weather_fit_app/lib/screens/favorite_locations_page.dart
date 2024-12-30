import 'package:flutter/material.dart';

class FavoriteLocationsPage extends StatelessWidget {
  final ValueNotifier<List<String>> favoriteLocations;
  final Function(String) onRemove;

  const FavoriteLocationsPage({
    Key? key,
    required this.favoriteLocations,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Locations"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.blue[50], // Subtle background color
        child: ValueListenableBuilder<List<String>>(
          valueListenable: favoriteLocations,
          builder: (context, locations, child) {
            return locations.isEmpty
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
              itemCount: locations.length,
              itemBuilder: (context, index) {
                final location = locations[index];
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
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        onRemove(location);
                        favoriteLocations.notifyListeners();
                      },
                    ),
                    onTap: () {
                      // Navigate to the weather page for the selected location
                      Navigator.pop(context, location);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
