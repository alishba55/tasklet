import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'favorites_provider.g.dart';

const _kFavoritesKey = 'toolify_favorites';

/// Persists a set of favorited tool IDs to SharedPreferences.
@riverpod
class Favorites extends _$Favorites {
  @override
  Set<String> build() {
    _loadFromPrefs();
    return {};
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_kFavoritesKey) ?? [];
    state = stored.toSet();
  }

  Future<void> toggle(String toolId) async {
    final updated = Set<String>.from(state);
    if (updated.contains(toolId)) {
      updated.remove(toolId);
    } else {
      updated.add(toolId);
    }
    state = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kFavoritesKey, updated.toList());
  }
}
