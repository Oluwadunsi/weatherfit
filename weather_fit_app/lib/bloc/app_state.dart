import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppState extends ChangeNotifier {
  final List<String> _favourites = [];

  List<String> get favourites => _favourites;


  set addFavourite(String value) {
    _favourites.add(value);
    notifyListeners();
  }

  void removeFavourite(String value) {
    _favourites.remove(value);
    notifyListeners();
  }
}

var appState = ChangeNotifierProvider<AppState>((ref) {
  return AppState();
});