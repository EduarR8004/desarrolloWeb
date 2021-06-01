import 'package:http/http.dart';
import 'package:proveedores_manuelita/modelos/Cronologico.dart';
import 'package:proveedores_manuelita/modelos/EntradaCana.dart';
import 'package:proveedores_manuelita/modelos/EntradaCanaDetalle.dart';
import 'package:proveedores_manuelita/modelos/EntradaCanaGeneral.dart';
import 'package:proveedores_manuelita/modelos/EntradaCanaTotal.dart';

import 'package:proveedores_manuelita/utiles/Conexion.dart';


class Cronologicos{
List _objetos;
List _cronologico;

Conexion session;
var params;
Cronologicos(Conexion s){
  this.session=s;
}

Future <List<Cronologico>>listar_cronologico(cod_hda)async{
   List map;
   var params;

    if(cod_hda=='')
    {
      params={};
    }else
    {
      params={
          "cod_hda":cod_hda
        };
    }
   map = await this.session.callMethodList('/api/cronologico/listar_cronologico',params);
   List<Cronologico> objetos=[];
   for ( var entrada in map)
   {
     objetos.add(Cronologico.fromJson(entrada));
   }
   this._cronologico= objetos;
}

obtener_cronologico()
{
  return this._cronologico;
}

limpiar_cronologico()
{
  return this._cronologico;
}
}