
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/modelos/response_status.dart';
import 'package:proveedores_manuelita/utiles/Utiles.dart';
import 'package:proveedores_manuelita/modelos/Respuesta.dart';


class Seguridad{
  List _objetos_seguridad;
  List menu;
  List _todos;
  String _usuario_actual;
  Conexion session;

  Seguridad(Conexion s){
    this.session=s;
  }

  descargar_objetos(pantalla)async{
   List map;
   Map <String,String> params = new Map();
   params={'pantalla': pantalla.toString()};
   map = await this.session.callMethod('/api/usuarios/objetos_seguridad_menu',params);
    this._objetos_seguridad=map;
  }

  descargar_todos()async{
   List map;
   Map <String,String> params = new Map();
   params={};
   map = await this.session.callMethod('/api/usuarios/objetos_seguridad',params);
    this._todos=map;
  }

  descargar_usuario_actual(String token)async{
   String usuario;
   usuario = await this.session.nombre_usuario(token);
    this._usuario_actual=usuario;
  }
   obtener_todos(){
    return this._todos;
  }
  obtener_usuario(){
    return this._usuario_actual;
  }
 establecer_obj_menu(obj){
   this.menu=obj;
 }

 obtener_obj_menu(){
   return this.menu;
 }
  obtener_objetos(){
    return this._objetos_seguridad;
  }

  validaObjeto(obj){
    if(this._objetos_seguridad.contains(obj)){
      return true;
    }else{
      return false;
    }
  }
}