import 'package:flutter/material.dart';
import 'package:proveedores_manuelita/logica/Usuarios.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/modelos/Usuario.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:proveedores_manuelita/vistas/rolesObjetos/RolesAsignados.dart';
import 'package:proveedores_manuelita/vistas/rolesObjetos/RolesNoAsignados.dart';

class RolesCompletar extends StatefulWidget {
  Data data;
  RolesCompletar(this.data) : super();
  @override
  _RolesCompletarState createState() => _RolesCompletarState();
}

class _RolesCompletarState extends State<RolesCompletar> {
  
  String _url='https://proveedores-cana.manuelita.com';
  List<Usuario> usuariosTemp=[];
  List<Usuario> users=[];
  bool asignados = false;


  Future <List<Usuario>> descargar_usuarios()async{
   List map;
   //roles=[];
    if(users.length > 0){
       return users;
    }else
    {
      var session= Conexion();
      session.set_token(widget.data.token);
      var usuario= Usuarios(session);
      var params={
          "filtro":'',
        };
      
       map = await session.callMethodList('/api/usuarios/listar_usuarios',params);
      for ( var usuario in map)
      {
        users.add(Usuario.fromJson(usuario));
      }
      return users;
    }
    
}
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<Usuario>> key = new GlobalKey();
  AutoCompleteTextField textField;

  @override void initState() {
      textField = new AutoCompleteTextField<Usuario>(
        decoration: new InputDecoration(
          hintText:"Ingrese el Usuario",
        ),
        key: key,
        submitOnSuggestionTap: true,
        clearOnSubmit: true,
        suggestions: users,
        textInputAction: TextInputAction.go,
        textChanged: (item) {
          currentText = item;
        },
        itemSubmitted: (item) {
          setState(() {
            currentText = item.nombre_completo;
            usuariosTemp=[];
            asignados= true;
            usuariosTemp.add(item);
            currentText = "";
          });
        },
        itemBuilder: (context, item) {
          return new Padding(
              padding: EdgeInsets.all(8.0), child: new Text(item.nombre_completo));
        },
        itemSorter: (a, b) {
          return a.nombre_completo.compareTo(b.nombre_completo);
        },
        itemFilter: (item, query) {
          return item.nombre_completo.toLowerCase().startsWith(query.toLowerCase());
        },
      );
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  autocompletar(),
                  SizedBox(height:10),
                  Container(padding: EdgeInsets.all(2),child:Column(children: [Text('Roles Asignados')],)),
                  asignados?
                  RolesAsignados(widget.data,usuariosTemp):Container(child:Column(children: [Text('')],)),
                  // Container(padding: EdgeInsets.all(2),child:Column(children: [Text('Roles No Asignados')],)),
                  // asignados?
                  // RolesNoAsignados(widget.data,usuariosTemp):Container(child:Column(children: [Text('')],)),
                ],
              ),
    );
  }

  Widget  autocompletar() {
    return FutureBuilder(
      future:descargar_usuarios(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          Column body = new Column(children: [
            new ListTile(
                title: textField,
                trailing: new IconButton(
                    icon: new Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        if (currentText != "") {
                          usuariosTemp.add(users.firstWhere((i) => i.nombre_completo.toLowerCase().contains(currentText)));
                          textField.clear();
                          currentText = "";
                        }
                      });
                    }))
          ]);

          body.children.addAll(usuariosTemp.map((item) {
            return Container(child:Column(
              mainAxisSize: MainAxisSize.min,
               mainAxisAlignment: MainAxisAlignment.start,
              verticalDirection: VerticalDirection.down,
              children: [
               Text(item.nombre_completo,style:TextStyle(color: Color.fromRGBO(83, 86, 90, 1.0),fontWeight: FontWeight.bold,fontSize: 16,)), 
               //Text(item.descripcion),
            ],));
            //return ListTile(title: Text(item.nombre_completo), subtitle: Text(item.nombre_completo));
          }));

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


}