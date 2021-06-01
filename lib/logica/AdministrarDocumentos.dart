import 'package:proveedores_manuelita/modelos/AdminDistri.dart';
import 'package:proveedores_manuelita/modelos/AdminDocumento.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';


class AdministrarDocumentos{
List _objetos;
List _documentos;
List _documentosDistri;
Map _id,_ruta;

Conexion session;
var params;
AdministrarDocumentos(Conexion s){
  this.session=s;
}

Future <List<AdminDocumento>>listar_documentos(id)async{
   List map;
   var params={
          "orden_procesamiento_id":id
      };
   map = await this.session.callMethodList('/api/admin_documentos/consultar_documentos_producidos',params);
   List<AdminDocumento> objetos=[];
   for ( var entrada in map)
   {
     objetos.add(AdminDocumento.fromJson(entrada));
   }
   this._documentos= objetos;
}

Future <List<AdminDocumento>>listar_documentos_distri(id)async{
   List map;
   var params={
          "orden_procesamiento_id":id
      };
   map = await this.session.callMethodList('/api/admin_documentos/consultar_documentos_producidos',params);
   List<AdminDocumentoDistri> objetos=[];
   for ( var entrada in map)
   {
     objetos.add(AdminDocumentoDistri.fromJson(entrada));
   }
   this._documentosDistri= objetos;
   //return this._documentosDistri;
}

Future <Map>crear_orden(tipo)async{
   Map map;
   var params={"tipo":tipo};
   map = await this.session.callMethodOne('/api/admin_documentos/crear_orden',params);
   this._id=map;
}

Future <Map>distribuir(id,tipo,preliminar)async{
   Map map;
   var params={"orden_procesamiento_id":id,"tipo":tipo,"preliminar":preliminar};
   map = await this.session.callMethodOne('/api/admin_documentos/distribuir_orden',params);
}

Future <Map>precesar_orden(id)async{
   Map map;
   var params={"orden_procesamiento_id":id};
   map = await this.session.callMethodOne('/api/admin_documentos/procesar_orden',params);
   return map;
}
//OrdenProcesamientoDocumentos5f3c45d45b1d9b37238040fa72ef49d125f3cbb0

Future <Map>obtener_ruta_documento(id)async{
   Map map;
   var params={"documento_id":id};
   map = await this.session.callMethodOne('/api/admin_documentos/obtener_documento',params);
   this._ruta=map;
}
 establecer_ruta(){
   return this._ruta;
 }
obtener_documentos()
{
  return this._documentos;
}
obtener_documentos_distri()
{
  return this._documentosDistri;
}

limpiar_documentos()
{
  return this._documentos;
}
obtener_orden()
{
  return this._id;
}
}