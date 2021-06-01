import 'package:flutter/material.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/modelos/Usuario.dart';


class Usuarios with ChangeNotifier{
  List _usuarios;
  Map _usuario_actual;
  Conexion session;
  Map _id,_ruta;
  var params;
  Usuarios(Conexion s){
    this.session=s;
  }

  Future <List<Usuario>>descargar_usuarios(filtro)async{
    List map;
    var params={
    "filtro":filtro.toString(),
    };
    map = await this.session.callMethodList('/api/usuarios/listar_usuarios',params);
    List<Usuario> usuarios=[];
    for ( var usuario in map)
    {
      usuarios.add(Usuario.fromJson(usuario));
    }
    this._usuarios= usuarios;
  }

  Future <Map>actualizar_token(token)async{
    Map map;
    var params={"token_firebase":token};
    map = await this.session.callMethodOne('/actualizar-token',params);
  }

  obtener_usuarios(){
    return this._usuarios;
  }

  obtener_usuario(){
    return this._usuario_actual;
  }

  eliminar_usuario(id)async{
    Map map;
    var params={
      "usuario_id": id.toString(),
    };
    map=await this.session.callMethodOne('/api/usuarios/eliminar_usuario',params);
  }

  Future <Map>usuario_actual()async{
    Map map;
    var params={};
    map = await this.session.callMethodOne('/api/usuario_actual',params);
    this._usuario_actual=map;
  }

  editar_usuario(usuario_id,usuario,nombre_completo,telefono1,telefono2,telefono3,email,email_alternativo,nits,roles)async{
    Map map;
    var params={
      "usuario_id":usuario_id.toString(),
      "usuario":usuario.toString(),
      "nombre_completo":nombre_completo.toString(),
      "clave_acceso":"",
      "reintentos_acceso":0,
      "telefono1":telefono1.toString(),
      "telefono2":telefono2.toString(),
      "telefono3":telefono3.toString(),
      "email":email.toString(),
      "email_alternativo":email_alternativo.toString(),
      "bloqueo":false,
      "clave_acceso":"",
      "reintentos_acceso":0,
      "creation_stamp":0,
      "created_by": "",
      "modification_stamp": 0,
      "modified_by": ""
    };
    map = await this.session.callMethodOne('/api/usuarios/actualizar_usuario',params); 
  }

  aceptar_politica()async{

    var params={};
    var map=await this.session.callMethodOne('/api/establecer_aceptacion_politica_admin_datos',params);
  }

  Future <Map>obtener_ruta_documento(ini,fin)async{
    Map map;
    var params={
      "ini":ini,
      "fin":fin
    };
    map = await this.session.callMethodOne('/api/usuarios/reporte_trazabilidad_acciones_usuarios',params);
    this._ruta=map;
  }

  establecer_ruta(){
    return this._ruta;
  }
}