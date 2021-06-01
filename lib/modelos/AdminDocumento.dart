import 'dart:convert';

class AdminDocumento {
String cod_hda;
bool   distribuido;
String documento_id;
DateTime  fecha_doc;
String nit;
String tipo;
String prop;


  AdminDocumento({
    this.cod_hda,
    this.distribuido,
    this.documento_id,
    this.fecha_doc,
    this.nit,
    this.tipo,
    this.prop,

  });



  Map<String, dynamic> toMap() {
    return {
      'cod_hda': cod_hda,
      'distribuido': distribuido,
      'documento_id': documento_id,
      'fecha_doc': fecha_doc,
      'nit': nit,
      'tipo': tipo,
      'prop':prop,
    };
  }


  factory AdminDocumento.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
  
    return AdminDocumento(
      cod_hda: json['cod_hda']==null?'':json['cod_hda'],
      distribuido: json['distribuido'],
      documento_id: json['documento_id']==null?'':json['documento_id'],
      // fecha_doc: json['fecha_doc']==null?DateTime.fromMillisecondsSinceEpoch(1613019600,isUtc: false):DateTime.fromMillisecondsSinceEpoch(json['fecha_doc']*1000,isUtc: false),
      nit: json['nit']==null?'':json['nit'],
      tipo: json['tipo']==null?'':json['tipo'],
      prop: json['prop']==null?'':json['prop'],
    );
  }
  
}
