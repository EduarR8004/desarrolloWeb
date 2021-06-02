import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:js' as js;
import 'dart:html' as html;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:proveedores_manuelita/logica/AdministrarDocumentos.dart';
import 'package:proveedores_manuelita/logica/Consultas.dart';

import 'package:proveedores_manuelita/modelos/Consulta.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/modelos/EntradaCana.dart';
import 'package:proveedores_manuelita/modelos/EntradaCanaDetalle.dart';
import 'package:proveedores_manuelita/modelos/EntradaCanaGeneral.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/vistas/encabezado/Encabezado.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/vistas/menu.dart';
import 'package:proveedores_manuelita/vistas/verPdf/PdfViewPage.dart';


class VerConsultas extends StatefulWidget {
  final Data data;
  
  VerConsultas ({Key key,this.data}) : super();

  @override
  _VerConsultasState createState() => _VerConsultasState();
}

class _VerConsultasState extends State<VerConsultas> {
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  List <String> listaAgno=['2050'	,'2049'	,'2048'	,'2047'	,'2046'	,'2045'	,'2044'	,'2043'	,'2042'	,'2041'	,'2040'	,'2039'	,'2038'	,'2037'	,'2036'	,'2035'	,'2034'	,'2033'	,'2032'	,'2031'	,'2030'	,'2029'	,'2028'	,'2027'	,'2026'	,'2025'	,'2024'	,'2023'	,'2022'	,'2021'	,'2020'	,'2019'	,'2018'	,'2017'	,'2016'	,'2015'	,'2014'	,'2013'	,'2012'	,'2011'	,'2010'	,'2009'	,'2008'	,'2007'	,'2006'	,'2005'	,'2004'	,'2003'	,'2002'	,'2001'	,'2000'	,'1999'	,'1998'	,'1997'	,'1996'	,'1995'	,'1994'	,'1993'	,'1992'	,'1991'	,'1990'];
  bool borrar = false;
  bool cambiar,tabla,detalle,mensaje,sort,mercado;
  List <EntradaCana>_entrada=[];
  List<EntradaCana> _region = [];
  List <EntradaCana>entrada=[];
  List <Consulta>entradaGeneral=[];
  List <EntradaCanaGeneral>selectedEntrada=[];
  List <EntradaCana>pasoParametro=[];
  List <EntradaCanaDetalle>entradaDetalle=[];
  List<String> mostrarNotificacion=[];
  List<String> objetos=[];
  var now = new DateTime.now();
  int fecha_inicial,fecha_final; 
  String selectedRegion,tipo,fi,ff,fomatoAgno,dropdownValue,newValueDoc,formatoAgnoAnterior,dropdownAgnoInicial,dropdownAgnoFinal;
  String urlPDFPath = "";
  String _url='https://proveedores-cana.manuelita.com/';
  ProgressDialog ms;
  Map total;
  int contador=0;
  int marcaFinal,agnoAnterior,marcaInicial;

  var validarFecha='Por favor ingresar la Fecha Inicial y la Fecha Final para realizar la consulta de información';
  var info='No se encontraron resultados para esta consulta';
  var error="La Fecha Inicial debe ser inferior o igual a la Fecha Final";
  var opcion='Por favor seleccionar un tipo de Documento';
  var parametro;
  var codParametro,codRespeuesta,inicial,fin,fecha_i,fecha_f;
  final format = DateFormat("dd/MM/yyyy");
 @override
  void initState() {
    sort = false;
    tabla = false;
    detalle = true;
    cambiar = false;
    mercado= true;
    widget.data;
    selectedEntrada = [];
    _endTimeController;
    _endTimeController;
    widget.data;
    var formatter =  DateFormat("yyyy");
    fomatoAgno = formatter.format(now);
    agnoAnterior= int.parse(fomatoAgno)-1;
    formatoAgnoAnterior=agnoAnterior.toString();
    fi = formatoAgnoAnterior+"-01-01 00:00:00"; 
    ff= fomatoAgno+"-12-31 23:59:00"; 
    fecha_final=DateTime.parse(ff).microsecondsSinceEpoch;
    fecha_inicial=DateTime.parse(fi).microsecondsSinceEpoch;
    dropdownValue ='Seleccione un Documento';
    dropdownAgnoInicial=formatoAgnoAnterior;
    dropdownAgnoFinal=fomatoAgno;
    super.initState();
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

  Widget dataBody(){
    return 
      Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height:20),
        Row(
          mainAxisAlignment:MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 10, 5),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Container(
                    padding:const EdgeInsets.fromLTRB(10, 10, 10, 10) ,
                    width:20,
                    child:
                      IconButton(
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.grey,
                          size:40,
                        ),
                        onPressed: () {
                          //Navigator.of(context).pop();
                        },
                      ),
                  ),
                  Container(
                    padding:const EdgeInsets.fromLTRB(50, 10, 5, 10) ,
                    child:
                    Text('Año Inicial'),
                  ),
                  listaAgnoInicial(),
                ]
              ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Container(
                  padding:const EdgeInsets.fromLTRB(10, 10, 10, 10) ,
                  width:20,
                  child:
                    IconButton(
                      icon: Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                      size:40,
                      ),
                      onPressed: () {
                            //Navigator.of(context).pop();
                      },
                  ),
                ),
                Container(
                  padding:const EdgeInsets.fromLTRB(50, 10,15, 10) ,
                  child:Text('Año Final'),
                ),
                listaAgnoFinal(),
              ]
            ),
          ),
          boton(),
        ]),
        // Container(
        //       padding: EdgeInsets.fromLTRB(56, 10, 56, 10),
        //       child:Center(
        //         child: DateTimeField(
        //         controller: _startTimeController,
        //         onChanged: (text) {
        //           if(_endTimeController.text!='')
        //          {
        //             var fechaicambio=_startTimeController.text.split('/');
        //             var fechafcambio=_endTimeController.text.split('/');
        //             var ini=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0]+' 00:00:00';
        //             var fin=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0]+' 23:00:00';
        //             DateTime parseInicial = DateTime.parse(ini);
        //             DateTime parseFinal = DateTime.parse(fin);
        //             var marcaIniP=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0];
        //             var marcaFin=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0];
        //             marcaInicial=DateTime.parse(marcaIniP).millisecondsSinceEpoch;
        //             marcaFinal=DateTime.parse(marcaFin).add(new Duration(hours:23, minutes:59, seconds:59)).millisecondsSinceEpoch;
        //             String nfechaI=DateFormat('yyyy-mm-dd').format(parseInicial);
        //             String nfechaF=DateFormat('yyyy-mm-dd').format(parseFinal);
        //             DateTime startDate = DateTime.parse(nfechaI);
        //             DateTime endDate = DateTime.parse(nfechaF);
        //             if(startDate.isBefore(endDate) || _startTimeController.text==_endTimeController.text)
        //             {
        //               if(dropdownValue=='Seleccione una Documento'){
        //               infoDialog(context, opcion,negativeAction: (){}, );
        //             }else
        //             {
        //               setState(() {
        //               cambiar= true;
        //               dataTable(_startTimeController.text,_endTimeController.text,tipo);
        //               });
        //             }
        //             }else{
        //               _startTimeController.text='';
        //               errorDialog(
        //                 context, 
        //                 error,
        //                 negativeAction: (){
        //                 },
        //               );
        //             }
        //          }else{
        //            infoDialog(
        //             context, 
        //             validarFecha,
        //             negativeAction: (){
        //             },
        //           );
        //           }
                  
        //         },
        //         format: format,
        //         onShowPicker: (context, currentValue) {
        //           return showDatePicker(
        //               context: context,
        //               firstDate: DateTime(1900),
        //               initialDate: currentValue ?? DateTime.now(),
        //               lastDate: DateTime(2100));
        //         },
        //         decoration: InputDecoration(
        //           prefixIcon: IconButton(
        //                 onPressed: (){
        //                   },
        //                 icon: Icon(
        //                 Icons.calendar_today,
        //                 color: Colors.grey,
        //                 ),
        //               ),
        //               enabledBorder:
        //                 UnderlineInputBorder(      
        //                   borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),   
        //                   ),  
        //                   focusedBorder: UnderlineInputBorder(
        //                     borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
        //                   ),
        //                   border: UnderlineInputBorder(
        //                     borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
        //                   ),
        //               labelText: 'Fecha Inicial',
        //         ),
        //       ),
        //       ),
        //       ),
        //       Container(
        //       padding: EdgeInsets.fromLTRB(56, 10, 56, 10),
        //       child:DateTimeField(
        //         controller:_endTimeController,
        //         onChanged: (text) {
        //           if(_startTimeController.text!="")
        //          { 
        //           var fechaicambio=_startTimeController.text.split('/');
        //           var fechafcambio=_endTimeController.text.split('/');
        //           var ini=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0]+' 00:00:00';
        //           var fin=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0]+' 00:00:00';
        //           var marcaIniP=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0];
        //           var marcaFin=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0];
        //           marcaInicial=DateTime.parse(marcaIniP).millisecondsSinceEpoch;
        //           marcaFinal=DateTime.parse(marcaFin).add(new Duration(hours:23, minutes:59, seconds:59)).millisecondsSinceEpoch;
        //           DateTime parseInicial = DateTime.parse(ini);
        //           DateTime parseFinal = DateTime.parse(fin);
        //           String nfechaI=DateFormat('yyyy-mm-dd').format(parseInicial);
        //           String nfechaF=DateFormat('yyyy-mm-dd').format(parseFinal);
        //           DateTime startDate = DateTime.parse(nfechaI);
        //           DateTime endDate = DateTime.parse(nfechaF);
        //           if(startDate.isBefore(endDate) || _startTimeController.text==_endTimeController.text)
        //           {
        //             if(dropdownValue=='Seleccione una Documento'){
        //               infoDialog(context, opcion,negativeAction: (){}, );
        //             }else
        //             {
        //               setState(() {
        //               cambiar= true;
        //               dataTable(_startTimeController.text,_endTimeController.text,tipo);
        //               });
        //             }
        //           }else{
        //             _endTimeController.text='';
        //             errorDialog(
        //               context, 
        //               error,
        //               negativeAction: (){
        //               },
        //             );
        //           }
        //          }else{
        //           infoDialog(
        //             context, 
        //             validarFecha,
        //             negativeAction: (){
        //             },
        //           );
        //           }
        //         },
        //         format: format,
        //         onShowPicker: (context, currentValue) {
        //           return showDatePicker(
        //               context: context,
        //               firstDate: DateTime(1900),
        //               initialDate: currentValue ?? DateTime.now(),
        //               lastDate: DateTime(2100));
        //         },
        //         decoration: InputDecoration(
        //           prefixIcon: IconButton(
        //                 onPressed: (){
        //                   },
        //                 icon: Icon(
        //                 Icons.calendar_today,
        //                 color: Colors.grey,
        //                 ),
        //               ),
        //               enabledBorder:
        //                 UnderlineInputBorder(      
        //                   borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),   
        //                   ),  
        //                   focusedBorder: UnderlineInputBorder(
        //                     borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
        //                   ),
        //                   border: UnderlineInputBorder(
        //                     borderSide: BorderSide(color: Color.fromRGBO(83, 86, 90, 1.0)),
        //                   ),
                      
        //           labelText: 'Fecha Final',
        //         ),
        //       ),
        //       ),
        SizedBox(height:30),
        cambiar?SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:dataTable(fecha_inicial,fecha_final,tipo)
        ):Container(),
      ],
      );
  }
//1640995140000 1546300800000
Widget listaAgnoInicial(){
  return Container(   
    height: 40,
    width: 120,
    //alignment: Alignment.topLeft,
    margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
    //margin: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(
      border: 
        Border(
          bottom:BorderSide(width: 1,
          color: Color.fromRGBO(83, 86, 90, 1.0),
        ),
      ),
    ),
    child:
    DropdownButtonHideUnderline(
      child:DropdownButton<String>(
        hint: Padding(
          padding: const EdgeInsets.all(0),
            child:Text(dropdownAgnoInicial, textAlign: TextAlign.left,style: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              fontFamily: 'Karla',
            ),),
        ),
        value: dropdownAgnoInicial,
        // icon: Icon(Icons.arrow_circle_down_rounded),
        // iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.black,fontSize: 15),
        underline: Container(
          height: 2,
          color: Colors.green,
        ),
        onChanged: ( String newValue) {
          int numeroFi=int.parse(newValue);
          int numeroFf=int.parse(dropdownAgnoFinal);
          if(numeroFi < numeroFf || numeroFi == numeroFf)
          {
            if(dropdownValue=='Seleccione un Documento'){
                  infoDialog(context, opcion,negativeAction: (){}, );
            }else
            {
              setState(() {
              contador=0;
              cambiar= true;
              fi = newValue+"-01-01 00:00:00"; 
              fecha_inicial=DateTime.parse(fi).microsecondsSinceEpoch;
              dropdownAgnoInicial= newValue;
              }); 
            }      
          }
          else
          {
            errorDialog(
              context, 
              error,
              negativeAction: (){
              },
            );
          } 
        },
        items:listaAgno.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child:Padding(
              padding: const EdgeInsets.fromLTRB(0, 2,2,2),
              child:new Text(value,textAlign: TextAlign.left,
              style: new TextStyle(color: Colors.black)),
            ),
          );
        }).toList(),
      ),
    ),
  );
}

Widget listaAgnoFinal(){
  return Container(
    height: 40,
    width: 120,
    //alignment: Alignment.topLeft,
    margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
    decoration: BoxDecoration(
      border: Border(bottom:BorderSide(width: 1,
      color: Color.fromRGBO(83, 86, 90, 1.0),),
      ),
    ),
    child:
    DropdownButtonHideUnderline(
    child:DropdownButton<String>(
      value: dropdownAgnoFinal,
      // icon: Icon(Icons.arrow_circle_down_rounded),
      // iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black,fontSize: 15),
      underline: Container(
        height: 2,
        color: Colors.green,
      ),
      onChanged: (String newValue) {
        int numeroFi=int.parse(dropdownAgnoInicial);
        int numeroFf=int.parse(newValue);
        if(numeroFi < numeroFf || numeroFi == numeroFf)
        { 
          if(dropdownValue=='Seleccione un Documento'){
                infoDialog(context, opcion,negativeAction: (){}, );
          }else
          {
            setState(() {
              contador=0;
              cambiar= true;
              var ff = newValue+"-12-31 23:59:00"; 
              fecha_final=DateTime.parse(ff).microsecondsSinceEpoch;
              dropdownAgnoFinal= newValue;
            });  
          }       
        }
        else
        {
          errorDialog(
          context, 
          error,
          negativeAction: (){
          },
        );
        }
      },
      items:listaAgno.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,textAlign: TextAlign.left),
        );
      }).toList(),
    ),),
  );
}
  @override
  Widget build(BuildContext context) {
    var menu = new Menu(data:widget.data,retorno:'');
    var encabezado= new Encabezado(data:widget.data,titulo:'Consultas',);
    return WillPopScope(
    onWillPop: () {  },
      child:SafeArea(
        child:Scaffold(
          appBar: new AppBar(
          flexibleSpace: encabezado,
          backgroundColor: Colors.transparent,
        ),
        drawer: menu,
        body: dataBody(),
        ),
      ),
    );
  }

  Future <List<Consulta>> listar_consultas(context,ini,fin,tipo)async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var verConsultas= Consultas(session);
    var token=widget.data.token;
    if(tipo =='Donación Fondo Social')
    {
      tipo='FondoSocial';
    }
    if(tipo =='Donación Cenicaña')
    {
      tipo='DonacionesCenicana';
    }
    if(tipo =='Retención en la Fuente')
    {
      tipo='Retenciones';
    }
    if(tipo =='Certificados de Ingresos y Costos')
    {
      tipo='IngresosYCostos';
    }
    if(tipo =='ICA')
    { 
      tipo='Ica';
    }
    if(tipo =='Seleccione un Documento' || tipo == null)
    {  
      setState(() {
          cambiar=false;
      });
    }
    var preEntrada;
    await verConsultas.listar_consultas(ini.toInt(),fin.toInt(),tipo).then((_){
    entradaGeneral=[];
    preEntrada=verConsultas.obtener_consulta();
    for ( var tabla_entrada in preEntrada)
    {
      entradaGeneral.add(tabla_entrada);
    }   
    preEntrada=[]; 
    verConsultas.limpiar_consulta();    
    });
    preEntrada=[]; 
    
    if(entradaGeneral.length > 0)
    {
      return entradaGeneral;
    }
    else
    {
      contador++;
      setState(() {
        cambiar = false;
      });
      if(contador > 0)
      { 
        cambiar=false;
        warningDialog(
          context, 
          info,
          negativeAction: (){
          },
        );
      }
    }
  //1130602589          
  }

  obtener_ruta(id) async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var verDocumentos= AdministrarDocumentos(session);
    var token=widget.data.token;
    var preEntrada;
    ms = new ProgressDialog(context);
    ms.style(message:'Se esta descargando el archivo');  
    await verDocumentos.obtener_ruta_documento(id).then((_){ 
      Map ruta=verDocumentos.establecer_ruta();  
      session.getFile(_url+ruta['ruta'].toString()).then((f){   
        ms.hide();
        js.context.callMethod ('webSaveAs', <dynamic> [html.Blob (<List <int>> [f]), 'archivo.pdf']);    
      });    
    });
  }

  Widget boton(){
    var token=widget.data.token;
    return Container(
      height: 40,
      margin: const EdgeInsets.fromLTRB(32, 10, 38,10),
      decoration: BoxDecoration(
      border: Border(bottom:BorderSide(width: 1,
                    color: Color.fromRGBO(83, 86, 90, 1.0),),
      ),
      // borderRadius: BorderRadius.circular(10), 
          //color: Color.fromRGBO(83, 86, 90, 1.0),
      ),
      child:DropdownButton<String>(
        value: dropdownValue,
        iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.black,fontSize: 16),
          underline: Container(
            height: 2,
              color: Colors.transparent,
          ),
          onChanged: (newValueDoc) {
            setState(() {
              if(newValueDoc!='Seleccione un Documento')
              {
                contador=0;
                cambiar = true;
                dropdownValue = newValueDoc;
                tipo=newValueDoc;
              }else{
                dropdownValue = newValueDoc;
              }
              
            });
          },
          items: <String>['Seleccione un Documento','Donación Cenicaña', 'Donación Fondo Social', 'Retención en la Fuente','Certificados de Ingresos y Costos','ICA']
          .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              //child:Center(
              child:Padding(
                padding: const EdgeInsets.fromLTRB(0, 5,25,10),
                child:new Text(value,textAlign: TextAlign.center,
                  style: new TextStyle(color: Colors.black)
                ),
              ),
              //),
            );
          }).toList(),
      ),
    );
  }

  Widget dataTable(ini,fin,tipo) {
    return FutureBuilder <List<Consulta>>(
      future:listar_consultas(context,ini,fin,tipo),
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
                      label: Expanded(child:Text("Fecha",textAlign: TextAlign.center,style: textStyle)),
                      numeric: false,
                      tooltip: "Fecha",
                    ),
                    DataColumn(
                      label: Expanded(child:Text("Documento",textAlign: TextAlign.center,style:textStyle)),
                      numeric: false,
                      tooltip: "Documento",
                    ),
                  ],
                  rows: entradaGeneral.map(
                    (entradaG) => DataRow(
                    cells: [
                      DataCell(
                        Center(child:Text(entradaG.fecha_distribucion.toString(),textAlign: TextAlign.center,)),
                        onTap: () {
              
                        },
                      ),
                      DataCell(
                          entradaG.documento_id==''?Center(child:Container(child: IconButton(icon: Icon(
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
                          obtener_ruta(entradaG.documento_id);
                        },
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

