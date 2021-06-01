import 'dart:convert';

class InformeProduccion {
  
String area_cosechada;
String area_lib;
String area_total;
String data_ultcol;
String edad;
String fazenda;
String fecha_ultco;
String ncortes;
String rdto;
String sacpc;
String suerte;
String tc;
String tch;
String tchm;
String variedad;
String cierre;

InformeProduccion({
    this.area_cosechada,
    this.area_lib,
    this.area_total,
    this.data_ultcol,
    this.edad,
    this.fazenda,
    this.fecha_ultco,
    this.ncortes,
    this.rdto,
    this.sacpc,
    this.suerte,
    this.tc,
    this.tch,
    this.tchm,
    this.variedad,
    this.cierre
  });

  Map<String, dynamic>to_Map() =>{
  'AREA_COSECHADA':area_cosechada,
  'SALDO_AREA':area_lib,
  'AREA_TOTAL':area_total,
  'DATA_ULTCOL':data_ultcol,
  'EDAD':edad,
  'FAZENDA':fazenda,
  'FECHA_ULTCO':fecha_ultco,
  'NCORTES':ncortes,
  'RDTO':rdto,
  'SACPC':sacpc,
  'SUERTE':suerte,
  'TC':tc,
  'TCH':tch,
  'TCHM':tchm,
  'VARIEDAD':variedad,
  'ESTADO_CORTE':cierre,
  };


  factory InformeProduccion.fromJson(Map<String, dynamic> json){
  
  return new InformeProduccion(

  area_cosechada:json['AREA_COSECHADA']==null?'':json['AREA_COSECHADA'],
  area_lib:json['SALDO_AREA']==null?'':json['SALDO_AREA'],
  area_total:json['AREA_TOTAL']==null?'':json['AREA_TOTAL'],
  data_ultcol:json['DATA_ULTCOL']==null?'':json['DATA_ULTCOL'],
  edad:json['EDAD']==null?'':json['EDAD'],
  fazenda:json['FAZENDA']==null?'':json['FAZENDA'],
  fecha_ultco:json['FECHA_ULTCOL']==null?'':json['FECHA_ULTCOL'],
  ncortes:json['NCORTES']==null?'':json['NCORTES'],
  rdto:json['RDTO']==null?'':json['RDTO'],
  sacpc:json['SACPC']==null?'':json['SACPC'],
  suerte:json['SUERTE']==null?'':json['SUERTE'],
  tc:json['TC']==null?'':json['TC'],
  tch:json['TCH']==null?'':json['TCH'],
  tchm:json['TCHM']==null?'':json['TCHM'],
  variedad:json['VARIEDAD']==null?'':json['VARIEDAD'],
  cierre:json['ESTADO_CORTE']==null?'':json['ESTADO_CORTE'],
  );
  }
  
}
