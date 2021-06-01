import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/modelos/Liquidacion.dart';
import 'package:proveedores_manuelita/modelos/AjusteMercExceden.dart';

class Liquidaciones{
List _liquidaciones;
List _ajustes;
List _anticipos;

Conexion session;
var params;
Liquidaciones(Conexion s){
  this.session=s;

}

 Future <List<Liquidacion>>listar_liquidacion(ini,fin,cod_hda)async{
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
   
   map = await this.session.callMethodList('/api/liquidaciones_cana/listar_liquidacion',params);
   List<Liquidacion> usuarios=[];
   for ( var usuario in map)
   {
     usuarios.add(Liquidacion.fromJson(usuario));
   }
   this._liquidaciones= usuarios;
}

 Future <List<Ajuste>>listar_anticipos(ini,fin,cod_hda)async{
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
   
   map = await this.session.callMethodList('/api/liquidaciones_cana/listar_anticipos',params);
   List<Ajuste> anticipos=[];
   for ( var anticipo in map)
   {
     anticipos.add(Ajuste.fromJson(anticipo));
   }
   this._anticipos= anticipos;
}

Future <List<Ajuste>>listar_ajuste(ini,fin,cod_hda)async{
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
   
   map = await this.session.callMethodList('/api/liquidaciones_cana/listar_ajuste_merc_exceden',params);
   List<Ajuste> ajustes=[];
   for ( var ajuste in map)
   {
     ajustes.add(Ajuste.fromJson(ajuste));
   }
   this._ajustes= ajustes;
}

obtener_liquidaciones(){
  return this._liquidaciones;
}
obtener_ajustes(){
  return this._ajustes;
}
obtener_anticipos(){
  return this._anticipos;
}
}