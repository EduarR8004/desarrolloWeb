import 'dart:convert';

class InformeProducTotal {
  
String total;
String fazenda;


InformeProducTotal({
 
    this.total,
    this.fazenda,
  });

  Map<String, dynamic>to_Map() =>{
  'TOTAL_SUERTES':total,
  'COD_HDA':fazenda,
 
  };


  factory InformeProducTotal.fromJson(Map<String, dynamic> json){
  
  return new InformeProducTotal(

    total:json['TOTAL_SUERTES'],
    fazenda:json['COD_HDA '],
  );
  }
  
}
