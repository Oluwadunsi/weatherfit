import 'package:flutter/material.dart';

class TopSection extends StatefulWidget {
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
  State<TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection> {
  @override
  Widget build(BuildContext context) {
    final isFavorited =
    widget.favoriteLocations.contains(widget.currentLocation);
    return Row(
      children: [
        IconButton(
          icon: Icon(
            isFavorited ? Icons.favorite : Icons.favorite_border,
            color: isFavorited
                ? const Color(0xFFB20000) // Custom red color
                : const Color(0xD6D6D6FF), // Custom grey color
          ),
          onPressed: () {
            widget.onFavouriteChanged(isFavorited);
            setState(() {}); // Force rebuild after favorite toggle
          },
        ),
        Expanded(
          child: TextField(
            controller: widget.searchLocation,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 2),
              prefixIcon: IconButton(
                onPressed: widget.onSearchPressed,
                icon: const Icon(Icons.search),
              ),
              hintText: "Search Your City",
              hintStyle: const TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white60),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              constraints: const BoxConstraints.tightFor(height: 40),
            ),
            onSubmitted: widget.onSearchSubmit,
          ),
        ),
      ],
    );
  }

}