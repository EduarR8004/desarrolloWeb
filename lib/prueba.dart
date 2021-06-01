// import 'package:creamy_field/creamy_field.dart';
// import 'package:flutter/material.dart';
// import 'package:quill_delta/quill_delta.dart';
// import 'package:zefyr/zefyr.dart';


// // class MyEditorApp extends StatefulWidget {
// //   @override
// //   _MyEditorAppState createState() => _MyEditorAppState();
// // }

// // class _MyEditorAppState extends State<MyEditorApp> {

// //   ZefyrController _controller;
// //   FocusNode _focusNode;
// //   @override
// //   void initState(){
// //     super.initState();
// //     final document = _loadDocuemnt();
// //     _controller = ZefyrController(document);
// //     _focusNode = FocusNode();
// //   }

// //   NotusDocument _loadDocuemnt(){
// //     final Delta delta = Delta()..insert("texto\n");
// //     return NotusDocument.fromDelta(delta);
    
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //        color:Colors.white ,
// //        child:ZefyrScaffold(
// //          child:ZefyrEditor(
// //            padding: EdgeInsets.all(16),
// //            controller: _controller,
// //            focusNode: _focusNode,)
// //         ,) ,
      
// //     );
// //   }
// // }

// class Prueba extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _Prueba();
//   }
// }

// class _Prueba extends State<Prueba> {
//   int counter = 0;

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Notification Badge"),
//         actions: <Widget>[
//           // Using Stack to show Notification Badge
//           new Stack(
//             children: <Widget>[
//               new IconButton(icon: Icon(Icons.notifications), onPressed: () {
//                 setState(() {
//                   counter = 0;
//                 });
//               }),
//               counter != 0 ? new Positioned(
//                 right: 11,
//                 top: 11,
//                 child: new Container(
//                   padding: EdgeInsets.all(2),
//                   decoration: new BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   constraints: BoxConstraints(
//                     minWidth: 14,
//                     minHeight: 14,
//                   ),
//                   child: Text(
//                     '$counter',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 8,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ) : new Container()
//             ],
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(onPressed: () {
//         print("Increment Counter");
//         setState(() {
//           counter++;
//         });
//       }, child: Icon(Icons.add),),
//     );
//   }
// }