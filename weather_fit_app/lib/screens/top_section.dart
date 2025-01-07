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
  _TopSectionState createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode(); // Initialize FocusNode
    widget.searchLocation.addListener(_handleTextFieldFocus);
  }

  @override
  void dispose() {
    focusNode.dispose(); // Dispose of the FocusNode
    widget.searchLocation.removeListener(_handleTextFieldFocus);
    super.dispose();
  }

  void _handleTextFieldFocus() {
    if (!focusNode.hasFocus && widget.searchLocation.text.isNotEmpty) {
      focusNode.requestFocus(); // Ensure focus remains consistent
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavorited = widget.favoriteLocations.contains(widget.currentLocation);

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
            focusNode: focusNode, // Attach FocusNode
            decoration: InputDecoration(
              prefixIcon: IconButton(
                onPressed: () {
                  focusNode.requestFocus(); // Ensure the TextField has focus
                  widget.onSearchPressed();
                },
                icon: const Icon(Icons.search),
              ),
              hintText: "Search city",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black),
              ),
              constraints: const BoxConstraints.tightFor(height: 40),
            ),
            onTap: () {
              focusNode.requestFocus(); // Request focus on tap
            },
            onSubmitted: (value) {
              focusNode.unfocus(); // Remove focus after submission
              widget.onSearchSubmit(value);
            },
          ),
        ),
      ],
    );
  }
}
