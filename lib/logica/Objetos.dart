
import 'package:http/http.dart';

import 'dart:convert';

import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/modelos/response_status.dart';
import 'package:proveedores_manuelita/utiles/Utiles.dart';
import 'package:proveedores_manuelita/modelos/Respuesta.dart';
import 'package:proveedores_manuelita/modelos/Objeto.dart';

class Objetos{
List _objetos;
List _no_objetos;
Conexion session;
var params;
Objetos(Conexion s){
  this.session=s;
}

Future <List<Objeto>>descargar_objetos_asignados(id)async{
  List map;
  var params={
        "id":id.toString(),
  };
  map = await this.session.callMethodList('/api/roles/listar_objetos_asignados_rol',params);
  List<Objeto> objetos=[];
  for ( var usuario in map)
  {
    objetos.add(Objeto.fromJson(usuario));
  }
  this._objetos= objetos;
}

Future <List<Objeto>>descargar_objetos_noasignados(id)async{
  List map;
  var params={
        "id":id.toString(),
      };
  map = await this.session.callMethodList('/api/roles/listar_objetos_noasignados_rol',params);
  List<Objeto> no_objetos=[];
  for ( var usuario in map)
  {
    no_objetos.add(Objeto.fromJson(usuario));
  }
  this._no_objetos= no_objetos;
}

asignar_objeto_rol(id,rol)async{
  List map;
   var params={
      "id":id.toString(),
      "objetos":rol
  };
  map = await this.session.callMethodListS('/api/roles/asignar_objetos_rol',params);
  List<Objeto> no_obj=[];
  for ( var usuario in map)
  {
    no_obj.add(Objeto.fromJson(usuario));
  }
  this._no_objetos= no_obj;
}

remover_objeto_rol(id,rol)async{
  List map;
  var params={
    "id":id.toString(),
    "objetos":rol
  };
  await this.session.callMethodListS('/api/roles/remover_objetos_rol',params);
}

obtener_noasignados(){
  return this._no_objetos;
}

obtener_asignados(){
  return this._objetos;
}

}