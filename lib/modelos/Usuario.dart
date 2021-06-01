import 'dart:convert';
import 'package:universal_io/io.dart';
class Usuario {
  bool bloqueo;
  String clave_acceso;
  String created_by;
  DateTime creation_stamp;
  String email;
  String email_alternativo;
  List   nits;
  DateTime modification_stamp;
  String modified_by;
  String nombre_completo;
  String propietario_id;
  int reintentos_acceso;
  List roles;
  String telefono1;
  String telefono2;
  String telefono3;
  String usuario;
  String usuario_id;
  
  Usuario({
    this.bloqueo,
    this.clave_acceso,
    this.created_by,
    this.creation_stamp,
    this.email,
    this.email_alternativo,
    this.nits,
    this.modification_stamp,
    this.modified_by,
    this.nombre_completo,
    this.propietario_id,
    this.reintentos_acceso,
    this.roles,
    this.telefono1,
    this.telefono2,
    this.telefono3,
    this.usuario,
    this.usuario_id,
  });
  

  factory Usuario.fromJson(Map<String, dynamic> json){
    return new Usuario(
      bloqueo:json['bloqueo'],
      clave_acceso:json['clave_acceso'],
      created_by:json['created_by'],
      creation_stamp:DateTime.fromMillisecondsSinceEpoch( json['creation_stamp']*1000,isUtc:false),
      email:json['email'],
      email_alternativo:json['email_alternativo'],
      nits:json['nits'],
      // modification_stamp:DateTime.fromMillisecondsSinceEpoch(json['modification_stamp']*1000,isUtc: false),
      modified_by:json['modified_by'],
      nombre_completo:json['nombre_completo'],
      propietario_id:json['propietario_id'],
      reintentos_acceso:json['reintentos_acceso'],
      roles:json['roles'],
      telefono1:json['telefono1'],
      telefono2:json['telefono2'],
      telefono3:json['telefono3'],
      usuario:json['usuario'],
      usuario_id:json['usuario_id'],
    );
  }
  Map<String, dynamic> to_Map() =>
      {
        "bloqueo":bloqueo,
        "clave_acceso":clave_acceso,
        "created_by":created_by,
        "creation_stamp":creation_stamp,
        "email":email,
        "email_alternativo":email_alternativo,
        "nits":nits,
        "modification_stamp":modification_stamp,
        "modified_by":modified_by,
        "nombre_completo":nombre_completo,
        "propietario_id":propietario_id,
        "reintentos_acceso":reintentos_acceso,
        "roles":roles,
        "telefono1":telefono1,
        "telefono2":telefono2,
        "telefono3":telefono3,
        "usuario":usuario,
        "usuario_id":usuario_id,
      };
  
}

class UsuarioList {
  final List<Usuario> usuarios;

  UsuarioList({
    this.usuarios,
  });

   factory UsuarioList.fromJson(List<dynamic> parsedJson) {

    List<Usuario> usuarios = new List<Usuario>();
    usuarios = parsedJson.map((i)=>Usuario.fromJson(i)).toList();

    return new UsuarioList(
      usuarios: usuarios
    );
}
}