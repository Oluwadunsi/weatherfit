import 'package:flutter/material.dart';

class TopSection extends StatelessWidget {
  final List<String> favoriteLocations;
  final String currentLocation;
  final TextEditingController searchLocation;
  final VoidCallback onSearchPressed;
  final Function(String) onSearchSubmit;
  final ValueChanged<bool> onFavouriteChanged;
  final Function(String) onInputChanged; // New callback
  final List<String> citySuggestions; // New prop
  final bool isLoadingSuggestions; // New prop

  const TopSection({
    super.key,
    required this.favoriteLocations,
    required this.currentLocation,
    required this.searchLocation,
    required this.onSearchPressed,
    required this.onSearchSubmit,
    required this.onFavouriteChanged,
    required this.onInputChanged,
    required this.citySuggestions,
    required this.isLoadingSuggestions,
  });

  @override
  Widget build(BuildContext context) {
    final isFavorited = favoriteLocations.contains(currentLocation);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                  hintText: "Search city",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  constraints: const BoxConstraints.tightFor(height: 40),
                ),
                onChanged: onInputChanged,
                onSubmitted: onSearchSubmit,
              ),
            ),
          ],
        ),
        if (isLoadingSuggestions)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        if (citySuggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: citySuggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(citySuggestions[index]),
                  onTap: () {
                    searchLocation.text = citySuggestions[index];
                    onSearchPressed();
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
