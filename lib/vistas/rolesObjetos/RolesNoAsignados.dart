import 'package:flutter/material.dart';

import 'package:proveedores_manuelita/logica/Objetos.dart';
import 'package:proveedores_manuelita/logica/Roles.dart';
import 'package:proveedores_manuelita/modelos/Objeto.dart';
import 'package:proveedores_manuelita/modelos/Rol.dart';
import 'package:proveedores_manuelita/modelos/Usuario.dart';
import 'package:proveedores_manuelita/modelos/response_status.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';

class RolesNoAsignados extends StatefulWidget {
  String data;
  List<Usuario> obj;
  RolesNoAsignados(this.data, this.obj) : super();
  @override
  _RolesNoAsignadosState createState() => _RolesNoAsignadosState();
}

class _RolesNoAsignadosState extends State<RolesNoAsignados> {
  List<Rol> rolesNo = [];
  List<Rol> selectedRolNo;
  bool sortNo;
  String _token;
  bool validar;
  bool borrar = false;
  String mensaje, texto;
  ResponseStatus status = new ResponseStatus();

  @override
  void initState() {
    sortNo = false;
    selectedRolNo = [];
    widget.data;
    rolesNo = [];
    widget.obj;
    //users =widget.data.usuarios ;
    //listar_usuario();
    super.initState();
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
      List rolesa = [];
      List rolesNombre = [];
      if (selectedRolNo.isNotEmpty) {
        List<Rol> temp = [];
        temp.addAll(selectedRolNo);
        for (Rol rol in temp) {
          rolesa.add(rol.id);
          rolesNombre.add(rol.nombre);
          rolesNo.remove(rol);
          selectedRolNo.remove(rol);
          //_showAlertDialogOnly('Usuario Eliminado Correctamente','Eliminar Usario');
        }
        asignar_rol(rolesa, rolesNombre);
      } else {
        //_showAlertDialog("Por favor seleccione un usuario","Operación invalida");
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

  Future<List<Rol>> descargar_roles_noasignados(id) async {
    var session = Conexion();
    session.set_token(widget.data);
    var rol = Roles(session);
    var token = widget.data;
    if (selectedRolNo.length > 0) {
      return rolesNo;
    } else if (borrar == true) {
      return rolesNo;
    } else if (rolesNo.length > 0 && borrar == true) {
      return rolesNo;
    } else {
      await rol.descargar_roles_noasignados(id).then((_) {
        var preRol = rol.obtener_noasignados();
        rolesNo = [];
        for (var rol in preRol) {
          rolesNo.add(rol);
        }
      });
      return rolesNo;
    }
  }

  asignar_rol(rolesa, rolesNombre) async {
    var session = Conexion();
    session.set_token(widget.data);
    var rol = Roles(session);
    var id = widget.obj[0].usuario_id;
    var token = widget.data;

    await rol.asignar_rol_usuario(id, rolesa, rolesNombre).then((_) {
      // rol.descargar_roles_asignados(widget.obj[0].usuario_id).then((_){
      //     var preRol=rol.obtener_asignados();
      //     roles=[];
      //     for ( var rol in preRol)
      //     {
      //      roles.add(rol);
      //     }
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    var id = widget.obj[0].usuario_id;
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: RaisedButton(
                  textColor: Color.fromRGBO(83, 86, 90, 1.0),
                  //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                  color: Color.fromRGBO(56, 124, 43, 1.0),
                  child: Text('Asignar',
                      style: TextStyle(
                          color: Colors.white,
                          //Color.fromRGBO(83, 86, 90, 1.0),
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
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
            dataBodyNo(id),
          ],
        ),
      ),
    );
  }

  Widget dataBodyNo(id) {
    return FutureBuilder<List<Rol>>(
      future: descargar_roles_noasignados(id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                    MaterialStateColor.resolveWith((states) => Colors.white),
                //Color.fromRGBO(136,139, 141, 1.0)
                sortAscending: sortNo,
                sortColumnIndex: 0,
                columns: [
                  DataColumn(
                    label: Text("Objeto"),
                    numeric: false,
                    tooltip: "Objeto",
                    onSort: (columnIndexNo, ascending) {
                      setState(() {
                        sortNo = !sortNo;
                      });
                      onSortColumNo(columnIndexNo, ascending);
                    }
                  ),
                  DataColumn(
                    label: Text("Descripción"),
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
                rows: rolesNo
                    .map(
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
                          ]),
                    )
                    .toList(),
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator()
              //Splash1(),
              );
        }
      },
    );
  }
}
