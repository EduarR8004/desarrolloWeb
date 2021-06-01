import 'dart:convert';

//import 'package:flutter/foundation.dart';

class AsisTecnica {
  
  String texto;

  AsisTecnica({
    this.texto,
  });
 
  Map<String, dynamic>to_Map() =>{
    'NM_HDA':texto,
  };

  factory AsisTecnica.fromJson(Map<String, dynamic> json){
  
    return new AsisTecnica(

      texto:json['texto']==null?'':json['texto'],
    );
  }

}