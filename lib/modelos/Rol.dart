import 'dart:convert';

//import 'package:flutter/foundation.dart';

class Rol {

  String created_by;
  DateTime creation_stamp;
  String descripcion;
  String id;
  DateTime modification_stamp;
  String modified_by;
  String nombre;
  List objetos;
  Rol({
    this.created_by,
    this.creation_stamp,
    this.descripcion,
    this.id,
    this.modification_stamp,
    this.modified_by,
    this.nombre,
    this.objetos,
  });



  Map<String, dynamic>to_Map() =>{
    
      'created_by': created_by,
      'creation_stamp': creation_stamp,
      'descripcion': descripcion,
      'id': id,
      'modification_stamp': modification_stamp,
      'modified_by': modified_by,
      'nombre': nombre,
      'objetos': objetos,
    
  };

  factory Rol.fromJson(Map<String, dynamic> json){
  
    return new Rol(
      created_by: json['created_by'],
      creation_stamp: DateTime.fromMillisecondsSinceEpoch(json['creation_stamp']),
      descripcion: json['descripcion'],
      id: json['id'],
      modification_stamp: DateTime.fromMillisecondsSinceEpoch(json['modification_stamp']),
      modified_by: json['modified_by'],
      nombre: json['nombre'],
      objetos: ['objetos'],
    );
  }

}
