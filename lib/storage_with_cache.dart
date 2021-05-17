library storage_with_cache;

import 'package:hive/hive.dart';

import 'package:storage/interface.dart';

export 'interface.dart';

class StorageWithCache<K, V> implements StorageInterface<K, V> {
  final String _name;
  final Map<K, V> _cache;

  StorageWithCache({
    required String name,
  })  : _name = name,
        _cache = Map<K, V>();

  Box<V>? _box;
  Future<Box<V>> _open() async => _box ??= await Hive.openBox<V>(_name);

  @override
  Future<void> create(K key, V value) async {
    _cache[key] = value;
    await _open().then((database) => database.put(key, value));
  }

  @override
  Future<void> createAll(Map<K, V> entries) async {
    _cache.addAll(entries);
    await _open().then((database) => database.putAll(entries));
  }

  @override
  Future<void> delete(K key) async {
    _cache.remove(key);
    await _open().then((database) => database.delete(key));
  }

  @override
  Future<void> deleteAll(List<K> keys) async {
    for (final key in keys) {
      _cache.remove(key);
    }
    await _open().then((database) => database.deleteAll(keys));
  }

  @override
  Future<V?> read(K key) async {
    if (_cache[key] != null) {
      return _cache[key] as V;
    } else {
      return _open().then((database) => database.get(key));
    }
  }

  @override
  Future<void> update(K key, V value) async {
    _cache[key] = value;
    await _open().then((database) => database.put(key, value));
  }

  @override
  Future<List<K>> getAllKeys() async {
    if (_cache.keys.isNotEmpty) {
      return _cache.keys.toList();
    } else {
      return _open().then(
        (database) async {
          final _keys = database.keys;

          final keys = <K>[];
          for (final key in _keys) {
            keys.add(key);
          }

          return keys;
        },
      );
    }
  }
}
