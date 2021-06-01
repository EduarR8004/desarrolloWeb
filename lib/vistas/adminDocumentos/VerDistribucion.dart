import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:proveedores_manuelita/logica/AdministrarDocumentos.dart';
import 'package:proveedores_manuelita/modelos/AdminDistri.dart';
import 'dart:convert' show utf8;
import 'dart:js' as js;
import 'dart:html' as html;
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/modelos/Orden.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/vistas/verPdf/PdfViewPage.dart';



class VerDistribucion extends StatefulWidget {
  Data data;
  final Orden orden;
  
  VerDistribucion({this.data,this.orden});
 @override
 _VerDistribucionState createState() => _VerDistribucionState();
}

class _VerDistribucionState extends State<VerDistribucion> {
var usuario_id;
var creacion="Rol creado correctamente\nDesea crear un nuevo Rol?";
FocusNode not;
String _token,tipo;
String dropdownValue;
bool pruebaTipo;
GlobalKey<FormState> keyForm = new GlobalKey();
List <AdminDocumentoDistri>entradaGeneralDistri=[];
num totalRegistros;
ProgressDialog ms;
String _url='https://proveedores-cana.manuelita.com/';
String urlPDFPath = "";
var ordenId;
  @override
  void initState() {
    entradaGeneralDistri=[];
    totalRegistros=0;
    super.initState();
    ordenId= widget.orden.orden_procesamiento_id.toString();
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

@override
  void dispose() {
    super.dispose();
  }

  Future <List<AdminDocumentoDistri>> listar_documentos_distri(id)async{
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


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new Scaffold(
        body:Container(
          color: Colors.white,
            child:Column(
            //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            //verticalDirection: VerticalDirection.down,
            children: <Widget>[
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
                      child:Text('Ver Distribución',style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),),
                    )
                  ],
                ) ,
                //padding: EdgeInsets.symmetric(horizontal:10),
              ),
              Expanded(
                child:Container(
                  color: Colors.white,
                  child:dataTableDistri(ordenId),),
              ),
            ],
          ),
        ), 
      ),
    );
  }

  Widget  dataTableDistri(id) {
    return FutureBuilder <List<AdminDocumentoDistri>>(
      future:listar_documentos_distri(id),
      builder:(context,snapshot){
        if(snapshot.hasData){
          var textStyle = TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize:15,);
          return  
          SingleChildScrollView(
          scrollDirection: Axis.vertical,
            child: SingleChildScrollView( 
              scrollDirection: Axis.horizontal,
              child: 
              Column(
                children:[
                  conteoRegistros(),
                  DataTable(
                      headingRowColor:
                    MaterialStateColor.resolveWith((states) =>Colors.white ),
                    //Color.fromRGBO(136,139, 141, 1.0)
                    sortColumnIndex: 0,
                    horizontalMargin:10,
                    columnSpacing:10,
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
                            ),
                            ),),)
                            :Center(
                            child:
                              Container(
                                child: 
                                  IconButton(
                                  icon: Icon(
                                    Icons.picture_as_pdf,
                                    size:30,
                                    color: Color.fromRGBO(56, 124, 43, 1.0),
                                  ),
                                ),
                              ),
                            ),
                            //Text(entradaG.id),
                            onTap: () {
                              obtener_ruta(entradaG.documento_id,context);
                            },
                          ),
                          DataCell(
                            Center(child:Text(entradaG.fecha_distribucion.toString()=='1969-12-31 19:00:00.000'?'':entradaG.fecha_distribucion.toString(),textAlign: TextAlign.center,)),
                            onTap: () {
                            },
                          ),
                        ]
                      ),
                    ).toList(),
                  )
                ]
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
  Widget conteoRegistros() {
    return  
    Row(
      mainAxisAlignment:MainAxisAlignment.center,
      children:<Widget>[
        Container(
        width: 200,
        color:Colors.white,
        child: 
          Padding(
          padding: const EdgeInsets.all(20.0),
            child: Table(
              children: [
                TableRow(
                  children: [
                    Text("Total Registros",textAlign: TextAlign.center,style: TextStyle(
                      color:Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                  ]
                ),
                TableRow(
                  children: [
                    Text(totalRegistros.toString(),textAlign: TextAlign.center,
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
  
}