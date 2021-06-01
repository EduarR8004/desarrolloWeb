class Data {
  String token,usuario,pass,parametro,suerte;
  List obj;
  bool entrada,crono,produccion;
  List usuarios;
  Map usuario_actual;
  
  Data({this.token, this.obj,this.usuario,this.pass,this.parametro,this.usuario_actual});
  Data.objetos({this.token, this.obj});
  Data.parametros({this.parametro,this.token,this.suerte});
  Data.usuarios({this.token, this.usuarios,this.parametro});
  Data.mensaje({this.token, this.obj,this.usuario,this.pass,this.entrada,this.crono,this.produccion,this.usuario_actual});
}
class ParametrosOrden {
  String parametroFechaI,parametroFechaF,tipoOrden;
  int fechaParametroI,fechaParametroF;
  ParametrosOrden({
    this.parametroFechaI,this.parametroFechaF,
    this.fechaParametroI,this.fechaParametroF,
    this.tipoOrden
  });
  
}
