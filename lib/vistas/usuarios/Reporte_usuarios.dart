import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:js' as js;
import 'dart:html' as html;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:proveedores_manuelita/logica/Usuarios.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/modelos/Orden.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/vistas/encabezado/Encabezado.dart';
import 'package:proveedores_manuelita/vistas/menu.dart';

class ReporteUsuarios extends StatefulWidget {
  final Data data;
  final ParametrosOrden parametros;
  final Orden orden;
  bool reporte;
  ReporteUsuarios({Key key,this.data,this.parametros,this.orden,this.reporte}) : super();
  @override
  _ReporteUsuariosState createState() => _ReporteUsuariosState();
}

class _ReporteUsuariosState extends State<ReporteUsuarios> {
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  DateTime parseFinal,parseInicial;
  Orden consulta;
  ProgressDialog ms;
  String _token,tipo;
  String mensaje,texto;
  int marcaFinal;
  int marcaInicial;
  final format = DateFormat("dd/MM/yyyy");
  String _url='https://proveedores-cana.manuelita.com/';
  String eliminarUsuario='Usuario Eliminado Correctamente';
  var validarFecha='Por favor ingresar la Fecha Inicial y la Fecha Final para realizar la consulta de información';
  var vacios='Por favor seleccione un fecha inicial y una fecha final';
  var error="La Fecha Inicial debe ser inferior o igual a la Fecha Final";
  var parametroFechaI;
  var parametroFechaF;
   @override
  void initState() {
    widget.data;
  
  super.initState();
}

  obtener_ruta_reporte_usuarios(ini,fin) async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var usuario= Usuarios(session);
    print(widget.data.token);
    var token=widget.data.token;
    var preEntrada;
    ms = new ProgressDialog(context);
    ms.style(message:'Se esta descargando el archivo');  
    print(ini+','+fin);
    await usuario.obtener_ruta_reporte_usuarios(ini,fin).then((_){ 
      Map ruta=usuario.establecer_ruta();  
      print(ruta['ruta'].toString());
      session.getFile(_url+ruta['ruta'].toString()).then((f){   
        ms.hide();
        js.context.callMethod ('webSaveAs', <dynamic> [html.Blob (<List <int>> [f]), 'archivo.txt']);    
      });    
    });
  }
  obtener_ruta_reporte_politica(ini,fin) async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var usuario= Usuarios(session);
    print(widget.data.token);
    var token=widget.data.token;
    var preEntrada;
    ms = new ProgressDialog(context);
    ms.style(message:'Se esta descargando el archivo');  
    print(ini+','+fin);
    await usuario.obtener_ruta_reporte_log(ini,fin).then((_){ 
      Map ruta=usuario.establecer_ruta();  
      print(ruta['ruta'].toString());
      session.getFile(_url+ruta['ruta'].toString()).then((f){   
        ms.hide();
        js.context.callMethod ('webSaveAs', <dynamic> [html.Blob (<List <int>> [f]), 'archivo.csv']);    
      });    
    });
  }

  @override
  Widget build(BuildContext context) {
    var menu = new Menu(data:widget.data,retorno:'');
    var encabezado= new Encabezado(data:widget.data,titulo:'Reporte Usuarios',);
    return WillPopScope(
    onWillPop: () {  },
      child: SafeArea(
        child:Scaffold(
          appBar: new AppBar(
            flexibleSpace:encabezado, 
            backgroundColor: Colors.transparent,
          ),
          drawer: menu,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:Container(
              height: 800,
              color:Colors.white,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height:80),
                  Container(
                    child:widget.reporte?
                    Text("Reporte de Usuarios",
                      style: TextStyle(
                      color:Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize:20,
                      )
                    ):
                    Text("Reporte de Politica de Aceptación",
                      style: TextStyle(
                        color:Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize:20,
                      )
                    )
                  ),
                  SizedBox(height:40),
                  Container(
                    width: 400,
                    color:Colors.white,
                    padding: EdgeInsets.fromLTRB(56, 20, 56, 10),
                    child:Center(
                      child: DateTimeField(
                        controller: _startTimeController,
                        onChanged: (text) {
                          if(_endTimeController.text!='')
                          {
                            var fechaicambio=_startTimeController.text.split('/');
                            var fechafcambio=_endTimeController.text.split('/');
                            var ini=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0]+' 00:00:00';
                            var fin=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0]+' 23:59:59';
                            var marcaIniP=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0]+' 00:00:00';
                            var marcaFin=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0];
                            marcaInicial=DateTime.parse(marcaIniP).microsecondsSinceEpoch;
                            marcaFinal=DateTime.parse(marcaFin).add(new Duration(hours:23, minutes:59, seconds:59)).microsecondsSinceEpoch;
                            parseInicial = DateTime.parse(ini);
                            parseFinal = DateTime.parse(fin);
                            String nfechaI=DateFormat('yyyy-mm-dd').format(parseInicial);
                            String nfechaF=DateFormat('yyyy-mm-dd').format(parseFinal);
                            DateTime startDate = DateTime.parse(nfechaI);
                            DateTime endDate = DateTime.parse(nfechaF);
                            if(startDate.isBefore(endDate) || _startTimeController.text==_endTimeController.text)
                            {
                            
                            }else{
                              _startTimeController.text='';
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
                    width: 400,
                    color:Colors.white,
                    padding: EdgeInsets.fromLTRB(56, 10, 56, 10),
                      child:DateTimeField(
                        controller:_endTimeController,
                        onChanged: (text) {
                          if(_startTimeController.text!="")
                          { 
                            var fechaicambio=_startTimeController.text.split('/');
                            var fechafcambio=_endTimeController.text.split('/');
                            var ini=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0]+' 00:00:00';
                            var fin=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0]+' 23:59:59';
                            var marcaIniP=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0]+' 00:00:00';
                            var marcaFin=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0];
                            marcaInicial=DateTime.parse(marcaIniP).microsecondsSinceEpoch;
                            marcaFinal=DateTime.parse(marcaFin).add(new Duration(hours:23, minutes:59, seconds:59)).microsecondsSinceEpoch;
                            parseFinal = DateTime.parse(fin);
                            parseInicial = DateTime.parse(ini);
                            String nfechaI=DateFormat('yyyy-mm-dd').format(parseInicial);
                            String nfechaF=DateFormat('yyyy-mm-dd').format(parseFinal);
                            DateTime startDate = DateTime.parse(nfechaI);
                            DateTime endDate = DateTime.parse(nfechaF);
                            if(startDate.isBefore(endDate) || _startTimeController.text==_endTimeController.text)
                            {

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
                            child: RaisedButton(
                              textColor: Color.fromRGBO(83, 86, 90, 1.0),
                              //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                              color: Color.fromRGBO(56, 124, 43, 1.0),
                              child: Text('Descargar', style: TextStyle(
                                  color: Colors.white,
                                  //Color.fromRGBO(83, 86, 90, 1.0),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              )),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                //side: BorderSide(color: Colors.white)
                              ),
                              onPressed: () {
                                if(_startTimeController.text!="" && _endTimeController.text!=''){
                                  widget.reporte?obtener_ruta_reporte_usuarios(marcaInicial,marcaFinal):obtener_ruta_reporte_politica(marcaInicial,marcaFinal);
                                }else{
                                  infoDialog(
                                    context, 
                                    vacios,
                                    negativeAction: (){
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ),  
                      ],
                    ),   
                  ),
                  SizedBox(height:20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


