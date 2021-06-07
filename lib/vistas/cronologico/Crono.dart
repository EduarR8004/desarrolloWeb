import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:proveedores_manuelita/logica/Cronologicos.dart';
import 'package:proveedores_manuelita/logica/EntradasCana.dart';
import 'package:proveedores_manuelita/modelos/Cronologico.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/modelos/EntradaCana.dart';
import 'package:proveedores_manuelita/utiles/Flecha.dart';
import 'package:proveedores_manuelita/vistas/encabezado/Encabezado.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/OcultarColumnas.dart';
import 'package:proveedores_manuelita/vistas/menu.dart';
import 'package:proveedores_manuelita/utiles/Notificaciones.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/utiles/Globals.dart';
import 'package:proveedores_manuelita/vistas/index.dart';


class VerCronologico extends StatefulWidget {
  final Data data;
  
  VerCronologico ({Key key,this.data}) : super();

  @override
  _VerCronologicoState createState() => _VerCronologicoState();
}

class _VerCronologicoState extends State<VerCronologico> {
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  bool sort;
  bool borrar = false;
  bool cambiar,tabla,detalle,mensaje,zona,tierra,hacienda,ocupacion,estimado,siembra,fechaSiembra,mostrarFechaSiembra,mostrarSiembra,mostrarEstimado,mostrarOcupacion,mostrarZona,mostrarTierra,mostrarHacienda;
  List<String> mostrarNotificacion=[];
  int contadorEntradaCana,contadorConsultas,contadorInfoProduccion,contadorLiqCana;
  String selectedRegion,haciendaUnica;
  List <EntradaCana>_entrada=[];
  List<EntradaCana> _region = [];
  List <EntradaCana>entrada=[];
  List <Cronologico>entradaGeneral=[];
  List <Cronologico>entradaCrono=[];
  List <EntradaCana>pasoParametro=[];
  List<String> objetos=[];
  String value = "";
  Cronologico entradasCrono;
  List<DropdownMenuItem<String>> menuitems = List();  
  bool disabledropdown = true;
  bool otra;
  Map total;
  int contador=0;
  String vacio='';
  final format = DateFormat("yyyy-MM-dd");
  var info='No se encontraron resultados para esta consulta';
  var parametro,codParametro,codRespeuesta,inicial,fin,fecha_i,fecha_f;
  
 @override
  void initState() {
    sort = false;
    tabla = true;
    detalle = true;
    cambiar = true;
    zona=false;
    tierra=false;
    hacienda=false;
    ocupacion=false;
    mostrarOcupacion=false;
    mostrarZona=false;
    mostrarTierra=false;
    mostrarHacienda=false;
    estimado=false;
    mostrarEstimado=false;
    siembra=false;
    mostrarSiembra=false;
    fechaSiembra=false;
    mostrarFechaSiembra=false;
    codParametro='';
    otra=false;
    widget.data;
    contadorGeneral=0;
    guardaContador=0;
    widget.data;
    super.initState();
  }

  List <MultiSelectDialogItem<int>> multiItem = List();

  final valuestopopulate = {
    0 : "Seleccione Las Columnas A Visualizar",
    1 : "Hacienda",
    2 : "Ocupación",
    3 : "TCH.Estimado",
    4 : "Dist.Siembra",
    5 : "Dist.Tierra",
    6: "Zona Agroecológica",
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
      zona=false;
      tierra=false;
      hacienda=false;
      ocupacion=false;
      estimado=false;
      siembra=false;
      fechaSiembra=false;
      for(int x in selection.toList()){
        print(valuestopopulate[x]);
        if(valuestopopulate[x]=='Hacienda')
        { 
          setState(() {
            hacienda=true;
          });
        }
        if(valuestopopulate[x]=='Ocupación')
        { 
          setState(() {
            ocupacion=true;
          });
        }
        if(valuestopopulate[x]=='TCH.Estimado')
        { 
          setState(() {
            estimado=true;
          });
        }
        if(valuestopopulate[x]=='Dist.Siembra')
        { 
          setState(() {
            siembra=true;
          });
        }
        if(valuestopopulate[x]=='Dist.Tierra')
        { 
          setState(() {
            tierra=true;
          });
        }
        if(valuestopopulate[x]=='Zona Agroecológica')
        { setState(() {
            zona=true;
          });
        }
      }
      if(hacienda==true)
      {
        setState(() {
          x.add(1);
          mostrarHacienda=true;
        });
      }else
      {
        setState(() {
          x.remove(1);
          mostrarHacienda=false;
        });
      }
      if(tierra==true)
      {
        setState(() {
          x.add(5);
          mostrarTierra=true;
        });
      }else
      {
        setState(() {
          x.remove(5);
          mostrarTierra=false;
        });
      }
      if(zona==true)
      {
        setState(() {
          mostrarZona=true;
          x.add(6);
        });
      }else
      {
        setState(() {
          x.remove(6);
          mostrarZona=false;
        });
      }
      if(ocupacion==true)
      {
        setState(() {
          x.add(2);
          mostrarOcupacion=true;
        });
      }else
      {
        setState(() {
          x.remove(2);
          mostrarOcupacion=false;
        });
      }
      if(estimado==true)
      {
        setState(() {
          x.add(3);
          mostrarEstimado=true;
        });
      }else
      {
        setState(() {
          x.remove(3);
          mostrarEstimado=false;
        });
      }
      if(siembra==true)
      {
        setState(() {
          x.add(4);
          mostrarSiembra=true;
        });
      }else
      {
        setState(() {
          x.remove(4);
          mostrarSiembra=false;
        });
      }
    }else{
      setState(() {
        x.remove(6);
        x.remove(5);
        x.remove(4);
        x.remove(3);
        x.remove(2);
        x.remove(1);
        mostrarTierra=false;
        mostrarZona=false;
        mostrarHacienda=false;
        mostrarOcupacion=false;
        mostrarEstimado=false;
        mostrarSiembra=false;
          //mostrarFechaSiembra=false;
      });
    }
  }

 Future <List<EntradaCana>> listar_haciendas()async{
  var session= Conexion();
  session.set_token(widget.data.token);
  var usuario= EntradasCana(session);
  var token=widget.data.token;
  if(entrada.length > 0)
  {
    return entrada;
  }else{
    await usuario.listar_haciendas(false).then((data){
      var preUsuarios=usuario.obtener_haciendas();
      for ( var user in preUsuarios)
      {
        entrada.add(user);
      }        
    });
    if(entrada.length==1)
    { 
      setState(() {
        haciendaUnica=entrada[0].cod_hda+" - "+entrada[0].nm_hda;
        return entrada;
      });
    }
      return entrada;
  }
}

  @override
  Widget build(BuildContext context) {
    var menu = new Menu(data:widget.data,retorno:'crono');
    var encabezado= new Encabezado(data:widget.data,titulo:'Cronológico',);
    return WillPopScope(
    onWillPop: () {  },
      child:SafeArea(
        top: false,
        child:Scaffold(
          appBar: new AppBar(
          flexibleSpace: encabezado,
          backgroundColor: Colors.transparent,
          ),
          drawer: menu,
          body: Container(
            height: 700,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child:dataBody()),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showMultiSelect(context);
            },
            child: const Icon(Icons.add),
            backgroundColor: Color.fromRGBO(56, 124, 43, 1.0),
          ),
        ),
      ),
    );
  }
  
  parametros(parametro){
   for ( var par in parametro)
    {
      pasoParametro.add(par);
    }
    var codParametro;
    pasoParametro.map((EntradaCana map) {
    codParametro=map.cod_hda;
    }).toList();
     return codParametro;
  }
  Widget dataBody() {
    return FutureBuilder<List<EntradaCana>>(
      future:listar_haciendas(),
      builder:(context,snapshot){
        List<Widget> children;
        if(snapshot.hasData){
          _entrada = (entrada).toList();
          cambiar?codParametro=entrada[0].cod_hda:codParametro=codRespeuesta;
          //tabla = true;
          return 
          Center(child:
            Column(
              children:<Widget>[
                SizedBox(height:15),
                Container(
                  height: 40,
                  margin: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom:BorderSide(width: 1,
                        color: Color.fromRGBO(83, 86, 90, 1.0),
                      ),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      hint: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child:Text(haciendaUnica!=null?haciendaUnica:'Seleccione una Hacienda', textAlign: TextAlign.left,
                            style: TextStyle(
                            color: Colors.black,
                            //fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            fontFamily: 'Karla',
                            ),
                          ),
                        ),
                      ),
                      value:selectedRegion,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          contador=0;
                          parametro=entrada.where((a) => a.nm_hda==newValue);
                          codRespeuesta=parametros(parametro);
                          cambiar = false;
                          detalle = true;
                          tabla = false;
                          selectedRegion = newValue;
                        });
                        print(selectedRegion);
                      },
                      items: _entrada.map((EntradaCana map) {
                        return new DropdownMenuItem<String>(
                          value: map.nm_hda,
                          //child: Center(
                          child:Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 38,2),
                          child:new Text(map.cod_hda+' - '+map.nm_hda,textAlign: TextAlign.left,
                            style: new TextStyle(
                              //fontWeight: FontWeight.bold,
                              color: Colors.black
                            )
                          ),
                        ),
                        //),
                        );
                      }
                      ).toList(),
                    ),
                  ),
                ),
                SizedBox(height:15), 
                // Container(
                // padding:const EdgeInsets.fromLTRB(400, 10, 0,0),
                // alignment: Alignment.bottomLeft,
                //   child:Row(
                //     children:[
                //       RaisedButton(
                //         textColor: Color.fromRGBO(83, 86, 90, 1.0),
                //         //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                //         color: Color.fromRGBO(56, 124, 43, 1.0),
                //         child: Text('Más Info', style: TextStyle(
                //           color: Colors.white,
                //           //Color.fromRGBO(83, 86, 90, 1.0),
                //           fontSize: 16,
                //           fontWeight: FontWeight.bold
                //         )),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(50.0),
                //           //side: BorderSide(color: Colors.white)
                //         ),
                //         onPressed: () {
                //           _showMultiSelect(context);
                //         },
                //       ),
                //     ],
                //   )
                // ),
                SizedBox(height:5),
                tabla?Expanded(child:dataTableVacia()):Expanded(child:dataTable(codParametro)),
                
              ],
            )
          );
        } else if (snapshot.hasError) {
          return Column(
            children:[
              SizedBox(height: 150,),
              Container(
                padding: EdgeInsets.all(20),
                child:Text("Ha superado el tiempo de espera para comunicarse con el servidor",
                  textAlign:TextAlign.center,
                  style:  TextStyle(
                    color: Color.fromRGBO(83, 86, 90, 1.0),
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                )
              ),
              Center(child: 
                const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 120,
                ),
              )
            ]
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

  Future <List<Cronologico>> listar_informe(cod_hda)async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var cronologico= Cronologicos(session);
    var token=widget.data.token;
    var preEntrada;
    if(detalle)
    {
      await cronologico.listar_cronologico(cod_hda).then((data){
      entradaGeneral=[];
      preEntrada=cronologico.obtener_cronologico();
      for ( var tabla_informe in preEntrada)
      {
        entradaGeneral.add(tabla_informe );
      }   
      preEntrada=[]; 
      cronologico.limpiar_cronologico();    
      });
      preEntrada=[]; 

      if(entradaGeneral.length > 0)
      {
        return entradaGeneral;
      }
      else{
        contador++;
        setState(() {
          tabla = true;
        });
        if(contador==1)
        {
          warningDialog(
            context, 
            info,
            negativeAction: (){
            },
          );
        }
      }
    }else
    {
      return entradaGeneral;
    }        
}

  Widget  dataTable(cod_hda) {
    return FutureBuilder <List<Cronologico>>(
      future:listar_informe(cod_hda),
        builder:(context,snapshot){
          if(snapshot.hasData){
            var textStyle = TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize:15,);
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
                        columns:
                        [
                          DataColumn(
                            label: mostrarHacienda?Expanded(child:Text("Hacienda",textAlign: TextAlign.center,style: textStyle),):Container(),
                            numeric: false,
                            tooltip: "Hacienda",
                          ),
                          DataColumn(
                              label: Expanded(child:Text("Suerte",textAlign: TextAlign.center,style: textStyle),),
                              numeric: false,
                              tooltip: "Suerte",
                          ),
                          DataColumn(
                              label:  mostrarOcupacion?Expanded(child:Text("Ocupación",textAlign: TextAlign.center,style: textStyle),):Container(),
                              numeric: false,
                              tooltip: mostrarOcupacion?"Ocupación":'',
                          ),
                          DataColumn(
                            label: Expanded(child:Text("Área",textAlign: TextAlign.center,style: textStyle),),
                            numeric: false,
                            tooltip: "Área",
                          ),
                          DataColumn(
                            label: Expanded(child:Text("Edad",textAlign: TextAlign.center,style: textStyle),),
                            numeric: false,
                            tooltip: "Edad",
                          ),
                          DataColumn(
                              label: Expanded(child:Text("Fecha de Corte",textAlign: TextAlign.center,style: textStyle),),
                              numeric: false,
                              tooltip: "Fecha de Corte",
                              ),
                          DataColumn(
                            label: Expanded(child:Text("Variedad",textAlign: TextAlign.center,style: textStyle),),
                            numeric: false,
                            tooltip: "Variedad",
                          ),
                          DataColumn(
                            label: mostrarEstimado?Expanded(child:Text("TCH Estimado",textAlign: TextAlign.center,style: textStyle),):Container(),
                            numeric: false,
                            tooltip: mostrarEstimado?"TCH Estimado":'',
                          ),
                          DataColumn(
                              label: Expanded(child:Text("No. Cortes",textAlign: TextAlign.center,style: textStyle),),
                              numeric: false,
                              tooltip: "No.Cortes",
                              ),
                          DataColumn(
                            label:Expanded(child:Text("Fecha de Siembra",textAlign: TextAlign.center,style: textStyle),),
                            numeric: false,
                            tooltip: "Fecha de Siembra",
                          ),
                          DataColumn(
                              label: mostrarTierra?Expanded(child:Text("Dist. Tierra",textAlign: TextAlign.center,style: textStyle),):Container(),
                              numeric: false,
                              tooltip: mostrarTierra?"Dist.Tierra":'',
                          ),
                          DataColumn(
                            label: mostrarSiembra?Expanded(child:Text("Dist. Siembra",textAlign: TextAlign.center,style: textStyle),):Container(),
                            numeric: false,
                            tooltip: mostrarSiembra?"Dist.Siembra":'',
                          ),
                          DataColumn(
                            label: mostrarZona?Expanded(child:Text("Zona Agroecológica",textAlign: TextAlign.center,style: textStyle),):Container(),
                            numeric: false,
                            tooltip:"Zona Agroecológica",
                          ),
                        ],
                        rows:
                        entradaGeneral.map(
                          (entradaCrono) => DataRow(
                            cells:[
                              DataCell(
                                  mostrarHacienda?Center(child:Text(entradaCrono.hacienda_cod),):Container(),
                              ),
                              DataCell(
                                Center(child:Text(entradaCrono.suerte_cod),),
                              ),
                              DataCell(
                                mostrarOcupacion?Center(child:Text(entradaCrono.ocup),):Container(),
                              ),
                              DataCell(
                                Center(child:Text(entradaCrono.area),),
                              ),
                              DataCell(
                                Center(child:Text(entradaCrono.edad),),
                              ),
                              DataCell(
                                Center(child:Text(entradaCrono.fecha_uc),),
                              ),
                              DataCell(
                                Center(child:Text(entradaCrono.variedad),),
                              ),
                              DataCell(
                                mostrarEstimado?Center(child:Text(entradaCrono.tch_est),):Container(),
                              ),
                              DataCell(
                                Center(child:Text(entradaCrono.ncorte),),
                              ),
                              DataCell(
                                Center(child:Text(entradaCrono.fecha_siembra),),
                              ),
                              DataCell(
                                mostrarTierra?Center(child:Text(entradaCrono.dist_surc),):Container(),
                              ),
                              DataCell(
                                mostrarSiembra?Center(child:Text(entradaCrono.distancia),):Container(),
                              ),
                              DataCell(
                                mostrarZona?Center(child:Text(entradaCrono.zona_agroc),):Container(),
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

  Widget  dataTableVacia() {
    var textStyle = TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize:15,);
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
              columns:
              [
                DataColumn(
                label: Text("Suerte",style:textStyle),
                numeric: false,
                tooltip: "Suerte",
                ),
                DataColumn(
                  label: Text("Área",style:textStyle),
                  numeric: false,
                  tooltip: "Área",
                ),
                DataColumn(
                  label: Text("Edad",style:textStyle),
                  numeric: false,
                  tooltip: "Edad",
                ),
                DataColumn(
                    label: Text("Fecha de Corte",style:textStyle),
                    numeric: false,
                    tooltip: "Fecha de Corte",
                    ),
                DataColumn(
                  label: Text("Variedad",style:textStyle),
                  numeric: false,
                  tooltip: "Variedad",
                ),
                DataColumn(
                    label: Text("No.Corte",style:textStyle),
                    numeric: false,
                    tooltip: "No.Corte",
                    ),
                DataColumn(
                  label: Text("Fecha de Siembra",style:textStyle),
                  numeric: false,
                  tooltip: "Fecha de Siembra",
                ),
              ],
              rows:
              entradaGeneral.map(
                (entradaCrono) => DataRow(
                  cells:[
                    DataCell(
                        Text('Sin info'),
                      ),
                      DataCell(
                        Text('disponible'),
                      ),
                      DataCell(
                        Text('para esta consulta'),
                      ),
                    DataCell(
                      Text(''),
                    ),
                    DataCell(
                      Text(''),
                    ),
                    DataCell(
                      Text(''),
                    ),
                    DataCell(
                      Text(''),
                    ),
                  ]
                ),   
              ).toList(),
            ),
          ),
      );
  }
}




