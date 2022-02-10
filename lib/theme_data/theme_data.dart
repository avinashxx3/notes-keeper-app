import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();

    return directory.path;
  }

  Future<void> writePermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      return null;
    }
  }

  Future<File> get _localFile async {
    await writePermission();
    final path = await _localPath;
    final dirPath = path.toString() + '/themeData';
    await Directory(dirPath).create(recursive: true);
    return File(dirPath +'/themeStatus.txt');
    //return File('/storage/emulated/0/Android/data/com.example.note_keeper/noteKeeper/data/themeStatus.txt');
  }

  Future<String> readFile() async {
    try {
      final file = await _localFile;
      // Read the file
      final contents = await file.readAsString();
      print("Read From themeStatus.txt File");
      return (contents.toString());
    } catch (e) {
      // If encountering an error, return false
      return "false";
    }
  }

  Future<File> writeFile(String isDarkModeTrue) async {
    final file = await _localFile;
    print("Written to themeStatus.txt File");
    // Write the file
    return file.writeAsString(isDarkModeTrue);
  }
}