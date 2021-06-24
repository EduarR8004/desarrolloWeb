import 'package:flutter/material.dart';
import 'dart:async';
import 'package:universal_io/io.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/Seguridad.dart';
import 'package:proveedores_manuelita/vistas/login/login.dart';
import 'package:proveedores_manuelita/utiles/Globals.dart';
import 'package:proveedores_manuelita/utiles/Notificaciones.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/logica/Usuarios.dart';
import 'package:proveedores_manuelita/modelos/Usuario.dart';


class Encabezado extends StatefulWidget {
  final Data data;
  String titulo;
  Encabezado ({Key key,this.data,this.titulo}) : super();
  @override
  _EncabezadoState createState() => _EncabezadoState();
}


class _EncabezadoState extends State<Encabezado> {
  ProgressDialog pr;
  int contadorEntradaCana,contadorConsultas,contadorInfoProduccion,contadorLiqCana;
  @override
  void initState() {
    contadorGeneral=0;
    guardaContador=0;
    contadorEntradaCana=entradaCana.length;
    contadorConsultas=consultas.length;
    contadorInfoProduccion=infoProduccion.length;
    contadorLiqCana=liqCana.length;
    widget.data;
    if(Platform.isAndroid){
    final notificaciones =  new Notificaciones();
    notificaciones.iniciarNotificacion();
    //get_preference_notification();
    notificaciones.mensajes.listen((argumento) {
      //Map valueMap = jsonDecode(argumento);
      //print(valueMap);
      print('Argumento');
      print(argumento);
      mensajeNotificacion.add(argumento);
      setState(() {
        contadorGeneral=mensajeNotificacion.length;
        contadorEntradaCana=entradaCana.length;
        contadorConsultas=consultas.length;
        contadorInfoProduccion=infoProduccion.length;
        contadorLiqCana=liqCana.length;
      });
    });
    }
    super.initState();
  }
  void confirm (dialog){
    Alert(
      context: context,
      type: AlertType.error,
      title: "Faltan Permisos",
      desc: dialog,
      buttons: [
        DialogButton(
          child: Text(
            "Aceptar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }

  mostrar_mensaje(contador){
    Timer(Duration(seconds:5), () {
      guardaContador=contadorEntradaCana+contadorConsultas+contadorInfoProduccion+contadorLiqCana;
      if(contadorGeneral>0 &&contadorGeneral == guardaContador)
      {
        if(contadorEntradaCana>0){
          mensajeGeneral.addAll(mensajeEntradaCana);
        }
        if(contadorConsultas>0){
          mensajeGeneral.addAll(mensaConsultas);
        }
        if(contadorInfoProduccion>0){
            mensajeGeneral.addAll(mensajeInfoProduccion);
        }
        if(contadorLiqCana>0){
          mensajeGeneral.length;
          mensajeGeneral.addAll(mensajeLiqCana);
        }
        contadorGeneral=0;
        var textomensaje=mensajeGeneral.toString().replaceAll("[", "").replaceAll("]", "");
        
        infoDialog(context,textomensaje,
        neutralAction:(){
          mensajeGeneral.clear();
              return;
        },
        negativeAction: (){
          mensajeGeneral.clear();
              return;
        }, );
      }
    });
  }

  Future <List<Usuario>> actualizar_token(token)async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var usuario= Usuarios(session);
    await usuario.actualizar_token(token).then((_){
    });
  }
  @override
  Widget build(BuildContext context) {
    mostrar_mensaje(contadorGeneral);
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
      message: 'Cerrando Sesión del Usuario ',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
      color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
      color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    return Container(
      height: 120,
      //width: 700,
      margin: EdgeInsets.only(top:3),
      decoration: BoxDecoration(
        color: Colors.white,  
          //borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage("images/titulop.png"),
          fit: BoxFit.cover
        ),
      ),
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:<Widget>[
          Container(
            width:60,
            child:
            IconButton(
              icon: Icon(
                Icons.home_rounded,
                color: Colors.white,
                size:40,
              ),
              onPressed: () {
                //Navigator.of(context).pop();
              },
            ),
          ),
          Center(
            child: 
            Text(
              widget.titulo,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Padding(
          padding: EdgeInsets.only(right:2),
            child:Container(
              width:50,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:<Widget>[
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.exit_to_app_rounded,
                  //     color: Colors.white,
                  //   ),
                  //   onPressed: () {
                  //     bool navigator;
                  //     pr.show();
                  //     var session= Conexion();
                  //     session.set_token(widget.data.token);
                  //     var seguridad= Seguridad(session);
                  //       seguridad.descargar_objetos('CerrarSesion').then((_){
                  //         navigator=seguridad.validaObjeto('CS001');
                  //         if(navigator==true)
                  //         { 
                  //           actualizar_token('n/a');
                  //           pr.hide();
                  //           WidgetsBinding.instance.addPostFrameCallback((_) {
                  //              Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => Login(true),)); });
                  //         }else{
                  //           pr.hide();
                  //           confirm ('No tiene los permisos para ingresar a la funcionalidad');
                  //         }
                  //       }); 
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ],
      ) ,
    //padding: EdgeInsets.symmetric(horizontal:10),
    );
  }
}