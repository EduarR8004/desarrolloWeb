import 'package:proveedores_manuelita/utiles/Conexion.dart';


class ActualizarDocLogica{
List _objetos;
List _documentos;
List _documentosDistri;
Map _id,_ruta;

Conexion session;
var params;
ActualizarDocLogica(Conexion s){
  this.session=s;
}


Future <Map>obtener_ruta_documento_natural()async{
   Map map;
   var params={};
   map = await this.session.callMethodOne('/api/formato_vinculacion_natural/obtener_pdf',params);
   this._ruta=map;
}

Future <Map>obtener_ruta_documento_politica()async{
   Map map;
   var params={};
   map = await this.session.callMethodOne('/api/formato_autorizacion_tratamiento/obtener_pdf',params);
   this._ruta=map;
}

Future <Map>obtener_ruta_documento_juridica()async{
   Map map;
   var params={};
   map = await this.session.callMethodOne('/api/formato_vinculacion_juridica/obtener_pdf',params);
   this._ruta=map;
}

 establecer_ruta(){
   return this._ruta;
 }

}