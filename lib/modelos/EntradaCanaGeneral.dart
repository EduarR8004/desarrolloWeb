import 'dart:convert';

//import 'package:flutter/foundation.dart';

class EntradaCanaGeneral {
  
  String suerte;
  String peso_neto;
  String ncanasta;

  EntradaCanaGeneral({
    this.suerte,
    this.peso_neto,
    this.ncanasta,
  });
 
  Map<String, dynamic>to_Map() =>{
    'suerte':suerte,
    'peso_neto':peso_neto,
    'ncanasta':ncanasta,
    
  };

  factory EntradaCanaGeneral.fromJson(Map<String, dynamic> json){
  
    return new EntradaCanaGeneral(

      suerte:json['SUERTE']==null?'':json['SUERTE'],
      peso_neto:json['PESO_NETO']==null?'':json['PESO_NETO'],
      ncanasta:json['NCANASTA']==null?'':json['NCANASTA'],
    );
  }

}
