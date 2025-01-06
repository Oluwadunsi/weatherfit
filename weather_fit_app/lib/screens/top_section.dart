import 'package:flutter/material.dart';

class TopSection extends StatelessWidget {
  final List<String> favoriteLocations;
  final String currentLocation;
  final TextEditingController searchLocation;
  final VoidCallback onSearchPressed;
  final Function(String) onSearchSubmit;
  final ValueChanged<bool> onFavouriteChanged;

  const TopSection({
    super.key,
    required this.favoriteLocations,
    required this.currentLocation,
    required this.searchLocation,
    required this.onSearchPressed,
    required this.onSearchSubmit,
    required this.onFavouriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isFavorited = favoriteLocations.contains(currentLocation);
    return Row(
      children: [
        IconButton(
          icon: Icon(
            isFavorited ? Icons.favorite : Icons.favorite_border,
            color: isFavorited ? Colors.red : null,
          ),
          onPressed: () => onFavouriteChanged(isFavorited),
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
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black)),
                constraints: BoxConstraints.tightFor(height: 40)),
            onSubmitted: onSearchSubmit,
          ),
        ),
      ],
    );
  }
}
