import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:js' as js;
import 'dart:html' as html;
import 'package:proveedores_manuelita/logica/ActualizarDocumentos.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/vistas/verPdf/PdfViewPage.dart';

class PersonaJuridica extends StatefulWidget {
  Data data;
  PersonaJuridica({this.data});
  @override
  _PersonaJuridicaState createState() => _PersonaJuridicaState();
}

class _PersonaJuridicaState extends State<PersonaJuridica> {
  String _url='https://proveedores-cana.manuelita.com/';
  String urlPDFPath = "";
  ProgressDialog ms;
  double letra=16;
  obtener_ruta_juridica() async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var verDocumentos= ActualizarDocLogica(session);
    var token=widget.data.token;
    var preEntrada;
    ms = new ProgressDialog(context);
    ms.style(message:'Se esta descargando el archivo',textAlign:TextAlign.center);  
    await ms.show();
    await verDocumentos.obtener_ruta_documento_juridica().then((_){ 
      Map ruta=verDocumentos.establecer_ruta();  
      session.getFile(_url+ruta['ruta'].toString()).then((f){   
        ms.hide();
        js.context.callMethod ('webSaveAs', <dynamic> [html.Blob (<List <int>> [f]), 'archivo.pdf']);     
      });    
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: 
        Column(
          //mainAxisAlignment:MainAxisAlignment.center,
          children:<Widget>[
            SizedBox(height:50),
            Container(
              width: 600,
              margin: const EdgeInsets.fromLTRB(5, 20, 5,5),
              child:Text('1. Para descargar el Formato de Vinculación Proveedor, por favor haga clic en el botón "Descargar Archivo". Al final del formato se encuentra el listado de documentos que deben ser enviados para la vincuación',
              textAlign: TextAlign.justify,
              style: TextStyle(
                color:Colors.black,
                fontSize:letra,
                height:1.5,
              ),),),
              Container(
                width: 300,
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(7,40, 5,5),
                decoration: BoxDecoration(
                        //color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                ),
                child: RaisedButton.icon(
                  textColor: Color.fromRGBO(83, 86, 90, 1.0),
                  //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                  color: Color.fromRGBO(56, 124, 43, 1.0),
                  icon: Icon(Icons.download_rounded,color:Colors.white ,),
                  label:Text('Descargar Archivo', style: TextStyle(
                    color: Colors.white,
                    //Color.fromRGBO(83, 86, 90, 1.0),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
                  // child: Text('Descargar Archivo', style: TextStyle(
                  //   color: Colors.white,
                  //   //Color.fromRGBO(83, 86, 90, 1.0),
                  //   fontSize: 14,
                  //   fontWeight: FontWeight.bold,
                  // )),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    //side: BorderSide(color: Colors.white)
                  ),
                  onPressed:(){
                    obtener_ruta_juridica();
                  },
                ),
              ),
              // Container(
              // alignment: Alignment.centerLeft,
              // margin: const EdgeInsets.fromLTRB(7, 5, 7,5),
              // child:Text("2. Adjuntar los siguientes documentos:",
              // textAlign: TextAlign.justify,
              // style: TextStyle(
              //               color:Colors.black,
              //               fontSize:letra
              // )),),
              // textoMediano('a',"Certificado de Existencia y Representación Legal de la Cámara de Comercio local no mayor a 45 días calendario."),
              // texto('b',"Copia de la cédula de ciudadanía del representante legal, representante legal suplente o persona natural, según sea el caso, de quien suscribe el presente documento."),
              // texto('c',"RUT actualizado con fecha de generación al año de vinculación o actualización."),
              // textoLargo('d',"Certificado de cuenta bancaria en donde se realizará el pago por transferencia no mayor a 45 días calendario (El proveedor debe ser el titular de la cuenta bancaria). Sólo aplica para proveedores."),
              // textoExtraLargo('e',"Certificado de composición accionaria firmada por el contador público, revisor fiscal u oficial de cumplimiento que incluyan solamente aquellos socios o accionistas que posean el 25% o más del capital de la sociedad incluyendo beneficiarios finales con una participación directa o indirecta superior al 25%, con vigencia de 45 días calendario."),
          ],
        )
    );
  }

  Widget texto(numero,texto){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
      Container(
        margin: const EdgeInsets.fromLTRB(7,5, 5,5),
        height: 40,
        width: 20,
        child:Text(numero,textAlign: TextAlign.start,style: TextStyle(
          color:Colors.black,
          fontSize:letra,
          fontWeight: FontWeight.bold
        ),),),
      Container(
        height:50,
        width:300,
        child:Text(texto,
        textAlign: TextAlign.justify,style: TextStyle(
          color:Colors.black,
          fontSize:letra,
          height:1.5,
        ),)),
      ],
    );
  }

  Widget textoLargo(numero,texto){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
      Container(
        margin: const EdgeInsets.fromLTRB(7,10, 5,5),
        height: 115,
        width: 20,
        child:Text(numero,textAlign: TextAlign.start,style: TextStyle(
          color:Colors.black,
          fontSize:letra,
          fontWeight: FontWeight.bold
        ),),),
      Container(
        height:115,
        width:300,
        child:Text(texto,
        textAlign: TextAlign.justify,style: TextStyle(
          color:Colors.black,
          fontSize:letra,
          height:1.5,
        ),)),
    ],
    );
  }
  Widget textoExtraLargo(numero,texto){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(7,10, 5,5),
          height: 220,
          width: 20,
          child:Text(numero,textAlign: TextAlign.start,style: TextStyle(
            color:Colors.black,
            fontSize:letra,
            fontWeight: FontWeight.bold
          ),),),
        Container(
          height:220,
          width:300,
          child:Text(texto,
          textAlign: TextAlign.justify,style: TextStyle(
            color:Colors.black,
            fontSize:letra,
            height:1.5,
                          //fontWeight: FontWeight.bold
          ),)),
      ],
    );
  }
  Widget textoMediano(numero,texto){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(7,5, 5,5),
          height: 60,
          width: 20,
          child:Text(numero,textAlign: TextAlign.start,style: TextStyle(
            color:Colors.black,
            fontSize:letra,
            fontWeight: FontWeight.bold
          ),),
        ),
        Container(
          height:70,
          width:300,
          child:Text(texto,
          textAlign: TextAlign.justify,style: TextStyle(
            color:Colors.black,
            fontSize:letra,
            height:1.5,
            //fontWeight: FontWeight.bold
          ),)
        ),
      ],
    );
  }
}