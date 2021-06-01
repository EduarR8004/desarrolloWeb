import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:proveedores_manuelita/utiles/Seguridad.dart';
import 'package:proveedores_manuelita/utiles/Utiles.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/vistas/index.dart';
import 'package:proveedores_manuelita/vistas/login/login.dart';
import 'package:proveedores_manuelita/vistas/login/recuperar_clave.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SolicitarRecuperar extends StatefulWidget {
  @override
  _Clave createState() => _Clave();
}
 
class _Clave extends State<SolicitarRecuperar> {
  ProgressDialog pr;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    emailController.dispose();
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
             pr.hide();
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
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
                                          MaterialPageRoute(builder: (context) => Login(true)));
                            //Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                   ),
                    Container(
                        color:Colors.white,
                        height:700,
                        //MediaQuery.of(context).size.height,
                        //width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              //SizedBox(height: 5),
                              Container(
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
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                                    padding: EdgeInsets.symmetric(horizontal:10),
                                  ), 
  
                              ),
                              SizedBox(height:50),
                              Text("Proveedores Caña",style: TextStyle(
                                color: Color.fromRGBO(83, 86, 90, 1.0),
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              )),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal:10,vertical:0),
                                height: 450,//MediaQuery.of(context).size.height * 0.70,
                                width:MediaQuery.of(context).size.width,
                                color:Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text("Solicitar Recuperación de Contraseña",style: TextStyle(
                                      color: Color.fromRGBO(83, 86, 90, 1.0),
                                      //Color.fromRGBO(255, 255, 255, 1.0),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold
                                    )),
                                    SizedBox(height:40),
                                      Container(
                                        width: 400,
                                        child: Column(
                                          children: <Widget>[
                                            TextFormField(
                                              controller: emailController,
                                              keyboardType: TextInputType.emailAddress,
                                              validator: validateEmail,
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
                                                labelText:"Ingrese su Correo",
                                                labelStyle: TextStyle(color:Color.fromRGBO(83, 86, 90, 1.0),fontWeight: FontWeight.bold),
                                                suffixIcon: Icon(Icons.email_rounded, size: 27,color: Color.fromRGBO(83, 86, 90, 1.0),),
                                              ),
                                              
                                          ),
                                          SizedBox(height:70),
                                           Container(
                                            height: 50,
                                            width: 250,
                                              //padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                              child: RaisedButton(
                                                textColor: Color.fromRGBO(255, 210, 0, 1.0),
                                                color: Colors.white,
                                                child: Text('Solicitar', style: TextStyle(
                                                  color:Color.fromRGBO(83, 86, 90, 1.0),
                                                  //Color.fromRGBO(255, 210, 0, 1.0),
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
                                                      var session= Conexion();
                                                      var seguridad= Seguridad(session);
                                                      pr.show();
                                                      session. solicitar(emailController.text).then((_) {
                                                        pr.hide();
                                                        if(session.validar == true){
                                                          final token = Token(
                                                          token: session.get_session());
                                                          Navigator.of(context).push(
                                                          MaterialPageRoute(builder: (context) => Recuperar(token)));
                                                        }else{
                                                          pr.hide();
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
                                                },
                                              )),
                                          
                                          SizedBox(height:150),
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
    // return Scaffold(
    //     appBar: AppBar(
    //       title: Text('Proveedores Caña Manuelita'),
    //     ),
    //     body: Padding(
    //         padding: EdgeInsets.all(10),
    //         child: new Form(
    //         key: _formKey,
    //         child: ListView(
    //           children: <Widget>[
    //             new Container(
    //                     padding: EdgeInsets.only(top:10.0,bottom:10.0),
    //                     child: new Image(
    //                       width: 120,
    //                       height: 120,
    //                       image: new AssetImage('assets/img/logo.png'),
    //                       ) ,
    //             ),
    //             // Container(
    //             //     alignment: Alignment.center,
    //             //     padding: EdgeInsets.all(10),
    //             //     child: Text(
    //             //       'TutorialKart',
    //             //       style: TextStyle(
    //             //           color: Colors.blue,
    //             //           fontWeight: FontWeight.w500,
    //             //           fontSize: 30),
    //             //     )),
    //             Container(
    //                 alignment: Alignment.center,
    //                 padding: EdgeInsets.all(10),
    //                 child: Text(
    //                   'Solicitar Recuperar Contraseña',
    //                   style: TextStyle(fontSize: 20),
    //                 )),
    //             Container(
    //               padding: EdgeInsets.all(10),
    //               child: TextFormField(
    //                 controller: emailController,
    //                 keyboardType: TextInputType.emailAddress,
    //                 validator: validateEmail,
    //                 // validator: (value){
    //                 //   if (value.isEmpty) {
    //                 //   return 'Por favor Ingrese su Correo';
    //                 //   }
    //                 // },
    //                 decoration: InputDecoration(
    //                   border: OutlineInputBorder(),
    //                   labelText: 'Correo',
    //                 ),
    //               ),
    //             ),
    //             // FlatButton(
    //             //   onPressed: (){
                     
    //             //   },
    //             //   textColor: Colors.blue,
    //             //   child: Text('Olvidó tu contraseña'),
    //             // ),
    //             Container(
    //               height: 50,
    //                 padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //                 child: RaisedButton(
    //                   textColor: Colors.white,
    //                   color: Colors.blueGrey,
    //                   child: Text('Enviar Solicitud',style:TextStyle(color:Colors.white,fontSize: 20),),
    //                   onPressed: () {
    //                     if (!_formKey.currentState.validate()){
    //                             Scaffold.of(context).showSnackBar(
    //                               SnackBar(content: Text('Processing Data'))
    //                             );
    //                       }else{
    //                         print(emailController.text);
    //                         var session= Conexion();
    //                         var seguridad= Seguridad(session);
    //                         pr.show();
    //                         session. solicitar(emailController.text).then((_) {
    //                           pr.hide();
    //                           if(session.validar == true){
    //                             final token = Token(
    //                             token: session.get_session());
    //                           Navigator.of(context).push(
    //                           MaterialPageRoute(builder: (context) => Recuperar(token)));
    //                           }else{
    //                             pr.hide();
    //                             String mensaje=session.mensaje; 
    //                             if (mensaje!=null)
    //                             {
    //                               confirm (mensaje); 
                                                          
    //                             }else{
    //                               confirm ("Sin conexión al servidor");
    //                             }
    //                           }
    //                         }).catchError( (onError){

    //                         if(onError is SessionNotFound){
    //                         return 'Usuario o Contraseña Incorrecta';
                            
    //                         }else if(onError is ConnectionError){
                              
    //                         }else{
                            
    //                         }
                                                    
    //                         });
                      
    //                     }
    //                   },
    //                 )),
    //             // Container(
    //             //   child: Row(
    //             //     children: <Widget>[
    //             //       Text('Does not have account?'),
    //             //       FlatButton(
    //             //         textColor: Colors.blueGrey,
    //             //         child: Text(
    //             //           'Sign in',
    //             //           style: TextStyle(fontSize: 20),
    //             //         ),
    //             //         onPressed: () {
    //             //           //signup screen
    //             //         },
    //             //       )
    //             //     ],
    //             //     mainAxisAlignment: MainAxisAlignment.center,
    //             // ))
    //           ],
    //         ),
    //         ),
    //         ),
    //         );
  }
}
 
 class Token {
  String token;
Token({this.token});
}

String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Ingrese un Correo Válido';
    else
      return null;
  }

  