import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:js' as js;
import 'dart:html' as html;
import 'package:progress_dialog/progress_dialog.dart';

import 'package:proveedores_manuelita/logica/AdministrarDocumentos.dart';
import 'package:proveedores_manuelita/logica/EntradasCana.dart';
import 'package:proveedores_manuelita/modelos/AjusteMercExceden.dart';
import 'package:proveedores_manuelita/utiles/Flecha.dart';
import 'package:proveedores_manuelita/vistas/encabezado/Encabezado.dart';
import 'package:proveedores_manuelita/logica/Liquidaciones.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/modelos/EntradaCana.dart';
import 'package:proveedores_manuelita/modelos/Liquidacion.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/utiles/OcultarColumnas.dart';
import 'package:proveedores_manuelita/vistas/liquidaciones/AjusteMercado.dart';
import 'package:proveedores_manuelita/utiles/Globals.dart';
import 'package:proveedores_manuelita/vistas/menu.dart';
import 'package:proveedores_manuelita/vistas/verPdf/PdfViewPage.dart';


class VerLiquidaciones extends StatefulWidget {
  final Data data;
  final String tipo;
  
  VerLiquidaciones ({Key key,this.data,this.tipo}) : super();

  @override
  _VerLiquidacionesState createState() => _VerLiquidacionesState();
}

class _VerLiquidacionesState extends State<VerLiquidaciones> {
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  var validarFecha='Por favor ingresar la Fecha Inicial y la Fecha Final para realizar la consulta de información';
  var info='No se encontraron resultados para esta consulta';
  var error="La Fecha Inicial debe ser inferior o igual a la Fecha Final";
  var opcion='Por favor seleccionar un tipo de Liquidación';
  bool sort;
  bool borrar = false;
  bool cambiar,tabla,detalle,mensaje,anticipo,liquidacion,mercado,ocultar,botonCana;
  bool bonificacionTotal,toneladasBrutas,hacienda,haciendaCana,mostrarHaciendaCana,mostrarbonificacionTotal,mostrartoneladasBrutas,mostrarhacienda;
  int contadorEntradaCana,contadorConsultas,contadorInfoProduccion,contadorLiqCana;
  String selectedRegion;
  List <EntradaCana>_entrada=[];
  List<EntradaCana> _region = [];
  List <EntradaCana>entrada=[];
  List <Liquidacion>entradaGeneral=[];
  List <Liquidacion>entradaGeneralVacio=[];
  List <Ajuste>entradaAjuste=[];
  List <Ajuste>entradaAnticipo=[];
  List <EntradaCana>pasoParametro=[];
  List<String> mostrarNotificacion=[];
  List<String> objetos=[];
  ProgressDialog ms;
  String _url='https://proveedores-cana.manuelita.com/';
  String urlPDFPath = "";
  String dropdownValue,dropdownAgnoInicial,dropdownAgnoFinal,newValueLiq,valorLiquidacion,haciendaUnica;
  var now = new DateTime.now();
  Map total;
  int contador,contadorLiq;
  var parametro,codParametro,codRespeuesta,inicial,fin,fecha_i,fecha_f;
  final format = DateFormat("dd/MM/yyyy");

 @override
  void initState() {
    sort = false;
    tabla = true;
    detalle = true;
    cambiar = true;
    anticipo= false;
    liquidacion= false;
    mercado= false;
    bonificacionTotal=false;
    toneladasBrutas=false;
    hacienda=false;
    mostrarbonificacionTotal=false;
    mostrartoneladasBrutas=false;
    mostrarhacienda=false;
    haciendaCana=false;
    mostrarHaciendaCana=false;
    botonCana=false;
    contador=0;
    contadorLiq=0;
    newValueLiq='';
    valorLiquidacion='';
    dropdownValue =widget.tipo==null?'Seleccione una Liquidación':widget.tipo;
    contadorGeneral=0;
    guardaContador=0;
    contadorEntradaCana=entradaCana.length;
    contadorConsultas=consultas.length;
    contadorInfoProduccion=infoProduccion.length;
    contadorLiqCana=liqCana.length;
    widget.data;
    if(widget.tipo=='Liquidación Caña')
    { 
      setState(() {
        anticipo= false;
        liquidacion= true;
        botonCana=true;
        contador=0;
      });
    }

    if(widget.tipo=='Anticipos')
    {
      setState(() {
        anticipo= true;
        liquidacion= false;
        contador=0;
      });
    }
    widget.data;
    _endTimeController;
    _endTimeController;
    super.initState();
  }
   List <MultiSelectDialogItem<int>> multiItem = List();

  final valuestopopulate = {
    0 : "Seleccione Las Columnas A Visualizar",
    1 : "Hacienda",
    2 : "Toneladas Brutas",
    3 : "Bonificación Total",
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
      bonificacionTotal=false;
      toneladasBrutas=false;
      hacienda=false;
      for(int x in selection.toList()){
        print(valuestopopulate[x]);
        if(valuestopopulate[x]=='Hacienda')
        { setState(() {
            hacienda=true;
          });
        }
        if(valuestopopulate[x]=='Toneladas Brutas')
        { 
          setState(() {
            toneladasBrutas=true;
          });
        }
        if(valuestopopulate[x]=='Bonificación Total')
        { 
          setState(() {
            bonificacionTotal=true;
          });
        }
      }
      if(hacienda==true)
      {
        setState(() {
          mostrarhacienda=true;
          x.add(1);
        });
      }else
      {
        setState(() {
          x.remove(1);
          mostrarhacienda=false;
        });
      }
      if(toneladasBrutas==true)
      {
        setState(() {
          x.add(2);
          mostrartoneladasBrutas=true;
        });
      }else
      {
        setState(() {
          x.remove(2);
          mostrartoneladasBrutas=false;
        });
      }
      if(bonificacionTotal==true)
      {
        setState(() {
          x.add(3);
          mostrarbonificacionTotal=true;
        });
      }else
      {
        setState(() {
          x.remove(3);
          mostrarbonificacionTotal=false;
        });
      }
    }else{
      setState(() {
        x.remove(3);
        x.remove(2);
        x.remove(1);
        bonificacionTotal=false;
        toneladasBrutas=false;
        hacienda=false;
      });
    }
  }

  List <MultiSelectDialogItem<int>> multiItemAnticipo = List();

  final valuestopopulateAnticipo = {
    0 : "Seleccione Las Columnas A Visualizar",
    1 : "Hacienda",
  };

  void populateMultiselectAnticipo(){
    for(int v in valuestopopulateAnticipo.keys){
      multiItemAnticipo.add(MultiSelectDialogItem(v, valuestopopulateAnticipo[v]));
    }
  }
  var xCana=[0].toSet();
  void _showMultiSelectAnticipo(BuildContext context) async {
    multiItemAnticipo = [];
    populateMultiselectAnticipo();
    final items = multiItemAnticipo;
    final selectedValuesAnticipos = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues:xCana,
        );
      },
    );

    print(selectedValuesAnticipos);
    getvaluefromkeyAnticipo(selectedValuesAnticipos);
  }
  
  void getvaluefromkeyAnticipo(Set selection){
    if(selection.isNotEmpty){
      haciendaCana=false;
      for(int x in selection.toList()){
        print(valuestopopulateAnticipo[x]);
        if(valuestopopulateAnticipo[x]=='Hacienda')
        { setState(() {
            haciendaCana=true;
          });
        }
      }
      if(haciendaCana==true)
      {
        setState(() {
          mostrarHaciendaCana=true;
          xCana.add(1);
        });
      }else
      {
        setState(() {
          xCana.remove(1);
          mostrarHaciendaCana=false;
        });
      }
    }else{
      setState(() {
        xCana.remove(1);
        haciendaCana=false;
      });
    }
  }
sinRespuesta(){
  Timer(Duration(seconds:5), () {
    return warningDialog(
      context, 
      "Sin conexión al servidor",
      negativeAction: (){
    },
  );
  });
}
Future <List<EntradaCana>> listar_haciendas()async{
  var session= Conexion();
  session.set_token(widget.data.token);
  var resultado= EntradasCana(session);
  var token=widget.data.token;
  if(entrada.length > 0)
  {
    return entrada;
  }else{
    await resultado.listar_haciendas(false).then((_){
    var preUsuarios=resultado.obtener_haciendas();
    for ( var resul in preUsuarios)
    {
      entrada.add(resul);
    }        
    });
    if(entrada.length==1)
    { 
      setState(() {
        haciendaUnica=entrada[0].cod_hda+" - "+entrada[0].nm_hda;
      });
    }
    // if(entrada.length > 0)
    // {
      return entrada;
    //}
    // else{
    //   contador++;
    //   if(contador==1)
    //   {
    //     warningDialog(
    //     context, 
    //     info,
    //     negativeAction: (){
    //     },
    //   );
    //   }
    // }
  }
}

obtener_ruta(id) async{
  if(id==''||id==null)
  { 
   warningDialog(
    context, 
    'El registro no tiene documento',
    negativeAction: (){
    },
  );
  return;
  }
  var session= Conexion();
  session.set_token(widget.data.token);
  var verDocumentos= AdministrarDocumentos(session);
  var token=widget.data.token;
  var preEntrada;
  ms = new ProgressDialog(context);
  ms.style(message:'Se esta descargando el archivo');  
  await ms.show();
  await verDocumentos.obtener_ruta_documento(id).then((_){ 
     Map ruta=verDocumentos.establecer_ruta();  
     session.getFile(_url+ruta['ruta'].toString()).then((f){  
       ms.hide(); 
       js.context.callMethod ('webSaveAs', <dynamic> [html.Blob (<List <int>> [f]), 'archivo.pdf']);    
    });    
  });
}

 mostrar(){
  if(mercado==true)
  { 
    return tablaVacia();
  }
  if(tabla==true)
  {
    return tablaVacia();
  }
  if(liquidacion==true)
  {
    return dataTable(_startTimeController.text,_endTimeController.text,codParametro);
  }
  if(anticipo==true)
  {
    return dataTableAnticipo(_startTimeController.text,_endTimeController.text,codParametro);
  }
}

Future <List<Liquidacion>> listar_liquidacion(ini,fin,cod_hda)async{
  var session= Conexion();
  session.set_token(widget.data.token);
  var liquidaciones= Liquidaciones(session);
  var token=widget.data.token;
  var preEntrada;
  await liquidaciones.listar_liquidacion(ini,fin,cod_hda).then((_){
  entradaGeneral=[];
  preEntrada=liquidaciones.obtener_liquidaciones();
    for ( var tabla_informe in preEntrada)
    {
      entradaGeneral.add(tabla_informe );
    }   
    preEntrada=[]; 
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
        liquidacion = false;
        mercado = false;
        anticipo = false;
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
}

Future <List<Ajuste>> listar_anticipos(ini,fin,cod_hda)async{
  var session= Conexion();
  session.set_token(widget.data.token);
  var liquidaciones= Liquidaciones(session);
  var token=widget.data.token;
  var preEntrada;
  await liquidaciones.listar_anticipos(ini,fin,cod_hda).then((_){
    entradaAnticipo=[];
    preEntrada=liquidaciones.obtener_anticipos();
    for ( var tabla_informe in preEntrada)
    {
      entradaAnticipo.add(tabla_informe );
    }   
    preEntrada=[]; 
  });
  preEntrada=[]; 
  if(entradaAnticipo.length > 0)
  {
    return entradaAnticipo;
  }
  else{
    contador++;
    setState(() {
      tabla = true;
      liquidacion = false;
      mercado = false;
      anticipo = false;
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
}

  @override
  Widget build(BuildContext context) {
    var menu = new Menu(data:widget.data,retorno:'info');
    var encabezado= new Encabezado(data:widget.data,titulo:'Liquidaciones',);
    return WillPopScope(
      onWillPop: () {  },
      child:SafeArea(
        child:Scaffold(
        appBar: new AppBar(
        flexibleSpace:encabezado,
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
  Widget lista(){
    var token=widget.data.token;
    return Container(
      width: 250,
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.fromLTRB(20, 5, 20,10),
      decoration: BoxDecoration(
      border: Border(bottom:BorderSide(width: 1,
        color: Color.fromRGBO(83, 86, 90, 1.0),
      ),
      ),
      // borderRadius: BorderRadius.circular(10), 
      //color: Color.fromRGBO(83, 86, 90, 1.0),
      ),
      child:
      DropdownButtonHideUnderline(
      child:DropdownButton<String>(
        hint: Padding(
          padding: const EdgeInsets.fromLTRB(10, 1, 10,5),
          child: Center(
            child:Text('Seleccione una Liquidación', textAlign: TextAlign.center,style: TextStyle(
              fontSize: 15.0,
              fontFamily: 'Karla',
            ),
            ),
          ),
        ),
        value: dropdownValue,
        //icon: Icon(Icons.arrow_circle_down_rounded),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.black,fontSize: 15),
        underline: Container(
          height: 2,
          color: Colors.green,
        ),
        onChanged: (newValueLiq) {
          if(newValueLiq!='Ajuste de Mercado Excedentario')
          {   
            if(_endTimeController.text!=''&& _startTimeController.text!="")
            {  
              var fechaicambio=_startTimeController.text.split('/');
              var fechafcambio=_endTimeController.text.split('/');
              var ini=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0]+' 00:00:00';
              var fin=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0]+' 23:59:00';
              DateTime parseInicial = DateTime.parse(ini);
              DateTime parseFinal = DateTime.parse(fin);
              String nfechaI=DateFormat('yyyy-mm-dd').format(parseInicial);
              String nfechaF=DateFormat('yyyy-mm-dd').format(parseFinal);
              DateTime startDate = DateTime.parse(nfechaI);
              DateTime endDate = DateTime.parse(nfechaF);
              if(startDate.isBefore(endDate) || _startTimeController.text==_endTimeController.text)
              {
                if(newValueLiq=='Liquidación Caña')
                { 
                  setState(() {
                    anticipo= false;
                    liquidacion= true;
                    tabla=false;
                    botonCana=true;
                    contador=0;
                  });
                }
                if(newValueLiq=='Anticipos')
                {
                  setState(() {
                    anticipo= true;
                    liquidacion= false;
                    tabla=false;
                    botonCana=false;
                    contador=0;
                  });
                }
                setState(() {
                  dropdownValue = newValueLiq;
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
          }else
          {
            setState(() {
              tabla=true;
            }); 
            WidgetsBinding.instance.addPostFrameCallback((_) { 
              Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => VerMercado (data:widget.data),)); });
          }
        },
        items: <String>['Seleccione una Liquidación','Anticipos', 'Liquidación Caña', 'Ajuste de Mercado Excedentario']
        .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child:Padding(
            padding: const EdgeInsets.fromLTRB(0, 5,20,10),
            child:new Text(value,textAlign: TextAlign.center,
              style: new TextStyle(color: Colors.black)
            ),
            ),
          );
        }).toList(),
    ),),
    );
  }

  Widget  dataBody() {
    return FutureBuilder<List<EntradaCana>>(
    future:listar_haciendas(),
    builder:(context,snapshot){
      if(snapshot.hasData){
        _entrada = (entrada).toList();
        cambiar?codParametro='':codParametro=codRespeuesta;
        return 
          Column(
            children:<Widget>[
              SizedBox(height:30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Container(
                    width:290,
                    padding: EdgeInsets.fromLTRB(0, 0,20, 10),
                    child:Center(
                      child: DateTimeField(
                      controller: _startTimeController,
                      onChanged: (text) {
                      if(_endTimeController.text!='')
                      {
                        var fechaicambio=_startTimeController.text.split('/');
                        var fechafcambio=_endTimeController.text.split('/');
                        var ini=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0]+' 00:00:00';
                        var fin=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0]+' 23:59:00';
                        DateTime parseInicial = DateTime.parse(ini);
                        DateTime parseFinal = DateTime.parse(fin);
                        String nfechaI=DateFormat('yyyy-mm-dd').format(parseInicial);
                        String nfechaF=DateFormat('yyyy-mm-dd').format(parseFinal);
                        DateTime startDate = DateTime.parse(nfechaI);
                        DateTime endDate = DateTime.parse(nfechaF);
                        if(startDate.isBefore(endDate) || _startTimeController.text==_endTimeController.text)
                        {
                          if(dropdownValue != 'Seleccione una Liquidación')
                          {
                            if(dropdownValue=='Liquidación Caña')
                              { 
                                setState(() {
                                  anticipo= false;
                                  liquidacion= true;
                                  tabla=false;
                                  contador=0;
                                });
                              }
                            if(dropdownValue=='Anticipos')
                            {
                              setState(() {
                                anticipo= true;
                                liquidacion= false;
                                tabla=false;
                                contador=0;
                              });
                            }
                          }else{
                            infoDialog(
                              context, 
                              opcion,
                              negativeAction: (){
                              },
                            );
                            setState(() {
                              tabla = true;
                            });
                          }
                        }else{
                          _startTimeController.text='';
                          setState(() {
                            tabla = true;
                            });
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
                          labelText: 'Fecha Inicial',
                      ),
                    ),
                    ),
                  ),
                  Container(
                  width:290,
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child:DateTimeField(
                    controller:_endTimeController,
                    onChanged: (text) {
                      if(_startTimeController.text!="")
                      { 
                      var fechaicambio=_startTimeController.text.split('/');
                      var fechafcambio=_endTimeController.text.split('/');
                      var ini=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0]+' 00:00:00';
                      var fin=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0]+' 23:59:00';
                      DateTime parseInicial = DateTime.parse(ini);
                      DateTime parseFinal = DateTime.parse(fin);
                      String nfechaI=DateFormat('yyyy-mm-dd').format(parseInicial);
                      String nfechaF=DateFormat('yyyy-mm-dd').format(parseFinal);
                      DateTime startDate = DateTime.parse(nfechaI);
                      DateTime endDate = DateTime.parse(nfechaF);
                      if(startDate.isBefore(endDate) || _startTimeController.text==_endTimeController.text)
                      {
                        if(dropdownValue != 'Seleccione una Liquidación')
                        {
                          if(dropdownValue=='Liquidación Caña')
                              { 
                                setState(() {
                                  anticipo= false;
                                  liquidacion= true;
                                  tabla=false;
                                  contador=0;
                                });
                              }

                          if(dropdownValue=='Anticipos')
                          {
                            setState(() {
                              anticipo= true;
                              liquidacion= false;
                              tabla=false;
                              contador=0;
                            });
                          }
                        }else{
                          infoDialog(
                              context, 
                              opcion,
                              negativeAction: (){
                              },
                            );
                          setState(() {
                            tabla = true;
                          });
                        }
                      }else{
                        setState(() {
                        tabla = true;
                        });
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
                      enabledBorder: UnderlineInputBorder(      
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
                  //SizedBox(height:8),
                  lista(),
                  //SizedBox(height:8),
                  Container(
                  width: 230,
                  height: 40,
                  //padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  margin: const EdgeInsets.fromLTRB(20, 10, 0,10),
                    decoration: BoxDecoration(
                    border: Border(bottom:BorderSide(width: 1,
                      color: Color.fromRGBO(83, 86, 90, 1.0),),),
                        // borderRadius: BorderRadius.circular(10), 
                        //color: Color.fromRGBO(83, 86, 90, 1.0)
                    ),
                    child: DropdownButtonHideUnderline(
                      child: new DropdownButton<String>(
                        hint: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Center(
                          child:Text(haciendaUnica!=null?haciendaUnica:'Seleccione una Hacienda', textAlign: TextAlign.left,style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontFamily: 'Karla',
                          ),),),),
                          value:selectedRegion,
                          style: TextStyle(color: Colors.black,fontSize: 15),
                          isDense: true,
                          onChanged: (String newValue) {
                          if(_endTimeController.text!=''&& _startTimeController.text!="")
                          {  
                            var fechaicambio=_startTimeController.text.split('/');
                            var fechafcambio=_endTimeController.text.split('/');
                            var ini=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0]+' 00:00:00';
                            var fin=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0]+' 23:59:00';
                            DateTime parseInicial = DateTime.parse(ini);
                            DateTime parseFinal = DateTime.parse(fin);
                            String nfechaI=DateFormat('yyyy-mm-dd').format(parseInicial);
                            String nfechaF=DateFormat('yyyy-mm-dd').format(parseFinal);
                            DateTime startDate = DateTime.parse(nfechaI);
                            DateTime endDate = DateTime.parse(nfechaF);
                            if(startDate.isBefore(endDate) || _startTimeController.text==_endTimeController.text)
                            {
                              setState(() {
                                parametro=entrada.where((a) => a.nm_hda==newValue);
                                codRespeuesta=parametros(parametro);
                                cambiar = false;
                                detalle = true;
                                if(dropdownValue=='Liquidación Caña')
                                { 
                                  setState(() {
                                    anticipo= false;
                                    liquidacion= true;
                                    mercado= false;
                                    tabla=false;
                                    contador=0;
                                  });
                                }
                                if(dropdownValue=='Anticipos')
                                {
                                  setState(() {
                                    anticipo= true;
                                    liquidacion= false;
                                    mercado= false;
                                    tabla=false;
                                    contador=0;
                                  });
                                }
                                  selectedRegion = newValue;
                              });
                            }else{
                              setState(() {
                                tabla = true;
                              });
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
                              child:Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 18,2),
                                child:new Text(map.cod_hda+' - '+map.nm_hda,textAlign: TextAlign.left,
                                  style: new TextStyle(color: Colors.black)
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                    ),
                  ),
                  //SizedBox(height:2),
                  //SizedBox(height:8),
              ]
              ),
              SizedBox(height:40),
              // Container(
              //   padding:const EdgeInsets.fromLTRB(400, 5, 0,5),
              //   alignment: Alignment.bottomLeft,
              //     child:Row(
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
              SizedBox(height:15),
              Expanded(child:mostrar(),),
                //listaAgnoInicial(),
            ],
          );
      }else if (snapshot.hasError) {
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
        );
      }
    },
  );
  }

  Widget  dataTable(ini,fin,cod_hda) {
    return FutureBuilder <List<Liquidacion>>(
      future:listar_liquidacion(ini,fin,cod_hda),
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
                          label:Expanded(child: Text("Fecha Liquidación",textAlign: TextAlign.center,style:textStyle)),
                          numeric: false,
                          tooltip: "Fecha Liquidación",
                      ),
                      DataColumn(
                          label: mostrarhacienda?Expanded(child:Text("Hacienda",textAlign: TextAlign.center,style:textStyle)):Container(),
                          numeric: false,
                          tooltip: "Hacienda",
                      ),
                      DataColumn(
                        label: mostrartoneladasBrutas?Expanded(child:Text("Toneladas Brutas",textAlign: TextAlign.center,style:textStyle)):Container(),
                        numeric: false,
                        tooltip: "Toneladas Brutas",
                      ),
                      DataColumn(
                        label: Expanded(child: Text("Toneladas Netas",textAlign: TextAlign.center,style:textStyle)),
                        numeric: false,
                        tooltip: "Toneladas Netas",
                      ),
                      DataColumn(
                        label: Expanded(child:Text("Rendimiento Promedio",textAlign: TextAlign.center,style:textStyle),),
                        numeric: false,
                        tooltip: "Rendimiento Promedio",
                      ),
                      DataColumn(
                        label: mostrarbonificacionTotal?Expanded(child:Text("Bonificación Total",textAlign: TextAlign.center,style:textStyle)):Container(),
                        numeric: false,
                        tooltip: "Bonificación Total",
                      ),
                      DataColumn(
                          label: Expanded(child:Text("Valor Bruto",textAlign: TextAlign.center,style:textStyle),),
                          numeric: false,
                          tooltip: "Valor Bruto",
                          ),
                      DataColumn(
                        label: Expanded(child:Text("Valor Neto",textAlign: TextAlign.center,style:textStyle),),
                        numeric: false,
                        tooltip: "Valor Neto",
                      ),
                      DataColumn(
                        label: Expanded(child:Text("Detalle Liquidación",textAlign: TextAlign.center,style:textStyle)),
                        numeric: false,
                        tooltip: "Detalle Liquidación",
                      ),
                    ],
                    rows: entradaGeneral.map(
                      (entradaG) => DataRow(
                        cells: [
                          DataCell(
                            Center(child:Text(entradaG.fecha,textAlign: TextAlign.center,),),
                          ),
                          DataCell(
                            mostrarhacienda?Center(child:Text(entradaG.predio,textAlign: TextAlign.center,),):Container(),
                          ),
                          DataCell(
                            mostrartoneladasBrutas?Center(child:Text(entradaG.ton_bruta,textAlign: TextAlign.center,),):Container(),
                          ),
                          DataCell(
                            Center(child:Text(entradaG.ton_cana,textAlign: TextAlign.center,),),
                          ),
                          DataCell(
                            Center(child:Text(entradaG.rto_real_ing,textAlign: TextAlign.center,),),
                          ),
                          DataCell(
                            mostrarbonificacionTotal?Center(child:Text(entradaG.rend_bonif,textAlign: TextAlign.center,),):Container(),
                          ),
                          DataCell(
                            Center(child:Text(entradaG.valor_total,textAlign: TextAlign.center,),),
                          ),
                          DataCell(
                            Center(child:Text(entradaG.valor_desc,textAlign: TextAlign.center,),),
                          ),
                          
                          DataCell(
                            entradaG.id==''?Center(child:Container(child: IconButton(icon: Icon(
                              Icons.error,
                              size:30,
                              color: Color.fromRGBO(176, 188, 34, 1.0),
                            ),),),):Center(child:Container(child: IconButton(icon: Icon(
                              Icons.picture_as_pdf,
                              size:30,
                              color: Color.fromRGBO(56, 124, 43, 1.0),
                            ),),),),
                            onTap: () {
                                obtener_ruta(entradaG.id);
                            },
                          ),
                        ]
                      ),
                    ).toList(),
                  ),
                ),
            );
        }else if (snapshot.hasError) {
          return  Column(
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
          );
        }
      },
    );
  }

  Widget  dataTableAnticipo(ini,fin,cod_hda) {
     return FutureBuilder <List<Ajuste>>(
      future:listar_anticipos(ini,fin,cod_hda),
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
                          label: Expanded(child:Text("Fecha Liquidación",textAlign: TextAlign.center,style:textStyle)),
                          numeric: false,
                          tooltip: "Fecha Liquidación",
                        ),
                        DataColumn(
                          label: mostrarHaciendaCana?Expanded(child:Text("Hacienda",textAlign: TextAlign.center,style:textStyle)):Container(),
                          numeric: false,
                          tooltip: "Hacienda",
                        ),
                        DataColumn(
                          label:Expanded(child:Text("Valor",textAlign: TextAlign.center,style:textStyle)),
                          numeric: false,
                          tooltip: "Valor",
                        ),
                        DataColumn(
                          label: Expanded(child:Text("Detalle Liquidación",textAlign: TextAlign.center,style:textStyle)),
                          numeric: false,
                          tooltip: "Detalle Liquidación",
                        ),
                      ],
                      rows: entradaAnticipo
                      .map(
                        (entradaG) => DataRow(
                          cells: [
                            DataCell(
                              Center(child:Text(entradaG.fecha,textAlign: TextAlign.center,),),
                            ),
                            DataCell(
                              mostrarHaciendaCana?Center(child:Text(entradaG.predio,textAlign: TextAlign.center,),):Container(),
                            ),
                            DataCell(
                              Center(child:Text(entradaG.valor,textAlign: TextAlign.center,),),
                            ),
                            DataCell(
                              entradaG.id==''?Center(child:Container(child: IconButton(icon: Icon(
                                Icons.error,
                                size:30,
                                color: Color.fromRGBO(176, 188, 34, 1.0),
                              ),),),):Center(child:Container(child: IconButton(icon: Icon(
                                Icons.picture_as_pdf,
                                size:30,
                                color: Color.fromRGBO(56, 124, 43, 1.0),
                              ),),),),
                              //Text(entradaG.id),
                              onTap: () {
                                  obtener_ruta(entradaG.id);
                              },
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
          horizontalMargin:10,
          columnSpacing:10,
            columns: [
              DataColumn(
                label: Text("Fecha Liquidación",style:textStyle),
                numeric: false,
                tooltip: "Fecha Liquidación",
              ),
              DataColumn(
                label: Text("Valor",style:textStyle),
                numeric: false,
                tooltip: "Valor",
              ),
              DataColumn(
                label: Text("Detalle Liquidación",style:textStyle),
                numeric: false,
                tooltip: "Detalle Liquidación",
              ),
            ],
            rows: entradaGeneralVacio
            .map(
              (entradaG) => DataRow(
                cells: [
                  DataCell(
                    Text("",textAlign: TextAlign.center),
                  ),
                  DataCell(
                    Text("",textAlign: TextAlign.center,style:textStyle),
                  ),
                  DataCell(
                    Text("",textAlign: TextAlign.center,style:textStyle),
                  ), 
                                     
                ]
              ),
            ).toList(),
        ),
      ),
    );
  }
}

