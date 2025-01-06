import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:async_preferences/async_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {

  List<String> _favourites = [];

  String _key = "favourite";

  List<String> get favourites => _favourites;
  void loadSavedFavoriteLocation(List<String> favouriteLocations) async {
    _favourites = favouriteLocations;
  }


  set addFavourite(String value) {
    _favourites.add(value);
   _saveFavouriteLocation();
    notifyListeners();
  }

  void removeFavourite(String value) {
    _favourites.remove(value);
   _removeFavouriteLocation();
   _saveFavouriteLocation();
    notifyListeners();
  }

  void _saveFavouriteLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(_key, _favourites);
  }

  void _removeFavouriteLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(_key);
  }
}

var appState = ChangeNotifierProvider<AppState>((ref) {
  return AppState();
});