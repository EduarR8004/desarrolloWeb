// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:share/share.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';

// class PdfViewPage extends StatefulWidget {
//   final String path;
//   final String titulo;

//   const PdfViewPage({Key key, this.path,this.titulo}) : super(key: key);
//   @override
//   _PdfViewPageState createState() => _PdfViewPageState();
// }

// class _PdfViewPageState extends State<PdfViewPage> {
//   int _totalPages = 0;
//   int _currentPage = 0;
//   bool pdfReady = false;
//   PDFViewController _pdfViewController;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Container(
//          height: 60,
//           margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
//           decoration: BoxDecoration(
//             color: Colors.white,  
//               //borderRadius: BorderRadius.circular(20),
//             image: DecorationImage(
//               image: AssetImage('images/titulop.png'),
//                 fit: BoxFit.cover),
//             ),
//           child:Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children:<Widget>[
//               Container(
//                 margin: EdgeInsets.fromLTRB(60, 0, 0, 0),
//                 child:Text(widget.titulo.toLowerCase(),style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold
//                     ),),
//               ),
//                Container(
//                 //margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
//                 child:IconButton(
//                   icon: Icon(
//                     Icons.share_rounded,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {
//                     Share.shareFiles(["${widget.path}"], text: "Archivo");
//                   },
//                 ),
//               ),
//             ],
//           ) ,
//           //padding: EdgeInsets.symmetric(horizontal:10),
//       ),
//         backgroundColor: Colors.transparent,
//       ),
//       body: Stack(
//         children: <Widget>[
//           PDFView(
//             filePath: widget.path,
//             autoSpacing: true,
//             enableSwipe: true,
//             pageSnap: true,
//             swipeHorizontal: true,
//             nightMode: false,
//             onError: (e) {
//               print(e);
//             },
//             onRender: (_pages) {
//               setState(() {
//                 _totalPages = _pages;
//                 pdfReady = true;
//               });
//             },
//             onViewCreated: (PDFViewController vc) {
//               _pdfViewController = vc;
//             },
//             onPageChanged: (int page, int total) {
//               setState(() {});
//             },
//             onPageError: (page, e) {},
//           ),
//           !pdfReady
//               ? Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : Offstage()
//         ],
//       ),
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           _currentPage > 0
//               ? FloatingActionButton.extended(
//                   backgroundColor: Color.fromRGBO(255,210,0, 1.0),
//                   label: Text("Anterior"),
//                   onPressed: () {
//                     _currentPage -= 1;
//                     _pdfViewController.setPage(_currentPage);
//                   },
//                 )
//               : Offstage(),
//           _currentPage+1 < _totalPages
//               ? FloatingActionButton.extended(
//                   backgroundColor: Color.fromRGBO(56, 124, 43, 1.0),
//                   label: Text("Siguiente"),
//                   onPressed: () {
//                     _currentPage += 1;
//                     _pdfViewController.setPage(_currentPage);
//                   },
//                 )
//               : Offstage(),
//         ],
//       ),
//     );
//   }
// }
//"CPFS":["8300538122","8903162479"],