import 'package:flutter/material.dart';

class TopSection extends StatelessWidget {
  final ValueNotifier<List<String>> favoriteLocations;
  final String currentLocation;
  final TextEditingController searchLocation;
  final VoidCallback onSearchPressed;
  final Function(String) onSearchSubmit;

  const TopSection({
    Key? key,
    required this.favoriteLocations,
    required this.currentLocation,
    required this.searchLocation,
    required this.onSearchPressed,
    required this.onSearchSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder<List<String>>(
          valueListenable: favoriteLocations,
          builder: (_, favorites, __) {
            final isFavorited = favorites.contains(currentLocation);
            return IconButton(
              icon: Icon(
                isFavorited ? Icons.favorite : Icons.favorite_border,
                color: isFavorited ? Colors.red : null,
              ),
              onPressed: () {
                if (isFavorited) {
                  favorites.remove(currentLocation);
                } else {
                  favorites.add(currentLocation);
                }
                favoriteLocations.notifyListeners();
              },
            );
          },
        ),
        Expanded(
          child: TextField(
            controller: searchLocation,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                onPressed: onSearchPressed,
                icon: const Icon(Icons.search),
              ),
              hintText: "search city",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onSubmitted: onSearchSubmit,
          ),
        ),
      ],
    );
  }
}
