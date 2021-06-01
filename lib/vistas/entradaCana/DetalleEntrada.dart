import 'package:flutter/material.dart';
import 'package:proveedores_manuelita/logica/EntradasCana.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/modelos/EntradaCanaDetalle.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/Flecha.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/utiles/OcultarColumnas.dart';

class DetalleEntrada extends StatefulWidget {
  final Data data;
  String ini,fin,cod_hda,suerte;
  
  DetalleEntrada ({Key key,this.data,this.ini,this.fin,this.cod_hda,this.suerte}) : super();
  @override
  _DetalleEntradaState createState() => _DetalleEntradaState();
}

class _DetalleEntradaState extends State<DetalleEntrada> {
  List <EntradaCanaDetalle>entradaDetalle=[];
  bool cambiar,tabla,detalle,mensaje,cambioFechaI,cambioFechaF,entradaTabla,guia,vehiculo,canasta,verCanasta,verVehiculo,verGuia;
  var info='No se encontraron resultados para esta consulta';
  bool sort;
  @override
  void initState() {
    tabla = false;
    sort = false;
    detalle = true;
    cambiar = true;
    cambioFechaI=false;
    cambioFechaF=false;
    entradaTabla=true;
    guia=false;
    vehiculo=false;
    canasta=false;
    verCanasta=false;
    verVehiculo=false;
    verGuia=false;
    widget.data;
    super.initState();
  }

    Future <List<EntradaCanaDetalle>> listar_detalle(ini,fin,cod_hda,suerte)async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var entradasCana= EntradasCana(session);
    var token=widget.data.token;
    var preEntrada;
    await entradasCana.listar_detalle(ini,fin,cod_hda,suerte).then((_){
    entradaDetalle=[];
    preEntrada=entradasCana.obtener_detalle();
    for ( var user in preEntrada)
    {
      entradaDetalle.add(user);
    }   
    preEntrada=[]; 
    entradasCana.limpiar_detalle(); 
    });
    preEntrada=[]; 
    if(entradaDetalle.length > 0)
    {
      return entradaDetalle;
    }
    else{
      setState(() {
        tabla = true;
      });
      warningDialog(
        context, 
        info,
        negativeAction: (){
        },
      );
    }
}
 List <MultiSelectDialogItem<int>> multiItem = List();

  final valuestopopulate = {
    0 : "Seleccione Las Columnas A Visualizar",
    1 : "Guía",
    2 : "Cod.Vehículo",
    3 : "Cod.Canasta",
  };

  void populateMultiselect(){
    for(int v in valuestopopulate.keys){
      multiItem.add(MultiSelectDialogItem(v, valuestopopulate[v]));
    }
  }
    var x=[0].toSet();
    void _showMultiSelect(BuildContext context) async {
      multiItem = [];
      populateMultiselect();
      final items = multiItem;
    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues:x,
        );
      },
    );

    print(selectedValues);
    getvaluefromkey(selectedValues);
  }
  
  void getvaluefromkey(Set selection){
    if(selection.isNotEmpty){
      guia=false;
      vehiculo=false;
      canasta=false;
      for(int x in selection.toList()){
        print(valuestopopulate[x]);
        if(valuestopopulate[x]=='Guía')
        { setState(() {
            guia=true;
          });
        }
        if(valuestopopulate[x]=='Cod.Vehículo')
        { 
          setState(() {
            vehiculo=true;
          });
        }
        if(valuestopopulate[x]=='Cod.Canasta')
        { 
          setState(() {
            canasta=true;
          });
        }
      }
      if(guia==true)
      {
        setState(() {
          verGuia=true;
          x.add(1);
        });
      }else
      {
        setState(() {
          x.remove(1);
          verGuia=false;
        });
      }
      if(vehiculo==true)
      {
        setState(() {
          x.add(2);
          verVehiculo=true;
        });
      }else
      {
        setState(() {
          x.remove(2);
          verVehiculo=false;
        });
      }
      if(canasta==true)
      {
        setState(() {
          x.add(3);
          verCanasta=true;
        });
      }else
      {
        setState(() {
          x.remove(3);
          verCanasta=false;
        });
      }
    }else{
      setState(() {
        x.remove(3);
        x.remove(2);
        x.remove(1);
        verCanasta=false;
        verVehiculo=false;
        verGuia=false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // height: 60,
              //   width: 600,
              margin: EdgeInsets.only(top:21),
              decoration: BoxDecoration(
                color: Colors.white,  
                  //borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('images/titulop.png'),
                  fit: BoxFit.cover
                ),
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
                    child:Text("Detalle de Entrada de Caña",
                      style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding:const EdgeInsets.fromLTRB(3, 2, 0,0),
              alignment: Alignment.topLeft,
              child:Row(children:[
                RaisedButton(
                  textColor: Color.fromRGBO(83, 86, 90, 1.0),
                  //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                  color: Color.fromRGBO(56, 124, 43, 1.0),
                  child: Text('Más Info', style: TextStyle(
                    color: Colors.white,
                    //Color.fromRGBO(83, 86, 90, 1.0),
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  )),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    //side: BorderSide(color: Colors.white)
                  ),
                  onPressed: () {
                    setState(() {
                    _showMultiSelect(context);
                    //key_modal(context,ini,fin,cod_hda,suerte);
                    });
                  },
                ),
                Flecha(),
              ]),
            ),
            Expanded(child:dataTable(widget.ini,widget.fin,widget.cod_hda,widget.suerte),),
          ],
        ),
      ),
    );
  }

Widget  dataTable(ini,fin,cod_hda,suerte) {
  return FutureBuilder <List<EntradaCanaDetalle>>(
      future:listar_detalle(ini,fin,cod_hda,suerte),
      builder:(context,snapshot){
        if(snapshot.hasData){
          var textStyle = TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize:15,);
          return
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
                child: SingleChildScrollView( 
                  scrollDirection: Axis.horizontal,
                  child:DataTable(
                    headingRowColor:
                    MaterialStateColor.resolveWith((states) =>Color.fromRGBO(56, 124, 43, 1.0) ),
                    //Color.fromRGBO(136,139, 141, 1.0)
                    sortAscending: sort,
                    sortColumnIndex: 0,
                    horizontalMargin:10,
                    columnSpacing:10,
                    columns: [
                      DataColumn(
                        label: Expanded(child:Text("Suerte",textAlign: TextAlign.center,style:textStyle)),
                        numeric: false,
                        tooltip: "Suerte",
                      ),
                      DataColumn(
                        label: Expanded(child:Text("Fecha Entrada",textAlign: TextAlign.center,style:textStyle)),
                        numeric: false,
                        tooltip: "Fecha",
                      ),
                      DataColumn(
                        label: Expanded(child:Text("Hora",textAlign: TextAlign.center,style:textStyle)),
                        numeric: false,
                        tooltip: "Hora",
                      ),
                      DataColumn(
                        label: verGuia?Expanded(child:Text("Guía",textAlign: TextAlign.center,style:textStyle)):Container(),
                        numeric: false,
                        tooltip: "Guia",
                      ),
                      DataColumn(
                        label: verVehiculo?Expanded(child:Text("Cod. Vehículo",textAlign: TextAlign.center,style:textStyle)):Container(),
                        numeric: false,
                        tooltip: "Cod.Vehículo",
                      ),
                      DataColumn(
                        label: verCanasta?Expanded(child:Text("Cod. Canasta",textAlign: TextAlign.center,style:textStyle)):Container(),
                        numeric: false,
                        tooltip: "Canasta",
                      ),
                      DataColumn(
                        label: Expanded(child:Text("Peso Neto",textAlign: TextAlign.center,style:textStyle)),
                        numeric: false,
                        tooltip: "Peso Neto",
                      ),
                    ],
                    rows: entradaDetalle.map(
                      (entradaG) => DataRow(
                        cells: [
                          DataCell(
                            Center(child:Text(suerte),
                          ),),
                          DataCell(
                            Center(child:Text(entradaG.fch_entrada),),
                          ),
                          DataCell(
                            Center(child:Text(entradaG.hr_entrada),),
                          ),
                          DataCell(
                            verGuia?Center(child:Text(entradaG.guia),):Container(),
                          ),
                          DataCell(
                            verVehiculo?Center(child:Text(entradaG.cod_vehiculo),):Container(),
                          ),
                          DataCell(
                            verCanasta?Center(child:Text(entradaG.canasta),):Container(),
                          ),
                          DataCell(
                            Center(child:Text(entradaG.peso_neto),),
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
          );
        }
      },
    );
  }
}