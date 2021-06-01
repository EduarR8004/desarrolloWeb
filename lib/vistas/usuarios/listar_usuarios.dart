
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/modelos/Usuario.dart';
import 'package:proveedores_manuelita/logica/Usuarios.dart';
import 'package:proveedores_manuelita/modelos/response_status.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/Seguridad.dart';
import 'package:proveedores_manuelita/utiles/Utiles.dart';
import 'package:proveedores_manuelita/vistas/menu.dart';
import 'package:proveedores_manuelita/vistas/encabezado/Encabezado.dart';
import 'package:proveedores_manuelita/vistas/usuarios/Reporte_usuarios.dart';
import 'package:proveedores_manuelita/vistas/usuarios/crear.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';

class DataTableUsuarios extends StatefulWidget {
  final Data data;
  String parametro;

  DataTableUsuarios({Key key,this.data,this.parametro}) : super();
 
  final String title = "Gestión de Usuarios";
 
  @override
  DataTableUsuariosState createState() => DataTableUsuariosState();
}
 
class DataTableUsuariosState extends State<DataTableUsuarios> {
  List<Widget> lista =[];
  List<Usuario> users=[];
  Usuario consulta;
  List<Usuario> selectedUsers;
  bool sort,validar,borrar=false,refrescar = false;
  String dropdownValue = 'Opciones';
  String mensaje,texto,_token;
  ResponseStatus status = new ResponseStatus();
  final format = DateFormat("dd/MM/yyyy");
  String eliminarUsuario='Usuario Eliminado Correctamente';
  TextEditingController _controller;
  
  Future <List<Usuario>> listar_usuario(filtro)async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var usuario= Usuarios(session);
    var token=widget.data.token;
    if(selectedUsers.length > 0){
        return users;
    }else if(borrar==true)
    {
      return users;
    }else if(users.length > 0)
    {
      return users;
    }
    else
    {
      await usuario.descargar_usuarios(filtro).then((_){
        var preUsuarios=usuario.obtener_usuarios();
        for ( var usuario in preUsuarios)
        {
          users.add(usuario);
        }        
      });
      return users;
    }
  }
    
  @override
  void initState() {
    sort = false;
    widget.data;
    selectedUsers = [];
    _controller=TextEditingController();
    _controller.text=widget.data.parametro;
    //users =widget.data.usuarios ;
    //listar_usuario();
    super.initState();
  }

  void borrarTabla(){
    setState(() {
      users=[]; 
    });
  }
  
  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        users.sort((a, b) => a.nombre_completo.compareTo(b.nombre_completo));
      } else {
        users.sort((a, b) => b.nombre_completo.compareTo(a.nombre_completo));
      }
    }
  }
 
  onSelectedRow(bool selected, Usuario user) async {
    setState(() {
      if (selected) {
        selectedUsers.add(user);
      } else {
        selectedUsers.remove(user);
      }
    });
  }

  eliminar(){
    var session= Conexion();
    session.set_token(widget.data.token);
    var usuario= Usuarios(session);
    borrar=true; 
    for (int i = 0;i<selectedUsers.length; i++){
    var parametro=selectedUsers[i].usuario_id;
        usuario.eliminar_usuario(parametro).then((_){     
        });
    }
  }

  inicio()async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var seguridad= Seguridad(session);
    seguridad.descargar_objetos('Consultas').then((_){
      final data = Data.objetos(
      token: session.get_session(),
      obj: seguridad.obtener_objetos());
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => DataTableUsuarios(data:widget.data,parametro:'')));
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
                                
      }
      else{
                              
      }                                              
    });
  }
  deleteSelected() async {
    setState(() {
      if (selectedUsers.isNotEmpty) {
        List<Usuario> temp = [];
        temp.addAll(selectedUsers);
        for (Usuario user in temp) {
          eliminar();
          users.remove(user);
          selectedUsers.remove(user);  
        }
        successDialog(
          context, 
          'Usuario Eliminado Correctamente',
          neutralText: "Aceptar",
          neutralAction: (){
          },
        );
      }else
      {
        warningDialog(
          context, 
          'Por favor seleccione un usuario',
            negativeAction: (){
          },
        );
      }
    });
  }
 
  Widget  dataBody(texto) {
    return FutureBuilder <List<Usuario>>(
      future:listar_usuario(texto),
      builder:(context,snapshot){
        if(snapshot.hasData){
          return  
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView( 
                scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor:
                    MaterialStateColor.resolveWith((states) =>Color.fromRGBO(56, 124, 43, 1.0) ),
                    //Color.fromRGBO(136,139, 141, 1.0)
                    sortAscending: sort,
                    sortColumnIndex: 0,
                    horizontalMargin:10,
                    columnSpacing:10,
                    columns: [
                      DataColumn(
                        label: Text("Nombre",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Nombre Completo",
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            sort = !sort;
                          });
                          onSortColum(columnIndex, ascending);
                        }
                      ),
                      DataColumn(
                        label: Text("Usuario",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Usuario",
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            sort = !sort;
                          });
                          onSortColum(columnIndex, ascending);
                        }
                      ),
                      DataColumn(
                        label: Text("Estado",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Estado",
                      ),
                      DataColumn(
                        label: Text("Correo",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Correo",
                      ),
                      DataColumn(
                        label: Text("Documento",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Documento de identidad",
                      ),
                      DataColumn(
                        label: Text("Teléfono",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Teléfono",
                      ),
                      DataColumn(
                        label: Text("Fecha",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Fecha",
                      ),
                    ],
                    rows: users.map(
                      (user) => DataRow(
                        selected: selectedUsers.contains(user),
                        onSelectChanged: (b) {
                          print("Onselect");
                          onSelectedRow(b, user);
                        },
                        cells: [
                          DataCell(
                            Text(user.nombre_completo),
                            onTap: () {
                              print('Selected ${user.nombre_completo}');
                            },
                          ),
                          DataCell(
                            Text(user.usuario),
                          ),
                          DataCell(
                            Text(user.bloqueo?"Inactivo":"Activo"),
                          ),
                          DataCell(
                            Text(user.email),
                          ),
                          DataCell(
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 0,5,0),
                              width: 750,
                              child:
                              Text(user.nits.toString().replaceAll("[", "").replaceAll("]", ""),textAlign: TextAlign.justify,style: TextStyle(
                                //Color.fromRGBO(83, 86, 90, 1.0),
                                fontSize:13,
                              )),
                            )
                          ),
                          DataCell(
                            Text(user.telefono1.toString()),
                          ),
                          DataCell(
                            Text( format.format(user.creation_stamp) .toString()),
                          ),
                        ]
                      ),
                    ).toList(),
                  ),
              ),
            );
        }else{
          return
          Center(
            child:CircularProgressIndicator()
            //Splash1(),
          );
        }
      },
    );
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
    var menu = new Menu(data:widget.data,retorno:'');
    texto=widget.parametro;
    var encabezado= new Encabezado(data:widget.data,titulo:'Gestión de Usuarios',);
    return WillPopScope(
    onWillPop: () {  },
      child: SafeArea(
        child:Scaffold(
        appBar: new AppBar(
          flexibleSpace:encabezado, 
          backgroundColor: Colors.transparent,
        ),
        drawer: menu,
        body:Container(
          color:Colors.white,
          child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Container(
            color:Colors.white ,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.fromLTRB(10,12,10,10),child:boton(),),
                  Container(
                    width: 400,
                    alignment: Alignment.topLeft,
                    color:Colors.white ,
                    padding: EdgeInsets.fromLTRB(30,0,30,20),
                    child: TextField(
                      controller: _controller,
                      autofocus: false,
                      autocorrect: true,
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
                        labelText: 'Buscar',
                        prefixIcon: Icon(Icons.search)
                      ),
                    ), 
                  ),
                  Container(
                    color:Colors.white,
                    padding: EdgeInsets.fromLTRB(30,22,30,20),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child:Container(
                          width: 280,
                          height: 35,
                          decoration: BoxDecoration(
                          //color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: RaisedButton(
                            textColor: Color.fromRGBO(83, 86, 90, 1.0),
                            //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                            color: Color.fromRGBO(56, 124, 43, 1.0),
                            child: Text('Buscar', style: TextStyle(
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
                              if(_controller.text==null || _controller.text=="")
                              {
                                infoDialog(context,'Por favor ingrese un parámetro para realizar la búsqueda',
                                negativeAction: (){}, 
                                );
                              }else
                              {
                                texto=_controller.text==null?'':_controller.text;
                                Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => DataTableUsuarios(data:widget.data,parametro:texto)));
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                      padding: EdgeInsets.fromLTRB(30,25,30,20),
                      child:Container(
                        width: 280,
                        height: 35,
                        decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: RaisedButton(
                        textColor: Color.fromRGBO(83, 86, 90, 1.0),
                        //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                        color: Color.fromRGBO(56, 124, 43, 1.0),
                        child: Text('Limpiar filtro', style: TextStyle(
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
                          texto='';
                          Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => DataTableUsuarios(data:widget.data,parametro:texto)));
                        },
                      ),
                      ),
                      )
                    ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:dataBody(texto),
            ),
          ],
        ),),
        ),
      ),
    );
  }

  Widget boton(){
    var token=widget.data.token;
    return DropdownButton<String>(
      value: dropdownValue,
      // icon: Icon(Icons.arrow_circle_down_rounded),
      // iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black,fontSize: 16),
      underline: Container(
        height: 2,
        color: Colors.green,
      ),
      onChanged: (String newValue) {
        final data = UsuarioEnvio(token:token);
        if(newValue=='Crear'){
          Navigator.of(context).push(
                                 MaterialPageRoute(builder: (context) => RegisterPage(false,data:widget.data,usuario:null))); 
        }else if(newValue=='Eliminar')
        {
            deleteSelected();
        }else if(newValue=='Editar')
        {
          if(selectedUsers.length < 1)
          {
            _showAlertDialog("Por favor seleccione un usuario","Operación invalida");
          }else if(selectedUsers.length > 1)
          {
            _showAlertDialog("Por favor seleccione solo un usuario","Operación invalida");
          }
          else{
            Usuario usuario = selectedUsers[0];
            Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => RegisterPage(true,data:widget.data,usuario:usuario))); 
          }
          
        }else if(newValue=='Reporte Usuarios')
        {
          Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ReporteUsuarios(data:widget.data))); 
        }
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Opciones','Crear', 'Editar', 'Eliminar','Reporte Usuarios']
      .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void _showAlertDialog(text,titulo) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(text),
          actions: <Widget>[
            RaisedButton(
              child: Text("Aceptar", style: TextStyle(color: Colors.green),),
              onPressed: (){ Navigator.of(context).pop(); },
            ),
            RaisedButton(
              child: Text("Cancelar", style: TextStyle(color: Colors.green),),
              onPressed: (){ Navigator.of(context).pop(); },
            )
          ],
        );
      }
    );
  }
  
   void _showAlertDialogOnly(text,titulo) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(text),
          actions: <Widget>[
            RaisedButton(
              child: Text("Aceptar", style: TextStyle(color: Colors.green),),
              onPressed: (){ Navigator.of(context).pop(); },
            ),
          ],
        );
      }
    );
  }
  
}

 class UsuarioEnvio {
  String token;
  UsuarioEnvio({this.token});
}

      