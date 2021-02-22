import 'dart:io';

import 'package:book_app/app/helper/network_cache/file_cache.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:test/test.dart';

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    // Create a temporary directory.
    final directory = await Directory.systemTemp.createTemp();

    // Mock out the MethodChannel for the path_provider plugin.
    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      // If you're getting the apps documents directory, return the path to the
      // temp directory on the test environment instead.
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return directory.path;
      }
      return null;
    });
  });
  group('FileCache', () {
    test('get file invalid key', () async {
      final fileCache = FileCached();
      expect(await fileCache.getCachedData("random-test-cache"), null);
    });

    test('add new cache', () async {
      final fileCache = FileCached();
      await fileCache.writeDataToCached(
          "test-cache", "data", Duration(minutes: 1));
      expect(await fileCache.getCachedData("test-cache"), "data");
    });

    test('cache should expire when duration smaller than now', () async {
      final fileCache = FileCached();
      await fileCache.writeDataToCached(
          "test-cache-duration", "data", Duration(minutes: -2));
      expect(await fileCache.getCachedData("test-cache-duration"), null);
    });

    test('cache should return true when remove existing key', () async {
      final fileCache = FileCached();
      await fileCache.writeDataToCached(
          "test-cache", "data", Duration(minutes: 1));

      expect(await fileCache.removeCachedData("test-cache"), true);
    });

    test('cache should be empty after clear', () async {
      final fileCache = FileCached();
      await fileCache.writeDataToCached(
          "test-cache1", "data", Duration(minutes: 1));
      await fileCache.writeDataToCached(
          "test-cache2", "data", Duration(minutes: 1));

      expect(await fileCache.removeAllCached(), true);
      expect(await fileCache.getCachedData("test-cache2"), null);
    });
  });
}
