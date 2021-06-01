import 'package:flutter/material.dart';
import 'package:proveedores_manuelita/logica/Objetos.dart';
import 'package:proveedores_manuelita/modelos/Objeto.dart';
import 'package:proveedores_manuelita/modelos/Rol.dart';
import 'package:proveedores_manuelita/modelos/response_status.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';


class ObjetosNoAsignados extends StatefulWidget {
  method() => createState().imprimir();
  String data;
  List <Rol>obj;
  ObjetosNoAsignados(this.data,this.obj) : super();
  
  @override
  _ObjetosNoAsignadosState createState() => _ObjetosNoAsignadosState();
}

class _ObjetosNoAsignadosState extends State<ObjetosNoAsignados> {
  List<Objeto> objetos=[];
  Objeto consulta;
  List<Objeto> selectedObject;
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
    selectedObject = [];
    objetos=[];
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
  
  imprimir(){
    
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
          objetoa.remove(obj); 
          //_showAlertDialogOnly('Usuario Eliminado Correctamente','Eliminar Usario');
       }
       asignar_objeto(objetoa);
      }else
      {
        //_showAlertDialog("Por favor seleccione un usuario","Operación invalida");
      }
    });
  }

  Future <List<Objeto>> listar_objetos_noasignados(id)async{
    var session= Conexion();
    session.set_token(widget.data);
    var objeto= Objetos(session);
    var token=widget.data;
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
      await objeto.descargar_objetos_noasignados(id).then((_){
        var preObjetos=objeto.obtener_noasignados();
        objetos=[];
        for ( var obj in preObjetos)
        {
         objetos.add(obj);
        }        
      });
      return objetos;
    }
}

asignar_objeto(objetoa)async{
  var session= Conexion();
  session.set_token(widget.data);
  var objeto= Objetos(session);
  
  var token=widget.data;
  

  await objeto.asignar_objeto_rol(widget.obj[0].id,objetoa).then((_){
   
  });
}
   
  
  @override
  Widget build(BuildContext context) {
    var id=widget.obj[0].id;
    return Expanded(child:
                    SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child:Column(children:[
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

                         deleteSelected();
                                      // texto=_controller.text==null?'':_controller.text;
                                      //   final data = Data.parametros(
                                      //     parametro:texto,
                                      //     token:widget.data.token
                                      //   );
                                      //   Navigator.of(context).push(
                                      //   MaterialPageRoute(builder: (context) => DataTableUsuarios(data)));
                        },
                      ),
                      ),
                      ),
                      dataBody(id),     
            ],
            ),
            ),
                    
                
            );
  
  }

  Widget  dataBody(id) {
     return FutureBuilder <List<Objeto>>(
      future:listar_objetos_noasignados(id),
      builder:(context,snapshot){
        if(snapshot.hasData){
          return  
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                  child: SingleChildScrollView( 
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                       headingRowColor:
                      MaterialStateColor.resolveWith((states) =>Colors.white ),
                      //Color.fromRGBO(136,139, 141, 1.0)
                      sortAscending: sort,
                      sortColumnIndex: 0,
                      columns: [
                        DataColumn(
                            label: Text("Objeto"),
                            numeric: false,
                            tooltip: "Objeto",
                            onSort: (columnIndex, ascending) {
                              setState(() {
                                sort = !sort;
                              });
                              onSortColum(columnIndex, ascending);
                            }),
                        DataColumn(
                          label: Text("Descripción"),
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
                      rows: objetos
                          .map(
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
                                      
                                    ]),
                          )
                          .toList(),
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