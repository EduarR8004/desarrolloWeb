import 'dart:convert';

//import 'package:flutter/foundation.dart';

class EntradaCanaTotal {
  
  String total_general;
  String cod_hda;
  String total_canastas;

  EntradaCanaTotal({
    this.total_general,
    this.cod_hda,
    this.total_canastas,
  });
 
  Map<String, dynamic>to_Map() =>{
    'TOTAL_GENERAL':total_general,
    'COD_HDA':cod_hda,
    'TOTAL_CANASTAS':total_canastas,
    
  };

  factory EntradaCanaTotal.fromJson(Map<String, dynamic> json){
  
    return new EntradaCanaTotal(

      total_general:json['TOTAL_GENERAL']==null?'':json['TOTAL_GENERAL'],
      cod_hda:json['COD_HDA']==null?'':json['COD_HDA'],
      total_canastas:json['TOTAL_CANASTAS']==null?'':json['TOTAL_CANASTAS'],
    );
  }

}
