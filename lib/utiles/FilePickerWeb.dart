// import 'dart:html' as htmlfile;
// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';

// //typedef CallbackForFilePicker = Function(List<dynamic> files);

// class PlatformFilePicker {
//   startWebFilePicker( pickerCallback) async {
//     if (kIsWeb) {
//       htmlfile.InputElement uploadInput = htmlfile.FileUploadInputElement();
//       uploadInput.click();

//       uploadInput.onChange.listen((e) {
//         // read file content as dataURL
//         final files = uploadInput.files;
//         //was just checking for single file but you can check for multiple one
//         if (files.length == 1) {
//           final htmlfile.File file = files[0];
//           final reader = htmlfile.FileReader();

//           reader.onLoadEnd.listen((e) {
//             //to upload file we will be needing file bytes as web does not work exactly like path thing
//             //and to fetch file name we will be needing file object
//             //so created custom class to hold both.
//             pickerCallback([FlutterWebFile(file, reader.result)]);
//           });
//           reader.readAsArrayBuffer(file);
//         }
//       });
//     } else {
//       File file = await FilePicker.getFile();
//       pickerCallback([file.path]);
//     }
//   }

//   getFileName(dynamic file) {
//     if (kIsWeb) {
//       return file.file.name;
//     } else {
//       return file.path.substring(file.lastIndexOf(Platform.pathSeparator) + 1);
//     }
//   }
// }

// class FlutterWebFile {
//   htmlfile.File file;
//   List<int> fileBytes;

//   FlutterWebFile(this.file, this.fileBytes);
// }