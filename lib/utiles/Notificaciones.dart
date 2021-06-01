import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:universal_io/io.dart';

import 'package:proveedores_manuelita/services/navigator_service.dart';
import 'package:proveedores_manuelita/utiles/locator.dart';
import 'package:proveedores_manuelita/constants/route_paths.dart';
import 'package:proveedores_manuelita/utiles/Seguridad.dart';
import 'package:proveedores_manuelita/utiles/Utiles.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/logica/Usuarios.dart';
import 'package:proveedores_manuelita/utiles/Globals.dart';

class Notificaciones{
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final _mensajes= StreamController<String>.broadcast();
  Data data;
  Map usuario_actual;
  String stored_user;
  String stored_pass;
  String stored_session;
  List<String> objetos=[];
  Stream<String> get mensajes =>_mensajes.stream;
  String mensaje;
  var token;
  List <String>preMensaje=[];
  int contador;

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

}

Future set_preference(token)async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('token', token);
}

  iniciarNotificacion(){
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token){
      print('==== FCM Token');
      print( token );
      set_preference(token);
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> info) async {
        print("onMessage: $info");
        String body='no-data';
        String argumento= 'no-data';
        if(Platform.isAndroid){
          body=info['data']['body'] ?? 'no-data';
          argumento = info['data']['tipo'] ?? 'no-data';
          preMensaje.add(argumento);
          contador=preMensaje.length;
          if(argumento=='LiquidacionCana' || argumento=='LiquidacionMercadoExcedentario' || argumento=='LiquidacionAnticipos'){
            mensajeLiqCana.add(body);
            mensaje='LiquidacionCana';
            liqCana.add(mensaje);
          }
          if(argumento=='EntradaDeCana'){
            mensajeEntradaCana.add(body);
            mensaje='EntradaDeCana';
            entradaCana.add(mensaje);
          }
          if(argumento=='DonacionesCenicana' || argumento=='FondoSocial'|| argumento=='Retenciones'|| argumento=='IngresosYCostos'|| argumento=='Ica'){
            mensaConsultas.add(body);
            mensaje='liquidaciones';
            consultas.add(mensaje);
          }
          if(argumento=='InformeDeProduccion'){
            mensajeInfoProduccion.add(body);
            mensaje='InformeDeProduccion';
            infoProduccion.add(mensaje);
          }
        }
        _mensajes.sink.add(mensaje);
      },
        onLaunch: ( info ) async {
        var lastMessageId = info['data']['google.message_id'];
        Future<SharedPreferences> prefs =  SharedPreferences.getInstance();
        prefs.then((pref){
          if(pref.containsKey(LAST_MESSAGE_ID)) {
            if(pref.getString(LAST_MESSAGE_ID) != lastMessageId) {
              pref.setString(LAST_MESSAGE_ID, lastMessageId);
              print("onMessage: $info");
              String argumento= 'no-data';
              if(Platform.isAndroid){
                argumento = info['data']['tipo'] ?? 'no-data';
                contador=preMensaje.length;
                if(argumento=='LiquidacionCana' || argumento=='LiquidacionMercadoExcedentario' || argumento=='LiquidacionAnticipos'){
                  mensaje='LiquidacionCana';
                  get_preference('LiquidacionCana');
                  
                }
                if(argumento=='EntradaDeCana'){
                  get_preference('EntradaDeCana');
                }
                if(argumento=='DonacionesCenicana' || argumento=='FondoSocial'|| argumento=='Retenciones'|| argumento=='IngresosYCostos'|| argumento=='Ica'){
                  mensaje='liquidaciones';
                  get_preference('Consultas');
                }
                if(argumento=='InformeDeProduccion'){
                  get_preference('InformeDeProduccion');
                }
              }
              _mensajes.sink.add(mensaje);
              
            }
          } else {
            pref.setString(LAST_MESSAGE_ID, lastMessageId);
            print("onMessage: $info");
            String argumento= 'no-data';
            if(Platform.isAndroid){
              argumento = info['data']['tipo'] ?? 'no-data';
            // preMensaje.add(argumento);
              contador=preMensaje.length;
              if(argumento=='LiquidacionCana' || argumento=='LiquidacionMercadoExcedentario' || argumento=='LiquidacionAnticipos'){
                mensaje='LiquidacionCana';
                get_preference('LiquidacionCana');
                
              }
              if(argumento=='EntradaDeCana'){
                get_preference('EntradaDeCana');
              }
              if(argumento=='DonacionesCenicana' || argumento=='FondoSocial'|| argumento=='Retenciones'|| argumento=='IngresosYCostos'|| argumento=='Ica'){
                mensaje='liquidaciones';
                get_preference('Consultas');
              }
              if(argumento=='InformeDeProduccion'){
                get_preference('InformeDeProduccion');
              }
            }
            _mensajes.sink.add(mensaje);
            
          }
        });
      },
      onResume: (Map<String, dynamic> info) async {
        print("onMessage: $info");
        String argumento= 'no-data';
        if(Platform.isAndroid){
          argumento = info['data']['tipo'] ?? 'no-data';
          contador=preMensaje.length;
          if(argumento=='LiquidacionCana' || argumento=='LiquidacionMercadoExcedentario' || argumento=='LiquidacionAnticipos'){
            mensaje='LiquidacionCana';
            get_preference('LiquidacionCana');
          }
          if(argumento=='EntradaDeCana'){

            get_preference('EntradaDeCana');
          }
          if(argumento=='DonacionesCenicana' || argumento=='FondoSocial'|| argumento=='Retenciones'|| argumento=='IngresosYCostos'|| argumento=='Ica'){
            mensaje='liquidaciones';
            get_preference('Consultas');
          }
          if(argumento=='InformeDeProduccion'){
            get_preference('InformeDeProduccion');
          }
        }
        _mensajes.sink.add(mensaje);
      }
    
      // onBackgroundMessage: myBackgroundMessageHandler,
      // onLaunch: (Map<String, dynamic> info) async {
      //   print ('== on Resume ======');
      //   print( info );
      //   final noti = info['data']['tipo'];
      //   // get_preference_notificaction();
      //   // set_preference_notificaction(noti);
      //   if(Platform.isAndroid){
      //   //globalList.add('onLaunch');
      //   }
      //   _mensajes.sink.add(noti);
      //   print ( noti );

      // },
      // onResume: (Map<String, dynamic> info) async {
      //   print ('== on Resume ======');
      //   print( info );
      //   final noti = info['data']['tipo'];
      //   // get_preference_notificaction();
      //   // set_preference_notificaction(noti);
      //   if(Platform.isAndroid){
      //   //globalList.add('onLaunch');
      //   }
      //   _mensajes.sink.add(noti);
      //   print ( noti );
      // },
    );
    // _firebaseMessaging.configure(

    //   onMessage: ( info ) async {
    //     print ('== on mesage ======');
    //     print( info );
    //     String argumento= 'no-data';
    //     if(Platform.isAndroid){
    //       argumento = info['data']['tipo'] ?? 'no-data';
    //       if(argumento=='cana'){
    //         argumento='prueba';
    //         globalList.add('prueba3');
    //       }
    //       //set_preference_notificaction(argumento);
    //     }
    //     _mensajes.sink.add(argumento);
  
    //   },
    //   onLaunch: ( info ) async {
    //     print ('== on Launch ======');
    //     print( info );
    //     final noti = info['data']['tipo'];
    //     if(Platform.isAndroid){
    //     globalList.add('onLaunch');
    //     }
    //     // get_preference_notificaction();
    //     // set_preference_notificaction(noti);
    //     _mensajes.sink.add(noti);
    //     print ( noti );
    //   },
    //   onResume: ( info ) async {
        // print ('== on Resume ======');
        // print( info );
        // final noti = info['data']['tipo'];
        // // get_preference_notificaction();
        // // set_preference_notificaction(noti);
        // if(Platform.isAndroid){
        // globalList.add('onLaunch');
        // }
        // _mensajes.sink.add(noti);
        // print ( noti );
    //https://we.tl/t-zPOmfeQAGj
    //   }
    // );
  }

  obtener_token(){
    return this.token;
  }

  dispose(){
    _mensajes?.close();
  }

  void navegar(){

    _navigatorService.navigateTo(Consultas);

  }

 Future get_preference(parametro)async{
	SharedPreferences preferences = await SharedPreferences.getInstance();
	  stored_user=preferences.get('user')?? null;
	  stored_pass=preferences.get('pass')?? null;
	  if(stored_user!=null && stored_pass!=null )
	  { 
	    var objs;
	    var session= Conexion();
      var usuario= Usuarios(session);
	    var seguridad= Seguridad(session);
	    session.autenticar(stored_user,stored_pass).then((_) {
      List<String> adminu;
      seguridad.descargar_todos().then((_){
        usuario.usuario_actual().then((_){
          usuario_actual=usuario.obtener_usuario();
          adminu=seguridad.obtener_todos();
          objetos.addAll(adminu);
          final data = Data.mensaje(
            usuario:stored_user ,
            pass:stored_pass,
            token: session.get_session(),
            obj: objetos,
            entrada: true,
            produccion: true,
            crono: true,
            usuario_actual:usuario_actual 
          );
          _navigatorService.navigateTo(parametro,arguments:data);
          
      });
                         
      });    
      if(session.validar == true){
      String token=session.get_session();
      }else{
        String mensaje=session.mensaje; 
        if (mensaje!=null)
        { 
                            
        }else{
       
        }                        
      }              
      }).catchError( (onError){

      if(onError is SessionNotFound){
      return 'Usuario o Contraseña Incorrecta';
                              
      }else if(onError is ConnectionError){
                                
      }else{
                              
      }
                                                    
      });
	  }
	     
}
}