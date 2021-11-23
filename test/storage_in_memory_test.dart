@TestOn("vm || browser")
library universal_storage_in_memory_test;

import 'package:test/test.dart';
import 'package:universal_storage/storage_in_memory.dart';

void main() {
  group("StorageInMemory", () {
    test('create', () async {
      final store =
          StorageInMemory<String, String>(name: 'storage_in_memory_create');

      String? value;

      value = await store.read("test_key");
      expect(value, isNull);

      await store.create("test_key", "test_value");

      value = await store.read("test_key");
      expect(value, isNotNull);
      expect(value, equals("test_value"));

      await store.delete("test_key");
    });

    test('read', () async {
      final store =
          StorageInMemory<String, String>(name: 'storage_in_memory_read');

      String? value;

      value = await store.read("test_key");
      expect(value, isNull);

      await store.create("test_key", "test_value");

      value = await store.read("test_key");
      expect(value, isNotNull);
      expect(value, equals("test_value"));

      await store.delete("test_key");
    });

    test('update', () async {
      final store =
          StorageInMemory<String, String>(name: 'storage_in_memory_update');

      String? value;

      await store.create("test_key", "test_value");

      value = await store.read("test_key");
      expect(value, equals("test_value"));

      await store.update("test_key", "new_test_value");

      value = await store.read("test_key");
      expect(value, equals("new_test_value"));

      await store.delete("test_key");
    });

    test('delete', () async {
      final store =
          StorageInMemory<String, String>(name: 'storage_in_memory_delete');

      String? value;

      value = await store.read("test_key");
      expect(value, isNull);

      await store.create("test_key", "test_value");

      value = await store.read("test_key");
      expect(value, isNotNull);
      expect(value, equals("test_value"));

      await store.delete("test_key");

      value = await store.read("test_key");
      expect(value, isNull);
    });

    test('getAllKeys', () async {
      final store =
          StorageInMemory<String, String>(name: 'storage_in_memory_getAllKeys');

      String? value;

      value = await store.read("test_key");
      expect(value, isNull);

      await store.create("test_key", "test_value");

      List<String> keys;

      keys = await store.getAllKeys();
      expect(keys, isNotEmpty);
      expect(keys.length, equals(1));
      expect(keys.first, equals("test_key"));

      await store.create("second_test_key", "second_test_value");

      keys = await store.getAllKeys();
      expect(keys, isNotEmpty);
      expect(keys.length, equals(2));
      expect(keys.first, equals("test_key"));
      expect(keys.last, equals("second_test_key"));

      await store.delete("test_key");
    });
  });
}
