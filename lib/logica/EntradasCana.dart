
import 'package:http/http.dart';
import 'package:proveedores_manuelita/modelos/EntradaCana.dart';
import 'package:proveedores_manuelita/modelos/EntradaCanaDetalle.dart';
import 'package:proveedores_manuelita/modelos/EntradaCanaGeneral.dart';
import 'package:proveedores_manuelita/modelos/EntradaCanaTotal.dart';

import 'package:proveedores_manuelita/utiles/Conexion.dart';


class EntradasCana{
List _objetos;
List _haciendas;
List _entradas;
List _detalle;
Map _total;
Conexion session;
var params;
EntradasCana(Conexion s){
  this.session=s;

}


Future <List<EntradaCana>>listar_haciendas(estado)async{
  List map;
  var params={
    "ingreso_cana": estado
  };
   map = await this.session.callMethodList('/api/entrada_cana/listar_haciendas',params);
   List<EntradaCana> objetos=[];
   for ( var entrada in map)
   {
     objetos.add(EntradaCana.fromJson(entrada));
   }
   this._haciendas= objetos;
}

Future <List<EntradaCanaGeneral>>listar_entrada(ini,fin,cod_hda)async{
   List map;
   var params={
          "fecha_inicial":ini,
          "fecha_final":fin,
          "cod_hda":cod_hda,
          "inicial":false
  };
   map = await this.session.callMethodList('/api/entrada_cana/listar_entrada_cana_general',params);
   List<EntradaCanaGeneral> objetos=[];
   for ( var entrada in map)
   {
     objetos.add(EntradaCanaGeneral.fromJson(entrada));
   }
   this._entradas= objetos;
}

Future <List<EntradaCanaDetalle>>listar_detalle(ini,fin,cod_hda,suerte)async{
   List map;
   var params={
          "fecha_inicial":ini,
          "fecha_final":fin,
          "cod_hda":cod_hda,
          "suerte":suerte
        };
   map = await this.session.callMethodList('/api/entrada_cana/listar_entrada_cana_detalle',params);
   List<EntradaCanaDetalle> objetos=[];
   for ( var entrada in map)
   {
     objetos.add(EntradaCanaDetalle.fromJson(entrada));
   }
   this._detalle= objetos;
}

Future <Map>listar_total(ini,fin,cod_hda)async{
   Map map;
   var total;
   var canastas;
   var params={
          "fecha_inicial":ini,
          "fecha_final":fin,
          "cod_hda":cod_hda,
        };
   map = await this.session.callMethodOne('/api/entrada_cana/total_general',params);
   
   this._total=map;
   
}


 obtener_haciendas(){
    return this._haciendas;
}

obtener_entradas(){
    return this._entradas;
}

obtener_detalle(){
    return this._detalle;
}
 obtener_total(){
    return this._total;
}
limpiar_total(){
    return this._total;
}

limpiar_entradas(){
    return this._entradas=[];
}

limpiar_detalle(){
    return this._detalle=[];
}

}