library universal_storage_in_memory;

import 'storage_interface.dart';
export 'storage_interface.dart';

class StorageInMemory<K, V> implements StorageInterface<K, V> {
  final String _name;
  final Map<K, V> _cache;

  StorageInMemory({
    required String name,
  })  : _name = name,
        _cache = Map<K, V>();

  @override
  Future<void> create(K key, V value) async => _cache[key] = value;

  @override
  Future<void> createAll(Map<K, V> entries) async => _cache.addAll(entries);

  @override
  Future<void> delete(K key) async => _cache.remove(key);

  @override
  Future<void> deleteAll(List<K> keys) async {
    for (final key in keys) {
      _cache.remove(key);
    }
  }

  @override
  Future<V?> read(K key) async {
    final value = _cache[key];

    return value == null ? null : value as V;
  }

  @override
  Future<void> update(K key, V value) async => _cache[key] = value;

  @override
  Future<List<K>> getAllKeys() async => _cache.keys.toList();
}
