import 'package:flutter/material.dart';
import 'dart:async';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/vistas/encabezado/Encabezado.dart';
import 'package:proveedores_manuelita/vistas/menu.dart';
import 'package:proveedores_manuelita/vistas/actualDatos/PersonaNatural.dart';
import 'package:proveedores_manuelita/vistas/actualDatos/PersonaJuridica.dart';
import 'package:proveedores_manuelita/utiles/Globals.dart';


class ActualizarDatosp extends StatefulWidget {
  Data data;
  ActualizarDatosp({this.data});
  @override
  ActualizarDatospState createState() => ActualizarDatospState();
}

class ActualizarDatospState extends State<ActualizarDatosp>with SingleTickerProviderStateMixin {
  List<String> mostrarNotificacion=[];
  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    contadorGeneral=0;
    guardaContador=0;
    widget.data;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var menu = new Menu(data:widget.data,retorno:'');
    var encabezado= new Encabezado(data:widget.data,titulo:'Actualización Datos',);
    return WillPopScope(
    onWillPop: () {  },
    child: SafeArea(
          child:Scaffold(
          appBar: new AppBar(
          flexibleSpace:encabezado,
          backgroundColor: Colors.transparent,
          ),
          drawer: menu,
          body: Container(
            margin: EdgeInsets.fromLTRB(1,1, 1, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                margin: const EdgeInsets.fromLTRB(10,20, 10,1),
                height: 150,
                width: 400,
                child:Text('Señor Proveedor, a continuación encontrará la información para realizar el proceso de vinculación y/o actualización de documentos para personas Jurídicas y Naturales. Una vez cuente con la documentación completa, por favor enviarla al correo:',
                textAlign: TextAlign.justify,style: TextStyle(
                  color:Colors.black,
                  fontSize: 16,
                  height:1.5,
                                          //fontWeight: FontWeight.bold
                ),),),
                Container(
                margin: const EdgeInsets.fromLTRB(10,5, 10,10),
                height: 20,
                width: 400,
                child:Text('auxiliar.proveedores@manuelita.com',
                textAlign: TextAlign.center,style: TextStyle(
                  color:Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),),),
                TabBar(
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.red,
                  tabs: [
                    Tab(
                      child: Text('Personas Jurídicas',style:TextStyle(
                        color:Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      )),
                    ),
                    Tab(
                      child: Text('Personas Naturales',style:TextStyle(
                        color:Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      )),
                    )
                  ],
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
                TabBarView(
                  children: [PersonaJuridica(data: widget.data,),PersonaNatuarl(data: widget.data,) ],
                  controller: _tabController,
                ),
              ],
            ),
          ),
    ),),);
  }
}