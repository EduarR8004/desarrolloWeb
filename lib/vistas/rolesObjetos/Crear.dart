import 'package:flutter/material.dart';
import 'package:proveedores_manuelita/logica/Roles.dart';
import 'dart:convert' show utf8;

import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/modelos/Rol.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/utiles/Seguridad.dart';
import 'package:proveedores_manuelita/utiles/Utiles.dart';
import 'package:proveedores_manuelita/vistas/rolesObjetos/RolesObjetos.dart';


class CrearRol extends StatefulWidget {
  final bool editar;
  Data data;
  final Rol rol;
 
  CrearRol(this.editar,{this.data,this.rol}): assert(editar == true || rol ==null);
 @override
 _CrearRolState createState() => _CrearRolState();
}

class _CrearRolState extends State<CrearRol> {
var usuario_id;
var creacion="Rol creado correctamente\nDesea crear un nuevo Rol?";
FocusNode rol;
FocusNode descripcion;
  @override
  void initState() {
    super.initState();
    rol = FocusNode();
    descripcion = FocusNode();
    widget.data;
    if(widget.editar == true){
      role.text =widget.rol.nombre; 
      descp.text =widget.rol.descripcion; 
    
    }
  }
 
 GlobalKey<FormState> keyForm = new GlobalKey();
 TextEditingController  role = new TextEditingController();
 TextEditingController  descp = new TextEditingController();

crear_rol()async{
  var session= Conexion();
  session.set_token(widget.data.token);
  var rol= Roles(session);
   await rol.crear_rol(role.text,descp.text).then((_){
     successDialog(
        context, 
        creacion,
        negativeText: "Si",
        negativeAction: (){
          role.text =''; 
          descp.text ='';
        },
        neutralText: "No",
        neutralAction: (){
          final data = Data(
                            token:widget.data.token ,
                            obj: widget.data.obj,
                            usuario_actual:widget.data.usuario_actual, 
                            parametro:'');
                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => ProfilePage(data:data))); 
        },
    );
    //_showAlertDialog("Crear Rol","Rol creado correctamente\n""Desea crear un nuevo Rol?");
  }).catchError( (onError){
     'Error interno '+ onError.toString();

     if(onError is SessionNotFound){
      //return 'Usuario o Contraseña Incorrecta';
                        
    }else if(onError is ConnectionError){
    errorDialog(
      context, 
      "Sin conexión al servidor",
      negativeAction: (){
      },
    ); 
    //_showAlert("Error de conexión ","Sin conexión al servidor");
                          
    }else{                  
    }                                          
  });
}
 
editar_rol()async{
  var session= Conexion();
  session.set_token(widget.data.token);
  var rol= Roles(session);
   await rol.editar_rol(widget.rol.id,role.text,descp.text).then((_){
     successDialog(
      context, 
      "Rol editado correctamente",
      neutralText: "Aceptar",
      neutralAction: (){
      final data = Data(
                    token:widget.data.token ,
                    obj: widget.data.obj,
                    usuario_actual:widget.data.usuario_actual, 
                    parametro:'');
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfilePage(data:data))); 
        },
    );
  }).catchError( (onError){
     'Error interno '+ onError.toString();
     if(onError is SessionNotFound){
      //return 'Usuario o Contraseña Incorrecta';                
    }else if(onError is ConnectionError){
    errorDialog(
      context, 
      "Sin conexión al servidor",
      negativeAction: (){
      },
    );              
    }else{
                         
    }                                           
  });
}
 
@override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    role.dispose(); 
    descp.dispose();
    super.dispose();
  }
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     home: new Scaffold(
      //  appBar: new AppBar(
      //    title: new Text('Registrarse'),
      //  ),
       body: new SingleChildScrollView(
         child: new Container(
           margin: new EdgeInsets.all(4.0),
           child: new Form(
             key: keyForm,
             child: formUI(),
           ),
         ),
       ),
     ),
   );
 }

 formItemsDesign(icon, item) {
   return Padding(
     padding: EdgeInsets.symmetric(vertical:4),
     child: Card(child: ListTile(leading: Icon(icon), title: item)),
   );
 }

 
 Widget formUI() {
   return  Column(
     children: <Widget>[
       Container(
         height: 60,
          width: 600,
          margin: EdgeInsets.only(top:21),
          decoration: BoxDecoration(
            color: Colors.white,  
              //borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage('images/titulop.png'),
                fit: BoxFit.cover),
            ),
          child:Row(
            children:<Widget>[
              Container(
                child:IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                
              ),
              Center(
                child:Text(widget.editar?"Editar Rol":'Crear Rol',style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),),
              )
            ],
          ) ,
          //padding: EdgeInsets.symmetric(horizontal:10),
      ),
        formItemsDesign(
           Icons.person,
           TextFormField(
             controller: role,
             focusNode: rol,
             autofocus: true,
             decoration: new InputDecoration(
               labelText: 'Rol',
             ),
             validator: (value){
               if (value.isEmpty) {
                return 'Por favor Ingrese el Rol';
              }
            },
             //validator: validateName,
           )),
       formItemsDesign(
           Icons.person,
           TextFormField(
             controller: descp,
             focusNode: descripcion,
             autofocus: false,
             decoration: new InputDecoration(
               labelText: 'Descripción',
             ),
             validator: (value){
               if (value.isEmpty) {
                return 'Por favor Ingrese la Descripción';
              }
            },
             //validator: validateName,
           )),
       Padding(
        padding: EdgeInsets.all(10.0),
        child:Container(
          decoration: BoxDecoration(
          //color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: RaisedButton(
          textColor: Color.fromRGBO(83, 86, 90, 1.0),
          //textColor: Color.fromRGBO(255, 210, 0, 1.0),
          color: Color.fromRGBO(56, 124, 43, 1.0),
          child: Text(widget.editar?"Editar Rol":'Crear Rol', style: TextStyle(
            color: Colors.white,
            //Color.fromRGBO(83, 86, 90, 1.0),
            fontSize: 18,
            fontWeight: FontWeight.bold
          )),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
            //side: BorderSide(color: Colors.white)
          ),
          onPressed: () {
            if(role.text==''){
              warningDialog(
              context, 
              "Por favor diligencie el campo Rol",
              negativeAction: (){
              },
            );
              rol.requestFocus();
              return;
            }
            if(descp.text==''){
               warningDialog(
              context, 
              "Por favor diligencie el campo Descripción",
              negativeAction: (){
              },
              );
              descripcion.requestFocus();
              return;
            }                   
            if (!keyForm.currentState.validate()){
            //   warningDialog(
            //   context, 
            //   "Por favor revise la información ingresada",
            //   negativeAction: (){
            //   },
            // );
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('Processing Data'))
              );
                                        
            }else{
              save();
          }
        },
      ),
      ),
      ),
     ],
   );
 }
 save() {
   if(widget.editar == true){
     editar_rol();
   }else{
     crear_rol();
   } 
 }
}


