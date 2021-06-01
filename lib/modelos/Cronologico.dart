import 'dart:convert';

class Cronologico {

String area;
String distancia;
String dist_surc;
String edad;
String fecha_siembra;
String fecha_uc;
String hacienda_cod;
String ncorte;
String ocup;
String suerte_cod;
String tch_est;
String variedad;
String zona_agroc;

  Cronologico({
    this.area,
    this.distancia,
    this.dist_surc,
    this.edad,
    this.fecha_siembra,
    this.fecha_uc,
    this.hacienda_cod,
    this.ncorte,
    this.ocup,
    this.suerte_cod,
    this.tch_est,
    this.variedad,
    this.zona_agroc,
  });


  Map<String, dynamic> toMap() {
    return {
      'area': area,
      'distancia': distancia,
      'dist_surc': dist_surc,
      'edad': edad,
      'fecha_siembra': fecha_siembra,
      'fecha_uc': fecha_uc,
      'hacienda_cod': hacienda_cod,
      'ncorte': ncorte,
      'ocup': ocup,
      'suerte_cod': suerte_cod,
      'tch_est': tch_est,
      'variedad': variedad,
      'zona_agroc': zona_agroc,
    };
  }

  factory Cronologico.fromJson(Map<String, dynamic> map) {
    return Cronologico(
      area: map['AREA']==null?'':map['AREA'],
      distancia: map['DISTANCIA']==null?'':map['DISTANCIA'],
      dist_surc: map['DIST_SURC']==null?'':map['DIST_SURC'],
      edad: map['EDAD']==null?'':map['EDAD'],
      fecha_siembra: map['FECHA_SIEMBRA']==null?'':map['FECHA_SIEMBRA'],
      fecha_uc: map['FECHA_UC']==null?'':map['FECHA_UC'],
      hacienda_cod: map['HACIENDA']==null?'':map['HACIENDA'],
      ncorte: map['NCORTE']==null?'':map['NCORTE'],
      ocup: map['OCUP']==null?'':map['OCUP'],
      suerte_cod: map['SUERTE']==null?'':map['SUERTE'],
      tch_est: map['TCH_EST']==null?'':map['TCH_EST'],
      variedad: map['VARIEDAD']==null?'':map['VARIEDAD'],
      zona_agroc: map['ZONA_AGROC']==null?'':map['ZONA_AGROC'],
    );
  }

}
