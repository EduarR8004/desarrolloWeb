import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:async';

import 'package:proveedores_manuelita/logica/EntradasCana.dart';
import 'package:proveedores_manuelita/logica/InformesProduccion.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/modelos/EntradaCana.dart';
import 'package:proveedores_manuelita/modelos/InfoProduccion.dart';
import 'package:proveedores_manuelita/utiles/Flecha.dart';
import 'package:proveedores_manuelita/vistas/encabezado/Encabezado.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/utiles/OcultarColumnas.dart';
import 'package:proveedores_manuelita/vistas/menu.dart';


class InfoProduccion extends StatefulWidget {
  final Data data;
  
  InfoProduccion ({Key key,this.data}) : super();

  @override
  _InfoProduccionState createState() => _InfoProduccionState();
}

class _InfoProduccionState extends State<InfoProduccion> {
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  var validarFecha='Por favor ingresar la Fecha Inicial y la Fecha Final para realizar la consulta de información';
  var info='No se encontraron resultados para esta consulta';
  var error="La Fecha Inicial debe ser inferior o igual a la Fecha Final";
  bool sort;
  bool borrar = false;
  bool cambiar,tabla,detalle,mensaje,hacienda,noCortes,area,saldoArea,mostrarHacienda,mostrarArea,mostrarSaldoArea,mostrarnoCortes;
  bool variedad,edad,toneladas,tchm,sac,mostrarSac,mostrarVariedad,mostrarEdad,mostrarToneladas,mostrarTchm;
  String selectedRegion,haciendaUnica;
  int contadorEntradaCana,contadorConsultas,contadorInfoProduccion,contadorLiqCana;
  List<String> mostrarNotificacion=[];
  List <EntradaCana>_entrada=[];
  List<EntradaCana> _region = [];
  List <EntradaCana>entrada=[];
  List <InformeProduccion>entradaGeneral=[];
  List <EntradaCana>pasoParametro=[];
  List<String> objetos=[];
  int contador=0;
  ProgressDialog ms;
  DateTime now = DateTime.now();
  final format = DateFormat("dd/MM/yyyy");
  var formatter =  DateFormat("yyyy");
  Map total;
  var parametro;
  var codParametro;
  var codRespeuesta;
  var inicial;
  var fin;
  var fecha_i;
  var fecha_f;

 @override
  void initState() {
    sort = false;
    tabla = false;
    detalle = true;
    cambiar = true;
    hacienda=false;
    noCortes=false;
    area=false;
    saldoArea=false;
    variedad=false;
    edad=false;
    toneladas=false;
    tchm=false;
    sac=false;
    mostrarSac=false;
    mostrarVariedad=false;
    mostrarEdad=false;
    mostrarToneladas=false;
    mostrarTchm=false;
    mostrarHacienda=false;
    mostrarArea=false;
    mostrarSaldoArea=false;
    mostrarnoCortes=false;
    widget.data;
    _endTimeController.text=DateFormat("dd/MM/yyyy").format(now).toString();
    String fomatoAgno = formatter.format(now);
    var primerAgno=int.parse(fomatoAgno);
    var agnoInicial=primerAgno-1;
    fomatoAgno="$agnoInicial";
    var fi = "01/01/"+fomatoAgno;
    _startTimeController.text=fi;
    widget.data;
    super.initState();
  }
  List <MultiSelectDialogItem<int>> multiItem = List();

  final valuestopopulate = {
    0 : "Seleccione Las Columnas A Visualizar",
    1 : "Hacienda",
    2 : "Área",
    3 : "Saldo Área",
    4:  "No.Cortes",
    5:  "Variedad",
    6:  "Edad",
    7:  "Toneladas",
    8:  "TCHM",
    9:  "% Sac",
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
      hacienda=false;
      noCortes=false;
      area=false;
      saldoArea=false;
      variedad=false;
      edad=false;
      toneladas=false;
      tchm=false;
      sac=false;
      for(int x in selection.toList()){
        print(valuestopopulate[x]);
        if(valuestopopulate[x]=='Hacienda')
        { setState(() {
            hacienda=true;
          });
        }
        if(valuestopopulate[x]=='Área')
        { 
          setState(() {
            area=true;
          });
        }
        if(valuestopopulate[x]=='Saldo Área')
        { 
          setState(() {
            saldoArea=true;
          });
        }
        if(valuestopopulate[x]=='No.Cortes')
        { 
          setState(() {
            noCortes=true;
          });
        }
        if(valuestopopulate[x]=='Variedad')
        { 
          setState(() {
            variedad=true;
          });
        }
        if(valuestopopulate[x]=='Edad')
        { 
          setState(() {
            edad=true;
          });
        }
        if(valuestopopulate[x]=='Toneladas')
        { 
          setState(() {
            toneladas=true;
          });
        }
        if(valuestopopulate[x]=='TCHM')
        { 
          setState(() {
            tchm=true;
          });
        }
        if(valuestopopulate[x]=='% Sac')
        { 
          setState(() {
            sac=true;
          });
        }
      }
      if(hacienda==true)
      {
        setState(() {
          mostrarHacienda=true;
          x.add(1);
        });
      }else
      {
        setState(() {
          x.remove(1);
          mostrarHacienda=false;
        });
      }
      if(area==true)
      {
        setState(() {
          x.add(2);
          mostrarArea=true;
        });
      }else
      {
        setState(() {
          x.remove(2);
          mostrarArea=false;
        });
      }
      if(saldoArea==true)
      {
        setState(() {
          x.add(3);
          mostrarSaldoArea=true;
        });
      }else
      {
        setState(() {
          x.remove(3);
          mostrarArea=false;
        });
      }
      if(noCortes==true)
      {
        setState(() {
          x.add(4);
          mostrarnoCortes=true;
        });
      }else
      {
        setState(() {
          x.remove(4);
         mostrarnoCortes=false;
        });
      }
      if(variedad==true)
      {
        setState(() {
          x.add(5);
          mostrarVariedad=true;
        });
      }else
      {
        setState(() {
          x.remove(5);
          mostrarVariedad=false;
        });
      }
      if(edad==true)
      {
        setState(() {
          x.add(6);
          mostrarEdad=true;
        });
      }else
      {
        setState(() {
          x.remove(6);
          mostrarEdad=false;
        });
      }
      if(toneladas==true)
      {
        setState(() {
          x.add(7);
          mostrarToneladas=true;
        });
      }else
      {
        setState(() {
          x.remove(7);
          mostrarToneladas=false;
        });
      }
      if(tchm==true)
      {
        setState(() {
          x.add(8);
          mostrarTchm=true;
        });
      }else
      {
        setState(() {
          x.remove(8);
          mostrarTchm=false;
        });
      }
      if(sac==true)
      {
        setState(() {
          x.add(9);
          mostrarSac=true;
        });
      }else
      {
        setState(() {
          x.remove(9);
          mostrarSac=false;
        });
      }
    }else{
      setState(() {
        x.remove(9);
        x.remove(8);
        x.remove(7);
        x.remove(6);
        x.remove(5);
        x.remove(4);
        x.remove(3);
        x.remove(2);
        x.remove(1);
        hacienda=false;
        noCortes=false;
        area=false;
        saldoArea=false;
        variedad=false;
        edad=false;
        toneladas=false;
        tchm=false;
        sac=false;
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
    await usuario.listar_haciendas(false).then((_){
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
      });
    }
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
    }).toList();
     return codParametro;
}
Future <List<InformeProduccion>> listar_informe(ini,fin,cod_hda)async{
  var session= Conexion();
  session.set_token(widget.data.token);
  var informes= InformesProduccion(session);
  var token=widget.data.token;
  var preEntrada;
  await informes.listar_informes(ini,fin,cod_hda).then((_){
    entradaGeneral=[];
    preEntrada=informes.obtener_informes();
    for ( var tabla_informe in preEntrada)
    {
        entradaGeneral.add(tabla_informe );
    }   
    preEntrada=[]; 
    informes.limpiar_informes();    
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
             
}

  @override
  Widget build(BuildContext context) {
    var menu = new Menu(data:widget.data,retorno:'info');
    var encabezado= new Encabezado(data:widget.data,titulo:'Informe de Producción',);
    return WillPopScope(
    onWillPop: () {  },
    child:
    SafeArea(
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
      ),),
    );
  }
 

  Widget  dataBody() {
    return FutureBuilder<List<EntradaCana>>(
      future:listar_haciendas(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          _entrada = (entrada).toList();
          cambiar?codParametro=entrada[0].cod_hda:codParametro=codRespeuesta;
          return 
          Column(
            children:<Widget>[
              SizedBox(height:30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[         
                Container(
                width: 400,
                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: DateTimeField(
                    controller: _startTimeController,
                    onChanged: (text) {
                      if(_endTimeController.text!='')
                      {  
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
                  width: 400,
                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child:DateTimeField(
                    controller:_endTimeController,
                    onChanged: (text) { 
                    if(_startTimeController.text!="")
                    { 
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
                width: 300,
                height: 40,
                //padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                margin: const EdgeInsets.fromLTRB(38, 20, 38,10),
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
                        var ffinal=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0]+' 00:00:00';
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
              Container(
                padding:const EdgeInsets.fromLTRB(400, 5, 0,5),
                alignment: Alignment.bottomLeft,
                  child:Row(
                    children:[
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
                          _showMultiSelect(context);
                        },
                      ),
                    ],
                  )
              ),
              SizedBox(height:15),
              tabla?tablaVacia():Expanded(child:dataTable(_startTimeController.text,_endTimeController.text,codParametro)),      

            ],
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


  Widget  dataTable(ini,fin,cod_hda) {
    return FutureBuilder <List<InformeProduccion>>(
      future:listar_informe(ini,fin,cod_hda),
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
                        label: Expanded(child:Text("Fecha Corte",textAlign: TextAlign.center,style: textStyle),),
                        numeric: false,
                        tooltip: "Fecha Corte",
                      ),
                      DataColumn(
                          label: mostrarArea?Expanded(child:Text("Área",textAlign: TextAlign.center,style: textStyle),):Container(),
                          numeric: false,
                          tooltip: "Área",
                      ),
                      DataColumn(
                        label: Expanded(child:Text("Área Cosechada",textAlign: TextAlign.center,style: textStyle),),
                        numeric: false,
                        tooltip: "Área Cosecha",
                      ),
                      DataColumn(
                        label: mostrarSaldoArea?Expanded(child:Text("Saldo Área",textAlign: TextAlign.center,style: textStyle),):Container(),
                        numeric: false,
                        tooltip: "Saldo Área",
                      ),
                      DataColumn(
                          label: mostrarnoCortes?Expanded(child:Text("No.Cortes",textAlign: TextAlign.center,style: textStyle)):Container(),
                          numeric: false,
                          tooltip: "No.Cortes",
                      ),
                      DataColumn(
                        label: mostrarVariedad?Expanded(child:Text("Variedad",textAlign: TextAlign.center,style: textStyle),):Container(),
                        numeric: false,
                        tooltip: "Variedad",
                      ),
                      DataColumn(
                        label: mostrarEdad?Expanded(child:Text("Edad",textAlign: TextAlign.center,style: textStyle),):Container(),
                        numeric: false,
                        tooltip: "Edad",
                      ),
                      DataColumn(
                          label: mostrarToneladas?Expanded(child:Text("Toneladas",textAlign: TextAlign.center,style: textStyle),):Container(),
                          numeric: false,
                          tooltip: "Toneladas",
                      ),
                        DataColumn(
                        label: Expanded(child:Text("TCH",textAlign: TextAlign.center,style: textStyle),),
                        numeric: false,
                        tooltip: "TCH",
                      ),
                      DataColumn(
                        label: mostrarTchm?Expanded(child:Text("TCHM",textAlign: TextAlign.center,style: textStyle),):Container(),
                        numeric: false,
                        tooltip: "TCHM",
                      ),
                      DataColumn(
                          label: Expanded(child:Text("Rto",textAlign: TextAlign.center,style: textStyle),),
                          numeric: false,
                          tooltip: "Rto",
                          ),
                      DataColumn(
                        label: mostrarSac?Expanded(child:Text("%Sac",textAlign: TextAlign.center,style: textStyle),):Container(),
                        numeric: false,
                        tooltip: "%Sac",
                      ),
                      DataColumn(
                        label: Expanded(child:Text("Estado Corte",textAlign: TextAlign.center,style: textStyle),),
                        numeric: false,
                        tooltip: "Estado de Corte",
                      ),
                    ],
                    rows: entradaGeneral.map(
                      (entradaG) => DataRow(
                        cells: [
                          DataCell(
                            mostrarHacienda?Center(child:Text(entradaG.fazenda),):Container(),
                          ),
                          DataCell(
                            Center(child:Text(entradaG.suerte),),
                          ),
                          DataCell(
                            Center(child:Text(entradaG.fecha_ultco),),
                          ),
                          DataCell(
                            mostrarArea?Center(child:Text(entradaG.area_total),):Container(),
                          ),
                          DataCell(
                            Center(child:Text(entradaG.area_cosechada),),
                          ),
                          DataCell(
                            mostrarSaldoArea?Center(child:Text(entradaG.area_lib),):Container(),
                          ),
                          DataCell(
                            mostrarnoCortes?Center(child:Text(entradaG.ncortes),):Container(),
                          ),
                          DataCell(
                            mostrarVariedad?Center(child:Text(entradaG.variedad),):Container(),
                          ),
                          DataCell(
                            mostrarEdad?Center(child:Text(entradaG.edad),):Container(),
                          ),
                          DataCell(
                            mostrarToneladas?Center(child:Text(entradaG.tc),):Container(),
                          ),
                          DataCell(
                            Center(child:Text(entradaG.tch),),
                          ),
                          DataCell(
                            mostrarTchm?Center(child:Text(entradaG.tchm),):Container(),
                          ),
                          DataCell(
                            Center(child:Text(entradaG.rdto),),
                          ),
                          DataCell(
                            mostrarSac?Center(child:Text(entradaG.sacpc),):Container(),
                          ),
                          DataCell(
                            Center(child:Text(entradaG.cierre),),
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

  Widget tablaVacia() {
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
                          label: Expanded(child:Text("Suerte",textAlign: TextAlign.center),),
                          numeric: false,
                          tooltip: "Suerte",
                        ),
                        DataColumn(
                          label: Expanded(child:Text("Fecha Corte",textAlign: TextAlign.center),),
                          numeric: false,
                          tooltip: "Fecha Corte",
                        ),
                        DataColumn(
                          label: Expanded(child:Text("Área Cosechada",textAlign: TextAlign.center),),
                          numeric: false,
                          tooltip: "Área Cosecha",
                        ),
                       DataColumn(
                          label: Expanded(child:Text("TCH",textAlign: TextAlign.center),),
                          numeric: false,
                          tooltip: "TCH",
                        ),
                        DataColumn(
                            label: Expanded(child:Text("Rto",textAlign: TextAlign.center),),
                            numeric: false,
                            tooltip: "Rto",
                            ),
                        DataColumn(
                          label: Expanded(child:Text("Estado de Corte",textAlign: TextAlign.center),),
                          numeric: false,
                          tooltip: "Estado de Corte",
                        ),
                ],
                rows: entradaGeneral
                    .map(
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
                                DataCell(
                                  Text(''),
                                ),
                                DataCell(
                                  Text(''),
                                ),
                                DataCell(
                                  Text(''),
                                ),
                              ]),
                          )
                          .toList(),
                    ),
                  ),
              );
        
    
  }
}

