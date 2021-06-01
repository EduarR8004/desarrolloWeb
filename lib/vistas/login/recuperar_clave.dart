import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:proveedores_manuelita/logica/Usuarios.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/utiles/Seguridad.dart';
import 'package:proveedores_manuelita/utiles/Utiles.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/vistas/index.dart';
import 'package:proveedores_manuelita/vistas/login/Politica_tratamiento_datos.dart';
import 'package:proveedores_manuelita/vistas/login/solicitar_recuperar_clave.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Recuperar extends StatefulWidget {
  var data;
  
  
  Recuperar(this.data);
  @override
  _State createState() => _State();
}
 
class _State extends State<Recuperar> {
  TextEditingController dinamicaController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ProgressDialog pr;
  var usuario;
  Map usuario_actual;
  List<String> objetos=[];

  void initState() {
    super.initState();
    widget.data;
    
  }

  @override
  void dispose() {
    dinamicaController.dispose();
    passwordController.dispose();
  super.dispose();
  }
  
  Future set_preference()async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     preferences.setString('user', usuario);
     preferences.setString('pass', passwordController.text);
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
            pr.hide();
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
}

validar ()async
{ 
  var session= Conexion();
  var seguridad= Seguridad(session);
  var usuario= Usuarios(session);
  await pr.show();
  session.recuperar(passwordController.text,widget.data.token,dinamicaController.text).then((_) {
  List<String> adminu;
  pr.hide();
  seguridad.descargar_todos().then((_){
    usuario.usuario_actual().then((_){
      usuario_actual=usuario.obtener_usuario();
      adminu=seguridad.obtener_todos();
      objetos.addAll(adminu);
      pr.hide();
      final data = Data.mensaje(
        token: session.get_session(),
        obj: objetos,
        entrada: true,
        produccion: true,
        crono: true,
        usuario_actual:usuario_actual 
      );
      if(session.get_aceptar()){
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Inicio(data:data,retorno:'')));
      }else{
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PoliticaTratamientoDatos(data:data,retorno:'')));
      }
  });      
});
     if(session.validar == null){
      
      String mensaje=session.mensaje; 

      if (mensaje!=null)
      {
        confirm ("Clave Dinámica incorrecta"); 
                                
      }else{
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
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
      message: 'Validando la información del Usuario',
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
    onWillPop: () async => true,
    child:new Scaffold(
      body: Padding(
        padding: EdgeInsets.all(1),
          child: new Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                   Container(
                    color:Colors.white,
                    height:35,
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Color.fromRGBO(56, 124, 43, 1.0),
                          ),
                           onPressed: () {
                            Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => SolicitarRecuperar()));
                            //Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                   ), 
                    Container(
                        color:Colors.white,
                        height:600,
                        //MediaQuery.of(context).size.height,
                        //width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              //SizedBox(height: 5),
                              Container(
                                //height: 150,
                                ///child:FadeInUp(
                                  child: Container(
                                    height: 120,
                                    width: 250,
                                    decoration: BoxDecoration(
                                      color: Colors.white,  
                                        //borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        image: AssetImage("images/logo_principal.JPG"),
                                          fit: BoxFit.fitWidth),
                                      ),
                                    margin: EdgeInsets.all(0),
                                    padding: EdgeInsets.symmetric(horizontal:10),
                                    
                                  ), 
                                  //duration: Duration(seconds:2),
                                //),
                                //,
                              ),
                              SizedBox(height:50),
                              Text("Proveedores Caña",style: TextStyle(
                                      color: Color.fromRGBO(83, 86, 90, 1.0),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                              )),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal:10,vertical:0),
                                height: 400,//MediaQuery.of(context).size.height * 0.70,
                                width:MediaQuery.of(context).size.width,
                                color:Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text("Actualización de Contrseña",style: TextStyle(
                                      color: Color.fromRGBO(83, 86, 90, 1.0),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold
                                    )),
                                    
                                    SizedBox(height: 15),
                                      Container(
                                        width: 400,
                                        padding: EdgeInsets.all(30),
                                        child: Column(
                                          children: <Widget>[
                                            TextFormField(
                                              controller: dinamicaController,
                                              validator: (value){
                                                if (value.isEmpty) {
                                                  return 'Por favor Ingrese su Clave Dinámica';
                                                }
                                              },
                                              style: TextStyle(color: Color.fromRGBO(83, 86, 90, 1.0),fontWeight: FontWeight.bold), 
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
                                                labelText:"Clave Dinámica",
                                                labelStyle: TextStyle(color:Color.fromRGBO(83, 86, 90, 1.0),fontWeight: FontWeight.bold),
                                                suffixIcon: Icon(Icons.mobile_friendly_outlined, size: 27,color: Color.fromRGBO(83, 86, 90, 1.0),),
                                              ),
                                              
                                          ),
                                          SizedBox(height: 10),
                                          TextFormField(
                                              controller:passwordController ,
                                              obscureText: true,
                                              validator: (value){
                                              if (value.isEmpty) {
                                                    return 'Por favor Ingrese su Contraseña';
                                              }
                                              },
                                              style: TextStyle(color: Color.fromRGBO(83, 86, 90, 1.0),fontWeight: FontWeight.bold), 
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
                                                labelText:"Nueva Contraseña",
                                                labelStyle: TextStyle(color:Color.fromRGBO(83, 86, 90, 1.0),fontWeight: FontWeight.bold),
                                                suffixIcon: Icon(Icons.https, size: 27,color: Color.fromRGBO(83, 86, 90, 1.0),),
                                              ),
                                              
                                          ),
                                          
                                          SizedBox(height:5),
                                          // ButtonLoginAnimation(
                                          //   label: "Ingresar",
                                          //   fontColor: Color.fromRGBO(255, 210, 0, 1.0),
                                          //   background: Colors.white,
                                          //   borderColor: Colors.white,
                                          //   child: validar(),
                                          // ),
                                          // Text("¿Olvidó su Contraseña?",style: TextStyle(
                                          //   color: Color.fromRGBO(255, 255, 255, 1.0),
                                          //   fontSize: 20,
                                          //   fontWeight: FontWeight.bold
                                          // )),
                                          SizedBox(height:25),
                                           Container(
                                            height: 48,
                                            width: 250,
                                              //padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                              child: RaisedButton(
                                                textColor: Color.fromRGBO(255, 210, 0, 1.0),
                                                color: Colors.white,
                                                child: Text('Actualizar Contraseña', style: TextStyle(
                                                  color: Color.fromRGBO(83, 86, 90, 1.0),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold
                                                )),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(18.0),
                                                  side: BorderSide(color: Colors.white)
                                                ),
                                                onPressed: () {
                                                  if (!_formKey.currentState.validate()){
                                                          Scaffold.of(context).showSnackBar(
                                                            SnackBar(content: Text('Processing Data'))
                                                          );
                                                  }else{
                                                    validar ();
                                                  }
                                                },
                                              )),
                                              SizedBox(height:30),
                                          ],
                                          
                                        ),
                                      ),
                                     
                                  ],
                                ),
                              )
                            ],
                          ),
                        
                      ),
                    
              ],
            ),
          ),
      ),
    ),   
  );
  }
}


 
//  return Scaffold(
//         appBar: AppBar(
//           title: Text('Proveedores Caña Manuelita'),
//         ),
//         body: Padding(
//             padding: EdgeInsets.all(10),
//             child: new Form(
//               key: _formKey,
//               child: ListView(
//                 children: <Widget>[
//                   new Container(
//                           padding: EdgeInsets.only(top:10.0,bottom:10.0),
//                           child: new Image(
//                             width: 120,
//                             height: 120,
//                             image: new AssetImage('assets/img/logo.png'),
//                             ) ,
//                   ),
//                   // Container(
//                   //     alignment: Alignment.center,
//                   //     padding: EdgeInsets.all(10),
//                   //     child: Text(
//                   //       'TutorialKart',
//                   //       style: TextStyle(
//                   //           color: Colors.blue,
//                   //           fontWeight: FontWeight.w500,
//                   //           fontSize: 30),
//                   //     )),
//                   Container(
//                       alignment: Alignment.center,
//                       padding: EdgeInsets.all(10),
//                       child: Text(
//                         'Recuperar Contraseña',
//                         style: TextStyle(fontSize: 20),
//                       )),
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     child: TextFormField(
//                       controller: dinamicaController,
//                       validator: (value){
//                             if (value.isEmpty) {
//                             return 'Por favor Ingrese su Clave Dinamica';
//                             }
//                           },
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Clave Dinamica',
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
//                     child: TextFormField(
//                       obscureText: true,
//                       controller: passwordController,
//                       validator: (value){
//                       if (value.isEmpty) {
//                             return 'Por favor Ingrese su Contraseña';
//                       }
//                       },
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Nueva Contraseña',
//                       ),
//                     ),
//                   ),
//                   FlatButton(
//                     onPressed: (){
//                       // Navigator.of(context).push(
//                       // MaterialPageRoute(builder: (context) => Recuperar()));
//                     },
//                     textColor: Colors.blue,
//                     child: Text('Forgot Password'),
//                   ),
//                   Container(
//                     height: 50,
//                       padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                       child: RaisedButton(
//                         textColor: Colors.white,
//                         color: Colors.blueGrey,
//                         child: Text('Login'),
//                         onPressed: () {
//                           if (!_formKey.currentState.validate()){
//                                   Scaffold.of(context).showSnackBar(
//                                     SnackBar(content: Text('Processing Data'))
//                                   );
//                           }else{
//                             print(dinamicaController.text);
//                             print(passwordController.text);
//                             validar ();
                            
//                           }
                          

//                         },
//                       )),
//                   Container(
//                     child: Row(
//                       children: <Widget>[
//                         Text('Does not have account?'),
//                         FlatButton(
//                           textColor: Colors.blueGrey,
//                           child: Text(
//                             'Sign in',
//                             style: TextStyle(fontSize: 20),
//                           ),
//                           onPressed: () {
//                             //signup screen
//                           },
//                         )
//                       ],
//                       mainAxisAlignment: MainAxisAlignment.center,
//                   ))
//                 ],
//               ),
//             ),
//             )
//             );