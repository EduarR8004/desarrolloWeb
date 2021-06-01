import 'package:proveedores_manuelita/utiles/Conexion.dart';


class AsistenciasTecnicas{

Map _texto;

Conexion session;
var params;
AsistenciasTecnicas(Conexion s){
  this.session=s;
}


Future <Map>recuperar_texto(categoria,subcateroria)async{
   Map map;
   var params={"categoria":{categoria:subcateroria}};
   map = await this.session.callMethodOne('/api/asistencia_tecnica/recuperar_texto',params);
   this._texto=map;
}

Future <Map>almacenar_texto(categoria,subcateroria,texto)async{
   Map map;
   var params={"categoria":{categoria:subcateroria},"texto":texto};
   map = await this.session.callMethodOne('/api/asistencia_tecnica/almacenar_texto',params);
}

 establecer_texto(){
   return this._texto;
 }

}