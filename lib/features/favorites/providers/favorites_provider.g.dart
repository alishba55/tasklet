// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoritesHash() => r'8cad77fde1b42e3dbf9cfc7d54999fc08dd228db';

/// Persists a set of favorited tool IDs to SharedPreferences.
///
/// Copied from [Favorites].
@ProviderFor(Favorites)
final favoritesProvider =
    AutoDisposeNotifierProvider<Favorites, Set<String>>.internal(
  Favorites.new,
  name: r'favoritesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$favoritesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Favorites = AutoDisposeNotifier<Set<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
