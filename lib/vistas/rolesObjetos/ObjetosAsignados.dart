import 'package:flutter/material.dart';

import 'package:proveedores_manuelita/logica/Objetos.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/modelos/Objeto.dart';
import 'package:proveedores_manuelita/modelos/Rol.dart';
import 'package:proveedores_manuelita/modelos/response_status.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/vistas/rolesObjetos/ObjetosNoAsignados.dart';


class ObjetosAsignados extends StatefulWidget {
  Data data;
  List <Rol>obj;
  ObjetosAsignados(this.data,this.obj) : super();
  @override
  _ObjetosAsignadosState createState() => _ObjetosAsignadosState();
}

class _ObjetosAsignadosState extends State<ObjetosAsignados> {
  List<Objeto> objetos=[];
  List<Objeto> objetosNo=[];
  Objeto consulta;
  List<Objeto> selectedObject;
  List<Objeto> selectedObjectNo;
  bool refrescar = false;
  bool sort;
  bool sortNo;
  String _token;
  bool validar;
  bool borrar=false;
  String mensaje,texto;
  ResponseStatus status = new ResponseStatus();

   
   @override
  void initState() {
    sort = false;
    sortNo = false;
    widget.data;
    selectedObject = [];
    objetos=[];
    selectedObjectNo = [];
    objetosNo=[];
    widget.obj;
    //users =widget.data.usuarios ;
    //listar_usuario();
    super.initState();
  }

  void borrarTabla(){
    setState(() {
      objetos=[]; 
    });
  }
  
  
  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        objetos.sort((a, b) => a.objeto.compareTo(b.objeto));
      } else {
        objetos.sort((a, b) => b.objeto.compareTo(a.objeto));
      }
    }
  }

   onSortColumNo(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        objetosNo.sort((a, b) => a.objeto.compareTo(b.objeto));
      } else {
        objetosNo.sort((a, b) => b.objeto.compareTo(a.objeto));
      }
    }
  }
 
  onSelectedRowNo(bool selected, Objeto obj) async {
    setState(() {
      if (selected) {
        selectedObjectNo.add(obj);
      } else {
        selectedObjectNo.remove(obj);
      }
    });
  }
 
  onSelectedRow(bool selected, Objeto obj) async {
    setState(() {
      if (selected) {
        selectedObject.add(obj);
      } else {
        selectedObject.remove(obj);
      }
    });
  }

  deleteSelected() async {
    setState(() {
      List objetoa=[];
      if (selectedObject.isNotEmpty) {
        List<Objeto> temp = [];
        temp.addAll(selectedObject);
        for (Objeto obj in temp) {
          objetoa.add(obj.objeto);
          objetos.remove(obj);
          selectedObject.remove(obj); 
          //_showAlertDialogOnly('Usuario Eliminado Correctamente','Eliminar Usario');
       }
       remover_objetos(objetoa);
       successDialog(
       context, 
        'Se quitaron los objetos seleccionados',
        neutralText: "Aceptar",
        neutralAction: (){
            
         },
      );
      }else
      {  
        errorDialog(
          context, 
          "Por favor seleccione un objeto",
          negativeAction: (){
          },
        );
      }
    });
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
                Navigator.of(context).pop();
               },
            )
          ],
        );
      }
    );
  }
  Future <List<Objeto>> listar_objetos_asignados(id)async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var objeto= Objetos(session);
    var token=widget.data.token;
    if(selectedObject.length > 0){
       return objetos;
    }else if(borrar==true)
    {
      return objetos;
    }else if(objetos.length > 0 && borrar==true )
    {
      return objetos;
    }
    else
    {
      await objeto.descargar_objetos_asignados(id).then((_){
        var preObjetos=objeto.obtener_asignados();
        objetos=[];
        for ( var obj in preObjetos)
        {
         objetos.add(obj);
        }        
      });
      return objetos;
    }
  }

  remover_objetos(objetoa)async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var objeto= Objetos(session);
    var id=widget.obj[0].id;
    var token=widget.data.token;
    await objeto.remover_objeto_rol(id,objetoa).then((_){
    });
  }

  deleteSelectedNo() async {
    setState(() {
      List objetoNoT=[];
      if (selectedObjectNo.isNotEmpty) {
        List<Objeto> temp = [];
        temp.addAll(selectedObjectNo);
        for (Objeto obj in temp) {
          objetoNoT.add(obj.objeto);
          objetosNo.remove(obj);
          selectedObjectNo.remove(obj); 
       }
       asignar_objeto(objetoNoT);
       successDialog(
       context, 
        'Se asignaron los objetos seleccionados',
        neutralText: "Aceptar",
        neutralAction: (){
            
         },
      );
      }else
      {  
        errorDialog(
              context, 
              "Por favor seleccione un objeto",
              negativeAction: (){
              },
        );
      }
    });
  }

    Future <List<Objeto>> listar_objetos_noasignados(id)async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var objeto= Objetos(session);
    var token=widget.data.token;
    if(selectedObjectNo.length > 0){
       return objetosNo;
    }else if(borrar==true)
    {
      return objetos;
    }else if(objetosNo.length > 0 && borrar==true )
    {
      return objetosNo;
    }
    else
    {
      await objeto.descargar_objetos_noasignados(id).then((_){
        var preObjetos=objeto.obtener_noasignados();
        objetosNo=[];
        for ( var obj in preObjetos)
        {
         objetosNo.add(obj);
        }        
      });
      return objetosNo;
    }
  } 

  asignar_objeto(objetoa)async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var objeto= Objetos(session);
    var token=widget.data.token;
    await objeto.asignar_objeto_rol(widget.obj[0].id,objetoa).then((_){
    });
  }
   
  @override
  Widget build(BuildContext context) {
    var id=widget.obj[0].id;
    return Expanded(
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Padding(
            padding: EdgeInsets.fromLTRB(10,10,10,0),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children:[
                  //Container(padding: EdgeInsets.all(5),child:Column(children: [Text('Objetos Asignados',style:TextStyle(fontWeight:FontWeight.bold))],)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children:[
                      Padding(
                      padding: EdgeInsets.fromLTRB(5,5,5,10),
                      child:Container(
                        alignment:Alignment.topRight,
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
                    ]
                  ),
                  Expanded(child:dataBody(id)),   
                ]
              ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10,10,10,0),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  //Container(padding: EdgeInsets.all(5),child:Column(children: [Text('Objetos No Asignados',style:TextStyle(fontWeight:FontWeight.bold))],)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Padding(
                        padding: EdgeInsets.fromLTRB(5,5,5,10),
                        child:Container(
                          alignment:Alignment.topRight,
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
                    ]
                  ),
                  Expanded(child:dataBodyNo(id)),
                ]
              ),
          ),
        ],
      ),
    );
  }

  Widget dataBody(id) {
    return FutureBuilder <List<Objeto>>(
      future:listar_objetos_asignados(id),
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
                    label: Text("Objetos\nAsignados",style: textStyle),
                    numeric: false,
                    tooltip: "Objetos Asignado",
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        sort = !sort;
                      });
                      onSortColum(columnIndex, ascending);
                    }
                  ),
                  DataColumn(
                    label: Text("Descripci??n",style: textStyle),
                    numeric: false,
                    tooltip: "Descripci??n",
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        sort = !sort;
                      });
                      onSortColum(columnIndex, ascending);
                    }
                  ),
                ],
                rows: objetos.map(
                  (obj) => DataRow(
                    selected: selectedObject.contains(obj),
                    onSelectChanged: (b) {
                      print("Onselect");
                      onSelectedRow(b, obj);
                    },
                    cells: [
                      DataCell(
                        Text(obj.objeto),
                        onTap: () {
                          print('Selected ${obj.objeto}');
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
    return FutureBuilder <List<Objeto>>(
      future:listar_objetos_noasignados(id),
      builder:(context,snapshot){
        if(snapshot.hasData){
          var textStyle = TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize:15,);
          return  
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
              child:DataTable(
                headingRowColor:MaterialStateColor.resolveWith((states) =>Color.fromRGBO(56, 124, 43, 1.0) ),
                //Color.fromRGBO(136,139, 141, 1.0)
                sortAscending: sort,
                sortColumnIndex: 0,
                columns: [
                  DataColumn(
                    label: Text("Objetos\nNo Asignados",style: textStyle),
                    numeric: false,
                    tooltip: "Objetos No Asignados",
                    onSort: (columnIndexNo, ascendingNo) {
                      setState(() {
                        sortNo = !sortNo;
                      });
                      onSortColumNo(columnIndexNo, ascendingNo);
                    }
                  ),
                  DataColumn(
                    label: Text("Descripci??n",style: textStyle),
                    numeric: false,
                    tooltip: "Descri",
                    onSort: (columnIndexNo, ascendingNo) {
                      setState(() {
                        sortNo = !sortNo;
                      });
                      onSortColumNo(columnIndexNo, ascendingNo);
                    }
                  ),
                ],
                rows: objetosNo.map(
                  (objNo) => DataRow(
                    selected: selectedObjectNo.contains(objNo),
                    onSelectChanged: (b) {
                      print("Onselect");
                      onSelectedRowNo(b, objNo);
                    },
                    cells: [
                      DataCell(
                        Text(objNo.objeto),
                        onTap: () {
                          print('Selected ${objNo.objeto}');
                        },
                      ),
                      DataCell(
                        Text(objNo.descripcion),
                      ),
                    ]
                  ),
                ).toList(),
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