abstract class StorageInterface<K, V> {
  Future<void> create(K key, V value);
  Future<void> createAll(Map<K, V> entries);
  Future<V?> read(K key);
  Future<void> update(K key, V value);
  Future<void> delete(K key);
  Future<void> deleteAll(List<K> keys);

  Future<List<K>> getAllKeys();
}
