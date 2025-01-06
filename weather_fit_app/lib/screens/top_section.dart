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
            color: isFavorited ? Colors.red : null,
          ),
          onPressed: () => widget.onFavouriteChanged(isFavorited),
        ),
        Expanded(
          child: TextField(
            controller: widget.searchLocation,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 2),
                prefixIcon: IconButton(
                  onPressed: widget.onSearchPressed,
                  icon: const Icon(Icons.search),
                ),
                hintText: "search city",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black)),
                constraints: BoxConstraints.tightFor(height: 40)),
            onSubmitted: widget.onSearchSubmit,
          ),
        ),
      ],
    );
  }
}
