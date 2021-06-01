import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proveedores_manuelita/constants/route_paths.dart' as routes;
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/vistas/consultas/Consultas.dart';
import 'package:proveedores_manuelita/vistas/entradaCana/EntradasCana.dart';
import 'package:proveedores_manuelita/vistas/infoProduccion/InfoProduccion.dart';
import 'package:proveedores_manuelita/vistas/liquidaciones/Liquidaciones.dart';
Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name) {
      case routes.Consultas:
        var  data = settings.arguments as Data;
        return MaterialPageRoute(builder: (context) => VerConsultas(data:data));
      case routes.EntradaDeCana:
        var  data = settings.arguments as Data;
        return MaterialPageRoute(builder: (context) => EntradasCanas(data:data));
      case routes.InformeDeProduccion:
        var  data = settings.arguments as Data;
        return MaterialPageRoute(builder: (context) => InfoProduccion(data:data));
      case routes.LiquidacionCana:
        var  data = settings.arguments as Data;
        return MaterialPageRoute(builder: (context) => VerLiquidaciones(data:data));
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No path for ${settings.name}'),
            ),
          ),
        );
    }
  
}
