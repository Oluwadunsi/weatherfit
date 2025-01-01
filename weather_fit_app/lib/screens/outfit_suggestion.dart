import 'dart:math';
import 'package:flutter/material.dart';

class OutfitSuggestion extends StatelessWidget {
  final double temperature;
  final String weatherCondition;

  OutfitSuggestion({Key? key, required this.temperature, required this.weatherCondition}) : super(key: key);

  // Define temperature and weather-based suggestions
  final Map<String, Map<String, List<Map<String, String>>>> outfitSuggestions = {
    "cold": {
      "rain": [
        {"suggestion": "Wear a raincoat and scarf.", "avatar": "../../assets/rainy_cold_avatar.jpeg"},
        {"suggestion": "Carry an umbrella and wear warm waterproof boots.", "avatar": "../../assets/rainy_cold_avatar.jpeg"},
      ],
      "snow": [
        {"suggestion": "Wear insulated gloves and snow boots.", "avatar": "../../assets/snowy_cold_avatar.jpeg"},
      ],
      "clouds": [
        {"suggestion": "Wear a heavy jacket and scarf.", "avatar": "../../assets/cloudy_cold_avatar.jpeg"},
      ],
      "general": [
        {"suggestion": "Wear a warm coat and gloves.", "avatar": "../../assets/cold_general_avatar.jpeg"},
      ],
    },
    "cool": {
      "clear": [
        {"suggestion": "Wear a light sweater or hoodie.", "avatar": "../../assets/clear_cool_avatar.jpeg"},
      ],
      "clouds": [
        {"suggestion": "Layer up with a jacket.", "avatar": "../../assets/cloudy_cold_avatar.jpeg"},
      ],
      "rain": [
        {"suggestion": "Carry an umbrella and wear waterproof shoes.", "avatar": "../../assets/rainy_cold_avatar.jpeg"},
      ],
      "general": [
        {"suggestion": "Layer up with a light jacket.", "avatar": "../../assets/clear_cool_avatar.jpeg"},
      ],
    },
    "warm": {
      "clear": [
        {"suggestion": "Wear a T-shirt, shorts, and sunglasses.", "avatar": "../../assets/sunny_warm_avatar.jpeg"},
      ],
      "rain": [
        {"suggestion": "Wear a light raincoat.", "avatar": "../../assets/rainy_warm_avatar.jpeg"},
      ],
      "general": [
        {"suggestion": "Light clothing is recommended.", "avatar": "../../assets/warm_general_avatar.jpeg"},
      ],
    },
    "hot": {
      "clear": [
        {"suggestion": "Light cotton clothing and sunscreen recommended.", "avatar": "../../assets/sunny_hot_avatar.jpeg"},
      ],
      "rain": [
        {"suggestion": "Light waterproof gear to stay cool.", "avatar": "../../assets/rainy_hot_avatar.jpeg"},
      ],
      "general": [
        {"suggestion": "Stay hydrated and wear breathable clothing.", "avatar": "../../assets/hot_general_avatar.jpeg"},
      ],
    },
  };

  String getTemperatureCategory(double temperature) {
    if (temperature < 10) return "cold";
    if (temperature < 20) return "cool";
    if (temperature < 30) return "warm";
    return "hot";
  }

  Map<String, String> getOutfitSuggestion(double temperature, String weatherCondition) {
    final tempCategory = getTemperatureCategory(temperature);

    // Primary category suggestion
    final primarySuggestions = outfitSuggestions[tempCategory]?[weatherCondition.toLowerCase()] ?? [];

    if (primarySuggestions.isNotEmpty) {
      return primarySuggestions[Random().nextInt(primarySuggestions.length)];
    }

    // Fallback to general suggestions for the current category
    final generalSuggestions = outfitSuggestions[tempCategory]?["general"] ?? [];
    if (generalSuggestions.isNotEmpty) {
      return generalSuggestions[Random().nextInt(generalSuggestions.length)];
    }

    // Fallback to the closest neighboring category's general suggestion
    final fallbackCategory = getNeighboringCategory(tempCategory);
    final fallbackSuggestions = outfitSuggestions[fallbackCategory]?["general"] ?? [];
    if (fallbackSuggestions.isNotEmpty) {
      return fallbackSuggestions[Random().nextInt(fallbackSuggestions.length)];
    }

    // Final default suggestion
    return {"suggestion": "Dress comfortably for the weather.", "avatar": "../../assets/default_avatar.jpg"};
  }

  String getNeighboringCategory(String currentCategory) {
    switch (currentCategory) {
      case "cold":
        return "cool";
      case "cool":
        return "cold"; // Fallback to cold for missing cases in cool
      case "warm":
        return "hot";
      case "hot":
        return "warm";
      default:
        return "cool"; // Default fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final suggestion = getOutfitSuggestion(temperature, weatherCondition);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(suggestion["avatar"]!),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "Outfit Suggestion: ${suggestion["suggestion"]}",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
