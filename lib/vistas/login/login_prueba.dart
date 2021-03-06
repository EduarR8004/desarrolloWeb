import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:proveedores_manuelita/vistas/login/Politica_tratamiento_datos.dart';
import 'package:universal_io/io.dart';
import 'package:provider/provider.dart';
import 'package:proveedores_manuelita/logica/Usuarios.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/utiles/Seguridad.dart';
import 'package:proveedores_manuelita/utiles/Utiles.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/vistas/index.dart';
import 'package:proveedores_manuelita/vistas/login/solicitar_recuperar_clave.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login_prueba extends StatefulWidget {
  bool clear;
  final String title;
  
  Login_prueba(this.clear,{Key key, this.title}) : super(key: key);
  @override
  _State createState() => _State();
}
 
class _State extends State<Login_prueba> {
  String token;
  List obj;
  bool isLoggedIn = true;
  ProgressDialog pr;
  String name = '';
  Map usuario_actual;
  String stored_user;
  String stored_pass;
  String stored_session;
  List<String> objetos=[];
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid){
      autoLogIn();
    }
  }
@override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
  super.dispose();
  }
void confirm (dialog){
  Alert(
    context: context,
    type: AlertType.error,
    title: "Error de Validación",
    desc: dialog,
    buttons: [
      DialogButton(
        child: Text(
          "Aceptar",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          
          Navigator.pop(context);
        },
        width: 120,
      )
    ],
  ).show();
}
autoLogIn(){
  setState(() {
    if(widget.clear==false){
      get_preference();
    }else
    {   
      clear_preferences();
      get_preference();
    }
  });   
}

Future clear_preferences()async{
SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.getKeys();
  for(String key in preferences.getKeys()) {
    if(key != "mobil_id" && key!= "server") {
      preferences.remove(key);
    }
  }
}
Future set_preference()async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('user', nameController.text);
  preferences.setString('pass', passwordController.text);
}

Future get_preference()async{
	SharedPreferences preferences = await SharedPreferences.getInstance();
	setState(() {
	  stored_user=preferences.get('user')?? null;
	  stored_pass=preferences.get('pass')?? null;
	  if(stored_user!=null && stored_pass!=null )
	  { 
	    isLoggedIn=false;
	    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true,);
	    pr.style(
	      message: 'Recuperando Credenciales del Usuario: '+stored_user,
	      borderRadius: 10.0,
	      backgroundColor: Colors.white,
	      progressWidget: CircularProgressIndicator(),
	      elevation: 10.0,
	      insetAnimCurve: Curves.easeInOut,
	      progress: 0.0,
	      maxProgress: 100.0,
        textAlign:TextAlign.center,
	      progressTextStyle: TextStyle(
	      color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
	      messageTextStyle: TextStyle(
	      color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
	    );
	    pr.show();
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
          pr.hide();
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => Inicio(data:data,retorno:''),)); 
          });
        });
                         
      });    
      if(session.validar == true){
      String token=session.get_session();
      }else{
        String mensaje=session.mensaje; 
        if (mensaje!=null)
        { 
          pr.hide();
          confirm (mensaje);                    
        }else{
          pr.hide();
          confirm ("Sin conexión al servidor");
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
	});     
}
validar()async{
  var loginProvider = Provider.of<Conexion>(context, listen: false);
  var session= Conexion();
  var seguridad= Seguridad(loginProvider);
  var usuario= Usuarios(loginProvider);
  await pr.show();
  loginProvider.autenticar(nameController.text, passwordController.text).then((_) {
  List<String> adminu;
  seguridad.descargar_todos().then((_){
    usuario.usuario_actual().then((_){
      usuario_actual=usuario.obtener_usuario();
      adminu=seguridad.obtener_todos();
      objetos.addAll(adminu);
      pr.hide();
      if(Platform.isAndroid){
        set_preference();
      }
      final data = Data.mensaje(
        usuario:stored_user ,
        pass:stored_pass,
        token: loginProvider.get_session(),
        obj: objetos,
        entrada: true,
        produccion: true,
        crono: true,
        usuario_actual:usuario_actual 
      );
      // if(loginProvider.get_aceptar()){
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //                           Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => Inicio(data:data,retorno:''),)); }); 
      // }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => PoliticaTratamientoDatos(data:data,retorno:''),)); }); 
      //}
        
    });              
  });
  if(loginProvider.validar == true){
    String token=session.get_session();
  }else{
    var mensaje=session; 
    if (mensaje!=null)
    { 
      pr.hide();
      confirm (mensaje.mensaje);                    
    }else{
      pr.hide();
      confirm ("Sin conexión al servidor");
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

  Widget build(BuildContext context) {
  pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
  pr.style(
    message: 'Validando la información del Usuario '+nameController.text,
    borderRadius: 10.0,
    backgroundColor: Colors.white,
    progressWidget: CircularProgressIndicator(),
    elevation: 10.0,
    insetAnimCurve: Curves.easeInOut,
    progress: 0.0,
    maxProgress: 100.0,
    textAlign:TextAlign.center,
    progressTextStyle: TextStyle(
    color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
    messageTextStyle: TextStyle(
    color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
  );
  return WillPopScope(
    onWillPop: () {  },
    child:new Scaffold(
      body:
      // Container(
      //   // decoration: BoxDecoration(
      //   //   gradient: LinearGradient(
      //   //     colors: [Colors.white,Color.fromRGBO(56,124,43, 1.0)],
      //   //     stops: [0.3,0.7],
      //   //     begin: FractionalOffset.topCenter,
      //   //     end: FractionalOffset.bottomCenter
      //   //   )
      //   // ),
      //   alignment:Alignment.center,
      //   height: double.infinity,
      //   child: 
        Stack(
          alignment:Alignment.center,
          children: [
            Container(
              height: double.infinity,
              alignment:Alignment.center,
              child:
              Image.asset(
                "images/login1.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                SizedBox(height:10),
                new Form(
                  key: _formKey,
                  child:
                  Container(
                    alignment:Alignment.center,
                    color:Colors.white,
                    //padding: EdgeInsets.symmetric(horizontal:10,vertical:0),
                    height:500,//MediaQuery.of(context).size.height * 0.70,
                    width:400,
                    decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      //   colors: [Color.fromRGBO(56, 124, 43, 1.0), Color.fromRGBO(176, 188, 34, 1.0)],
                      //   tileMode: TileMode.repeated,
                      // ),         
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(1),
                        topRight: Radius.circular(1)
                      )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Text("Proveedores Caña",textAlign:TextAlign.center,style: TextStyle(
                          color: Color.fromRGBO(83, 86, 90, 1.0),
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        )
                        ),
                        SizedBox(height:70),
                        Container(
                          width: 450,
                          padding: EdgeInsets.fromLTRB(30,5,30,30),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller:nameController ,
                                validator: (value){
                                if (value.isEmpty) {
                                      return 'Por favor Ingrese su Usuario';
                                }
                                },
                                style:TextStyle(color: Color.fromRGBO(83, 86, 90, 1.0),fontWeight: FontWeight.bold), 
                                //TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                obscureText:false,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(      
                                    borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),   
                                  ),  
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
                                  ),
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(color:Color.fromRGBO(83, 86, 90, 1.0),width: 1.0)
                                  // ),
                                  // enabledBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.white, width: 1.0)
                                  // ),
                                  labelText:"Usuario",
                                  labelStyle: TextStyle(color:Color.fromRGBO(83, 86, 90, 1.0),fontWeight: FontWeight.bold),
                                  suffixIcon: Icon(Icons.people_alt_rounded, size: 27,color: Color.fromRGBO(83, 86, 90, 1.0),),
                                ),
                                
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller:passwordController ,
                                validator: (value){
                                if (value.isEmpty) {
                                      return 'Por favor Ingrese su Contraseña';
                                }
                                },
                                style:TextStyle(color: Color.fromRGBO(83, 86, 90, 1.0),fontWeight: FontWeight.bold), 
                                //style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                obscureText:true,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(      
                                    borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),   
                                  ),  
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
                                  ),
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.white,width: 1.0)
                                  // ),
                                  // enabledBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.white, width: 1.0)
                                  // ),
                                  labelText:"Contraseña",
                                  labelStyle: TextStyle(color: Color.fromRGBO(83, 86, 90, 1.0),fontWeight: FontWeight.bold),
                                  suffixIcon: Icon(Icons.https, size: 27,color: Color.fromRGBO(83, 86, 90, 1.0),),
                                ),
                                
                              ),
                              //SizedBox(height:15),
                              SizedBox(height:30),
                              Container(
                              height: 50,
                              width: 250,
                                //padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: RaisedButton(
                                  textColor: Color.fromRGBO(83, 86, 90, 1.0),
                                  //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                                  color: Color.fromRGBO(56, 124, 43, 1.0),
                                  child: Text('Ingresar', style: TextStyle(
                                    color:  Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  )),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    side: BorderSide(color: Colors.white)
                                  ),
                                  onPressed: () {
                                    if (!_formKey.currentState.validate()){
                                            Scaffold.of(context).showSnackBar(
                                              SnackBar(content: Text('Processing Data'))
                                            );
                                    }else{
                                      validar();   
                                    }
                                  },
                                )
                              ),
                              SizedBox(height:50),
                              FlatButton(
                                onPressed: (){
                                  Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => SolicitarRecuperar()));
                                },
                                textColor:Color.fromRGBO(83, 86, 90, 1.0),
                                child: Text("¿Olvidó su Contraseña?",style: TextStyle(
                                  color: Color.fromRGBO(83, 86, 90, 1.0),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),),
                              ),
                              SizedBox(height:50),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      //)
    ),   
  );
  }

}
 
  