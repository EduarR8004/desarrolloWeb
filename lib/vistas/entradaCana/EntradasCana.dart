import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:proveedores_manuelita/logica/EntradasCana.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/modelos/EntradaCana.dart';
import 'package:proveedores_manuelita/modelos/EntradaCanaDetalle.dart';
import 'package:proveedores_manuelita/modelos/EntradaCanaGeneral.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/utiles/OcultarColumnas.dart';
import 'package:proveedores_manuelita/vistas/encabezado/Encabezado.dart';
import 'package:proveedores_manuelita/vistas/entradaCana/DetalleEntrada.dart';
import 'package:proveedores_manuelita/utiles/Utiles.dart';
import 'package:proveedores_manuelita/utiles/Globals.dart';
import 'package:proveedores_manuelita/vistas/menu.dart';


class EntradasCanas extends StatefulWidget {
  final Data data;
  
  EntradasCanas ({Key key,this.data}) : super();

  @override
  _EntradasCanasState createState() => _EntradasCanasState();
}

class _EntradasCanasState extends State<EntradasCanas> {
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  bool sort;
  bool borrar = false;
  int contadorEntradaCana,contadorConsultas,contadorInfoProduccion,contadorLiqCana;
  bool cambiar,tabla,detalle,mensaje,cambioFechaI,cambioFechaF,entradaTabla,guia,vehiculo,canasta,verCanasta,verVehiculo,verGuia,tablaDetalle;
  String selectedRegion,llegaItexto,llegaFtexto,suerte;
  List<String> mostrarNotificacion=[];
  List <EntradaCana>_entrada=[];
  List<EntradaCana> _region = [];
  List <EntradaCana>entrada=[];
  List <EntradaCanaGeneral>entradaGeneral=[];
  List <EntradaCanaGeneral>selectedEntrada=[];
  List <EntradaCana>pasoParametro=[];
  List <EntradaCanaDetalle>entradaDetalle=[];
  List <EntradaCanaDetalle>entradaDetalleVacio=[];
  List<String> objetos=[];

  ProgressDialog ms;
  var validarFecha='Por favor ingresar la Fecha Inicial y la Fecha Final para realizar la consulta de información';
  var info='No se encontraron resultados para esta consulta';
  var error="La Fecha Inicial debe ser inferior o igual a la Fecha Final";
  DateTime now = DateTime.now();
  Map total;
  var parametro,codParametro,codRespeuesta,inicial,fin,fecha_i,fecha_f;
  final format = DateFormat("dd/MM/yyyy");
 @override
  void initState() {
    tablaDetalle=false;
    sort = false;
    tabla = false;
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
    selectedEntrada = [];
    _endTimeController;
    _endTimeController;
    contadorGeneral=0;
    guardaContador=0;
    widget.data;
    super.initState();
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
          ],
        );
      }
    );
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
      await usuario.listar_haciendas(true).then((_){
      var preUsuarios=usuario.obtener_haciendas();
      for ( var user in preUsuarios)
      {
        entrada.add(user);
      }   
      }).catchError( (onError){
        if(onError is SessionNotFound){
        
        print("SessionNotFound");
        }else if(onError is ConnectionError){
          print("ConnectionError");
        }else{
          print("ninguno de los anteriores");
        }                                          
      });
      DateTime llegaInicial = DateTime.parse(entrada[0].fch_ini_ent);
      DateTime llegaFinal = DateTime.parse(entrada[0].fch_ult_ent);
      llegaItexto=DateFormat('dd/MM/yyyy').format(llegaInicial);
      llegaFtexto=DateFormat('dd/MM/yyyy').format( llegaFinal);
      return entrada;
    }  
  }

  parametros(parametro){
   for ( var par in parametro)
    {
      pasoParametro.add(par);
    }
    var codParametro;
    pasoParametro.map((EntradaCana map) {
      codParametro=map.cod_hda;
      fecha_i=map.fch_ini_ent;
      fecha_f=map.fch_ult_ent;
    }).toList();
    DateTime llegaInicial = DateTime.parse(fecha_i);
    DateTime llegaFinal = DateTime.parse(fecha_f);
    String mapItexto=DateFormat('dd/MM/yyyy').format(llegaInicial);
    String mapFtexto=DateFormat('dd/MM/yyyy').format( llegaFinal);
    llegaItexto=mapItexto;
    llegaFtexto=mapFtexto;
    // inicial=mapItexto;
    // fin=mapFtexto;
    return codParametro;
  }

  @override
  Widget build(BuildContext context) {
    var menu = new Menu(data:widget.data,retorno:'entrada');
    var encabezado= new Encabezado(data:widget.data,titulo:'Entrada de Caña',);
    return WillPopScope(
    onWillPop: () {  },
      child:SafeArea(
        child:Scaffold(
          appBar: new AppBar(
            flexibleSpace: encabezado,
            backgroundColor: Colors.transparent,
          ),
          drawer: menu,
          body: Container(
            height:700,
            child:Center(child:dataBody())
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
  Widget dataBody() {
    return FutureBuilder<List<EntradaCana>>(
      future:listar_haciendas(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          _entrada = (entrada).toList();
          _startTimeController.text=llegaItexto;
          _endTimeController.text=llegaFtexto;
          cambiar?codParametro=entrada[0].cod_hda:codParametro=codRespeuesta;
          return 
            Column(
              children:<Widget>[
                SizedBox(height:30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[         
                  Container(
                  width: 330,
                  padding: EdgeInsets.fromLTRB(50, 10, 40, 10),
                    child: DateTimeField(
                      controller: _startTimeController,
                      onChanged: (text) {
                        if(_endTimeController.text!='')
                        {  
                          llegaItexto=_startTimeController.text;
                          var fechaicambio=_startTimeController.text.split('/');
                          var fechafcambio=_endTimeController.text.split('/');
                          var ini=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0]+' 00:00:00';
                          var ffinal=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0]+' 23:59:00';
                          DateTime parseInicial = DateTime.parse(ini);
                          DateTime parseFinal = DateTime.parse(ffinal);
                          String nfechaI=DateFormat('dd/MM/yyyy').format(parseInicial);
                          String nfechaF=DateFormat('dd/MM/yyyy').format(parseFinal);
                          setState(() {
                              tabla = false;
                          });
                          // if(parseInicial.isBefore(parseFinal))
                          // {
                          //   setState(() {
                          //     tabla = false;
                          //   });
                          // }else{
                          //   _startTimeController.text='';
                          //   errorDialog(
                          //     context, 
                          //     error,
                          //     negativeAction: (){
                          //     },
                          //   );
                          // }
                        }else{
                          infoDialog(
                            context, 
                            validarFecha,
                            negativeAction: (){
                            },
                          );
                        }
                      },
                      format: format,
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100)
                        );
                      },
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: (){
                            },
                          icon: Icon(
                          Icons.calendar_today,
                          color: Colors.grey,
                          ),
                        ),
                        enabledBorder:
                        UnderlineInputBorder(      
                          borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),   
                        ),  
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
                        ),
                      labelText: 'Fecha Inicial',
                      ),
                    ),
                  ),
                  Container(
                    width: 330,
                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child:DateTimeField(
                      controller:_endTimeController,
                      onChanged: (text) { 
                      if(_startTimeController.text!="")
                      { 
                        llegaFtexto=_endTimeController.text;
                        cambioFechaF=true;
                        var fechaicambio=_startTimeController.text.split('/');
                        var fechafcambio=_endTimeController.text.split('/');
                        var ini=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0]+' 00:00:00';
                        var ffinal=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0]+' 23:59:00';
                        DateTime parseInicial = DateTime.parse(ini);
                        DateTime parseFinal = DateTime.parse(ffinal);
                        String nfechaI=DateFormat('yyyy-mm-dd').format(parseInicial);
                        String nfechaF=DateFormat('yyyy-mm-dd').format(parseFinal);
                        //DateTime startDate = DateTime.parse(nfechaI);
                        //DateTime endDate = DateTime.parse(nfechaF);
                        if(parseInicial.isBefore(parseFinal))
                        {
                          setState(() {
                            tabla = false;
                          });
                        }else{
                          _endTimeController.text='';
                          errorDialog(
                            context, 
                            error,
                            negativeAction: (){
                            },
                          );
                        }
                      }else{
                        infoDialog(
                          context, 
                          validarFecha,
                          negativeAction: (){
                          },
                        );
                      }
                      },
                      format: format,
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100)
                        );
                      },
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: (){
                            },
                          icon: Icon(
                          Icons.calendar_today,
                          color: Colors.grey,
                          ),
                        ),
                        enabledBorder:
                        UnderlineInputBorder(      
                        borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),   
                        ),  
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
                        ), 
                        labelText: 'Fecha Final',
                      ),
                    ),
                  ),
                  Container(
                  width: 230,
                  height: 40,
                  //padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  margin: const EdgeInsets.fromLTRB(38, 20, 0,10),
                  decoration: BoxDecoration(
                    border: Border(bottom:BorderSide(width: 1,
                      color: Color.fromRGBO(83, 86, 90, 1.0),
                    ),
                    ),
                  ),
                    child: DropdownButtonHideUnderline(
                      child: new DropdownButton<String>(
                        hint: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Center(
                            child:Text(entrada[0].cod_hda.toString()+' - '+entrada[0].nm_hda.toString(), textAlign: TextAlign.center,style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Karla',
                            ),
                            ),
                          ),
                        ),
                        value:selectedRegion,
                        isDense: true,
                        onChanged: (String newValue) {
                        if(_endTimeController.text!=''&& _startTimeController.text!="")
                        {  
                          var fechaicambio=_startTimeController.text.split('/');
                          var fechafcambio=_endTimeController.text.split('/');
                          var ini=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0]+' 00:00:00';
                          var ffinal=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0]+' 23:59:00';
                          DateTime parseInicial = DateTime.parse(ini);
                          DateTime parseFinal = DateTime.parse(ffinal);
                          String nfechaI=DateFormat('yyyy-mm-dd').format(parseInicial);
                          String nfechaF=DateFormat('yyyy-mm-dd').format(parseFinal);
                          DateTime startDate = DateTime.parse(nfechaI);
                          DateTime endDate = DateTime.parse(nfechaF);
                          if(startDate.isBefore(endDate) || _startTimeController.text==_endTimeController.text)
                          {   
                            setState(() {
                              parametro=entrada.where((a) => a.nm_hda==newValue);
                              codRespeuesta=parametros(parametro);
                              _startTimeController.text=inicial;
                              _endTimeController.text=fin;
                              cambiar = false;
                              detalle = true;
                              tablaDetalle=false;
                              selectedRegion = newValue;
                            });
                          }else{
                            errorDialog(
                              context, 
                              error,
                              negativeAction: (){
                              },
                            );
                          }
                        }else
                        {
                          infoDialog(
                            context, 
                            validarFecha,
                            negativeAction: (){
                            },
                          );
                        }
                          print(selectedRegion);
                        },
                        items: _entrada.map((EntradaCana map) {
                          return new DropdownMenuItem<String>(
                            value: map.nm_hda,
                            //child: Center(
                            child:Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 2,2),
                            child:new Text(map.cod_hda+' - '+map.nm_hda,textAlign: TextAlign.center,
                              style: new TextStyle(color: Colors.black)
                            ),
                          ),
                        //),
                        );
                        }).toList(),
                      ),
                    ),
                  ), 
                ]
                ),
                SizedBox(height:15),
                Expanded(
                  child:
                  Center(
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0,10,0,5),
                          child:Column(
                            children:[
                              tabla?dataTotalVacia():dataTotal(_startTimeController.text,_endTimeController.text,codParametro),
                              SizedBox(height:15),
                              tabla?tablaVacia():Expanded(child:dataTable(_startTimeController.text,_endTimeController.text,codParametro)),
                            ]
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0,30,0,5),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Container(
                                padding: EdgeInsets.fromLTRB(0,0,0,5),
                                child:Row(
                                crossAxisAlignment:CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                  children:[
                                    Text("Detalle de Entrada de Caña",style: TextStyle(
                                      color:Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                    ),textAlign:TextAlign.center
                                    ),
                                  ]
                                ),
                              ),
                              SizedBox(height:36),
                              // Container(
                              //   padding:const EdgeInsets.fromLTRB(0,4,0,5),
                              //   alignment: Alignment.bottomLeft,
                              //     child:Row(
                              //       mainAxisAlignment: MainAxisAlignment.start,
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children:[
                              //         RaisedButton(
                              //           textColor: Color.fromRGBO(83, 86, 90, 1.0),
                              //           //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                              //           color: Color.fromRGBO(56, 124, 43, 1.0),
                              //           child: Text('Más Info', style: TextStyle(
                              //             color: Colors.white,
                              //             //Color.fromRGBO(83, 86, 90, 1.0),
                              //             fontSize: 16,
                              //             fontWeight: FontWeight.bold
                              //           )),
                              //           shape: RoundedRectangleBorder(
                              //             borderRadius: BorderRadius.circular(50.0),
                              //             //side: BorderSide(color: Colors.white)
                              //           ),
                              //           onPressed: () {
                              //             _showMultiSelect(context);
                              //           },
                              //         ),
                              //       ],
                              //     )
                              // ),
                              tablaDetalle?Expanded(child:dataTableDetalle(_startTimeController.text,_endTimeController.text,codParametro,suerte,))
                              :tablaVaciaDetalle(),
                            ]
                          )
                        ),
                      ]
                    )
                  ),
                ),
              ],
            );
        } else if (snapshot.hasError) {
          return  Column(children:[
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
          ]);
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

  Future <List<EntradaCanaGeneral>> listar_entrada(ini,fin,cod_hda)async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var entradasCana= EntradasCana(session);
    var token=widget.data.token;
    var preEntrada;
    if(detalle)
    {
      await entradasCana.listar_entrada(ini,fin,cod_hda).then((_){
      entradaGeneral=[];
      preEntrada=entradasCana.obtener_entradas();
      for ( var tabla_entrada in preEntrada)
      {
        entradaGeneral.add(tabla_entrada);
      }   
      preEntrada=[]; 
      entradasCana.limpiar_entradas();    
      });
      preEntrada=[]; 
    if(entradaGeneral.length > 0)
    {
      return entradaGeneral;
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
    }else
    { 
      ms.hide();
      return entradaGeneral;
    }        
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
  }

  Future <Map> listar_total(ini,fin,cod_hda)async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var entradasCana= EntradasCana(session);
    var token=widget.data.token;
    var preEntrada;
    Map totales;
    await entradasCana.listar_total(ini,fin,cod_hda).then((_){
      
      totales=entradasCana.obtener_total();
      //entradasCana.limpiar_total(); 
    });
    return total=totales;
}

  Widget  dataTotal(ini,fin,cod_hda) {
    return FutureBuilder <Map>(
    future:listar_total(ini,fin,cod_hda),
    builder:(context,snapshot){
      if(snapshot.hasData){
        return  
        Container(
          alignment: Alignment.center,
          width:350,
          child:
          Column(
            crossAxisAlignment:CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              Container(child: 
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,20,30,10),
                  child: Table(children: [  
                    TableRow(
                      children: [
                        Text("Peso Neto",textAlign: TextAlign.center,style: TextStyle(
                          color:Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),),
                        Text("Total Canastas",textAlign: TextAlign.center,style: TextStyle(
                          color:Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),),
                      ]
                    ),
                    TableRow(
                    children: [
                      Text(total['TOTAL_GENERAL'].toString(),textAlign: TextAlign.center,
                      style: TextStyle(
                        color:Colors.black,
                        fontSize: 15,
                      ),),
                      Text(total['TOTAL_CANASTAS'].toString(),textAlign: TextAlign.center,
                      style: TextStyle(
                        color:Colors.black,
                        fontSize: 15,
                      ),),
                    ]
                    ),
                  ],
                  ),
                ),
              ),
            ],
          )
        );
      }else{
        return
        Center(
          child:CircularProgressIndicator()
        );
      }
    }
  );
  }

Widget dataTotalVacia(){
  return  
    Column(
      mainAxisAlignment:MainAxisAlignment.center,
      children:<Widget>[
         Container(
          child: 
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Table(
                children: [
                  TableRow(
                    children: [
                      Text("Peso Neto",textAlign: TextAlign.center,style: TextStyle(
                        color:Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),),
                      Text("Total Canastas",textAlign: TextAlign.center,
                        style: TextStyle(
                        color:Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                        ),
                      ),
                    ]
                  ),
                  TableRow(
                    children: [
                      Text('Sin info',textAlign: TextAlign.center,
                        style: TextStyle(
                          color:Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      Text('Sin info',textAlign: TextAlign.center,
                        style: TextStyle(
                          color:Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ]
                  ),
                ],
              ),
            ),
        ),
      ],
    );
  }

  Widget  dataTable(ini,fin,cod_hda) {
    return FutureBuilder <List<EntradaCanaGeneral>>(
      future:listar_entrada(ini,fin,cod_hda),
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
                    columns: [
                      DataColumn(
                        label: Expanded(child:Text("Suerte",textAlign: TextAlign.center,style:textStyle)),
                        numeric: false,
                        tooltip: "Clic en cada una de las Suertes para ver el Detalle",
                      ),
                      DataColumn(
                        label: Expanded(child:Text("Peso Neto",textAlign: TextAlign.center,style:textStyle)),
                        numeric: false,
                        tooltip: "Peso Neto",
                      ),
                      DataColumn(
                        label: Expanded(child:Text("#Canastas",textAlign: TextAlign.center,style:textStyle)),
                        numeric: false,
                        tooltip: "Canasta",
                      ),
                    ],
                    rows: entradaGeneral.map(
                      (entradaG) => DataRow(
                        cells: [
                          DataCell(
                            Center(child:Text(entradaG.suerte,style: TextStyle(
                              color: Color.fromRGBO(56, 124, 43, 1.0),
                              fontWeight: FontWeight.bold,)),),
                            onTap: () {
                              setState(() {
                                suerte=entradaG.suerte.toString();
                                tablaDetalle=true;
                              });
                              
                              //  Navigator.of(context).push(
                              // MaterialPageRoute(builder: (context) => DetalleEntrada(data:widget.data,ini:ini,fin:fin,cod_hda:cod_hda,suerte:suerte,)));
                            },
                          ),
                          DataCell(
                            Center(child:Text(entradaG.peso_neto),),
                          ),
                          DataCell(
                            Center(child:Text(entradaG.ncanasta),),
                          ),
                        ]
                      ),
                    )
                    .toList(),
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

  Widget tablaVacia() {
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
            horizontalMargin:15,
            columnSpacing:15,
            columns: [
              DataColumn(
                  label: Text("Suerte",style:textStyle),
                  numeric: false,
                  tooltip: "Suerte",
                  ),
              DataColumn(
                label: Text("Peso Neto",style:textStyle),
                numeric: false,
                tooltip: "Peso Neto",
              ),
              DataColumn(
                label: Text("Canasta",style:textStyle),
                numeric: false,
                tooltip: "Canasta",
              ),
            ],
            rows: entradaGeneral.map(
              (entradaG) => DataRow(
                cells: [
                    DataCell(
                    Text('Sin info'),
                  ),
                  DataCell(
                    Text('disponible'),
                  ),
                  DataCell(
                    Text('para esta consulta'),
                  ),
                ]
              ),
            )
            .toList(),
          ),
        ),
    );
  }

  Widget tablaVaciaDetalle() {
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
            rows: entradaDetalleVacio.map(
              (entradaG) => DataRow(
                cells: [
                  DataCell(
                    Center(child:Text("Sin Información"),
                  ),),
                  DataCell(
                    Center(child:Text("Sin Información"),),
                  ),
                  DataCell(
                    Center(child:Text("Sin Información"),),
                  ),
                  DataCell(
                    verGuia?Center(child:Text("Sin Información"),):Container(),
                  ),
                  DataCell(
                    verVehiculo?Center(child:Text("Sin Información"),):Container(),
                  ),
                  DataCell(
                    verCanasta?Center(child:Text("Sin Información"),):Container(),
                  ),
                  DataCell(
                    Center(child:Text("Sin Información"),),
                  ),
                ]
              ),
            ).toList(),
          ),
        ),
    );
  }

  Widget  dataTableDetalle(ini,fin,cod_hda,suerte) {
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

