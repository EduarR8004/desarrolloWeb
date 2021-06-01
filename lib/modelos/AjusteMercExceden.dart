import 'dart:convert';

class Ajuste {
  String fecha;
  String predio;
  String valor;
  String proveedor;
  String id;
  Ajuste({
    this.fecha,
    this.predio,
    this.valor,
    this.proveedor,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'fecha': fecha,
      'predio': predio,
      'valor': valor,
    };
  }

  factory Ajuste.fromJson(Map<String, dynamic> json) {
  
    return Ajuste(
      fecha: json['FECHA']==null?'':json['FECHA'],
      predio: json['PREDIO']==null?'':json['PREDIO'],
      valor: json['VALOR']==null?'':json['VALOR'],
      proveedor: json['PROP']==null?'':json['PROP'],
      id:json['DOCUMENTO_ID']==null?'':json['DOCUMENTO_ID'],
    );
  }

}
