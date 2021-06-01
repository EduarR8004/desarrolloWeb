import 'dart:convert';

class Consulta {

  String documento_id;
  String usuario;
  DateTime fecha_distribucion;
  String orden_procesamiento_id;

  Consulta({
    this.documento_id,
    this.usuario,
    this.fecha_distribucion,
    this.orden_procesamiento_id,
  });


  Map<String, dynamic> toMap() {
    return {
      'documento_id': documento_id,
      'usuario': usuario,
      'fecha_distribucion': fecha_distribucion?.millisecondsSinceEpoch,
      'orden_procesamiento_id': orden_procesamiento_id,
    };
  }


  factory Consulta.fromJson(Map<String, dynamic> json) {
    return Consulta(
      documento_id: json['documento_id'],
      usuario: json['created_by'],
      fecha_distribucion: DateTime.fromMillisecondsSinceEpoch(json['fecha_distribucion']*1000,isUtc: false),
      orden_procesamiento_id: json['orden_procesamiento_id'],
    );
  }

}
