import 'package:flutter/material.dart';
import 'dart:async';
import 'package:proveedores_manuelita/logica/AsistenciasTecnicas.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/vistas/asisTecnica/VerRecomendacion.dart';
import 'package:proveedores_manuelita/vistas/encabezado/Encabezado.dart';
import 'package:proveedores_manuelita/utiles/Notificaciones.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/utiles/Globals.dart';
import 'package:proveedores_manuelita/vistas/index.dart';
import 'package:proveedores_manuelita/vistas/menu.dart';

class AsitenciaTecnica extends StatefulWidget {
  final Data data;

  AsitenciaTecnica({Key key,this.data}) : super();
  @override
  _AsitenciaTecnicaState createState() => _AsitenciaTecnicaState();
}

class _AsitenciaTecnicaState extends State<AsitenciaTecnica> {
  double tPlantilla,tSoca,iPlantilla,iSoca,texto,textoSeleccionado,espacio;
  bool mostrarPlantilla,mostrarSoca,soca,plantilla;
  Color seleccionado=Color.fromRGBO(176,188, 34, 1.0);
  Color sombra=Colors.black45;
  Color borde=Color.fromRGBO(56, 124, 43, 1.0);
  String categoria,subCategoria,respuesta;
  List<String> mostrarNotificacion=[];
  int contadorEntradaCana,contadorConsultas,contadorInfoProduccion,contadorLiqCana;

 @override
  void initState() {
  tPlantilla=85;
  iPlantilla=50;
  tSoca=85;
  iSoca=50;
  soca=false;
  plantilla=false;
  mostrarPlantilla=false;
  texto=14;
  textoSeleccionado=18;
  espacio=5;
  mostrarSoca=false;
  contadorGeneral=0;
  guardaContador=0;
  contadorEntradaCana=entradaCana.length;
  contadorConsultas=consultas.length;
  contadorInfoProduccion=infoProduccion.length;
  contadorLiqCana=liqCana.length;
  widget.data;
  super.initState();
}


Future <String> recuperar_texto({categoria,subcategoria,titulo,icono})async{
  var session= Conexion();
  session.set_token(widget.data.token);
  var recomendacion= AsistenciasTecnicas(session);
  Map textoRespuesta;
  await recomendacion.recuperar_texto(categoria,subcategoria).then((_){
      textoRespuesta=recomendacion.establecer_texto();       
  });    
  respuesta=textoRespuesta['texto'].toString();
  Navigator.push(
        context,MaterialPageRoute(builder: (context) =>VerRecomendacion(titulo:titulo,icono:icono,texto:respuesta,)));
                     
}
  @override
  Widget build(BuildContext context) {
    var menu = new Menu(data:widget.data,retorno:'');
    var encabezado= new Encabezado(data:widget.data,titulo:'Asistencia Técnica',);
    return WillPopScope(
    onWillPop: () {  },
    child: SafeArea(
      child:Scaffold(
        appBar: new AppBar(
          flexibleSpace:encabezado, 
          backgroundColor: Colors.transparent,
        ),
        drawer: menu,
        body:SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              width: 800,
              height: 120,
              margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(40),
                //     topRight: Radius.circular(40),
                  //   ),
                  //   color: Color.fromRGBO(31, 58, 47, 1.0),
                  // ),
              child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:<Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          tPlantilla=60;
                          iPlantilla=35;
                          tSoca=60;
                          iSoca=35;
                          plantilla=true;
                          soca=false;
                          mostrarPlantilla=true;
                          mostrarSoca=false;
                          categoria='Plantilla';
                        });
                      }, 
                      child:
                        Column(
                          children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            height: tPlantilla,
                            width: tPlantilla,
                            decoration: BoxDecoration(
                            color:plantilla?seleccionado:Colors.white,
                            border:Border.all(
                              color: plantilla?seleccionado:Color.fromRGBO(56, 124, 43, 1.0),
                              width:4,
                            ),
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [BoxShadow(
                              color: plantilla?Colors.black45:Colors.white,
                              offset: Offset(6,6),
                              blurRadius: 6,  
                            ),
                            ],
                            ),
                            child:Center(
                              child: 
                              Container(
                              height: iPlantilla,
                              width: iPlantilla,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                image: AssetImage('images/PLANTILLAF.png'),
                                fit: BoxFit.contain)),
                                
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Text('Plantilla',style: TextStyle(
                            color: plantilla?seleccionado:Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize:plantilla?textoSeleccionado:texto,
                            fontWeight: FontWeight.bold
                          ),),
                      ]
                      ),
                    ),
                    SizedBox(height:30,width:20),
                    InkWell(
                      onTap: () {
                        setState(() {
                          tPlantilla=60;
                          iPlantilla=35;
                          tSoca=60;
                          iSoca=35;
                          mostrarPlantilla=false;
                          mostrarSoca=true;
                          plantilla=false;
                          soca=true;
                          categoria='Socas';
                        });
                      }, 
                      child:
                      Column(
                        children: <Widget>[
                          Container(
                          alignment: Alignment.center,
                          height: tSoca,
                          width: tSoca,
                          decoration: BoxDecoration(
                          color: soca?seleccionado:Colors.white,
                          border:Border.all(
                            color: soca?seleccionado:Color.fromRGBO(56, 124, 43, 1.0),
                            width:4,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [BoxShadow(
                              color:soca?Colors.black45:Colors.white,
                              offset: Offset(6,6),
                              blurRadius: 6,  
                          ),
                          ],
                          ),
                          child:Center(
                            child: Container(
                              height: iSoca,
                              width: iSoca,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/SOCASF.png'),
                              fit: BoxFit.contain)),
                                    
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Text('Socas',style: TextStyle(
                            color:soca?seleccionado: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize:soca?textoSeleccionado:texto,
                            fontWeight: FontWeight.bold
                          ),),
                        ]
                      ),
                    ),
                  ],
                ),
            ),
            mostrarPlantilla?Container(
              alignment: Alignment.center,
              width: 800,
              height: 110,
              margin: EdgeInsets.fromLTRB(20, 10, 25, 10),
	                      // decoration: BoxDecoration(
	                      //   borderRadius: BorderRadius.only(
	                      //     topLeft: Radius.circular(40),
                      //     topRight: Radius.circular(40),
	                      //   ),
	                      //   color: Color.fromRGBO(31, 58, 47, 1.0),
	                      // ),
	            child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:<Widget>[
                    InkWell(
                      onTap: () {
                        recuperar_texto(categoria:categoria,subcategoria:'Adecuacion',titulo:'Adecuación',icono:'images/ADECUACION.png');
                      }, 
                      child:
                        Column(
                          children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            height: tPlantilla,
                            width: tPlantilla,
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
                              height: iPlantilla,
                              width: iPlantilla,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                image: AssetImage('images/ADECUACION.png'),
                                fit: BoxFit.contain)),
                                
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Text('  Adecuación',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),),
                      ]
                      ),
                    ),
                    SizedBox(height:30),
                    InkWell(
                      onTap: () {
                        recuperar_texto(categoria:categoria,subcategoria:'Renovacion',titulo: 'Preparación',icono:'images/RENOVACION.png');
                      }, 
                      child:
                      Column(
                        children: <Widget>[
                          Container(
                          alignment: Alignment.center,
                          height: tSoca,
                          width: tSoca,
                          decoration: BoxDecoration(
                          color: Colors.white,
                          border:Border.all(
                            color: Color.fromRGBO(30, 124, 43, 1.0),
                            width:4,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          // boxShadow: [BoxShadow(
                          //    color: Colors.black45,
                          //     offset: Offset(6,6),
                          //     blurRadius: 6,  
                          // ),
                          // ],
                          ),
                          child:Center(
                            child: Container(
                              height: iSoca,
                              width: iSoca,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/RENOVACION.png'),
                              fit: BoxFit.contain)),
                                    
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Text('Preparación',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),),
                        ]
                      ),
                    ),
                    SizedBox(height:30,width:espacio),
                    InkWell(
                      onTap: () {
                        recuperar_texto(categoria:categoria,subcategoria:'Siembra',titulo: 'Siembra',icono:'images/SIEMBRA.png');
                      }, 
                      child:
                      Column(
                        children: <Widget>[
                          Container(
                          margin: EdgeInsets.fromLTRB(5, 0, 5, 4),
                          alignment: Alignment.center,
                          height: tSoca,
                          width: tSoca,
                          decoration: BoxDecoration(
                          color: Colors.white,
                          border:Border.all(
                            color: Color.fromRGBO(56, 124, 43, 1.0),
                            width:4,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          // boxShadow: [BoxShadow(
                          //    color: Colors.black45,
                          //     offset: Offset(6,6),
                          //     blurRadius: 6,  
                          // ),
                          // ],
                          ),
                          child:Center(
                            child: Container(
                              height: iSoca,
                              width: iSoca,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/SIEMBRA.png'),
                              fit: BoxFit.contain)),
                                    
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Text('Siembra',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),),
                        ]
                      ),
                    ),
                  ],
                ),
	          ):Container(),
            mostrarPlantilla?Container(
              alignment: Alignment.center,
              width: 800,
              height: 110,
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:<Widget>[
                    InkWell(
                      onTap: () {
                        recuperar_texto(categoria:categoria,subcategoria:'RiegoGerminacion',titulo:'Riego.Germin',icono:'images/RIEGOGERMINACION.png');
                      }, 
                      child:
                        Column(
                          children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            height: tPlantilla,
                            width: tPlantilla,
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
                              height: iPlantilla,
                              width: iPlantilla,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                image: AssetImage('images/RIEGOGERMINACION.png'),
                                fit: BoxFit.contain)),
                                
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Text('Riego de',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),),
                          Text('Germinación',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),),
                      ]
                      ),
                    ),
                    SizedBox(height:30,width:espacio),
                    InkWell(
                      onTap: () {
                        recuperar_texto(categoria:categoria,subcategoria:'ControlMalezaPreEmergente',titulo: 'Pre-emergente',icono:'images/CONTROLDEMALEZAS.png');
                      }, 
                      child:
                      Column(
                        children: <Widget>[
                          Container(
                          alignment: Alignment.center,
                          height: tSoca,
                          width: tSoca,
                          decoration: BoxDecoration(
                          color: Colors.white,
                          border:Border.all(
                            color: Color.fromRGBO(56, 124, 43, 1.0),
                            width:4,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          // boxShadow: [BoxShadow(
                          //    color: Colors.black45,
                          //     offset: Offset(6,6),
                          //     blurRadius: 6,  
                          // ),
                          // ],
                          ),
                          child:Center(
                            child: Container(
                              height: iSoca,
                              width: iSoca,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/CONTROLDEMALEZAS.png'),
                              fit: BoxFit.contain)),
                                    
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Text('Pre-emergente',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),),
                          // Text('Pre-emerg',style: TextStyle(
                          //             color: Color.fromRGBO(83, 86, 90, 1.0),
                          //             fontSize: texto,
                          //             fontWeight: FontWeight.bold
                          // ),),
                        ]
                      ),
                    ),
                    SizedBox(height:30,width:espacio),
                    InkWell(
                      onTap: () {
                        recuperar_texto(categoria:categoria,subcategoria:'Fertilizacion',titulo: 'Fertilización',icono:'images/FERTILIZACION.png');
                      }, 
                      child:
                      Column(
                        children: <Widget>[
                          Container(
                          alignment: Alignment.center,
                          height: tSoca,
                          width: tSoca,
                          decoration: BoxDecoration(
                          color: Colors.white,
                          border:Border.all(
                            color: Color.fromRGBO(56, 124, 43, 1.0),
                            width:4,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          // boxShadow: [BoxShadow(
                          //    color: Colors.black45,
                          //     offset: Offset(6,6),
                          //     blurRadius: 6,  
                          // ),
                          // ],
                          ),
                          child:Center(
                            child: Container(
                              height: iSoca,
                              width: iSoca,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/FERTILIZACION.png'),
                              fit: BoxFit.contain)),
                                    
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Text('Fertilización',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),),
                        ]
                      ),
                    ),
                  ],
                ),
	          ):Container(),
            mostrarPlantilla?Container(
              alignment: Alignment.center,
              width: 800,
              height: 110,
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(40),
                //     topRight: Radius.circular(40),
                  //   ),
                  //   color: Color.fromRGBO(31, 58, 47, 1.0),
                  // ),
              child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:<Widget>[
                    InkWell(
                      onTap: () {
                        recuperar_texto(categoria:categoria,subcategoria:'RiegoDeLevante',titulo: 'Riego de Levante',icono:'images/RIEGOLEVANTE.png');
                      }, 
                      child:
                        Column(
                          children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 4),
                            height: tPlantilla,
                            width: tPlantilla,
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
                              height: iPlantilla,
                              width: iPlantilla,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                image: AssetImage('images/RIEGOLEVANTE.png'),
                                fit: BoxFit.contain)),
                                
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Text('Riego de',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),),
                          Text('Levante',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),
                          )
                      ]
                      ),
                    ),
                    SizedBox(height:30,width:45),
                    InkWell(
                      onTap: () {
                        recuperar_texto(categoria:categoria,subcategoria:'ControlPlagasYEnfermedades',titulo: 'Plagas y Enfermedades',icono:'images/PLAGASYENFERMEDADES.png');
                      }, 
                      child:
                      Column(
                        children: <Widget>[
                          Container(
                          alignment: Alignment.center,
                          height: tSoca,
                          width: tSoca,
                          decoration: BoxDecoration(
                          color: Colors.white,
                          border:Border.all(
                            color: Color.fromRGBO(56, 124, 43, 1.0),
                            width:4,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          // boxShadow: [BoxShadow(
                          //    color: Colors.black45,
                          //     offset: Offset(6,6),
                          //     blurRadius: 6,  
                          // ),
                          // ],
                          ),
                          child:Center(
                            child: Container(
                              height: iSoca,
                              width: iSoca,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/PLAGASYENFERMEDADES.png'),
                              fit: BoxFit.contain)),
                                    
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Text('Plagas',style: TextStyle(
                                      color: Color.fromRGBO(83, 86, 90, 1.0),
                                      fontSize: texto,
                                      fontWeight: FontWeight.bold
                          ),),
                          Text(' y Enfermedades',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),
                          ),
                        ]
                      ),
                    ),
                    SizedBox(height:30,width:14),
                    InkWell(
                      onTap: () {
                        recuperar_texto(categoria:categoria,subcategoria:'Agostamiento',titulo: 'Agostamiento',icono:'images/AGOSTAMIENTO.png');
                      }, 
                      child:
                      Column(
                        children: <Widget>[
                          Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          alignment: Alignment.center,
                          height: tSoca,
                          width: tSoca,
                          decoration: BoxDecoration(
                          color: Colors.white,
                          border:Border.all(
                            color: Color.fromRGBO(56, 124, 43, 1.0),
                            width:4,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          // boxShadow: [BoxShadow(
                          //    color: Colors.black45,
                          //     offset: Offset(6,6),
                          //     blurRadius: 6,  
                          // ),
                          // ],
                          ),
                          child:Center(
                            child: Container(
                              height: iSoca,
                              width: iSoca,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/AGOSTAMIENTO.png'),
                              fit: BoxFit.contain)),
                                    
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Container(
                            margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child:
                            Text('Agostamiento',style: TextStyle(
                              color: Color.fromRGBO(83, 86, 90, 1.0),
                              fontSize: texto,
                              fontWeight: FontWeight.bold
                            ),
                            ),
                          ),
                          
                        ]
                      ),
                    ),
                  ],
                ),
            ):Container(),
            mostrarSoca?Container(
              alignment: Alignment.center,
              width: 800,
              height: 110,
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
	                      // decoration: BoxDecoration(
	                      //   borderRadius: BorderRadius.only(
	                      //     topLeft: Radius.circular(40),
                      //     topRight: Radius.circular(40),
	                      //   ),
	                      //   color: Color.fromRGBO(31, 58, 47, 1.0),
	                      // ),
	            child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:<Widget>[
                    InkWell(
                      onTap: () {
                        recuperar_texto(categoria:categoria,subcategoria:'Encalle',titulo: 'Encalle',icono:'images/ENCALLE.png');
                      }, 
                      child:
                        Column(
                          children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 4),
                            alignment: Alignment.center,
                            height: tPlantilla,
                            width: tPlantilla,
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
                              height: iPlantilla,
                              width: iPlantilla,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                image: AssetImage('images/ENCALLE.png'),
                                fit: BoxFit.contain)),
                                
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Text('Encalle',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),),
                      ]
                      ),
                    ),
                    SizedBox(height:30,width:15),
                    InkWell(
                      onTap: () {
                        recuperar_texto(categoria:categoria,subcategoria:'Roturacion',titulo: 'Roturación',icono:'images/ROTURACION.png');
                      }, 
                      child:
                      Column(
                        children: <Widget>[
                          Container(
                          alignment: Alignment.center,
                          height: tSoca,
                          width: tSoca,
                          decoration: BoxDecoration(
                          color: Colors.white,
                          border:Border.all(
                            color: Color.fromRGBO(56, 124, 43, 1.0),
                            width:4,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          // boxShadow: [BoxShadow(
                          //    color: Colors.black45,
                          //     offset: Offset(6,6),
                          //     blurRadius: 6,  
                          // ),
                          // ],
                          ),
                          child:Center(
                            child: Container(
                              height: iSoca,
                              width: iSoca,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/ROTURACION.png'),
                              fit: BoxFit.contain)),
                                    
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Text('Roturación',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),),
                        ]
                      ),
                    ),
                    SizedBox(height:30,width:espacio),
                    InkWell(
                      onTap: () {
                        recuperar_texto(categoria:categoria,subcategoria:'Resiembra',titulo: 'Resiembra',icono:'images/RESIEMBRA.png');
                      }, 
                      child:
                      Column(
                        children: <Widget>[
                          Container(
                          alignment: Alignment.center,
                          height: tSoca,
                          width: tSoca,
                          decoration: BoxDecoration(
                          color: Colors.white,
                          border:Border.all(
                            color: Color.fromRGBO(56, 124, 43, 1.0),
                            width:4,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          // boxShadow: [BoxShadow(
                          //    color: Colors.black45,
                          //     offset: Offset(6,6),
                          //     blurRadius: 6,  
                          // ),
                          // ],
                          ),
                          child:Center(
                            child: Container(
                              height: iSoca,
                              width: iSoca,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/RESIEMBRA.png'),
                              fit: BoxFit.contain)),
                                    
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Text('Resiembra',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),),
                        ]
                      ),
                    ),
                  ],
                ),
	          ):Container(),
            mostrarSoca?Container(
              alignment: Alignment.center,
              height: 110,
              width: 800,
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: 
	              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:<Widget>[
                    InkWell(
                      onTap: () {
                        recuperar_texto(categoria:categoria,subcategoria:'Fertilizacion',titulo: 'Fertilización',icono:'images/FERTILIZACION.png');
                      }, 
                      child:
                        Column(
                          children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            height: tPlantilla,
                            width: tPlantilla,
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
                              height: iPlantilla,
                              width: iPlantilla,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                image: AssetImage('images/FERTILIZACION.png'),
                                fit: BoxFit.contain)),
                                
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Text('Fertilización',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),),
                      ]
                      ),
                    ),
                    SizedBox(height:30,width:espacio),
                    InkWell(
                      onTap: () {
                        recuperar_texto(categoria:categoria,subcategoria:'ControlDeMalezas',titulo: 'Control.Malezas',icono:'images/CONTROLDEMALEZAS.png');
                      }, 
                      child:
                      Column(
                        children: <Widget>[
                          Container(
                          alignment: Alignment.center,
                          height: tSoca,
                          width: tSoca,
                          decoration: BoxDecoration(
                          color: Colors.white,
                          border:Border.all(
                            color: Color.fromRGBO(56, 124, 43, 1.0),
                            width:4,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          // boxShadow: [BoxShadow(
                          //    color: Colors.black45,
                          //     offset: Offset(6,6),
                          //     blurRadius: 6,  
                          // ),
                          // ],
                          ),
                          child:Center(
                            child: Container(
                              height: iSoca,
                              width: iSoca,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/CONTROLDEMALEZAS.png'),
                              fit: BoxFit.contain)),
                                    
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Text('Control',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),),
                          Text('Malezas',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),)
                        ]
                      ),
                    ),
                    SizedBox(height:30,width:espacio),
                    InkWell(
                      onTap: () {
                        recuperar_texto(categoria:categoria,subcategoria:'Aporque',titulo: 'Aporque',icono:'images/APORQUE.png');
                      }, 
                      child:
                      Column(
                        children: <Widget>[
                          Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 7, 0),
                          alignment: Alignment.center,
                          height: tSoca,
                          width: tSoca,
                          decoration: BoxDecoration(
                          color: Colors.white,
                          border:Border.all(
                            color: Color.fromRGBO(56, 124, 43, 1.0),
                            width:4,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          // boxShadow: [BoxShadow(
                          //    color: Colors.black45,
                          //     offset: Offset(6,6),
                          //     blurRadius: 6,  
                          // ),
                          // ],
                          ),
                          child:Center(
                            child: Container(
                              height: iSoca,
                              width: iSoca,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/APORQUE.png'),
                              fit: BoxFit.contain)),
                                    
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Text('Aporque',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),),
                        ]
                      ),
                    ),
                  ],
	              ),
	          ):Container(),
            mostrarSoca?Container(
              alignment: Alignment.center,
              width: 800,
              height: 110,
              margin: EdgeInsets.fromLTRB(22, 10, 20, 10),
	                      // decoration: BoxDecoration(
	                      //   borderRadius: BorderRadius.only(
	                      //     topLeft: Radius.circular(40),
                      //     topRight: Radius.circular(40),
	                      //   ),
	                      //   color: Color.fromRGBO(31, 58, 47, 1.0),
	                      // ),
	            child: 
	              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:<Widget>[
                    InkWell(
                      onTap: () {
                        recuperar_texto(categoria:categoria,subcategoria:'RiegoDLevante',titulo: 'Riego de Levante',icono:'images/RIEGOLEVANTE.png');
                      }, 
                      child:
                        Column(
                          children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 4),
                            alignment: Alignment.center,
                            height: tPlantilla,
                            width: tPlantilla,
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
                              height: iPlantilla,
                              width: iPlantilla,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                image: AssetImage('images/RIEGOLEVANTE.png'),
                                fit: BoxFit.contain)),
                                
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Text('Riego de',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),),
                          Text('Levante',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),)
                      ]
                      ),
                    ),
                    SizedBox(height:30,width:45),
                    InkWell(
                      onTap: () {
                        recuperar_texto(categoria:categoria,subcategoria:'ControlPlagasYEnfermedades',titulo: 'Plagas y Enfermedades',icono:'images/PLAGASYENFERMEDADES.png');
                      }, 
                      child:
                      Column(
                        children: <Widget>[
                          Container(
                          alignment: Alignment.center,
                          height: tSoca,
                          width: tSoca,
                          decoration: BoxDecoration(
                          color: Colors.white,
                          border:Border.all(
                            color: Color.fromRGBO(56, 124, 43, 1.0),
                            width:4,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          // boxShadow: [BoxShadow(
                          //    color: Colors.black45,
                          //     offset: Offset(6,6),
                          //     blurRadius: 6,  
                          // ),
                          // ],
                          ),
                          child:Center(
                            child: Container(
                              height: iSoca,
                              width: iSoca,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/PLAGASYENFERMEDADES.png'),
                                fit: BoxFit.contain
                              )
                              ),   
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Text('Plagas',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),),
                          Text('y Enfermedades',style: TextStyle(
                            color: Color.fromRGBO(83, 86, 90, 1.0),
                            fontSize: texto,
                            fontWeight: FontWeight.bold
                          ),),
                        ]
                      ),
                    ),
                    SizedBox(height:30,width:13),
                    InkWell(
                      onTap: () {
                        recuperar_texto(categoria:categoria,subcategoria:'Agostamiento',titulo: 'Agostamiento',icono:'images/AGOSTAMIENTO.png');
                      }, 
                      child:
                      Column(
                        children: <Widget>[
                          Container(
                          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          alignment: Alignment.center,
                          height: tSoca,
                          width: tSoca,
                          decoration: BoxDecoration(
                          color: Colors.white,
                          border:Border.all(
                            color: Color.fromRGBO(56, 124, 43, 1.0),
                            width:4,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          // boxShadow: [BoxShadow(
                          //    color: Colors.black45,
                          //     offset: Offset(6,6),
                          //     blurRadius: 6,  
                          // ),
                          // ],
                          ),
                          child:Center(
                            child: Container(
                              height: iSoca,
                              width: iSoca,
                              padding: new EdgeInsets.all(30.0),
                              decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/AGOSTAMIENTO.png'),
                              fit: BoxFit.contain)),      
                            ) ,
                          ),
                          ),
                          SizedBox(height:espacio),
                          Container(
                            margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child:
                            Text('Agostamiento',style: TextStyle(
                              color: Color.fromRGBO(83, 86, 90, 1.0),
                              fontSize: texto,
                              fontWeight: FontWeight.bold
                            ),),
                          ),
                        ]
                      ),
                    ),
                  ],
	              ),
	          ):Container(),
        ],
      ),),
    ),
    ),);
  }
}