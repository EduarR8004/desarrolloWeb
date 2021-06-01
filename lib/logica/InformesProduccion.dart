import 'package:http/http.dart';
import 'package:proveedores_manuelita/modelos/InfoProduccion.dart';
import 'dart:convert';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/modelos/response_status.dart';
import 'package:proveedores_manuelita/utiles/Utiles.dart';
import 'package:proveedores_manuelita/modelos/Respuesta.dart';
import 'package:proveedores_manuelita/modelos/Objeto.dart';

class InformesProduccion{
List _objetos;
List _informes;
List _entradas;
List _detalle;
Map _total;
Conexion session;
var params;
InformesProduccion(Conexion s){
  this.session=s;
}

Future <List<InformesProduccion>>listar_informes(ini,fin,cod_hda)async{
   List map;
   var params;
    if(cod_hda=='')
    {
       params={
      "fecha_inicial" : ini,
      "fecha_final" : fin,
      };
    }else{
       params={
      "fecha_inicial" : ini,
      "fecha_final" : fin,
      "cod_hda":cod_hda
      };
    }
   
   map = await this.session.callMethodList('/api/informe_produccion/consultar_info_produc_suerte',params);
   List<InformeProduccion> objetos=[];
   for ( var entrada in map)
   {
     objetos.add(InformeProduccion.fromJson(entrada));
   }
   this._informes= objetos;
}

obtener_informes(){
  return this._informes;
}

limpiar_informes(){
    return this._informes;
}

}