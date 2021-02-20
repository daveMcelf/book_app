import 'dart:convert';
import 'dart:io';
import 'package:book_app/app/helper/network_cache/file_model.dart';
import 'package:path_provider/path_provider.dart';

/// [FileManager] handle all the file operations for our application.
///
/// In this application, the file will be stored in "ApplicationDirectory/http-cache.json"
/// Some operation is included in this class including: reading, writing, and removing files
///
class FileManager {
  static FileManager _instance;
  final String fileName = "http-cache.json";
  FileManager._init();

  /// Getter function of the class.
  /// Outside can access this class instance using: FileManager.instance
  ///
  static FileManager get instance {
    if (_instance == null) {
      _instance = FileManager._init();
    }
    return _instance;
  }

  /// Return the `Future<String>` of file path where the data will be stored
  Future<String> getFilePath() async {
    final path = (await createTempPath()).path;
    return "$path/$fileName";
  }

  /// Create and get a file object, where path is from `getFilePath()`
  ///
  /// Return will be a `Future<File>`
  ///
  Future<File> getFile() async {
    String _filePath = await getFilePath();
    File documentFile = File(_filePath);
    return documentFile;
  }

  /// Read the content of the file and decode it into JSON for easily access
  ///
  /// Return will be a Key-Value Map object
  ///
  Future<Map> fileReadAllData() async {
    try {
      String _filePath = await getFilePath();
      File curFile = File(_filePath);
      final data = await curFile?.readAsString();
      final jsonData = jsonDecode(data);

      return jsonData;
    } catch (e) {
      return null;
    }
  }

  /// Write data into file
  ///
  /// `key`: is the key when store the data
  ///
  /// `FileModel`: is the data that we store under key.
  /// `FileModel` object has two field: `data, time`
  ///
  Future<File> writeDataToFile(String key, FileModel local) async {
    String _filePath = await getFilePath();
    final sample = local.toJson();
    final Map<String, dynamic> model = {key: sample};

    final oldData = await fileReadAllData();
    model.addAll(oldData ?? {});
    var newLocalData = jsonEncode(model);

    File documentFile = File(_filePath);
    return await documentFile.writeAsString(newLocalData,
        flush: true, mode: FileMode.write);
  }

  /// Read file data using key
  ///
  /// when called, it will check if there is any data response for the provided key or not.
  ///
  /// Then, it will check if the current data is expired by using the `time` properties of the `FileModel`
  /// If expired, the data under the key will be removed.
  ///
  /// Return `data` of the provided key, if all condition success

  Future<String> readOnlyKeyData(String key) async {
    Map datas = await fileReadAllData();
    if (datas != null && datas[key] != null) {
      final model = datas[key];
      final item = FileModel.fromJson(model);
      if (DateTime.now().isBefore(item.time)) {
        return item.data;
      } else {
        await removeSingleItem(key);
        return null;
      }
    }
    return null;
  }

  /// Remove a value from the file using key
  ///
  /// Check if the key exist in file or not. If existed, the Key/Value pair will be removed, and File will rewritten.
  ///
  Future removeSingleItem(String key) async {
    Map<String, Object> tempDirectory = await fileReadAllData();
    final _key = tempDirectory.keys.length > 0
        ? tempDirectory.keys
            .singleWhere((element) => element == key, orElse: () => null)
        : "";
    tempDirectory.remove(_key);
    String _filePath = await getFilePath();
    File documentFile = File(_filePath);
    return await documentFile.writeAsString(
      jsonEncode(tempDirectory),
      flush: true,
      mode: FileMode.write,
    );
  }

  /// Access the current Application Document Directly, and create a new file that will be used for our application.
  Future<Directory> createTempPath() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String tempPath = appDir.path;
    return Directory("$tempPath").create();
  }

  /// Remove files from the directoy
  Future clearAllDirectoryItems() async {
    Directory tempDirectory = await createTempPath();
    await tempDirectory.delete(recursive: true);
  }
}
