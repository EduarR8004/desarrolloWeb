import 'dart:convert';

//import 'package:flutter/foundation.dart';

class EntradaCanaDetalle {
  
  String canasta;
  String peso_neto;
  String cod_vehiculo;
  String fch_entrada;
  String guia;
  String hr_entrada;

  EntradaCanaDetalle({
    this.canasta,
    this.peso_neto,
    this.cod_vehiculo,
    this.fch_entrada,
    this.guia,
    this.hr_entrada,
  });

  
 
  Map<String, dynamic>to_Map() =>{
    'canasta':canasta,
    'peso_neto':peso_neto,
    'cod_vehiculo':cod_vehiculo,
    'fch_entrada':fch_entrada,
    'guia':guia,
    'hr_entrada':hr_entrada,
  };

  factory EntradaCanaDetalle.fromJson(Map<String, dynamic> json){
  
    return new EntradaCanaDetalle(

      canasta:json['CANASTA']==null?'':json['CANASTA'],
      cod_vehiculo:json['COD_VEHICULO']==null?'':json['COD_VEHICULO'],
      fch_entrada:json['FCH_ENTRADA']==null?'':json['FCH_ENTRADA'],
      guia:json['GUIA']==null?'':json['GUIA'],
      hr_entrada:json['HR_ENTRADA']==null?'':json['HR_ENTRADA'],
      peso_neto:json['PESO_NETO']==null?'':json['PESO_NETO'],
    );
  }

}
