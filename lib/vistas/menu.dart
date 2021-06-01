import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:expandable/expandable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/vistas/adminDocumentos/AdminDocumentos.dart';
import 'package:proveedores_manuelita/vistas/adminDocumentos/AdminOrden.dart';
import 'package:proveedores_manuelita/vistas/asisTecnica/AdminRecomendacion.dart';
import 'package:proveedores_manuelita/vistas/asisTecnica/AsisTecnica.dart';
import 'package:proveedores_manuelita/vistas/consultas/Consultas.dart';
import 'package:proveedores_manuelita/vistas/cronologico/Crono.dart';
import 'package:proveedores_manuelita/vistas/index.dart';
import 'package:proveedores_manuelita/vistas/infoProduccion/InfoProduccion.dart';
import 'package:proveedores_manuelita/vistas/liquidaciones/Liquidaciones.dart';
import 'package:proveedores_manuelita/vistas/rolesObjetos/RolesObjetos.dart';
import 'package:proveedores_manuelita/vistas/usuarios/listar_usuarios.dart';
import 'package:proveedores_manuelita/utiles/Seguridad.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/logica/Usuarios.dart';
import 'package:proveedores_manuelita/utiles/Globals.dart';
import 'package:proveedores_manuelita/vistas/entradaCana/EntradasCana.dart';
import 'package:proveedores_manuelita/vistas/entradaCana/Mensaje.dart';
import 'package:proveedores_manuelita/vistas/actualDatos/ActualizarDatos.dart';
import 'package:proveedores_manuelita/vistas/actualDatos/ActualizarDocumentosAdmin.dart';
import 'login/login.dart';

class Menu extends StatefulWidget {
  final data;
  String retorno;
 
  Menu({this.data,this.retorno});
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  ProgressDialog pr;
  Map usuario_actual;
  List<String> objetos=[];
  List<Widget> menu =[];
  List<Widget> subMenu =[];
  double alto=35;
  double top=7;
  Color color = Color.fromRGBO(83, 86, 90, 1.0);
  @override
  void initState() {
    agregar();
    if(widget.retorno=='entrada')
    {
      widget.data.entrada=false;
    }
    if(widget.retorno=='info')
    {
      widget.data.produccion=false;
    }
    if(widget.retorno=='crono')
    {
      widget.data.crono=false;
    }
    super.initState();
    widget.data;
  }

  agregar(){
    setState(() {
      menu.add(header());
      menu.add(inicio());
      if(widget.data.obj.contains('CO001') || widget.data.obj.contains("ZZ999")){
        menu.add(verConsultas());
      }
      if(widget.data.obj.contains('EC001') || widget.data.obj.contains("ZZ999")){
        menu.add(verEntradaCana());
      }
      if(widget.data.obj.contains('LC001') || widget.data.obj.contains("ZZ999")){
        menu.add(verLiquidaciones());
      }
      if(widget.data.obj.contains('CR001') || widget.data.obj.contains("ZZ999")){
        menu.add(verCronologico());
      }
      if(widget.data.obj.contains('IP001') || widget.data.obj.contains("ZZ999")){
        menu.add(verInfoProduccion());
      }
      if(widget.data.obj.contains('AT001') || widget.data.obj.contains("ZZ999")){
        menu.add(asisTecnica());
      }
      if(widget.data.obj.contains('AO001') || widget.data.obj.contains("ZZ999")){
        menu.add(actDatos());
      }
      if(widget.data.obj.contains('AU002') || widget.data.obj.contains("ZZ999")){
        subMenu.add(roles());
      }
      if(widget.data.obj.contains('AU001') || widget.data.obj.contains("ZZ999")){
        subMenu.add(usuarios());
      }
      if(widget.data.obj.contains('AO002') || widget.data.obj.contains("ZZ999")){
        subMenu.add(adminActualizarDatos());
      }
      if(widget.data.obj.contains('AA001') || widget.data.obj.contains("ZZ999")){
        subMenu.add(adminAsisTecnica());
      }
      if(widget.data.obj.contains('AD001') || widget.data.obj.contains("ZZ999")){
        subMenu.add(adminOrdenes());
      }
      if(widget.data.obj.contains('AD001') || widget.data.obj.contains("ZZ999")){
        subMenu.add(adminDocumentos());
      }
      if(widget.data.obj.contains('AU000') || widget.data.obj.contains("ZZ999")){
        menu.add(Configuracion(subMenu));
      }
      if(widget.data.obj.contains('CS001') || widget.data.obj.contains("ZZ999")){
        menu.add(cerrarSesion());
      }
    });
  }

void confirm (dialog){
  Alert(
    context: context,
    type: AlertType.error,
    title: "Faltan Permisos",
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
  @override
  Widget build(BuildContext context) {
  var data=widget.data;
  pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
      message: 'Cerrando Sesión del Usuario ',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
      color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
      color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    return new Drawer(
      child:Container(
        color: Colors.white,
          child:ListView(
          children: menu,
        ), 
      ),
    );
  }

  Widget usuarios(){
    return InkWell(
      onTap: () {
        bool navigator;
        var session= Conexion();
        session.set_token(widget.data.token);
        var seguridad= Seguridad(session);
        seguridad.descargar_objetos('AdministracionUsuarios').then((_){
          navigator=seguridad.validaObjeto('AU001');
          if(navigator==true || widget.data.obj.contains("ZZ999"))
          {
            Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DataTableUsuarios(data:widget.data,parametro:'',)));
          }else{
            warningDialog(
              context, 
              "No tiene los permisos para ingresar a la funcionalidad",
              negativeAction: (){
              },
            );
          }
        });
      }, 
      child:Container(
        height: 50,
        margin: EdgeInsets.only(top:10),
        decoration: BoxDecoration(
        color: Colors.white, 
        ),
        child:Row(
          children:<Widget>[
            Container(
              child:IconButton(
                icon: Icon(
                  Icons.people,
                  color: Color.fromRGBO(56, 124, 43, 1.0),
                ),
                onPressed: () {
                  bool navigator;
                  var session= Conexion();
                  session.set_token(widget.data.token);
                  var seguridad= Seguridad(session);
                  seguridad.descargar_objetos('AdministracionUsuarios').then((_){
                    navigator=seguridad.validaObjeto('AU001');
                    if(navigator==true || widget.data.obj.contains("ZZ999"))
                    {
                      Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => DataTableUsuarios(data:widget.data,parametro:'',)));
                    }else{
                      warningDialog(
                        context, 
                        "No tiene los permisos para ingresar a la funcionalidad",
                        negativeAction: (){
                        },
                      );
                    }
                    }
                  );
                },
              ),         
            ),
            Padding( padding: EdgeInsets.only(top:6, left: 5, right: 5),
              child:Center(
                child:Text('Gestión de Usuarios',style:TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget roles(){
    return InkWell(
      onTap: () {
        bool navigator;
        var session= Conexion();
        session.set_token(widget.data.token);
        var seguridad= Seguridad(session);
        seguridad.descargar_objetos('RolesObjetos').then((_){
          navigator=seguridad.validaObjeto('RO004');
          if(navigator==true || widget.data.obj.contains("ZZ999"))
          {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ProfilePage(data:widget.data)));
          }else{
            warningDialog(
              context, 
              "No tiene los permisos para ingresar a la funcionalidad",
              negativeAction: (){
              },
            );
          }
        }); 
      }, 
      child:Container(
        height: 30,
        margin: EdgeInsets.only(top:10),
        decoration: BoxDecoration(
          color: Colors.white,  
        ),
        child:Row(
          children:<Widget>[
            Container(
              child:IconButton(
                icon: Icon(
                  Icons.handyman,
                  color: Color.fromRGBO(56, 124, 43, 1.0),
                ),
                onPressed: () {
                  bool navigator;
                var session= Conexion();
                session.set_token(widget.data.token);
                var seguridad= Seguridad(session);
                seguridad.descargar_objetos('RolesObjetos').then((_){
                  navigator=seguridad.validaObjeto('RO004');
                  if(navigator==true || widget.data.obj.contains("ZZ999"))
                  {
                    Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ProfilePage(data:widget.data)));
                  }else{
                    warningDialog(
                      context, 
                      "No tiene los permisos para ingresar a la funcionalidad",
                      negativeAction: (){
                      },
                    );
                  }
                }); 
                },
              ),
            ),
            Padding( padding: EdgeInsets.only(top: 15, left: 5, right: 5),
            child:
              Center(
                child:Text('Roles y Objetos',style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget header(){
    return new UserAccountsDrawerHeader(
      accountName: Text('Usuario: '+widget.data.usuario_actual['usuario'],
      style: TextStyle(color: Colors.white,
        fontSize:20,
        fontWeight: FontWeight.bold
      ),
      ),
      //accountEmail: Text(""),
      decoration: BoxDecoration(
        image: DecorationImage(
          image:AssetImage('images/derivados-cana.jpg'),
          fit: BoxFit.cover
        )
      ),
    );
 }

  Widget cerrarSesion(){
    return InkWell(
      onTap: () {
        bool navigator;
        var session= Conexion();
        session.set_token(widget.data.token);
        var seguridad= Seguridad(session);
        pr.show();
        seguridad.descargar_objetos('CerrarSesion').then((_){
          navigator=seguridad.validaObjeto('CS001') || widget.data.obj.contains("ZZ999");
          if(navigator==true)
          { 
            pr.hide();
            WidgetsBinding.instance.addPostFrameCallback((_) {
                                 Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => Login(true),)); });
          }else{
            pr.hide();
            warningDialog(
                context, 
                "No tiene los permisos para ingresar a la funcionalidad",
                negativeAction: (){
                },
            );
          }
        });
      }, 
      child:Container(
        height: alto,
        margin: EdgeInsets.only(top:10),
        decoration: BoxDecoration(
          color: Colors.white,  
        ),
        child:Row(
          children:<Widget>[
            Container(
              child:IconButton(
                icon: Icon(
                  Icons.exit_to_app_rounded,
                  color:Color.fromRGBO(56, 124, 43, 1.0),
                ),
                onPressed: () {
                  bool navigator;
                  var session= Conexion();
                  session.set_token(widget.data.token);
                  var seguridad= Seguridad(session);
                  pr.show();
                  seguridad.descargar_objetos('CerrarSesion').then((_){
                    navigator=seguridad.validaObjeto('CS001')|| widget.data.obj.contains("ZZ999");
                    if(navigator==true)
                    { 
                      pr.hide();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => Login(true),)); });
                    }else{
                      pr.hide();
                      warningDialog(
                        context, 
                        "No tiene los permisos para ingresar a la funcionalidad",
                        negativeAction: (){
                        },
                      );
                    }
                  });
                },
              ),  
            ),
            Padding( padding: EdgeInsets.only(top: 6, left: 5, right: 5),
              child:Center(
                child:Text('Cerrar Sesión',style: TextStyle(
                  color:color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
 Widget verInfoProduccion(){
  return InkWell(
    onTap:() {
      bool navigator;
      var session= Conexion();
      session.set_token(widget.data.token);
      var seguridad= Seguridad(session);
      seguridad.descargar_objetos('InformeProduccion').then((_){
        navigator=seguridad.validaObjeto('IP001')|| widget.data.obj.contains("ZZ999");
        if(navigator==true)
        { 
          if(widget.data.produccion==true)
          {
            infoProduccion=[];
            mensajeInfoProduccion.clear();
            mensajeNotificacion.clear();
            //mensajeNotificacion.removeWhere((element) => (element =='InformeDeProduccion'));
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Mensaje (data:widget.data,titulo:'Informe de Producción',mensaje:'informe',)));
          }else{
            infoProduccion=[];
            mensajeInfoProduccion.clear();
            mensajeNotificacion.clear();
            //mensajeNotificacion.removeWhere((element) => (element =='InformeDeProduccion'));
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => InfoProduccion (data:widget.data)));
          }
        }else{
          warningDialog(
            context, 
            "No tiene los permisos para ingresar a la funcionalidad",
            negativeAction: (){
            },
          );
        }
      });
    }, 
    child:Container(
      height: alto,
      margin: EdgeInsets.only(top:10),
      decoration: BoxDecoration(
        color: Colors.white,  
      ),
      child:Row(
        children:<Widget>[
          Padding( padding: EdgeInsets.only(top: 0, left: 12, right: 5),
            child:Container(
            height: 25,
            width: 25,
            //padding: new EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              image: DecorationImage(
              image: AssetImage('images/estadisticas.png'),
              fit: BoxFit.contain)),                          
            ),
          ),
          Padding( padding: EdgeInsets.only(top: 10, left: 12, right: 5),
            child:Center(
              child:Text('Info. Producción',style: TextStyle(
                    color:color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
              ),
              ),
            ),
          ),
        ],
      ) ,
    ),
  );
 }
  Widget adminDocumentos(){
    return InkWell(
      onTap:() {
        bool navigator;
        var session= Conexion();
        session.set_token(widget.data.token);
        var seguridad= Seguridad(session);
        seguridad.descargar_objetos('AdministracionDocumentos').then((_){
          navigator=seguridad.validaObjeto('AD001')|| widget.data.obj.contains("ZZ999");
          if(navigator==true)
          { 
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AdminDocumentos (data:widget.data)));
          }else{
            warningDialog(
              context, 
              "No tiene los permisos para ingresar a la funcionalidad",
              negativeAction: (){
              },
            );
          }
        });
      },
      child:Container(
        height: alto,
        margin: EdgeInsets.only(top:10),
        decoration: BoxDecoration(
          color: Colors.white,  
        ),
        child:Row(
          children:<Widget>[
            Container(
              child:IconButton(
                icon: Icon(
                  Icons.upload_rounded,
                  color:Color.fromRGBO(56, 124, 43, 1.0),
                ),
                onPressed: () {
                  bool navigator;
                  var session= Conexion();
                  session.set_token(widget.data.token);
                  var seguridad= Seguridad(session);
                  seguridad.descargar_objetos('AdministracionDocumentos').then((_){
                    navigator=seguridad.validaObjeto('AD001')|| widget.data.obj.contains("ZZ999");
                    if(navigator==true )
                    { 
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AdminDocumentos (data:widget.data)));
                    }else{
                      warningDialog(
                        context, 
                        "No tiene los permisos para ingresar a la funcionalidad",
                        negativeAction: (){
                        },
                      );
                    }
                  });
                },
              ),   
            ),
            Padding( padding: EdgeInsets.only(top: 6, left: 5, right: 5),
              child:Center(
                child:Text('Admin. Documentos',style: TextStyle(
                  color:color,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget adminOrdenes(){
    return InkWell(
      onTap:() {
        bool navigator;
        var session= Conexion();
        session.set_token(widget.data.token);
        var seguridad= Seguridad(session);
        seguridad.descargar_objetos('AdministracionDocumentos').then((_){
          navigator=seguridad.validaObjeto('AD001')|| widget.data.obj.contains("ZZ999");
          if(navigator==true)
          { 
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AdministrarOrdenesT (data:widget.data)));
          }else{
            warningDialog(
              context, 
              "No tiene los permisos para ingresar a la funcionalidad",
              negativeAction: (){
              },
            );
          }
        });
      },
      child:Container(
        height: alto,
        margin: EdgeInsets.only(top:10),
        decoration: BoxDecoration(
          color: Colors.white,  
        ),
        child:Row(
          children:<Widget>[
            Container(
              child:IconButton(
                icon: Icon(
                  Icons.assignment_turned_in_rounded,
                  color:Color.fromRGBO(56, 124, 43, 1.0),
                ),
                onPressed: () {
                  bool navigator;
                  var session= Conexion();
                  session.set_token(widget.data.token);
                  var seguridad= Seguridad(session);
                  seguridad.descargar_objetos('AdministracionDocumentos').then((_){
                    navigator=seguridad.validaObjeto('AD001')|| widget.data.obj.contains("ZZ999");
                    if(navigator==true)
                    { 
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AdminDocumentos (data:widget.data)));   
                    }else{
                      warningDialog(
                        context, 
                        "No tiene los permisos para ingresar a la funcionalidad",
                        negativeAction: (){
                        },
                      );
                    }
                  });
                },
              ),  
            ),
            Padding( padding: EdgeInsets.only(top: 6, left: 5, right: 5),
              child:Center(
                child:Text('Admin. Órdenes',style: TextStyle(
                  color:color,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
 }
Widget adminAsisTecnica(){
  return InkWell(
    onTap:() {
      bool navigator;
      var session= Conexion();
      session.set_token(widget.data.token);
      var seguridad= Seguridad(session);
      seguridad.descargar_objetos('AdministracionAsistenciaTecnica').then((_){
        navigator=seguridad.validaObjeto('AA001')|| widget.data.obj.contains("ZZ999");
        if(navigator==true)
        { 
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AdminRecomendacion (data:widget.data)));
        }else{
          warningDialog(
            context, 
            "No tiene los permisos para ingresar a la funcionalidad",
            negativeAction: (){
            },
          );
        }
      });
    },
    child:Container(
      height: alto,
      margin: EdgeInsets.only(top:10),
      decoration: BoxDecoration(
        color: Colors.white,  
      ),
      child:Row(
        children:<Widget>[
          Container(
            child:IconButton(
              icon: Icon(
                Icons.spa_rounded,
                color:Color.fromRGBO(56, 124, 43, 1.0),
              ),
              onPressed: () {
                bool navigator;
                var session= Conexion();
                session.set_token(widget.data.token);
                var seguridad= Seguridad(session);
                seguridad.descargar_objetos('AdministracionAsistenciaTecnica').then((_){
                  navigator=seguridad.validaObjeto('AA001')|| widget.data.obj.contains("ZZ999");
                  if(navigator==true)
                  { 
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AdminRecomendacion (data:widget.data)));
                  }else{
                    warningDialog(
                      context, 
                      "No tiene los permisos para ingresar a la funcionalidad",
                      negativeAction: (){
                      },
                    );
                  }
                });
              },
            ),  
          ),
          Padding( padding: EdgeInsets.only(top: 6, left: 5, right: 5),
            child:Center(
              child:Text('Admin. Asis.Técnica',style: TextStyle(
                color:color,
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
              ),
            ),
          ),
        ],
      ),
  ),
  );
 }

  Widget adminActualizarDatos(){
    return InkWell(
      onTap:() {
        bool navigator;
        var session= Conexion();
        session.set_token(widget.data.token);
        var seguridad= Seguridad(session);
        seguridad.descargar_objetos('AdminActualizarDatos').then((_){
          navigator=seguridad.validaObjeto('AO002')|| widget.data.obj.contains("ZZ999");
          if(navigator==true)
          { 
            WidgetsBinding.instance.addPostFrameCallback((_) { 
              Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) =>  ActualizarDocuemntoAdmin (data:widget.data)));});
          }else{
            warningDialog(
              context, 
              "No tiene los permisos para ingresar a la funcionalidad",
              negativeAction: (){
              },
            );
          }
        });
      },
      child:Container(
        height: alto,
        margin: EdgeInsets.only(top:10),
        decoration: BoxDecoration(
          color: Colors.white,  
        ),
        child:Row(
          children:<Widget>[
            Container(
              child:IconButton(
                icon: Icon(
                  Icons.folder_shared_rounded,
                  color:Color.fromRGBO(56, 124, 43, 1.0),
                ),
                onPressed: () {
                  bool navigator;
                  var session= Conexion();
                  session.set_token(widget.data.token);
                  var seguridad= Seguridad(session);
                  seguridad.descargar_objetos('AdminActualizarDatos').then((_){
                    navigator=seguridad.validaObjeto('AO002')|| widget.data.obj.contains("ZZ999");
                    if(navigator==true)
                    { 
                      WidgetsBinding.instance.addPostFrameCallback((_) { 
                        Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) =>  ActualizarDocuemntoAdmin (data:widget.data)));});
                    }else{
                      warningDialog(
                        context, 
                        "No tiene los permisos para ingresar a la funcionalidad",
                        negativeAction: (){
                        },
                      );
                    }
                  });
                },
              ),  
            ),
            Padding( padding: EdgeInsets.only(top: 6, left: 5, right: 5),
              child:Center(
                child:Text('Admin. Act. Datos',style: TextStyle(
                  color:color,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),
                ),
              ),
            ),
          ],
        ),
      ),
  );
 }

  Widget verLiquidaciones(){
    return InkWell(
      onTap:() {
        bool navigator;
        var session= Conexion();
        session.set_token(widget.data.token);
        var seguridad= Seguridad(session);
        seguridad.descargar_objetos('LiquidacionCana').then((_){
          navigator=seguridad.validaObjeto('LC001')|| widget.data.obj.contains("ZZ999");
          if(navigator==true)
          {   
            liqCana=[];
            mensajeLiqCana.clear();
            mensajeNotificacion.removeWhere((element) => (element =='LiquidacionCana'));
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => VerLiquidaciones (data:widget.data)));
          }else{
            warningDialog(
              context, 
              "No tiene los permisos para ingresar a la funcionalidad",
              negativeAction: (){
              },
            );
          }
        });
      }, 
      child:Container(
        height: alto,
        margin: EdgeInsets.only(top:10),
        decoration: BoxDecoration(
          color: Colors.white,  
        ),
        child:Row(
          children:<Widget>[
            Padding( padding: EdgeInsets.only(top: 0, left: 12, right: 5),
              child:Container(
                height: 25,
                width: 25,
                //padding: new EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                  image: AssetImage('images/bolsa-de-dinero.png'),
                    fit: BoxFit.contain)),                            
              ),
            ),
            Padding( padding: EdgeInsets.only(top: top, left:12, right: 5),
              child:Center(
                child:Text('Liquidaciones',style: TextStyle(
                  color:color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              ),
            ),
          ],
        ),
      ),
    );
 }

Widget asisTecnica(){
    return InkWell(
      onTap:() {
        bool navigator;
        var session= Conexion();
        session.set_token(widget.data.token);
        var seguridad= Seguridad(session);
        seguridad.descargar_objetos('AsistenciaTecnica').then((_){
          navigator=seguridad.validaObjeto('AT001')|| widget.data.obj.contains("ZZ999");
          if(navigator==true)
          { 
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AsitenciaTecnica (data:widget.data)));
          }else{
            warningDialog(
              context, 
              "No tiene los permisos para ingresar a la funcionalidad",
              negativeAction: (){
              },
            );
          }
        });
      }, 
      child:Container(
        height: alto,
        margin: EdgeInsets.only(top:10),
        decoration: BoxDecoration(
          color: Colors.white,  
        ),
        child:Row(
          children:<Widget>[
            Padding( padding: EdgeInsets.only(top: 0, left: 12, right: 5),
              child:Container(
                height: 25,
                width: 25,
                //padding: new EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                  image: AssetImage('images/cultivos.png'),
                  fit: BoxFit.contain)
                ),                          
              ),
            ),
            Padding( padding: EdgeInsets.only(top: top, left: 12, right: 5),
              child:Center(
                child:Text('Asis.Técnica',style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                ),
              ),
            ),
          ],
        ) ,
      ),
  );
 }

  Widget actDatos(){
    return InkWell(
      onTap:() {
        bool navigator;
        var session= Conexion();
        session.set_token(widget.data.token);
        var seguridad= Seguridad(session);
        seguridad.descargar_objetos('ActualizacionDatos').then((_){
          navigator=seguridad.validaObjeto('AO001')|| widget.data.obj.contains("ZZ999");
          if(navigator==true)
          { 
              WidgetsBinding.instance.addPostFrameCallback((_) { 
                                      Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) =>  ActualizarDatosp (data:widget.data)));});
          }else{
            warningDialog(
              context, 
              "No tiene los permisos para ingresar a la funcionalidad",
              negativeAction: (){
              },
            );
          }
        });
      }, 
      child:Container(
        height: alto,
        margin: EdgeInsets.only(top:10),
        decoration: BoxDecoration(
          color: Colors.white,  
        ),
        child:Row(
          children:<Widget>[
            Padding( padding: EdgeInsets.only(top: 0, left:12, right: 5),
              child:Container(
              height: 25,
              width: 25,
              //padding: new EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                image: AssetImage('images/actualizar_datos.png'),
                  fit: BoxFit.contain
                )
              ),                            
              ),
            ),
            Padding( padding: EdgeInsets.only(top: 2, left: 12, right: 5),
              child:Center(
                child:Text('Act. Datos',style: TextStyle(
                  color:color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                ),
              ),
            ),
          ],
        ) ,
      ),
  );
  }


  Widget verEntradaCana(){
    return InkWell(
      onTap:() {
        bool navigator;
        var session= Conexion();
        session.set_token(widget.data.token);
        var seguridad= Seguridad(session);
        seguridad.descargar_objetos('EntradaCana').then((_){
          navigator=seguridad.validaObjeto('EC001')|| widget.data.obj.contains("ZZ999");
          if(navigator==true)
          { 
            if(widget.data.entrada==true)
            {
              entradaCana=[];
              mensajeEntradaCana.clear();
              mensajeNotificacion.clear();
              //mensajeNotificacion.removeWhere((element) => (element =='EntradaDeCana'));
              Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Mensaje (data:widget.data,titulo:'Entrada Caña',mensaje:'entrada',)));
            }else{
              entradaCana=[];
              mensajeEntradaCana.clear();
              mensajeNotificacion.clear();
              //mensajeNotificacion.removeWhere((element) => (element =='EntradaDeCana'));
              Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => EntradasCanas (data:widget.data)));
            }
          }else{
            warningDialog(
              context, 
              "No tiene los permisos para ingresar a la funcionalidad",
              negativeAction: (){
              },
            );
          }
        });
      }, 
      child:Container(
        height: alto,
        margin: EdgeInsets.only(top:10),
        decoration: BoxDecoration(
          color: Colors.white,  
        ),
        child:Row(
          children:<Widget>[
            Padding( padding: EdgeInsets.only(top: 0, left:12, right: 5),
            child:Container(
            height: 25,
            width: 25,
            //padding: new EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              image: DecorationImage(
              image: AssetImage('images/tractor_verde.png'),
              fit: BoxFit.contain)),                            
            ),),
            Padding( padding: EdgeInsets.only(top: 2, left: 12, right: 5),
              child:Center(
                child:Text('Entrada Caña',style: TextStyle(
                  color:color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                ),
              ),
            ),
          ],
        ),
      ),
  );
 }

  Widget verCronologico(){
    return InkWell(
      onTap:() {
        bool navigator;
        var session= Conexion();
        session.set_token(widget.data.token);
        var seguridad= Seguridad(session);
        seguridad.descargar_objetos('Cronologico').then((_){
          navigator=seguridad.validaObjeto('CR001')|| widget.data.obj.contains("ZZ999");
          if(navigator==true)
          { 
            if(widget.data.crono==true)
            {
              Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Mensaje (data:widget.data,titulo:'Cronológico',mensaje:'crono')));
            }else{
              Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => VerCronologico (data:widget.data)));
            }
          }else{
            warningDialog(
              context, 
              "No tiene los permisos para ingresar a la funcionalidad",
              negativeAction: (){
              },
            );
          }
        });
      }, 
      child:Container(
        height: alto,
        margin: EdgeInsets.only(top:10),
        decoration: BoxDecoration(
          color: Colors.white,  
        ),
        child:Row(
          children:<Widget>[
            Padding( padding: EdgeInsets.only(top: 0, left:12, right: 5),
              child:Container(
              height: 25,
              width: 25,
              //padding: new EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                image: AssetImage('images/calendario.png'),
                fit: BoxFit.contain)
              ),                            
              ),
            ),
            Padding( padding: EdgeInsets.only(top: 10, left: 10, right: 5),
              child:Center(
              child:Text('Cronológico',style: TextStyle(
                color:color,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
              ),
              ),
            ),
          ],
        ),
      ),
  );
 }

  Widget verConsultas(){
    return InkWell(
      onTap:() {
        bool navigator;
        var session= Conexion();
        session.set_token(widget.data.token);
        var seguridad= Seguridad(session);
        seguridad.descargar_objetos('Consultas').then((_){
          navigator=seguridad.validaObjeto('CO001')|| widget.data.obj.contains("ZZ999");
          if(navigator==true)
          { 
            consultas=[];
            mensaConsultas.clear();
            mensajeNotificacion.removeWhere((element) => (element =='liquidaciones' ));
            Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => VerConsultas (data:widget.data)));
          }else{
            warningDialog(
              context, 
              "No tiene los permisos para ingresar a la funcionalidad",
              negativeAction: (){
              },
            );
          }
        });
      }, 
      child:Container(
        height: alto,
        margin: EdgeInsets.only(top:10),
        decoration: BoxDecoration(
          color: Colors.white,  
        ),
        child:Row(
          children:<Widget>[
          Padding( padding: EdgeInsets.only(top: 0, left:10, right: 5),
            child:Container(
              height: 25,
              width: 25,
              //padding: new EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/lupa.png'),
                  fit: BoxFit.contain
                )
              ),
                                            
            ),
          ),
          Padding( padding: EdgeInsets.only(top: top, left: 12, right: 5),
            child:Center(
              child:Text('Consultas',style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
              ),
            ),
          ),
          ],
        ),
      ),
  );
 }

  Widget inicio(){
    return InkWell(
      onTap:() {
        var session= Conexion();
        session.set_token(widget.data.token);
        var usuario= Usuarios(session);
        var seguridad= Seguridad(session);
        List<String> adminu;
        seguridad.descargar_todos().then((_){
          usuario.usuario_actual().then((_){
            usuario_actual=usuario.obtener_usuario();
            adminu=seguridad.obtener_todos();
            objetos.addAll(adminu);
            final data = Data.mensaje(
            usuario:'',
            pass:'',
            token: session.get_session(),
            obj: objetos,
            produccion:widget.data.produccion,
            entrada:widget.data.entrada,
            crono: widget.data.crono,
            usuario_actual:usuario_actual);
            Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Inicio(data:widget.data,retorno:''))); 
          });                 
        });
      }, 
      child:Container(
        height: alto,
        margin: EdgeInsets.only(top:10),
        decoration: BoxDecoration(
          color: Colors.white,  
        ),
        child:Row(
          children:<Widget>[
            Container(
              child:IconButton(
                icon: Icon(
                  Icons.home_rounded,
                  size:30,
                  color: Color.fromRGBO(56, 124, 43, 1.0),
                ),
                onPressed: () {
                  var session= Conexion();
                  session.set_token(widget.data.token);
                  var usuario= Usuarios(session);
                  var seguridad= Seguridad(session);
                  List<String> adminu;
                  seguridad.descargar_todos().then((_){
                    usuario.usuario_actual().then((_){
                      usuario_actual=usuario.obtener_usuario();
                      adminu=seguridad.obtener_todos();
                      objetos.addAll(adminu);
                      final data = Data.mensaje(
                      usuario:'',
                      pass:'',
                      token: session.get_session(),
                      obj: objetos,
                      produccion:false,
                      entrada:widget.data.entrada,
                      crono: widget.data.crono,
                      usuario_actual:usuario_actual);
                      Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Inicio(data:widget.data,retorno:''))); 
                    });                 
                  });
                },
              ),         
            ),
            Padding( padding: EdgeInsets.only(top:15, left: 5, right: 5),
              child:Center(
              child:Text('Inicio',style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  ),
              ),
            )
          ],
        ),
      ),
  );
  }
  
}

 class Parametros {
  String token;
  List usuarios;
 Parametros({this.token, this.usuarios});
}

class Configuracion extends StatelessWidget {
  List<Widget> subMenu =[];
  Color color = Color.fromRGBO(83, 86, 90, 1.0);
  Configuracion(this.subMenu);
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
    child: Padding(
      padding: const EdgeInsets.all(0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                  padding: EdgeInsets.all(0),
                  child:
                    Container(
                    height: 30,
                    margin: EdgeInsets.only(top:1),
                    decoration: BoxDecoration(
                      color: Colors.white,  
                      ),
                    child:Row(
                      children:<Widget>[
                        Container(
                          child:IconButton(
                            icon: Icon(
                              Icons.miscellaneous_services,
                              size:30,
                              color: Color.fromRGBO(56, 124, 43, 1.0),
                            ),
                            onPressed: () {
                              //inicio();
                              //Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Padding( padding: EdgeInsets.only(top: 9, left: 0, right: 5),
                          child:Center(
                          child:Text("Configuración",style: TextStyle(
                                color:color,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                              ),
                        ),),
                      ],
                    ) ,
                  ),
                    // Container(child: Text(
                    //   "Configuración",
                    //   style: Theme.of(context).textTheme.body2,
                    // ),
                    // ),
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: subMenu,
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}