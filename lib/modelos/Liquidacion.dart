import 'dart:convert';

class Liquidacion {
 String fecha;
 String predio;
 String rend_bonif;
 String rto_real_ing;
 String ton_cana;
 String valor_desc;
 String valor_total;
 String ton_bruta;
 String proveedor;
 String id;
  Liquidacion({
    this.fecha,
    this.predio,
    this.rend_bonif,
    this.rto_real_ing,
    this.ton_cana,
    this.valor_desc,
    this.valor_total,
    this.ton_bruta,
    this.proveedor,
    this.id
  });

  Map<String, dynamic> toMap() {
    return {
      'fecha': fecha,
      'predio': predio,
      'rend_bonif': rend_bonif,
      'rto_real_ing': rto_real_ing,
      'ton_cana': ton_cana,
      'valor_desc': valor_desc,
      'valor_total': valor_total,
      'ton_bruta':ton_bruta,
      'id':id,
    };
  }

  factory Liquidacion.fromJson(Map<String, dynamic> json) {
  
    return Liquidacion(
      fecha: json['FECHA']==null?'':json['FECHA'],
      predio: json['HACIENDA'],
      rend_bonif: json['BONIFICA_TOTAL']==null?'':json['BONIFICA_TOTAL'],
      rto_real_ing: json['RTO']==null?'':json['RTO'],
      ton_cana: json['TON_NETA']==null?'':json['TON_NETA'],
      valor_desc: json['VALOR_NETO']==null?'':json['VALOR_NETO'],
      valor_total: json['VALOR_TOTAL']==null?'':json['VALOR_TOTAL'],
      ton_bruta:json['TON_BRUTA']==null?'':json['TON_BRUTA'],
      proveedor: json['PROP']==null?'':json['PROP'],
      id: json['DOCUMENTO_ID']==null?'':json['DOCUMENTO_ID'],
    );
  }

 
}
