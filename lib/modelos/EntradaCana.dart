import 'dart:convert';

//import 'package:flutter/foundation.dart';

class EntradaCana {
  
  String nm_hda;
  String cod_hda;
  String fch_ini_ent;
  String fch_ult_ent;

  EntradaCana({
    this.nm_hda,
    this.cod_hda,
    this.fch_ini_ent,
    this.fch_ult_ent,
  });
 
  Map<String, dynamic>to_Map() =>{
    'NM_HDA':nm_hda,
    'cod_hda':cod_hda,
    'fch_ini_ent':fch_ini_ent,
    'fch_ult_ent':fch_ult_ent,
    
  };

  factory EntradaCana.fromJson(Map<String, dynamic> json){
  
    return new EntradaCana(

      nm_hda:json['NM_HDA']==null?'':json['NM_HDA'],
      cod_hda:json['COD_HDA']==null?'':json['COD_HDA'],
      fch_ini_ent:json['FCH_INI_ENT']==null?'':json['FCH_INI_ENT'],
      fch_ult_ent:json['FCH_ULT_ENT']==null?'':json['FCH_ULT_ENT'],
    );
  }

}
