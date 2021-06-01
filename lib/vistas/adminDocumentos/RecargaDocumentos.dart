

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';
import 'dart:js' as js;
import 'dart:html' as html;
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import 'package:proveedores_manuelita/logica/Ordenes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:proveedores_manuelita/logica/AdministrarDocumentos.dart';
import 'package:proveedores_manuelita/modelos/AdminDistri.dart';
import 'package:proveedores_manuelita/modelos/AdminDocumento.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/modelos/Orden.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/utiles/Seguridad.dart';
import 'package:proveedores_manuelita/utiles/ProgressDialog.dart';
import 'package:proveedores_manuelita/vistas/encabezado/Encabezado.dart';
import 'package:proveedores_manuelita/vistas/menu.dart';
import 'package:proveedores_manuelita/vistas/verPdf/PdfViewPage.dart';


class RecargaDocumentos extends StatefulWidget {
  final Data data;
  Orden ordenModificar;
  final ParametrosOrden parametros;
  RecargaDocumentos({Key key,this.data,this.ordenModificar,this.parametros}) : super();
  @override
  _RecargaDocumentosState createState() => _RecargaDocumentosState();
}

class _RecargaDocumentosState extends State<RecargaDocumentos> {
  dynamic _file;
  bool sort,adjuntar,procesar,mostrarDistri,preliminar;
  String dropdownValue,tipo,nuevaOrden,tabla,registros,nombreArchivo='',mensajeError;
  Map orden;
  num totalRegistros;
  ProgressDialog ms;
  ProgressDialog msf;
  String _url='https://proveedores-cana.manuelita.com/';
  String urlPDFPath = "";
  progressDialog showd = progressDialog();
  var error="Por favor Seleccione un tipo de Documento";
  var opcion='Seleccione un tipo de Documento';
  List <AdminDocumento>entradaGeneral=[];
  List <AdminDocumentoDistri>entradaGeneralDistri=[];
  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
 
  @override
  void initState() {
  
    sort = false;
    tabla = 'vacia';
    adjuntar=false;
    procesar=false;
    mostrarDistri=false;
    totalRegistros=0;
    widget.parametros;
    widget.data;
    tipo=widget.ordenModificar.tipo;
    nuevaOrden=widget.ordenModificar.orden_procesamiento_id.toString();
    super.initState();
  }

   Future getFile(context)async{
    dynamic file = await FilePicker.platform.pickFiles(
        type: FileType.custom,allowedExtensions: ['pdf','zip'], 
    );
    var name_file = file.files.first.name;
    var ext=name_file.split(".");
    var finalExt=ext[1];
    if(file != null) {
      if(finalExt=='pdf' || finalExt=='zip')
      {
        setState(() {
          _file = file;
          procesar=true;
          nombreArchivo=name_file;
        });
      }else{
        warningDialog(
        context, 
        'Por favor adjuntar un archivo PDF o ZIP',
        negativeAction: (){
        },
        );
      }
    }else{
      warningDialog(
        context, 
        'Por adjuntar un archivo PDF o ZIP',
        negativeAction: (){
        },
      );
    }
 }
  eliminar(nuevaOrden)async 
  {
    var session= Conexion();
    session.set_token(widget.data.token);
    var orden= Ordenes(session);
    orden.eliminar_orden(nuevaOrden).then((_){        
    });
  }
  void _uploadFile(filePath,nuevaOrden,context) async {
    ms = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    ms.style(message:'Se esta procesando el archivo, esto puede tardar unos minutos',textAlign:TextAlign.center);  
    var session= Conexion();
    session.set_token(widget.data.token);
    var seguridad= Seguridad(session);
    var verDocumentos= AdministrarDocumentos(session);
    var file = filePath.files.first.bytes;
    var name_file = filePath.files.first.name;
    var list = List.from(file);
    await ms.show();
     session.enviar_archivo(list,nuevaOrden).then((_){
        verDocumentos.precesar_orden(nuevaOrden).then((data){
          //var mensaje=data['message'];
          mensajeError=data['message'].toString();
          if(data.isEmpty)
          { 
            setState(() {
              tabla = 'procesar';
              mostrarDistri=true;
              ms.hide();
            });
          }else{
            eliminar(nuevaOrden);
            ms.hide();
            errorDialog(
              context, 
              data['message'].toString(),
              negativeText: "Aceptar",
              negativeAction: (){                         
              },
              neutralText: "Copiar",
              neutralAction: (){                 
                Clipboard.setData(new ClipboardData(text: mensajeError));
              },
            ); 
          }
        });
     });    
  }

Future <List<AdminDocumento>> listar_documentos(id,context)async{
  var session= Conexion();
  session.set_token(widget.data.token);
  var verDocumentos= AdministrarDocumentos(session);
  var token=widget.data.token;
  var preEntrada; 
  await verDocumentos.listar_documentos(id).then((_){
    entradaGeneral=[];
    preEntrada=verDocumentos.obtener_documentos();
    for ( var tabla_entrada in preEntrada)
    {
      entradaGeneral.add(tabla_entrada);
    }   
    preEntrada=[]; 
    verDocumentos.limpiar_documentos();    
  });
  preEntrada=[]; 
  totalRegistros=entradaGeneral.length;
  return entradaGeneral;
            
}

Future <List<AdminDocumentoDistri>> listar_documentos_distri(id,context)async{
  var session= Conexion();
  session.set_token(widget.data.token);
  var verDocumentos= AdministrarDocumentos(session);
  var token=widget.data.token;
  var preEntrada;
  await verDocumentos.listar_documentos_distri(id).then((_){
    entradaGeneralDistri=[];
    preEntrada=verDocumentos.obtener_documentos_distri();
    for ( var tabla_entrada in preEntrada)
    {
      entradaGeneralDistri.add(tabla_entrada);
    }   
    preEntrada=[]; 
    verDocumentos.limpiar_documentos();  
     
  });
  preEntrada=[]; 
  totalRegistros=entradaGeneralDistri.length; 
  return entradaGeneralDistri;
            
}
distribuir(id,tipo,context) async{
  if(tipo =='Fondo Social')
  {
    this.tipo='FondoSocial';
  }
  if(tipo =='Donaciones Cenicana')
  {
    tipo='DonacionesCenicana';
  }
  if(tipo =='Retención')
  {
    tipo='Retenciones';
  }
  if(tipo =='Ingr.Cost')
  {
    tipo='IngresosYCostos';
  }
  if(tipo =='ICA')
  {
    tipo='Ica';
  }
  if(tipo =='Anticipos')
  {
    tipo='LiquidacionAnticipos';
  }
  if(tipo =='Liquidación Caña')
  {
    tipo='LiquidacionCana';
  }
  var session= Conexion();
  session.set_token(widget.data.token);
  var verDocumentos= AdministrarDocumentos(session);
  var token=widget.data.token;
  var preEntrada;
  ms = new ProgressDialog(context);
  ms.style(message:'Se estan distribuyendo los archivos, esto puede tardar unos minutos',textAlign:TextAlign.center); 
  await ms.show();
  await verDocumentos.distribuir(id,tipo,preliminar).then((_){   
    setState(() {
    tabla='distribuir';
   });     
  });
}

obtener_ruta(id,context) async{
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
  ms.style(message:'Se esta descargando el archivo',textAlign:TextAlign.center);  
  await ms.show();
  await verDocumentos.obtener_ruta_documento(id).then((_){ 
     Map ruta=verDocumentos.establecer_ruta();  
     session.getFile(_url+ruta['ruta'].toString()).then((f){   
       ms.hide();
       js.context.callMethod ('webSaveAs', <dynamic> [html.Blob (<List <int>> [f]), 'archivo.pdf']);    
    });    
  });
}

crear_orden(String tipo)async{
  if(tipo =='Fondo Social')
  {
    this.tipo='FondoSocial';
  }
  if(tipo =='Donaciones Cenicana')
  {
    tipo='DonacionesCenicana';
  }
  if(tipo =='Retención')
  {
    tipo='Retenciones';
  }
  if(tipo =='Ingr.Cost')
  {
    tipo='IngresosYCostos';
  }
  if(tipo =='ICA')
  {
    tipo='Ica';
  }
  if(tipo =='Anticipos')
  {
    tipo='LiquidacionAnticipos';
  }
  if(tipo =='Liquidación Caña')
  {
    tipo='LiquidacionCana';
  }
  var session= Conexion();
  session.set_token(widget.data.token);
  var verDocumentos= AdministrarDocumentos(session);
  var token=widget.data.token;
  Map preOrden;
  await verDocumentos.crear_orden(tipo).then((_){
    preOrden=verDocumentos.obtener_orden();
  });
  return orden=preOrden;        
}
mostrar(String texto,context,nuevaOrden){

  if(texto=='procesar')
  {
    return dataTable(nuevaOrden,context);
  }
  if(texto=='distribuir')
  {
    return dataTableDistri(nuevaOrden,context);
  }
  if(texto=='vacia')
  {
    return dataTableVacia();
  }
}
//R009 error de paginas

  @override
  Widget build(BuildContext context) {
    var menu = new Menu(data:widget.data,retorno:'');
    var encabezado= new Encabezado(data:widget.data,titulo:'Cargar Documentos',);
    return WillPopScope(
    onWillPop: () {  },
      child:SafeArea(
        child:Scaffold(
          appBar: new AppBar(
            flexibleSpace: encabezado,
            backgroundColor: Colors.transparent,
          ),
          drawer: menu,
          body: 
          Container(
            color:Colors.white,
            child:Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
              children: <Widget>[
                Container(
                  color:Colors.white,
                ),
                Container(
                  color:Colors.white ,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: 
                      <Widget>[
                        Padding(
                        padding: EdgeInsets.all(10.0),
                        child:Container(),),
                      ],
                  ),
                ),
                SingleChildScrollView(
                scrollDirection: Axis.vertical,
                  child:Container(
                  color:Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                      padding: EdgeInsets.all(10.0),
                      child:Container(
                        decoration: BoxDecoration(
                        //color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: RaisedButton.icon(
                        textColor: Color.fromRGBO(83, 86, 90, 1.0),
                        //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                        color: Color.fromRGBO(56, 124, 43, 1.0),
                        icon: Icon(Icons.attach_file_outlined,color:Colors.white ,),
                        //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                        label: Text('Adjuntar', style: TextStyle(
                          color: Colors.white,
                          //Color.fromRGBO(83, 86, 90, 1.0),
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        )),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          //side: BorderSide(color: Colors.white)
                        ),
                        onPressed:() {
                          getFile(context);
                        },
                      ),
                      ),
                      ),
                      procesar?Padding(
                      padding: EdgeInsets.all(10.0),
                      child:Container(
                        decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: RaisedButton.icon(
                        textColor: Color.fromRGBO(83, 86, 90, 1.0),
                        //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                        color: Color.fromRGBO(56, 124, 43, 1.0),
                        icon: Icon(Icons.auto_awesome_motion,color:Colors.white ,),
                        //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                        label:Text('Procesar', style: TextStyle(
                          color: Colors.white,
                          //Color.fromRGBO(83, 86, 90, 1.0),
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        )),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          //side: BorderSide(color: Colors.white)
                        ),
                        onPressed: () {
                            _uploadFile(_file,nuevaOrden,context);
                        },
                      ),
                      ),
                      ):Container(),
                      mostrarDistri?Padding(
                      padding: EdgeInsets.all(10.0),
                      child:Container(
                        decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: RaisedButton.icon(
                        textColor: Color.fromRGBO(83, 86, 90, 1.0),
                        //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                        color: Color.fromRGBO(56, 124, 43, 1.0),
                        icon: Icon(Icons.cloud_upload_outlined,color:Colors.white ,),
                        //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                        label: Text('Distribuir', style: TextStyle(
                          color: Colors.white,
                          //Color.fromRGBO(83, 86, 90, 1.0),
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        )),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          //side: BorderSide(color: Colors.white)
                        ),
                        onPressed: () {
                          setState(() {
                          tabla='vacia';
                          distribuir(nuevaOrden,tipo,context);
                          });
                        },
                      ),
                      ),
                      ):Container(),
                    ],
                  ),
                ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                    padding: EdgeInsets.fromLTRB(50,10,5,0),
                    child:Text(nombreArchivo,style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                    ),),
                  ],
                ),
                Expanded(
                  child:Container(
                  color: Colors.white,
                    child:mostrar(tabla,context,nuevaOrden),
                  )
                ),
              ],
          ),
          ),
        ),
      ),
    );
  }

  Widget conteoRegistros() {
    return  
    Column(
      mainAxisAlignment:MainAxisAlignment.center,
      children:<Widget>[
        Container(
        width: 200,
        color:Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Table(children: [
            TableRow(
              children: [
                Text("Total Registros",textAlign: TextAlign.center,style: TextStyle(
                  color:Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),),
              ]
            ),
            TableRow(
            children: [
              Text(totalRegistros.toString(),textAlign: TextAlign.center,
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
    );
  }


  Widget  dataTableDistri(id,context) {
    return FutureBuilder <List<AdminDocumentoDistri>>(
    future:listar_documentos_distri(id,context),
      builder:(context,snapshot){
        if(snapshot.hasData){
          ms.hide();
          var textStyle = TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize:15,);
          return  
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                  child: SingleChildScrollView( 
                    scrollDirection: Axis.horizontal,
                    child:Column(children:[
                      conteoRegistros(),
                      DataTable(
                        headingRowColor:
                        MaterialStateColor.resolveWith((states) =>Color.fromRGBO(56, 124, 43, 1.0) ),
                        //Color.fromRGBO(136,139, 141, 1.0)
                        horizontalMargin:10,
                        columnSpacing:10,
                        sortAscending: sort,
                        sortColumnIndex: 0,
                        columns: [
                          DataColumn(
                            label: Expanded(child:Text("Nit",textAlign: TextAlign.center,style: textStyle)),
                            numeric: false,
                            tooltip: "Nit",
                          ),
                          DataColumn(
                            label: Expanded(child:Text("Documento",textAlign: TextAlign.center,style: textStyle)),
                            numeric: false,
                            tooltip: "Documento",
                          ),
                          DataColumn(
                            label: Expanded(child:Text("Fecha Distribución",textAlign: TextAlign.center,style: textStyle)),
                            numeric: false,
                            tooltip: "Fecha Distri",
                          ),
                        ],
                        rows: entradaGeneralDistri.map(
                          (entradaG) => DataRow(
                            cells: [
                              DataCell(
                                Center(child:Text(entradaG.nit,textAlign: TextAlign.center,)),
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
                                  obtener_ruta(entradaG.documento_id,context);
                                },
                              ),
                              DataCell(
                                Center(child:Text(entradaG.fecha_distribucion.toString(),textAlign: TextAlign.center,)),
                                onTap: () {
                    
                                },
                              ),
                            ]
                          ),
                        ).toList(),
                      ),
                    ],
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

  Widget  dataTable(id,context) {
     return FutureBuilder <List<AdminDocumento>>(
      future:listar_documentos(id,context),
      builder:(context,snapshot){
        if(snapshot.hasData){
          var textStyle = TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize:15,);
          return 
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
                child: SingleChildScrollView( 
                  scrollDirection: Axis.horizontal,
                  child: 
                  Column(children:[
                    conteoRegistros(),
                    DataTable(
                      headingRowColor:
                      MaterialStateColor.resolveWith((states) =>Color.fromRGBO(56, 124, 43, 1.0) ),
                      //Color.fromRGBO(136,139, 141, 1.0)
                      sortAscending: sort,
                      sortColumnIndex: 0,
                      horizontalMargin:10,
                      columnSpacing:10,
                      columns: [
                        DataColumn(
                          label: Expanded(child:Text("Hacienda",textAlign: TextAlign.center,style: textStyle)),
                          numeric: false,
                          tooltip: "Hacienda",
                        ),
                        DataColumn(
                            label: Expanded(child:Text("Nit",textAlign: TextAlign.center,style: textStyle)),
                            numeric: false,
                            tooltip: "Nit",
                        ),
                        DataColumn(
                          label: Expanded(child:Text("Documento",textAlign: TextAlign.center,style: textStyle)),
                          numeric: false,
                          tooltip: "Documento",
                        ),
                        DataColumn(
                          label: Expanded(child:Text("Prop",textAlign: TextAlign.center,style: textStyle)),
                          numeric: false,
                          tooltip: "prop",
                        )
                      ],
                      rows: entradaGeneral.map(
                        (entradaG) => DataRow(
                          cells: [
                            DataCell(
                              Center(child:Text(entradaG.cod_hda,textAlign: TextAlign.center,)),
                              onTap: () {
                  
                              },
                            ),
                            DataCell(
                              Center(child:Text(entradaG.nit,textAlign: TextAlign.center,)),
                              onTap: () {
                  
                              },
                            ),
                            DataCell(
                              Center(child:Container(child: IconButton(icon: Icon(
                                Icons.picture_as_pdf,
                                size:30,
                                color: Color.fromRGBO(56, 124, 43, 1.0),
                              ),),),),
                              //Text(entradaG.id),
                              onTap: () {
                                obtener_ruta(entradaG.documento_id,context);
                              },
                            ),
                            DataCell(
                              Center(child:Text(entradaG.prop,textAlign: TextAlign.center,)),
                              onTap: () {
                  
                              },
                            ),
                          ]
                        ),
                      ).toList(),
                    ),
                  ],
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
    return SingleChildScrollView(
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
                  label: Expanded(child:Text("Fecha",textAlign: TextAlign.center,style: textStyle)),
                  numeric: false,
                  tooltip: "Fecha",
              ),
              DataColumn(
                label: Expanded(child:Text("Documento",textAlign: TextAlign.center,style: textStyle)),
                numeric: false,
                tooltip: "Documento",
              ),
            ],
            rows: entradaGeneral.map(
              (entradaG) => DataRow(
                cells: [
                  DataCell(
                    Center(child:Text(entradaG.documento_id,textAlign: TextAlign.center,)),
                    onTap: () {
          
                    },
                  ),
                  DataCell(
                    Center(child:Container(child: IconButton(icon: Icon(
                      Icons.picture_as_pdf,
                      size:30,
                      color: Color.fromRGBO(56, 124, 43, 1.0),
                    ),),),),
                    //Text(entradaG.id),
                    onTap: () {
                        entradaG.documento_id;
                    },
                  ),
                ]
              ),
            ).toList(),
          ),
      ),
    );
  }
  
}