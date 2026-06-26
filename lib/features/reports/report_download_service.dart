import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:media_store_plus/media_store_plus.dart';

class ReportDownloadService {
  Future<bool> downloadFile({
    required String url,
    required String fileName,
  }) async {
    try {
      print("1- Start Download");

      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      print("2- File Downloaded");

      Uint8List bytes = Uint8List.fromList(response.data);

      final tempDir = await getTemporaryDirectory();

      print("3- Temp Dir = ${tempDir.path}");

      final tempFile = File(
        "${tempDir.path}/$fileName.pdf",
      );

      await tempFile.writeAsBytes(bytes);

      print("4- Temp File Created");

      await MediaStore.ensureInitialized();

print("5- MediaStore Initialized");

MediaStore.appFolder = "Tamkeen";

final result = await MediaStore().saveFile(
  tempFilePath: tempFile.path,
  dirType: DirType.download,
  dirName: DirName.download,
);

print("6- Saved Result = $result");

      return true;
    } catch (e) {
      print("DOWNLOAD ERROR:");
      print(e);

      return false;
    }
  }
}