import 'package:book_app/app/helper/network_cache/file_helper.dart';
import 'package:book_app/app/helper/network_cache/file_model.dart';

/// Our interface used for implementing of CacheManager
abstract class ICacheManager {
  Future<bool> writeDataToCached(String key, String data, Duration time);
  Future<String> getCachedData(String key);
  Future<bool> removeCachedData(String key);
  Future<bool> removeAllCached();
}

/// [FileCached] is used for controlling the cached in the application.
///
/// All the data that is cached will be saved into a file inside Application Directory.
///
/// Currently, our application used this for caching HTTP response.
/// Since the response from HTTP doesn't need to be securely stored, using File is faster and can be easily acess.
class FileCached implements ICacheManager {
  FileManager _fileManager = FileManager.instance;

  /// Return the data with the specified `Key`
  @override
  Future<String> getCachedData(String key) {
    return _fileManager.readOnlyKeyData(key);
  }

  /// Remove all the data from cache.
  @override
  Future<bool> removeAllCached() async {
    await _fileManager.clearAllDirectoryItems();
    return true;
  }

  /// Remove a single data from cache with the specified `Key`.
  @override
  Future<bool> removeCachedData(String key) async {
    await _fileManager.removeSingleItem(key);
    return true;
  }

  /// Write a new data to cache.
  /// The data that will be write will be expired in the next specified `time` duration.
  ///
  @override
  Future<bool> writeDataToCached(String key, String data, Duration time) async {
    if (time == null) {
      return false;
    } else {
      final expireDuration = DateTime.now().add(time);
      final fileModel = FileModel(time: expireDuration, data: data);
      await _fileManager.writeDataToFile(key, fileModel);
      return true;
    }
  }
}
