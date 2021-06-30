import 'dart:async';
import 'package:proveedores_manuelita/fileWeb.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/utiles/Seguridad.dart';
import 'package:proveedores_manuelita/utiles/Globals.dart';
import 'package:proveedores_manuelita/utiles/Notificaciones.dart';
import 'package:proveedores_manuelita/vistas/consultas/Consultas.dart';
import 'package:proveedores_manuelita/vistas/cronologico/Crono.dart';
import 'package:proveedores_manuelita/vistas/entradaCana/EntradasCana.dart';
import 'package:proveedores_manuelita/vistas/entradaCana/Mensaje.dart';
import 'package:proveedores_manuelita/vistas/infoProduccion/InfoProduccion.dart';
import 'package:proveedores_manuelita/vistas/asisTecnica/AsisTecnica.dart';
import 'package:proveedores_manuelita/vistas/liquidaciones/Liquidaciones.dart';
import 'package:proveedores_manuelita/vistas/actualDatos/ActualizarDatos.dart';
import 'package:proveedores_manuelita/logica/Usuarios.dart';
import 'package:proveedores_manuelita/modelos/Usuario.dart';
import 'package:proveedores_manuelita/vistas/menu.dart';

import 'login/login.dart';

class Inicio extends StatefulWidget {
final Data data;
String retorno;
Inicio({this.data,this.retorno});
@override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> objetos=[];
  List<String> obj_menu=[];
  List<String> mensaje=[];
  List<String> mostrarNotificacion=[];
  ProgressDialog pr;
  double letra=16;
  var session;
  String token;
  List cana=[];
  int contadorEntradaCana,contadorConsultas,contadorInfoProduccion,contadorLiqCana;
  @override
  void initState() {
    session= Conexion();
    session.set_token(widget.data.token);
    if(widget.retorno=='entrada')
    {
      widget.data.entrada=false;
    }
    if(widget.retorno=='info')
    {
      widget.data.produccion=false;
    }
    if(widget.retorno=='crono')
    {
      widget.data.crono=false;
    }
    contadorGeneral=0;
    guardaContador=0;
    contadorEntradaCana=entradaCana.length;
    contadorConsultas=consultas.length;
    contadorInfoProduccion=infoProduccion.length;
    contadorLiqCana=liqCana.length;
    widget.data;
    get_preference();
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
    mostrarNotificacion=[];
}
Future get_preference()async{
	SharedPreferences preferences = await SharedPreferences.getInstance();
	setState(() {
	  token=preferences.get('token')?? null;
    actualizar_token(token);
  });     
}

Future get_preference_notification()async{
	SharedPreferences preferences = await SharedPreferences.getInstance();
  cana=preferences.get('entradaCana');  
  //counter=cana.length;
}

  void _showAlert(titulo,text) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(text),
          actions: <Widget>[
            RaisedButton(
              child: Text("Aceptar", style: TextStyle(color: Colors.green),),
              onPressed: (){ 
                Navigator.of(context).pop();
               },
            )
          ],
        );
      }
    );
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

  Future <List<String>>objetos_menu()async{
    obj_menu=widget.data.obj;
    return obj_menu;              
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
    var data=widget.data;
    Size size = MediaQuery.of(context).size;
    var menu = new Menu(data:data,retorno:widget.retorno);
    return WillPopScope(
      onWillPop: () {  },
        child:SafeArea(
        key: _scaffoldKey,
          child: Scaffold(
            appBar: new AppBar(
              flexibleSpace: Container(
              //height: 60,
              //width: 700,
              margin: EdgeInsets.only(top:1),
              decoration: BoxDecoration(
                color: Colors.white,  
                //borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage("images/titulo.PNG"),
                    fit: BoxFit.cover),
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
                  Padding(
                  padding: EdgeInsets.only(right:2),
                  child:Container(
                    width:250,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:<Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.exit_to_app_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () { 
                            bool navigator;
                            pr.show();
                            var session= Conexion();
                            session.set_token(widget.data.token);
                            var seguridad= Seguridad(session);
                            seguridad.descargar_objetos('CerrarSesion').then((_){
                              navigator=seguridad.validaObjeto('CS001');
                                if(navigator==true)
                                { 
                                  actualizar_token('n/a');
                                  pr.hide();
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => Login(true),)); });
                                }else{
                                  pr.hide();
                                  errorDialog(
                                    context, 
                                    "No tiene los permisos para ingresar a la funcionalidad",
                                    negativeAction: (){
                                    },
                                  ); 
                                }
                            }); 
                          },
                        ),
                        InkWell(
                        onTap: () {
                          bool navigator;
                          pr.show();
                          var session= Conexion();
                          session.set_token(widget.data.token);
                          var seguridad= Seguridad(session);
                          seguridad.descargar_objetos('CerrarSesion').then((_){
                            navigator=seguridad.validaObjeto('CS001');
                              if(navigator==true)
                              { 
                                actualizar_token('n/a');
                                pr.hide();
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                    Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => Login(true),));});
                              }else{
                                pr.hide();
                                errorDialog(
                                    context, 
                                    "No tiene los permisos para ingresar a la funcionalidad",
                                    negativeAction: (){
                                    },
                                );
                              }
                          }); 
                        },child:Text("Cerrar Sesión",style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                        ),),
                    ],
                    ),
                  ),
                  ),
                ],
              ),
            //padding: EdgeInsets.symmetric(horizontal:10),
            ),
            backgroundColor: Colors.transparent,
          ),
          drawer: menu,
          body:Container(
            color: Colors.white,
            child:dataBody(),
          )
          ),
      ),
    );
  }

  Widget menuNo(imagen,texto,texto2){
  return 
  Column(
    children: <Widget>[
      new Container(width:20,height:20,),
      InkWell(
        onTap: () {
          warningDialog(
            context, 
            "No tiene los permisos para ingresar a la funcionalidad",
            negativeAction: (){
            },
          );
        },
        child:
        Column( 
          children: <Widget>[
            Container(
              height: 85,
              width: 85,
              decoration: BoxDecoration(
              color: Colors.white,
              border:Border.all(
                color: Color.fromRGBO(136,139,141, 1.0),
                width:4,
              ),
              borderRadius: BorderRadius.circular(50),
              // boxShadow: [BoxShadow(
              //   color: Colors.black45,
              //   offset: Offset(6,6),
              //   blurRadius: 6,  
              // ),
              // ],
              ),
              child:Center(
                child: Container(
                height: 50,
                width: 50,
                padding: new EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                  image: AssetImage(imagen),
                  fit: BoxFit.contain)),                             
                ) ,
              ),
            ),
            SizedBox(height: 20),
            Text(texto,style: TextStyle(
              color: Color.fromRGBO(83, 86, 90, 1.0),
              fontSize: letra,
              fontWeight: FontWeight.bold
            ),     
            ),
            Text(texto2,style: TextStyle(
              color: Color.fromRGBO(83, 86, 90, 1.0),
              fontSize: letra,
              fontWeight: FontWeight.bold
            ),     
            ),
          ]
        ),
      )
    ],
  ); 
}
  Widget  dataBody() {
    return FutureBuilder <List<String>>(
      future:objetos_menu(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          return  
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:Center(child:
              Container(
                width: 600,
                height: 800,
                color:Colors.white,
                child:Column(
                  children: <Widget>[
                    Container(
                      height: 120,
                      width: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,  
                          //borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage('images/logo_principal.JPG'),
                            fit: BoxFit.fitWidth
                        ),
                      ),
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.symmetric(horizontal:10),                             
                    ), 
                    SizedBox(height:5),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 163,
                      margin: EdgeInsets.fromLTRB(8,8, 8,0),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(40),
                    //     topRight: Radius.circular(40),
                      //   ),
                      //   color: Color.fromRGBO(31, 58, 47, 1.0),
                      // ),
                      child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:<Widget>[
                          obj_menu.contains("CO001") || obj_menu.contains("ZZ999")?
                          InkWell(
                            onTap: () {
                              consultas=[];
                              mensaConsultas.clear();
                              mensajeNotificacion.clear();
                              //mensajeNotificacion.removeWhere((element) => (element =='liquidaciones' ));
                              WidgetsBinding.instance.addPostFrameCallback((_) { 
                                  Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) =>  VerConsultas (data:widget.data))); });
                            }, 
                            child:
                            Column(
                              children: <Widget>[
                                contadorConsultas != 0 ? Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 10, 4),
                                  padding: EdgeInsets.all(2),
                                  decoration: new BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  child: Text(
                                    '$contadorConsultas',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ) : new Container(width:20,height:20,),
                                Container(
                                  height: 85,
                                  width: 85,
                                  margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:Border.all(
                                    color: Color.fromRGBO(56, 124, 43, 1.0),
                                    width:4,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  // boxShadow: [BoxShadow(
                                  //   color: Colors.black45,
                                  //   offset: Offset(6,6),
                                  //   blurRadius: 6,  
                                  // ),
                                  // ],
                                  ),
                                  child:Center(
                                    child: 
                                    Container(
                                    height: 50,
                                    width: 50,
                                    padding: new EdgeInsets.all(30.0),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                      image: AssetImage('images/lupa.png'),
                                      fit: BoxFit.contain)),
                                    ) ,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text('Consultas',
                                  style: TextStyle(
                                  color: Color.fromRGBO(83, 86, 90, 1.0),
                                  fontSize: letra,
                                  fontWeight: FontWeight.bold
                                  ),
                                ),
                              ]
                            ),
                          ):
                          menuNo('images/CONSULTAS.png','Consulta',''),
                          SizedBox(width:25),
                          //Spacer(),
                          obj_menu.contains("EC001") || obj_menu.contains("ZZ999")?
                          InkWell(
                            onTap: () {
                              if(widget.data.entrada==true)
                              { 
                                entradaCana=[];
                                mensajeEntradaCana.clear();
                                mensajeNotificacion.clear();
                                //mensajeNotificacion.removeWhere((element) => (element =='EntradaDeCana'));
                                WidgetsBinding.instance.addPostFrameCallback((_) { 
                                  Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) =>  Mensaje (data:widget.data,titulo:'Entrada Caña',mensaje:'entrada',), )); });
                              }else{
                                entradaCana=[];
                                //mensajeNotificacion.removeWhere((element) => (element =='EntradaDeCana'));
                                mensajeEntradaCana.clear();
                                mensajeNotificacion.clear();
                                WidgetsBinding.instance.addPostFrameCallback((_) { 
                                  Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => EntradasCanas (data:widget.data),)); });
                              }
                            }, 
                            child:
                            Column(
                              children: <Widget>[
                                contadorInfoProduccion != 0 ? Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 10, 4),
                                  padding: EdgeInsets.all(2),
                                  decoration: new BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  child: Text(
                                    '$contadorEntradaCana',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ): new Container(width:20,height:20,),
                                Container(
                                  height: 85,
                                  width: 85,
                                  decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:Border.all(
                                    color: Color.fromRGBO(56, 124, 43, 1.0),
                                    width:4,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  // boxShadow: [BoxShadow(
                                  //   color: Colors.black45,
                                  //   offset: Offset(6,6),
                                  //   blurRadius: 6,  
                                  // ),
                                  // ],
                                  ),
                                  child:Center(
                                    child: Container(
                                    height: 50,
                                    width: 50,
                                    padding: new EdgeInsets.all(30.0),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                      image: AssetImage('images/tractor_verde.png'),
                                      fit: BoxFit.contain)),
                                  ) ,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text('Entrada',style: TextStyle(  
                                  color: Color.fromRGBO(83, 86, 90, 1.0),
                                  fontSize: letra,
                                  fontWeight: FontWeight.bold
                                ),),
                                Text('De Caña',style: TextStyle(  
                                  color: Color.fromRGBO(83, 86, 90, 1.0),
                                  fontSize: letra,
                                  fontWeight: FontWeight.bold
                                ),),
                              ]
                            ),
                          )
                          :Row(children:[
                            SizedBox(width:3),
                            menuNo('images/vagon-gris.png','Entrada','De Caña'),
                          ]
                          ),
                          SizedBox(width:20),
                          //Spacer(),
                          obj_menu.contains("LC001") || obj_menu.contains("ZZ999")?
                          InkWell(
                            onTap: () {
                              liqCana=[];
                              mensajeLiqCana.clear();
                              mensajeNotificacion.clear();
                              //mensajeNotificacion.removeWhere((element) => (element =='LiquidacionCana'));
                              WidgetsBinding.instance.addPostFrameCallback((_) { 
                                  Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) =>  VerLiquidaciones (data:widget.data))); });
                            }, 
                            child:
                            Column(
                              children: <Widget>[ 
                                contadorLiqCana != 0 ?Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 10, 4),
                                  padding: EdgeInsets.all(2),
                                  decoration: new BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  child: Text(
                                    '$contadorLiqCana',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ): new Container(width:20,height:20,),
                                Container(
                                  height: 85,
                                  width: 85,
                                  decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:Border.all(
                                    color: Color.fromRGBO(56, 124, 43, 1.0),
                                    width:4,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  // boxShadow: [BoxShadow(
                                  //   color: Colors.black45,
                                  //   offset: Offset(6,6),
                                  //   blurRadius: 6,  
                                  // ),
                                  // ],
                                  ),
                                  child:Center(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      padding: new EdgeInsets.all(30.0),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                        image: AssetImage('images/bolsa-de-dinero.png'),
                                        fit: BoxFit.contain)),
                                    ) ,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text('Liquidaciones',
                                  style: TextStyle(
                                    color: Color.fromRGBO(83, 86, 90, 1.0),
                                    fontSize: letra,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ]
                            ),
                          ):
                          menuNo('images/LIQUIDACIÓN CAÑA.png','Liquidaciones',''),
                        ],
                      ),
                    ),
                    //SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 163,
                      margin: EdgeInsets.fromLTRB(8,0, 8,8),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(40),
                    //     topRight: Radius.circular(40),
                      //   ),
                      //   color: Color.fromRGBO(31, 58, 47, 1.0),
                      // ),
                      child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:<Widget>[
                          obj_menu.contains("CR001") || obj_menu.contains("ZZ999")?
                          InkWell(
                            onTap: () {
                              if(widget.data.crono==true)
                              {
                                WidgetsBinding.instance.addPostFrameCallback((_) { 
                                  Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) =>  Mensaje (data:widget.data,titulo:'Cronológico',mensaje:'crono'))); });
                              }else{
                                WidgetsBinding.instance.addPostFrameCallback((_) { 
                                  Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) =>  VerCronologico (data:widget.data))); });
                              }
                            }, 
                            child:
                              Column(
                              children: <Widget>[
                                new Container(width:20,height:20,),
                                Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  height: 85,
                                  width: 85,
                                  decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:Border.all(
                                    color: Color.fromRGBO(56, 124, 43, 1.0),
                                    width:4,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  // boxShadow: [BoxShadow(
                                  //   color: Colors.black45,
                                  //   offset: Offset(6,6),
                                  //   blurRadius: 6,  
                                  // ),
                                  // ],
                                  ),
                                  child:Center(
                                    child: 
                                    Container(
                                      height: 50,
                                      width: 50,
                                      padding: new EdgeInsets.all(30.0),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                        image: AssetImage('images/calendario.png'),
                                        fit: BoxFit.contain)
                                      ),  
                                    ) ,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text('Cronológico',style: TextStyle(
                                  color: Color.fromRGBO(83, 86, 90, 1.0),
                                  fontSize: letra,
                                  fontWeight: FontWeight.bold
                                ),),
                              ]
                            ),
                          ):Container(
                              //margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child:menuNo('images/CRONOLÓGICO.png','Cronológico',''
                            ),
                          ),
                          SizedBox(width:8),
                          //Spacer(),
                          obj_menu.contains("IP001") || obj_menu.contains("ZZ999")?
                          InkWell(
                            onTap: () {
                              if(widget.data.produccion==true)
                              { 
                                infoProduccion=[];
                                mensajeNotificacion.clear();
                                mensajeInfoProduccion.clear();
                                //mensajeNotificacion.removeWhere((element) => (element =='InformeDeProduccion'));
                                for(int i=0;i <= mensajeNotificacion.length;i++ )
                                WidgetsBinding.instance.addPostFrameCallback((_) { 
                                  Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) =>  Mensaje (data:widget.data,titulo:'Informe de Producción',mensaje:'informe')));});
                              }else{
                                infoProduccion=[];
                                mensajeInfoProduccion.clear();
                                mensajeNotificacion.clear();
                                //mensajeNotificacion.removeWhere((element) => (element =='InformeDeProduccion'));
                                WidgetsBinding.instance.addPostFrameCallback((_) { 
                                  Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) =>  InfoProduccion (data:widget.data)));});
                              }
                            }, 
                            child:
                            Column(
                              children: <Widget>[
                                contadorInfoProduccion != 0 ? Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 10, 4),
                                  padding: EdgeInsets.all(2),
                                  decoration: new BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  child: Text(
                                    '$contadorInfoProduccion',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ): new Container(width:20,height:20,),
                                Container(
                                  height: 85,
                                  width: 85,
                                  decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:Border.all(
                                    color: Color.fromRGBO(56, 124, 43, 1.0),
                                    width:4,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  // boxShadow: [BoxShadow(
                                  //   color: Colors.black45,
                                  //   offset: Offset(6,6),
                                  //   blurRadius: 6,  
                                  // ),
                                  // ],
                                  ),
                                  child:Center(
                                    child: Container(
                                    height: 50,
                                    width: 50,
                                    padding: new EdgeInsets.all(30.0),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                      image: AssetImage('images/estadisticas.png'),
                                      fit: BoxFit.contain)),
                                  ) ,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text('Informe',style: TextStyle(  
                                  color: Color.fromRGBO(83, 86, 90, 1.0),
                                  fontSize: letra,
                                  fontWeight: FontWeight.bold
                                ),),
                                Text('Producción',style: TextStyle(
                                  color: Color.fromRGBO(83, 86, 90, 1.0),
                                  fontSize: letra,
                                  fontWeight: FontWeight.bold
                                ),),
                              ]
                            ),
                          ):
                          Row(
                            children:[
                            SizedBox(width:3),
                            menuNo('images/INFORME DE PRODUCCIÓN.png','Informe','Producción'),
                            ]
                          ),
                          SizedBox(width:20),
                          //Spacer(),
                          obj_menu.contains("AT001") || obj_menu.contains("ZZ999")?
                          InkWell(
                            onTap: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) { 
                                  Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) =>  AsitenciaTecnica (data:widget.data)));});  
                            }, 
                            child:
                            Column(
                              children: <Widget>[
                                Container(width:20,height:20,),
                                Container(
                                  height: 85,
                                  width: 85,
                                  decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:Border.all(
                                    color: Color.fromRGBO(56, 124, 43, 1.0),
                                    width:4,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  // boxShadow: [BoxShadow(
                                  //   color: Colors.black45,
                                  //   offset: Offset(6,6),
                                  //   blurRadius: 6,  
                                  // ),
                                  // ],
                                  ),
                                  child:Center(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      padding:EdgeInsets.fromLTRB(30, 30, 5, 30),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                        image: AssetImage('images/cultivos.png'),
                                        fit: BoxFit.contain)
                                      ),
                                    ) ,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text('Asistencia',style: TextStyle(
                                  color: Color.fromRGBO(83, 86, 90, 1.0),
                                  fontSize: letra,
                                  fontWeight: FontWeight.bold
                                ),),
                                Text('Técnica',style: TextStyle(
                                  color: Color.fromRGBO(83, 86, 90, 1.0),
                                  fontSize: letra,
                                  fontWeight: FontWeight.bold
                                ),),
                              ],
                            ),
                          ):
                        menuNo('images/RECOMENDACIÓN.png','Asistencia','Técnica'),
                        ],
                      ),
                    ),
                    obj_menu.contains("AO001") || obj_menu.contains("ZZ999")?
                    InkWell(
                      onTap: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) { 
                            Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) =>  ActualizarDatosp (data:widget.data)));
                          });

                          // WidgetsBinding.instance.addPostFrameCallback((_) { 
                          //              Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) =>  FileWeb()));});
                      },
                      child:
                      Center(child:
                        Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          height: 143,
                          margin: EdgeInsets.all(8),
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.only(
                          //     topLeft: Radius.circular(40),
                          //     topRight: Radius.circular(40),
                          //   ),
                          //   color: Color.fromRGBO(31, 58, 47, 1.0),
                          // ),
                          child: 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    height: 85,
                                    width: 85,
                                    decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:Border.all(
                                      color: Color.fromRGBO(56, 124, 43, 1.0),
                                      width:4,
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                    // boxShadow: [BoxShadow(
                                    //   color: Colors.black45,
                                    //   offset: Offset(6,6),
                                    //   blurRadius: 6,  
                                    // ),
                                    // ],
                                    ),
                                    child:Center(
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        padding: new EdgeInsets.all(30.0),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                          image: AssetImage('images/actualizar_datos.png'),
                                          fit: BoxFit.contain)),
                                      ) ,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text('Actualización\n''    De Datos',
                                    style: TextStyle(
                                      color: Color.fromRGBO(83, 86, 90, 1.0),
                                      fontSize: letra,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ]
                              ),
                            ],
                          ),
                        ),
                      ),
                    ):
                    InkWell(
                      onTap: () {
                        warningDialog(
                          context, 
                          "No tiene los permisos para ingresar a la funcionalidad",
                          negativeAction: (){
                          },
                        );
                      },
                      child:
                      Center(child:
                        Container(
                          color:Colors.white,
                          width: MediaQuery.of(context).size.width,
                          height: 123,
                          margin: EdgeInsets.all(15),
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.only(
                          //     topLeft: Radius.circular(40),
                          //     topRight: Radius.circular(40),
                          //   ),
                          //   color: Color.fromRGBO(31, 58, 47, 1.0),
                          // ),
                          child: 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    height: 85,
                                    width: 85,
                                    decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:Border.all(
                                      color: Color.fromRGBO(136,139,141, 1.0),
                                      width:4,
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                    // boxShadow: [BoxShadow(
                                    //   color: Colors.black45,
                                    //   offset: Offset(6,6),
                                    //   blurRadius: 6,  
                                    // ),
                                    // ],
                                    ),
                                    child:Center(
                                      child: Container(
                                      height: 50,
                                      width: 50,
                                      padding: new EdgeInsets.all(30.0),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                          image: AssetImage('images/ACTUALIZAR DATOS.png'),
                                          fit: BoxFit.contain)
                                        ),
                                      ) ,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text('Actualización\n''    De Datos',style: TextStyle(
                                    color: Color.fromRGBO(83, 86, 90, 1.0),
                                    fontSize: letra,
                                    fontWeight: FontWeight.bold
                                  ),),
                                ]
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ) 
            );
        }else{
          return
          Center(
            child:CircularProgressIndicator()
            //Splash1(),
          );
        }
      },
    );
  }
}

    List _buildList(int count) {
      List<Widget> listItems = List();

      for (int i = 0; i < count; i++) {
        listItems.add(new Padding(padding: new EdgeInsets.all(20.0),
            child: new Text(
                'Item ${i.toString()}',
                style: new TextStyle(fontSize: 25.0)
            )
        ));
      }

      return listItems;
    }