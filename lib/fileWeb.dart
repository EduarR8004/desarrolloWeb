// import 'dart:html' as html;
 
// import 'package:path/path.dart' as Path;
// import 'package:image_picker_web/image_picker_web.dart';
// import 'package:flutter/material.dart';


// class FileWeb extends StatefulWidget {
//   @override
//   _FileWebState createState() => _FileWebState();
// }

// class _FileWebState extends State<FileWeb> {
//   @override
//   html.File _cloudFile;
//  var _fileBytes;
//  Image _imageWidget;

//  adjuntarArchivo() async{
//     html.File imageFile =
//         await ImagePickerWeb.getImage(outputType: ImageType.file);

//     if (imageFile != null) {
//       debugPrint(imageFile.name.toString());
//     }
//  }
//    Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("prueba"),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.open_in_browser),
//         onPressed: () async {
//           adjuntarArchivo();
//         },
//       ),
//       body: Center(child: Text('No data...')),
//     );
//   }
// }


 





// import 'package:flutter/material.dart';
// import 'package:flutter_web_image_picker/flutter_web_image_picker.dart';

// class FileWeb extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ImagePickerPage(),
//     );
//   }
// }

// class ImagePickerPage extends StatefulWidget {
//   @override
//   _ImagePickerPageState createState() => _ImagePickerPageState();
// }

// class _ImagePickerPageState extends State<ImagePickerPage> {
//   Image image;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(image?.semanticLabel ?? ""),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.open_in_browser),
//         onPressed: () async {
//           final _image = await FlutterWebImagePicker.getImage;
//           setState(() {
//             image = _image;
//           });
//         },
//       ),
//       body: Center(child: image != null ? image : Text('No data...')),
//     );
//   }
// }

















// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';

// class FileWeb extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyWebPage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyWebPage extends StatefulWidget {
//   MyWebPage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyWebPageState createState() => _MyWebPageState();
// }

// class _MyWebPageState extends State<MyWebPage> {
//   String _contentOfFile = "";

//   Future<String> getFilePath() async {
//     Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
//     String appDocumentsPath = appDocumentsDirectory.path;
//     String filePath = '$appDocumentsPath/demoTextFile.txt';

//     return filePath;
//   }

//   void saveFile() async {
//     File file = File(await getFilePath());
//     file.writeAsString(
//         "This is my demo text that will be saved to : demoTextFile.txt");
//   }

//   void readFile() async {
//     File file = File(await getFilePath());
//     String fileContent = await file.readAsString();

//     print('File Content: $fileContent');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               _contentOfFile,
//               textAlign: TextAlign.center,
//             ),
//             RaisedButton(
//               onPressed: () => {saveFile()},
//               child: Text("Save File"),
//             ),
//             RaisedButton(
//               onPressed: () => {readFile()},
//               child: Text("Read File"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }