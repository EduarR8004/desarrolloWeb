import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:proveedores_manuelita/modelos/Rol.dart';
import 'dart:convert';
import 'package:universal_io/io.dart';

import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/modelos/response_status.dart';
import 'package:proveedores_manuelita/utiles/Utiles.dart';
import 'package:proveedores_manuelita/modelos/Respuesta.dart';
import 'package:proveedores_manuelita/modelos/Usuario.dart';

class Roles{
List _roles;
List _no_roles;
Conexion session;
var params;
Roles(Conexion s){
  this.session=s;
}
obtener_roles(){
    return this._roles;
  }

eliminar_rol(id)async{
   List map;
   Map params={
          "ids":[id],
        };
    map=await this.session.callMethod('/api/roles/eliminar_roles',params);
    return map;
}

Future <List<Rol>>descargar_roles_asignados(id)async{
   List map;
   var params={
          "usuario_id":id.toString(),
        };
   map = await this.session.callMethodList('/api/usuarios/listar_roles_asignados_usuario',params);
   List<Rol> objetos=[];
   for ( var usuario in map)
   {
     objetos.add(Rol.fromJson(usuario));
   }
   this._roles= objetos;
}

Future <List<Rol>>descargar_roles_noasignados(id)async{
   List map;
   var params={
          "usuario_id":id.toString(),
        };
   map = await this.session.callMethodList('/api/usuarios/listar_roles_noasignados_usuario',params);
   List<Rol> no_roles=[];
   for ( var usuario in map)
   {
     no_roles.add(Rol.fromJson(usuario));
   }
   this._no_roles= no_roles;
}

asignar_rol_usuario(id,rol,rolesNombre)async{

  List map;
   var params={
      "usuario_id":id.toString(),
      "rol_ids":rol,
      "rol_nombre":rolesNombre
  };
   map = await this.session.callMethodListS('/api/usuarios/asignar_rol_usuario',params);
   List<Rol> no_roles=[];
   for ( var usuario in map)
   {
     no_roles.add(Rol.fromJson(usuario));
   }
   this._no_roles= no_roles;

}

remover_rol_usuario(id,rol,rolesNombre)async{

  List map;
   var params={
      "usuario_id":id.toString(),
      "rol_ids":rol,
      "rol_nombre":rolesNombre
  };
  await this.session.callMethodListS('/api/usuarios/remover_rol_usuario',params);

}

crear_rol(rol,desc)async{

  Map map;
   var params={
    "rol":rol.toString(),
    "descripcion":desc.toString()
  };
  map=await this.session.callMethodOne('/api/roles/crear_rol',params);

}

editar_rol(id,rol,desc)async{

  Map map;
   var params={
     "id":id.toString(),
    "nombre":rol.toString(),
    "descripcion":desc.toString()
  };
  map=await this.session.callMethodOne('/api/roles/actualizar_rol',params);

}
 obtener_noasignados(){
    return this._no_roles;
}

obtener_asignados(){
    return this._roles;
}

}