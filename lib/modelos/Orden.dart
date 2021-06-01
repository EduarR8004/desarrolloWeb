import 'dart:convert';

class Orden {
  
  String orden_procesamiento_id;
  String tipo;
  String estado;
  String notas;
  DateTime creation_stamp;
  String created_by;
  DateTime modification_stamp;
  String modified_by;
  String descripcion_tipo;
  bool preliminar;
  
  Orden({
    this.orden_procesamiento_id,
    this.tipo,
    this.estado,
    this.notas,
    this.creation_stamp,
    this.created_by,
    this.modification_stamp,
    this.modified_by,
    this.descripcion_tipo,
    this.preliminar,
  });
    

  Map<String, dynamic> toMap() {
    return {
      'orden_procesamiento_documentos_id"': orden_procesamiento_id,
      'tipo': tipo,
      'estado': estado,
      'notas': notas,
      'creation_stamp': creation_stamp?.millisecondsSinceEpoch,
      'created_by': created_by,
      'modification_stamp': modification_stamp?.millisecondsSinceEpoch,
      'modified_by': modified_by,
      'descripcion_tipo':descripcion_tipo,
      'preliminar':preliminar,
    };
  }

  factory Orden.fromJson(Map<String, dynamic> json) {  
    return Orden(
      orden_procesamiento_id: json['orden_procesamiento_documentos_id']==null?'':json['orden_procesamiento_documentos_id'],
      tipo: json['tipo']==null?'':json['tipo'],
      estado: json['estado']==null?'':json['estado'],
      notas: json['notas']==null?'':json['notas'],
      creation_stamp: DateTime.fromMicrosecondsSinceEpoch(json['creation_stamp'],isUtc: false),
      created_by: json['created_by']==null?'':json['created_by'],
      //modification_stamp:DateTime.fromMillisecondsSinceEpoch(json['modification_stamp']*1000,isUtc: false),
      modified_by: json['modified_by']==null?'':json['modified_by'],
      descripcion_tipo:json['descripcion_tipo']==null?'':json['descripcion_tipo'],
      preliminar:json['preliminar'],
    );
  }
}