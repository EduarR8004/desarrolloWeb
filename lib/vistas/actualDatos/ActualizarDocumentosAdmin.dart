import 'package:universal_io/io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/utiles/Seguridad.dart';
import 'package:proveedores_manuelita/vistas/encabezado/Encabezado.dart';
import 'package:proveedores_manuelita/vistas/menu.dart';

class ActualizarDocuemntoAdmin extends StatefulWidget {
  Data data;
  ActualizarDocuemntoAdmin({this.data});
  @override
  _ActualizarDocuemntoAdminState createState() => _ActualizarDocuemntoAdminState();
}

class _ActualizarDocuemntoAdminState extends State<ActualizarDocuemntoAdmin> {
  dynamic _file;
  bool natural,juridica,politica;
  String nombreArchivoN="",nombreArchivoJ="",nombreArchivoA="";
  ProgressDialog ms;
   
   @override
  void initState() {
    natural=false;
    juridica=false;
    politica=false;
    super.initState();
  }
   Future getFile(String evaluar,context)async{
      dynamic file = await FilePicker.platform.pickFiles(
        type: FileType.custom,allowedExtensions: ['pdf'], 
      );
      var name_file = file.files.first.name;
      var ext=name_file.split(".");
      var finalExt=ext[1];
      setState(() {
        if(finalExt=='pdf')
        { 
          if(evaluar=='natural')
          {
            setState(() {
              nombreArchivoN=name_file;
              natural=true;
            });
            
          }
          if(evaluar=='juridica')
          {
            setState(() {
              nombreArchivoJ=name_file;
              juridica=true;
            });
            
          }
          if(evaluar=='politica')
          {
            setState(() {
              nombreArchivoA=name_file;
              politica=true;
            });
            
          }
          _file = file;

        }else{
          warningDialog(
          context, 
          'Por favor adjuntar un archivo PDF',
          negativeAction: (){
          },
          );
        }
      });
 }
 
void _uploadFile(filePath,context,webservice) async {
  ms = new ProgressDialog(context);
  ms.style(message:'Se esta subiendo el archivo');  
  var session= Conexion();
  session.set_token(widget.data.token);
  var seguridad= Seguridad(session);
  var file = filePath.files.first.bytes;
  var name_file = filePath.files.first.name;
  var list = List.from(file);
    // _bytesData = Base64Decoder().convert(file.toString());
    // file = _bytesData;
  session.enviar_archivo_datos_web(webservice,name_file.toString(),list).then((_){
    setState(() {
      successDialog(
        context, 
        'Se Cargó el Archivo Correctamente',
        neutralText: "Aceptar",
        neutralAction: (){
        },
      );
    });
  });   
}
  @override
  Widget build(BuildContext context) {
    var menu = new Menu(data:widget.data,retorno:'');
    var encabezado= new Encabezado(data:widget.data,titulo:'Admin. Actualizar Datos',);
    return WillPopScope(
    onWillPop: () {  },
    child:SafeArea(
         child:Scaffold(
          appBar: new AppBar(
          flexibleSpace: encabezado,
          backgroundColor: Colors.transparent,
        ),
        drawer: menu,
        body:SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child:
                Container(
                height: 800,
                color:Colors.white,
                child:Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      verticalDirection: VerticalDirection.down,
                      children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                  padding: EdgeInsets.fromLTRB(50,50,5,0),
                                  child:
                                  Text('Persona Natural',textAlign: TextAlign.left,style: TextStyle(
                                                  color:Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold
                                  ),
                                  ),
                                  )
                              ],
                            ),
                            Container(
                              color:Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                            Column(children:[
                                              Padding(
                                              padding: EdgeInsets.fromLTRB(50,10,5,0),
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
                                                  getFile('natural',context);
                                                }
                                              ),
                                              ),
                                            ),
                                            ]),
                                            natural?Padding(
                                            padding: EdgeInsets.fromLTRB(2,17,5,10),
                                            child:Container(
                                              decoration: BoxDecoration(
                                              //color: Colors.white,
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            child:RaisedButton.icon(
                                              textColor: Color.fromRGBO(83, 86, 90, 1.0),
                                              //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                                              color: Color.fromRGBO(56, 124, 43, 1.0),
                                              icon: Icon(Icons.cloud_upload_sharp,color:Colors.white ,),
                                              //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                                              label: Text('Subir Archivo', style: TextStyle(
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
                                                _uploadFile(_file,context,'/api/formato_vinculacion_natural/cargar_pdf');
                                              }
                                            ),
                                            ),
                                            ):Container(),  

                                ],
                                ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                          Padding(
                                          padding: EdgeInsets.fromLTRB(50,10,5,0),
                                          child:Text(nombreArchivoN,style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold
                                          ),
                                          ),),
                              ],
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                  padding: EdgeInsets.fromLTRB(50,50,5,0),
                                  child:
                                  Text('Persona Juridica',textAlign: TextAlign.left,style: TextStyle(
                                                  color:Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold
                                  ),
                                  ),
                                  )
                              ],
                            ),
                            Container(
                                color:Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      children:[
                                            Padding(
                                            padding: EdgeInsets.fromLTRB(50,10,5,0),
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
                                                getFile('juridica',context);
                                              }
                                            ),
                                            ),
                                            ),
                                      ],
                                    ),
                                    juridica?Padding(
                                    padding: EdgeInsets.fromLTRB(2,17,5,10),
                                    child:Container(
                                      decoration: BoxDecoration(
                                      //color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: RaisedButton.icon(
                                      textColor: Color.fromRGBO(83, 86, 90, 1.0),
                                      //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                                      color: Color.fromRGBO(56, 124, 43, 1.0),
                                      icon: Icon(Icons.cloud_upload_sharp,color:Colors.white ,),
                                      //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                                      label: Text('Subir Archivo', style: TextStyle(
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
                                        _uploadFile(_file,context,'/api/formato_vinculacion_juridica/cargar_pdf');
                                      }
                                    ),
                                    ),
                                    ):Container(),  

                                  ],
                                ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                          Padding(
                                          padding: EdgeInsets.fromLTRB(50,10,5,0),
                                          child:Text(nombreArchivoJ,style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold
                                          ),
                                          ),),
                              ],
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                  padding: EdgeInsets.fromLTRB(50,50,5,0),
                                  child:
                                  Text('Autorización de Datos Personales',textAlign: TextAlign.left,style: TextStyle(
                                                  color:Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold
                                  ),
                                  ),
                                  )
                              ],
                            ),
                          Container(
                              color:Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    children:[
                                        Padding(
                                        padding: EdgeInsets.fromLTRB(50,10,5,0),
                                        child:Container(
                                          decoration: BoxDecoration(
                                          //color: Colors.white,
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child:  RaisedButton.icon(
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
                                            getFile('politica',context);
                                          }
                                        ),
                                        ),
                                        ),
                                    ],
                                  ),
                                  politica?Padding(
                                  padding: EdgeInsets.fromLTRB(2,17,5,10),
                                  child:Container(
                                    decoration: BoxDecoration(
                                    //color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: RaisedButton.icon(
                                    textColor: Color.fromRGBO(83, 86, 90, 1.0),
                                    //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                                    color: Color.fromRGBO(56, 124, 43, 1.0),
                                    icon: Icon(Icons.cloud_upload_sharp,color:Colors.white ,),
                                    //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                                    label: Text('Subir Archivo', style: TextStyle(
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
                                      _uploadFile(_file,context,'/api/formato_autorizacion_tratamiento/cargar_pdf');
                                    }
                                  ),
                                  ),
                                  ):Container(),  
                                ],
                              ),
                          ),
                          Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                                Padding(
                                                padding: EdgeInsets.fromLTRB(50,10,5,0),
                                                child:Text(nombreArchivoA,style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold
                                                ),
                                                ),),
                                    ],
                                  ),
                          
                      ],
                ),
            )
      ),
        
    ),),);
  }
}