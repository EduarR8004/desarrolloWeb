import 'package:http/http.dart';

import 'dart:convert';

import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/modelos/Orden.dart';

class Ordenes{
List _ordenes;

Conexion session;
var params;
Ordenes(Conexion s){
  this.session=s;

}


Future <List<Orden>>listar_ordenes(tipo,ini,fin)async{
   List map;
   var params;
    if(tipo=='')
    {
       params={
      "fecha_inicial" : ini,
      "fecha_final" : fin,
      };
    }else{
       params={
      "inicio" : ini,
      "fin" : fin,
      "tipo":tipo
      };
    }
   map = await this.session.callMethodList('/api/admin_documentos/listar_ordenes',params);
   List<Orden> ordenes=[];
   for ( var usuario in map)
   {
     ordenes.add(Orden.fromJson(usuario));
   }
   this._ordenes= ordenes;
}
Future <Map>eliminar_orden(id)async{
   Map map;
   var params={"orden_procesamiento_id":id};
   map = await this.session.callMethodOne('/api/admin_documentos/eliminar_orden',params);
}

Future <Map>editar_orden({id,tipo,notas})async{
   var map;
   var params={"orden_procesamiento_id":id,
                "notas":notas,
                "tipo":tipo};
   map = await this.session.callMethodOne('/api/admin_documentos/editar_orden',params);
}


 obtener_ordenes(){
    return this._ordenes;
}


}