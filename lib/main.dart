import 'package:flutter/material.dart';
import 'package:proveedores_manuelita/services/navigator_service.dart';
import 'package:proveedores_manuelita/utiles/locator.dart';

import 'package:proveedores_manuelita/vistas/consultas/Consultas.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/vistas/index.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proveedores_manuelita/utiles/Splash.dart';
import 'package:proveedores_manuelita/utiles/Notificaciones.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:proveedores_manuelita/router.dart'as router;
import 'dart:io';

void main() {
  HttpOverrides.global = new MyHttpOverrides ();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  void initState() {
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(_) => Conexion(),
      builder : (BuildContext context, Widget child){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Proveedores Caña Manuelita',
          initialRoute: 'splash',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          onGenerateRoute: router.generateRoute,
          navigatorKey: locator<NavigatorService>().navigatorKey,
          routes:{
            'splash' :(BuildContext context)=>Splash(),
            'consultas' :(BuildContext context)=>VerConsultas(),
          },
          //home: Splash(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en','US'), // English
            const Locale('es','CO'), // Spanish
          // const Locale('fr'), // French
          // const Locale('zh'), // Chinese
          ],
        );
      }
    
    );
  }
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
  return super.createHttpClient(context)
  ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}