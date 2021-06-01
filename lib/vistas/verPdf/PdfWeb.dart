// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:universal_html/html.dart' as html;

// class PdfWeb extends StatefulWidget {
//   final String path;
//   final String titulo;
//   const PdfWeb({Key key, this.path,this.titulo}) : super(key: key);
//   // This widget is the root of your application.
//   @override
//   _PdfWebState createState() => _PdfWebState();
// }

// class _PdfWebState extends State<PdfWeb> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: PdfDemo(),
//     );
//   }
// }

// class PdfDemo extends StatelessWidget {
//   Future<html.Blob> myGetBlobPdfContent() async {
//     var data = await rootBundle.load("fonts/arial.ttf");
//     var myFont = pw.Font.ttf(data);
//     var myStyle = pw.TextStyle(font: myFont, fontSize: 36.0);

//     final pdf = pw.Document();
//     pdf.addPage(pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return pw.Center(
//             child: pw.Text(
//               "Hello World",
//               style: myStyle,
//             ),
//             // child: pw.Text("Hello World", style: myStyle),
//           );
//         }));
//     final bytes = await pdf.save();
//     html.Blob blob = html.Blob([bytes], 'application/pdf');
//     return blob;
//   }

//   @override
//   Widget build(BuildContext context) {
//     myGetBlobPdfContent();
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             RaisedButton(
//               child: Text("Open"),
//               onPressed: () async {
//                 final url = html.Url.createObjectUrlFromBlob(
//                     await myGetBlobPdfContent());
//                 html.window.open(url, "_blank");
//                 html.Url.revokeObjectUrl(url);
//               },
//             ),
//             RaisedButton(
//               child: Text("Download"),
//               onPressed: () async {
//                 final url = html.Url.createObjectUrlFromBlob(
//                     await myGetBlobPdfContent());
//                 final anchor =
//                     html.document.createElement('a') as html.AnchorElement
//                       ..href = url
//                       ..style.display = 'none'
//                       ..download = 'some_name.pdf';
//                 html.document.body.children.add(anchor);
//                 anchor.click();
//                 html.document.body.children.remove(anchor);
//                 html.Url.revokeObjectUrl(url);
//               },
//             ),
//           ],
//           mainAxisAlignment: MainAxisAlignment.center,
//         ),
//       ),
//     );
//   }
// }