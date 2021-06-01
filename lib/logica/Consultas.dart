
import 'package:proveedores_manuelita/modelos/Consulta.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';


class Consultas{
List _objetos;
List _consultas;

Conexion session;
var params;
Consultas(Conexion s){
  this.session=s;
}

Future <List<Consulta>>listar_consultas(inicio,fin,tipo)async{
  List map;
  var params={
    "inicio":inicio,"fin":fin, "tipo":tipo
  };
   map = await this.session.callMethodList('/api/admin_documentos/listar_documentos',params);
   List<Consulta> objetos=[];
   for ( var entrada in map)
   {
     objetos.add(Consulta.fromJson(entrada));
   }
   this._consultas= objetos;
}

obtener_consulta()
{
  return this._consultas;
}

limpiar_consulta()
{
  return this._consultas;
}
}