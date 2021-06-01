import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
class Flecha extends StatefulWidget {
  @override
  _FlechaState createState() => _FlechaState();
}

class _FlechaState extends State<Flecha> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:FadeInLeft(child: Icon(Icons.arrow_forward ,color:Colors.black ,size: 30,),
        duration: Duration(seconds:5),
      ),
      
    );
  }
}