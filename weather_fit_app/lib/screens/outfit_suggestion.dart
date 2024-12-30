import 'package:flutter/material.dart';

class OutfitSuggestion extends StatelessWidget {
  const OutfitSuggestion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        "Outfit Suggestion: Wear a light T-shirt and sunglasses.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
