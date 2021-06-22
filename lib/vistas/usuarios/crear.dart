import 'package:flutter/material.dart';
import 'dart:convert' show utf8;
import 'package:proveedores_manuelita/logica/Usuarios.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/modelos/Usuario.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/Seguridad.dart';
import 'package:proveedores_manuelita/utiles/Utiles.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/vistas/encabezado/Encabezado.dart';
import 'package:proveedores_manuelita/vistas/infoProduccion/InfoProduccion.dart';
import 'package:proveedores_manuelita/vistas/menu.dart';
import 'package:proveedores_manuelita/vistas/usuarios/listar_usuarios.dart';

class RegisterPage extends StatefulWidget {
  final bool editar;
  var data;
  final Usuario usuario;
 
  RegisterPage(this.editar,{this.data,this.usuario}): assert(editar == true || usuario ==null);
 @override
 _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
var usuario_id;
FocusNode usuario;
FocusNode nombre;
FocusNode correo;
FocusNode telefono;
FocusNode documento;
List <String> activo=['Activo','Inactivo'];
String dropdownInicial;
var validarUsuario='El campo Usuario es obligatorio.';
var nombreUsuario='El campo Nombre es obligatorio.';
var documentoUsuario='El campo Documento es obligatorio.';
var telefonoUsuario='El campo Número de teléfono es obligatorio.';
var emailUsuario='El campo Email es obligatorio.';
var creacion="Usuario creado correctamente\n""Desea crear un nuevo usuario?";
  @override
  void initState() {
    super.initState();
    nombre = FocusNode();
    usuario = FocusNode();
    correo = FocusNode();
    documento = FocusNode();
    telefono = FocusNode();
    widget.data;
    if(widget.editar == true){
      user.text =widget.usuario.usuario; 
      nombre_completo.text =widget.usuario.nombre_completo; 
      nit.text =widget.usuario.nits.toString().replaceAll("[", "").replaceAll("]", "").replaceAll(" ",""); 
      telefono1.text =widget.usuario.telefono1; 
      telefono2.text =widget.usuario.telefono2; 
      telefono3.text =widget.usuario.telefono3; 
      email.text =widget.usuario.email; 
      usuario_id=widget.usuario.usuario_id;
      email_alternativo.text =widget.usuario.email_alternativo; 
      roles.text =widget.usuario.roles.toString();
      dropdownInicial = widget.usuario.bloqueo?"Inactivo":"Activo";
    }
  }
 
 GlobalKey<FormState> keyForm = new GlobalKey();
 TextEditingController  user = new TextEditingController();
 TextEditingController  nombre_completo = new TextEditingController();
 TextEditingController  nit = new TextEditingController();
 TextEditingController  clave_acceso = new TextEditingController();
 TextEditingController  telefono1 = new TextEditingController();
 TextEditingController  telefono2 = new TextEditingController();
 TextEditingController  telefono3 = new TextEditingController();
 TextEditingController  email = new TextEditingController();
 TextEditingController  email_alternativo = new TextEditingController();
 TextEditingController  roles = new TextEditingController();

 
 crear_usuario()async{
    List nits=[];
    nits=nit.text.split(",");
    List roles=[];
    
    var session= Conexion();
    session.set_token(widget.data.token);
    var seguridad= Seguridad(session);
    //await pr.show();

    session.crear_usuario(user.text,nombre_completo.text,telefono1.text,telefono2.text,telefono3.text,email.text,email_alternativo.text,nits,roles).then((_) {
      successDialog(
        context, 
        creacion,
        negativeText: "Si",
        negativeAction: (){
          user.text =''; 
          nombre_completo.text =''; 
          nit.text =''; 
          telefono1.text =''; 
          clave_acceso.text='';
          telefono2.text =''; 
          telefono3.text =''; 
          email.text =''; 
          usuario_id='';
          email_alternativo.text =''; 
        },
        neutralText: "No",
        neutralAction: (){
          var session= Conexion();
          session.set_token(widget.data.token);
          var usuario= Usuarios(session);
          var token=widget.data.token;
          Navigator.of(context).push(
           MaterialPageRoute(builder: (context) => DataTableUsuarios(data:widget.data,parametro:'')));
        },
      );
  if(session.validar == true){
    //token=session.get_session();
  }else{
    String mensaje=session.mensaje; 
    if (mensaje!=null)
    {
      //confirm (mensaje); 
                              
    }else{
      //confirm ("Sin conexión al servidor");
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

  editar_usuario()async{
    List nits=[];
    nits=nit.text.split(",");
    List roles=[];
    var session= Conexion();
    session.set_token(widget.data.token);
    var seguridad= Seguridad(session);
    session.editar_usuario(usuario_id,user.text,nombre_completo.text,telefono1.text,telefono2.text,telefono3.text,email.text,email_alternativo.text,nits,roles,dropdownInicial).then((_){
      successDialog(
        context, 
        'Usuario Editado con Éxito',
        neutralText: "Aceptar",
        neutralAction: (){
          var session= Conexion();
          session.set_token(widget.data.token);
          var usuario= Usuarios(session);
          var token=widget.data.token;
          Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DataTableUsuarios(data:widget.data,parametro:'')));
        },
      );
    });
  }

  listar_usuario()async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var usuario= Usuarios(session);
    var token=widget.data.token;
    usuario.descargar_usuarios('').then((_){
      List usuarios=usuario.obtener_usuarios();

      final data = Data.usuarios(
        token:token ,
        usuarios: usuario.obtener_usuarios(),
        parametro:''
      );
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DataTableUsuarios(data:widget.data,parametro:'')));          
    });
  }

  @override
  void dispose() {
    nombre.dispose();
    usuario.dispose();
    correo.dispose();
    documento.dispose();
    telefono.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var menu = new Menu(data:widget.data,retorno:'');
    var encabezado= new Encabezado(data:widget.data,titulo:widget.editar?"Editar Usuario":'Crear Usuario',);
    return WillPopScope(
    onWillPop: () {  },
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar: new AppBar(
            flexibleSpace:encabezado,
            backgroundColor: Colors.transparent,
          ),
          drawer: menu,
          body:  new SingleChildScrollView(
            child:
            Container(
              color: Colors.white,
              child:new Center(
              //margin: new EdgeInsets.fromLTRB(100,0,100,0),
                child: new Form(
                key: keyForm,
                  child:Container(
                    width: 600,
                    height: 800,
                    margin: new EdgeInsets.fromLTRB(0,20,0,0),
                    color:Colors.white,
                    child:formUI(),
                  ) 
                ),
              )
            )
          )
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

  void _showAlertDialog(titulo,text) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(text),
          actions: <Widget>[
            RaisedButton(
              child: Text("Si", style: TextStyle(color: Colors.green),),
              onPressed: (){ 
                user.text =''; 
                nombre_completo.text =''; 
                nit.text =''; 
                telefono1.text =''; 
                clave_acceso.text='';
                telefono2.text =''; 
                telefono3.text =''; 
                email.text =''; 
                usuario_id='';
                email_alternativo.text =''; 
                roles.text ='';
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text("No", style: TextStyle(color: Colors.green),),
              onPressed: (){ 
                var session= Conexion();
                session.set_token(widget.data.token);
                var usuario= Usuarios(session);
                var token=widget.data.token;
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DataTableUsuarios(data:widget.data,parametro:'')));                  
              },
            )
          ],
        );
      }
    );
  }

  void _showAlertDialogEdit(titulo,text) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(text),
          actions: <Widget>[
            RaisedButton(
              child: Text("Aceptar", style: TextStyle(color: Colors.green),),
              onPressed: (){ 
                var session= Conexion();
                session.set_token(widget.data.token);
                var usuario= Usuarios(session);
                var token=widget.data.token;
                Navigator.of(context).push(
                   MaterialPageRoute(builder: (context) => DataTableUsuarios(data:widget.data,parametro:'')));
               },
            )
          ],
        );
      }
    );
  }

  void _showAlert(titulo,text) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(text),
          actions: <Widget>[
            RaisedButton(
              child: Text("Aceptar", style: TextStyle(color: Colors.green),),
              onPressed: (){ 
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
  }

  Widget estado(){
    return Container(
      height: 40,
      width: 150,
      //alignment: Alignment.topLeft,
      margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
      //margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border(bottom:BorderSide(width: 1,
          color: Color.fromRGBO(83, 86, 90, 1.0),
        ),
        ),
      ),
      child:
        DropdownButtonHideUnderline(
          child:DropdownButton<String>(
            hint: Padding(
              padding: const EdgeInsets.all(0),
              child:Text(dropdownInicial, 
                textAlign: TextAlign.left,style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontFamily: 'Karla',
                ),
              ),
            ),
            value: dropdownInicial,
            // icon: Icon(Icons.arrow_circle_down_rounded),
            // iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black,fontSize: 15),
            underline: Container(
              height: 2,
              color: Colors.green,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownInicial= newValue;
              });
            },
            items:activo.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child:Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2,2,2),
                  child:new Text(value,textAlign: TextAlign.left,
                  style: new TextStyle(color: Colors.black)),
                ),
              );
            }).toList(),
          ),
        ),
    );
  }
  Widget formUI() {
    return  Column(
      children: <Widget>[
        formItemsDesign(
          Icons.person,
          TextFormField(
            controller: user,
            focusNode: usuario,
            //autofocus: true,
            decoration: new InputDecoration(
              labelText: 'Usuario',
            ),
            validator: (value){
              if (value.isEmpty) {
                return 'Por favor Ingrese el Usuario';
              }
            },
          )
        ),
        formItemsDesign(
          Icons.person,
          TextFormField(
            controller: nombre_completo,
            focusNode: nombre,
            decoration: new InputDecoration(
              labelText: 'Nombre',
            ),
            validator: (value){
              if (value.isEmpty) {
                return 'Por favor Ingrese el Nombre';
              }
            },
          )
        ),
        formItemsDesign(
          Icons.person,
          TextFormField(
            controller: nit,
            focusNode: documento,
            decoration: new InputDecoration(
              labelText: 'Documento',
            ),
            validator: (value){
              if (value.isEmpty) {
                
                return 'Por favor Ingrese el Documento';
              }
            },
          )
        ),
        formItemsDesign(
          Icons.phone,
          TextFormField(
            controller: telefono1,
            focusNode: telefono,
            decoration: new InputDecoration(
              labelText: 'Número de teléfono',
            ),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            validator: validateMobile,
          )
        ),
        formItemsDesign(
          Icons.phone,
          TextFormField(
            controller: telefono2,
            decoration: new InputDecoration(
              labelText: 'Número de teléfono',
            ),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            validator: validateMobileOptional,
          )
        ),
        formItemsDesign(
          Icons.email,
          TextFormField(
            controller: email,
            focusNode: correo,
            decoration: new InputDecoration(
              labelText: 'Email',
            ),
            keyboardType: TextInputType.emailAddress,
            maxLength: 60,
            validator: validateEmail,
          )
        ),
        widget.editar?formItemsDesign(
            Icons.check,
            widget.editar?estado():Container(),
        ):Container(),
        Padding(
        padding: EdgeInsets.all(10.0),
          child:Container(
            decoration: BoxDecoration(
            //color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            ),
            child: RaisedButton(
              textColor: Color.fromRGBO(83, 86, 90, 1.0),
              color: Color.fromRGBO(56, 124, 43, 1.0),
              child: Text(widget.editar?"Editar Usuario":'Crear Usuario',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                )
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
                //side: BorderSide(color: Colors.white)
              ),
              onPressed: () {
                if(user.text==''){
                  usuario.requestFocus();
                    warningDialog(
                      context, 
                      validarUsuario,
                      negativeAction: (){
                      },
                    );
                    return;
                }
                if(nombre_completo.text==''){
                  nombre.requestFocus();
                  warningDialog(
                    context, 
                    nombreUsuario,
                    negativeAction: (){
                    },
                  );
                  return;
                }
                if(nit.text==''){
                  documento.requestFocus();
                  warningDialog(
                    context, 
                    documentoUsuario,
                    negativeAction: (){
                    },
                  );
                  return;
                }
                if(telefono1.text==''){
                  correo.requestFocus();
                  warningDialog(
                    context, 
                    telefonoUsuario,
                    negativeAction: (){
                    },
                  );
                  return;
                }
                if(email.text==''){
                  correo.requestFocus();
                  warningDialog(
                    context, 
                    emailUsuario,
                    negativeAction: (){
                    },
                  );
                  return;
                }
                if (!keyForm.currentState.validate()){
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
//flutter build apk --release --target-platform=android-arm64
//  String validatePassword(String value) {
//    print("valorrr $value passsword ${passwordCtrl.text}");
//    if (value != passwordCtrl.text) {
//      return "Las contraseñas no coinciden";
//    }
//    return null;
//  }

  String validateName(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Este es un campo obligatorio";
    } else if (!regExp.hasMatch(value)) {
      return "El nombre debe de ser a-z y A-Z";
    }
    return null;
  }

  String validateMobile(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Por favor ingrese el número de teléfono";
    } else if (value.length != 10) {
      return "El número debe tener 10 digitos";
    }
    return null;
  }

  String validatePass(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0 && widget.editar==false) {
      return "La contraseña es necesaria";
    }else{
      if (value.length < 8) {
        return "Minimo 8 Caracteres";
      } else {
        return null;
      }
    }
  }

  String validateMobileOptional(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length > 0) {
        if (value.length < 7) {
        return "El número debe tener 7 o más digitos";
        }
    } else{
      return null;
    }
    
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Por favor ingrese el email";
    } else if (!regExp.hasMatch(value)) {
      return "Correo inválido";
    } else {
      return null;
    }
  }

  String validateEmailOptional(String value) {
   String pattern =
       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
   RegExp regExp = new RegExp(pattern);
   if (value.length > 0) {
      if (!regExp.hasMatch(value)) {
      return "Correo invalido";
       } else {
        return null;
      }
   } else {
     return null;
   }
  }

  save() {
    if(widget.editar == true){
      editar_usuario();
    }else{
      crear_usuario();
    } 
  }
}


