import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:proveedores_manuelita/logica/Roles.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/modelos/Rol.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/vistas/menu.dart';
import 'package:proveedores_manuelita/vistas/rolesObjetos/Crear.dart';
import 'package:proveedores_manuelita/vistas/rolesObjetos/ObjetosAsignados.dart';
import 'package:proveedores_manuelita/vistas/encabezado/Encabezado.dart';
import 'package:proveedores_manuelita/vistas/rolesObjetos/RolesCompletar.dart';



class ProfilePage extends StatefulWidget {
  Data data;
  ProfilePage({this.data});
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
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
    var encabezado= new Encabezado(data:widget.data,titulo:'Roles y Objetos',);
    return WillPopScope(
    onWillPop: () {  },
      child: SafeArea(
        child:Scaffold(
          appBar: new AppBar(
            flexibleSpace:encabezado,
            backgroundColor: Colors.transparent,
          ),
          drawer: menu,
          body: Container(
          alignment: Alignment.center,
          color:Colors.white ,
            child:Center(
              child:Container(
                width: 1200,
                height: 700,
                alignment: Alignment.center,
                color:Colors.white ,
                child: Center(
                  child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TabBar(
                      unselectedLabelColor: Colors.black,
                      labelColor: Colors.red,
                      tabs: [
                        Tab(
                          text: 'Asignar Objetos',
                        ),
                        Tab(
                          text: 'Asignar Roles',
                        )
                      ],
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [AutoCompletar(widget.data), RolesCompletar(widget.data), ],
                        controller: _tabController,
                      ),
                    ),
                  ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AutoCompletar extends StatefulWidget {
  Data data;
  AutoCompletar(this.data) : super();
  @override
  _AutoCompletarState createState() => _AutoCompletarState();
}

class _AutoCompletarState extends State<AutoCompletar> {
  
  String _url='https://proveedores-cana.manuelita.com';
  List<Rol> roles=[];
  List<Rol> rolesTemp=[];
  bool asignados = false;
  String dropdownValue = 'Opciones';
  
  deleteSelected(rolesTemp) async {
    if(rolesTemp.length>0){
      var session= Conexion();
      session.set_token(widget.data.token);
      var rol= Roles(session);
      await rol.eliminar_rol(rolesTemp[0].id).then((_){
        successDialog(
        context, 
          'Rol Eliminado Correctamente',
          neutralText: "Aceptar",
          neutralAction: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(data:widget.data))); 
          },
        );
      });
    }else
    {
      warningDialog(
        context, 
        'Por favor seleccione un Rol',
          negativeAction: (){
        },
      );
    }
  }

  Future <List<Rol>> descargar_roles()async{
   List map;
    if(roles.length > 0){
       return roles;
    }else
    {
      var session= Conexion();
      session.set_token(widget.data.token);
      var rol= Roles(session);
      Map <String,String> params = new Map();
      
        map = await session.callMethodList('/api/roles/listar_roles',params);
        for ( var rol in map)
        {
          roles.add(Rol.fromJson(rol));
        }
        return roles;
    }
  }
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<Rol>> key = new GlobalKey();
  AutoCompleteTextField textField;

  @override void initState() {
    Container(
      width: 400,
      child: textField = new AutoCompleteTextField<Rol>(
        decoration: new InputDecoration(
          hintText:"Ingrese el Rol",
        ),
        key: key,
        submitOnSuggestionTap: true,
        clearOnSubmit: true,
        suggestions: roles,
        textInputAction: TextInputAction.go,
        textChanged: (item) {
          currentText = item;
        },
        itemSubmitted: (item) {
          setState(() {
            currentText = item.nombre;
            rolesTemp=[];
            asignados= true;
            rolesTemp.add(item);
            currentText = "";
          });
        },
        itemBuilder: (context, item) {
          return new Padding(
              padding: EdgeInsets.all(8.0), child: new Text(item.nombre));
        },
        itemSorter: (a, b) {
          return a.nombre.compareTo(b.nombre);
        },
        itemFilter: (item, query) {
          return item.nombre.toLowerCase().startsWith(query.toLowerCase());
        },
      )
    );
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        Container(
          width: 400,
          child:AsignarObjetos(),
        ),
        Container(
          child: boton(),
        ),
        SizedBox(height:10),
        asignados?
        ObjetosAsignados(widget.data,rolesTemp):Container(child:Column(children: [Text('')],)),
        // Container(padding: EdgeInsets.all(2),child:Column(children: [Text('Objetos No Asignados')],)),
        // asignados?
        // ObjetosNoAsignados(widget.data,rolesTemp):Container(child:Column(children: [Text('')],)),
      ]
    );
  }

  Widget AsignarObjetos(){
    return FutureBuilder(
      future:descargar_roles(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          Column body = 
          Column(children: [
            new ListTile(
              title: textField,
              trailing: new IconButton(
                icon: new Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    if (currentText != "") {
                      rolesTemp.add(roles.firstWhere((i) => i.nombre.toLowerCase().contains(currentText)));
                      //textField.clear();
                      //currentText = "";
                    }
                  });
                }
              )
            ),
          ]);
          body.children.addAll(rolesTemp.map((item) {
            return Container(
              width: 500,
              child:Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                verticalDirection: VerticalDirection.down,
                children: [
                Text(item.nombre,style:TextStyle(color: Color.fromRGBO(83, 86, 90, 1.0),fontWeight: FontWeight.bold,fontSize: 16,),), 
                Text(item.descripcion),
                ],
              )
            );
            //:ListTile(title: Text('nada'), subtitle: Text('de nada'));
          })
          );
          return body;
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
  Widget boton(){
    //var token=widget.data.token;
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
        if(newValue=='Crear'){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CrearRol(false,data:widget.data,rol:null))
          ); 
        }
        else if(newValue=='Eliminar')
        {
            deleteSelected(rolesTemp);
        }
        else if(newValue=='Editar')
        {
          if(rolesTemp.length>0){
          Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CrearRol(true,data:widget.data,rol:rolesTemp[0]))); 
          }else{
            errorDialog(
            context, 
            "Por favor seleccione un Rol",
            negativeAction: (){
            },
          );
          }
        }
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Opciones','Crear', 'Editar', 'Eliminar']
      .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
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

}