import 'package:flutter/material.dart';
import 'package:proveedores_manuelita/vistas/login/login.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
   void initState() {

     Future.delayed(Duration(seconds:5),(){
       Navigator.of(context).push(
                   MaterialPageRoute(builder: (context) => Login(false)));
     }
     );
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
            color: Colors.white,
            child:Center(
        child:Image.asset("images/logo_principal.JPG",width: 150,height: 150),
      ))
      
    );
  }
}

class Splash1 extends StatefulWidget {
  @override
  _SplashState1 createState() => _SplashState1();
}

class _SplashState1 extends State<Splash1> {
  @override
   void initState() {

     Future.delayed(Duration(seconds:5),
     (){
      //  Navigator.of(context).push(
      //             MaterialPageRoute(builder: (context) => Login(false)));
      Navigator.of(context).pop();
     }
     );
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
            color: Colors.white,
            child:Center(
        child:Image.asset("assets/img/logo.png",width: 150,height: 150),
      )),
      
    );
  }
}