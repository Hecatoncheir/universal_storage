library storage;

import 'package:hive/hive.dart';

import 'package:storage/interface.dart';

export 'interface.dart';

class Storage<K, V> implements StorageInterface<K, V> {
  final String _name;

  final Map<K, V>? _cache;
  bool get _isCached => _cache != null && _cache!.isNotEmpty;

  Storage({
    required String name,
    bool isCached = true,
  })  : _name = name,
        _cache = isCached ? Map<K, V>() : null;

  Box<V>? _box;
  Future<Box<V>> _open() async => _box ??= await Hive.openBox<V>(_name);

  @override
  Future<void> create(K key, V value) async {
    if (_isCached) {
      _cache![key] = value;
      await _open().then((database) => database.put(key, value));
    } else {
      await _open().then((database) => database.put(key, value));
    }
  }

  @override
  Future<void> createAll(Map<K, V> entries) async {
    if (_isCached) {
      _cache!.addAll(entries);
      await _open().then((database) => database.putAll(entries));
    } else {
      await _open().then((database) => database.putAll(entries));
    }
  }

  @override
  Future<void> delete(K key) async {
    if (_isCached) {
      _cache!.remove(key);
      await _open().then((database) => database.delete(key));
    } else {
      await _open().then((database) => database.delete(key));
    }
  }

  @override
  Future<void> deleteAll(List<K> keys) async {
    if (_isCached) {
      for (final key in keys) {
        _cache!.remove(key);
      }
      await _open().then((database) => database.deleteAll(keys));
    } else {
      await _open().then((database) => database.deleteAll(keys));
    }
  }

  @override
  Future<V?> read(K key) async {
    if (_isCached && _cache![key] != null) {
      return _cache![key] as V;
    } else {
      return _open().then((database) => database.get(key));
    }
  }

  @override
  Future<void> update(K key, V value) async {
    if (_isCached) {
      _cache![key] = value;
      await _open().then((database) => database.put(key, value));
    } else {
      await _open().then((database) => database.put(key, value));
    }
  }

  @override
  Future<List<K>> getAllKeys() async {
    if (_isCached && _cache!.keys.isNotEmpty) {
      return _cache!.keys.toList();
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
