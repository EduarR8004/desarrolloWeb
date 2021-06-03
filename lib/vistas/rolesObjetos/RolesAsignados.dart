import 'package:flutter/material.dart';
import 'package:proveedores_manuelita/logica/Roles.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/modelos/Rol.dart';
import 'package:proveedores_manuelita/modelos/Usuario.dart';
import 'package:proveedores_manuelita/modelos/response_status.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';

class RolesAsignados extends StatefulWidget {
  Data data;
  List <Usuario>obj;
  RolesAsignados(this.data,this.obj) : super();
  @override
  _RolesAsignadosState createState() => _RolesAsignadosState();
}

class _RolesAsignadosState extends State<RolesAsignados> {
  List<Rol> roles=[];
  List<Rol> rolesNo=[];
  List<Rol> selectedRolNo;
  bool sortNo;
  List asignarRol;
  List<Rol> selectedRol;
  bool refrescar = false;
  bool sort;
  String _token;
  bool validar;
  bool borrar=false;
  String mensaje,texto;
  ResponseStatus status = new ResponseStatus();
   
   @override
  void initState() {
    sort = false;
    widget.data;
    selectedRol = [];
    roles=[];
    sortNo = false;
    selectedRolNo = [];
    widget.obj;
    //users =widget.data.usuarios ;
    //listar_usuario();
    super.initState();
  }
  void borrarTabla(){
    setState(() {
     roles=[]; 
    });
  }
  
  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        roles.sort((a, b) => a.nombre.compareTo(b.nombre));
      } else {
        roles.sort((a, b) => b.nombre.compareTo(a.nombre));
      }
    }
  }
  onSelectedRow(bool selected, Rol rol) async {
    setState(() {
      if (selected) {
        selectedRol.add(rol);
      } else {
        selectedRol.remove(rol);
      }
    });
  }
   deleteSelected() async {
    setState(() {
      List rolesa=[];
      if (selectedRol.isNotEmpty) {
        List<Rol> temp = [];
        temp.addAll(selectedRol);
        for (Rol rol in temp) {
          rolesa.add(rol.id);
          roles.remove(rol);
          selectedRol.remove(rol); 
       }
       remover_rol(rolesa);
       successDialog(
        context, 
        "Se quitaron los roles seleccionados",
        neutralText: "Aceptar",
        negativeAction: (){
        },
      );
      }else
      {  
        errorDialog(
          context, 
          "Por favor seleccione un rol",
          negativeAction: (){
          },
        );
      }
    });
  }
  onSortColumNo(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        rolesNo.sort((a, b) => a.nombre.compareTo(b.nombre));
      } else {
        rolesNo.sort((a, b) => b.nombre.compareTo(a.nombre));
      }
    }
  }

deleteSelectedNo() async {
  setState(() {
    List rolesa=[];
    if (selectedRolNo.isNotEmpty) {
      List<Rol> temp = [];
      temp.addAll(selectedRolNo);
      for (Rol rol in temp) {
        rolesa.add(rol.id);
        rolesNo.remove(rol);
        selectedRolNo.remove(rol); 
      }
      asignar_rol(rolesa);
      successDialog(
        context, 
        "Se asignaron los roles seleccionados",
        neutralText: "Aceptar",
        negativeAction: (){
        },
      );
    }else
    {
      errorDialog(
          context, 
          "Por favor seleccione un rol",
          negativeAction: (){
          },
        );
    }
  });
}
 
  onSelectedRowNo(bool selected, Rol rol) async {
    setState(() {
      if (selected) {
        selectedRolNo.add(rol);
      } else {
        selectedRolNo.remove(rol);
      }
    });
  }

  Future <List<Rol>> descargar_roles_noasignados(id)async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var rol= Roles(session);
    var token=widget.data.token;
    if(selectedRolNo.length > 0){
       return rolesNo;
    }else if(borrar==true)
    {
      return rolesNo;
    }else if(rolesNo.length > 0 && borrar==true )
    {
      return rolesNo;
    }
    else
    {
      await rol.descargar_roles_noasignados(id).then((_){
        var preRol=rol.obtener_noasignados();
        rolesNo=[];
        for ( var rol in preRol)
        {
         rolesNo.add(rol);
        }        
      });
      return rolesNo;
    }
}

asignar_rol(rolesa)async{
  var session= Conexion();
  session.set_token(widget.data.token);
  var rol= Roles(session);
  var id=widget.obj[0].usuario_id;
  var token=widget.data.token;
  await rol.asignar_rol_usuario(id,rolesa).then((_){
        
  });
}

  Future <List<Rol>> descargar_roles_asignados(id)async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var rol= Roles(session);
    var token=widget.data;
    if(selectedRol.length > 0){
       return roles;
    }else if(borrar==true)
    {
      return roles;
    }else if(roles.length > 0 && borrar==true )
    {
      return roles;
    }
    else
    {
      await rol.descargar_roles_asignados(id).then((_){
        var preRol=rol.obtener_asignados();
        roles=[];
        for ( var rol in preRol)
        {
         roles.add(rol);
        }        
      });
      return roles;
    }
}

remover_rol(rolesa)async{
  var session= Conexion();
  session.set_token(widget.data.token);
  var rol= Roles(session);
  var id=widget.obj[0].usuario_id;
  var token=widget.data;
  await rol.remover_rol_usuario(id,rolesa).then((_){
   
  });
}
  
  @override
  Widget build(BuildContext context) {
    var id=widget.obj[0].usuario_id;
    return Expanded(
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Padding(
            padding: EdgeInsets.fromLTRB(10,10,10,0),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children:[
                //Container(padding: EdgeInsets.all(5),child:Column(children: [Text('Roles Asignados',style:TextStyle(fontWeight:FontWeight.bold))],)),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child:Container(
                    decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    ),
                    child: RaisedButton(
                      textColor: Color.fromRGBO(83, 86, 90, 1.0),
                      //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                      color: Color.fromRGBO(56, 124, 43, 1.0),
                      child: Text('Quitar', style: TextStyle(
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
                        deleteSelected();
                      },
                    ),
                  ),
                ),
                Expanded(child:dataBody(id)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10,10,10,0),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                //Container(padding: EdgeInsets.all(5),child:Column(children: [Text('Roles No Asignados',style:TextStyle(fontWeight:FontWeight.bold),)],)),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child:Container(
                    decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    ),
                    child: RaisedButton(
                      textColor: Color.fromRGBO(83, 86, 90, 1.0),
                      //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                      color: Color.fromRGBO(56, 124, 43, 1.0),
                      child: Text('Asignar', style: TextStyle(
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
                        deleteSelectedNo();
                      },
                    ),
                  ),
                ),
                Expanded(child:dataBodyNo(id)),
              ],
            ),
          ),
        ],
      ),             
    );
  }

  Widget  dataBody(id) {
    return FutureBuilder <List<Rol>>(
      future:descargar_roles_asignados(id),
      builder:(context,snapshot){
        if(snapshot.hasData){
          var textStyle = TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize:15,);
          return 
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView( 
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor:MaterialStateColor.resolveWith((states) =>Color.fromRGBO(56, 124, 43, 1.0) ),
                  //Color.fromRGBO(136,139, 141, 1.0)
                  sortAscending: sort,
                  sortColumnIndex: 0,
                  columns: [
                    DataColumn(
                      label: Text("Roles\nAsignados",style: textStyle),
                      numeric: false,
                      tooltip: "Roles Asignados",
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          sort = !sort;
                        });
                        onSortColum(columnIndex, ascending);
                      }
                    ),
                    DataColumn(
                      label: Text("Descripción",style: textStyle),
                      numeric: false,
                      tooltip: "Descripción",
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          sort = !sort;
                        });
                        onSortColum(columnIndex, ascending);
                      }
                    ),
                  ],
                  rows: roles.map(
                        (obj) => DataRow(
                          selected: selectedRol.contains(obj),
                          onSelectChanged: (b) {
                            print("Onselect");
                            onSelectedRow(b, obj);
                          },
                          cells: [
                            DataCell(
                              Text(obj.nombre),
                              onTap: () {
                                print('Selected ${obj..nombre}');
                              },
                            ),
                            DataCell(
                              Text(obj.descripcion),
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

   Widget  dataBodyNo(id) {
    return FutureBuilder <List<Rol>>(
      future:descargar_roles_noasignados(id),
      builder:(context,snapshot){
        if(snapshot.hasData){
          var textStyle = TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize:15,);
          return  
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
                child: SingleChildScrollView( 
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor:MaterialStateColor.resolveWith((states) =>Color.fromRGBO(56, 124, 43, 1.0) ),
                    //Color.fromRGBO(136,139, 141, 1.0)
                    sortAscending: sortNo,
                    sortColumnIndex: 0,
                    columns: [
                      DataColumn(
                        label: Text("Roles\nNo Asignados",style: textStyle),
                        numeric: false,
                        tooltip: "Roles No Asignados",
                        onSort: (columnIndexNo, ascending) {
                          setState(() {
                            sortNo = !sortNo;
                          });
                          onSortColumNo(columnIndexNo, ascending);
                        }
                      ),
                      DataColumn(
                        label: Text("Descripción",style: textStyle),
                        numeric: false,
                        tooltip: "Descripción",
                        onSort: (columnIndexNo, ascending) {
                          setState(() {
                            sortNo = !sortNo;
                          });
                          onSortColumNo(columnIndexNo, ascending);
                        }
                      ),
                    ],
                    rows: rolesNo.map(
                      (objNo) => DataRow(
                        selected: selectedRolNo.contains(objNo),
                        onSelectChanged: (b) {
                          print("Onselect");
                          onSelectedRowNo(b, objNo);
                        },
                        cells: [
                          DataCell(
                            Text(objNo.nombre),
                            onTap: () {
                              print('Selected ${objNo.nombre}');
                            },
                          ),
                          DataCell(
                            Text(objNo.descripcion),
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
}