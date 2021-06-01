import 'dart:convert';
import 'dart:developer';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:proveedores_manuelita/vistas/adminDocumentos/VerDistribucion.dart';
import 'package:proveedores_manuelita/logica/AdministrarDocumentos.dart';
import 'package:proveedores_manuelita/logica/Ordenes.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/modelos/Orden.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/vistas/adminDocumentos/CrearEditOrden.dart';
import 'package:proveedores_manuelita/vistas/adminDocumentos/RecargaDocumentos.dart';
import 'package:proveedores_manuelita/vistas/encabezado/Encabezado.dart';
import 'package:proveedores_manuelita/vistas/menu.dart';

class AdministrarOrdenesT extends StatefulWidget {
  final Data data;
  final ParametrosOrden parametros;
  final Orden orden;
  AdministrarOrdenesT({Key key,this.data,this.parametros,this.orden}) : super();
  @override
  _AdministrarOrdenesTState createState() => _AdministrarOrdenesTState();
}

class _AdministrarOrdenesTState extends State<AdministrarOrdenesT> {
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  TextEditingController _controller = TextEditingController();
  List<Widget> lista =[];
  List<Orden> ordenes=[];
  DateTime parseFinal,parseInicial;
  Orden consulta;
  ProgressDialog ms;
  List<Orden> selectedOrders;
  bool refrescar = false,borrar=false;
  bool sort,cambiar,validar,preliminar;
  String dropdownValue = 'Opciones';
  String dropdownDoc = 'Seleccione un tipo de Documento';
  String _token,tipo;
  String mensaje,texto;
  int marcaFinal;
  int marcaInicial;
  final format = DateFormat("dd/MM/yyyy");
  String eliminarUsuario='Usuario Eliminado Correctamente';
  var validarFecha='Por favor ingresar la Fecha Inicial y la Fecha Final para realizar la consulta de información';
  var info='No se encontraron resultados para esta consulta';
  var error="La Fecha Inicial debe ser inferior o igual a la Fecha Final";
  var opcion='Por favor seleccionar un tipo de Documento';
  var parametroFechaI;
  var parametroFechaF;
   @override
  void initState() {
    preliminar= false;
    sort = false;
    cambiar = false;
    selectedOrders=[];
    
  widget.data;
  if(widget.parametros!=null)
  {
    parametroFechaI = widget.parametros.parametroFechaI;
    parametroFechaF=widget.parametros.parametroFechaF;
    var marcaI=widget.parametros.fechaParametroI;
    var marcaF=widget.parametros.fechaParametroF;
    _endTimeController.text=parametroFechaF;
    _startTimeController.text=parametroFechaI;
    marcaInicial=marcaI;
    marcaFinal=marcaF;
    cambiar=true;
    if(widget.orden!=null)
    { 
      if(widget.orden.tipo =='FondoSocial')
      {
        dropdownDoc='Fondo Social';
      }
      if(widget.orden.tipo =='DonacionesCenicana')
      {
        dropdownDoc='Donaciones Cenicaña';
      }
      if(widget.orden.tipo =='Retenciones')
      {
        dropdownDoc='Retención';
      }
      if(widget.orden.tipo =='IngresosYCostos')
      {
        dropdownDoc='Ingr.Cost';
      }
      if(widget.orden.tipo =='Ica')
      {
        dropdownValue='ICA';
      }
      if(widget.orden.tipo =='LiquidacionAnticipos')
      {
        dropdownDoc='Anticipos';
      }
      if(widget.orden.tipo =='LiquidacionCana')
      {
        dropdownDoc='Liquidación Caña';
      } 

    }
    
  }
  super.initState();
}
    onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        ordenes.sort((a, b) => a.orden_procesamiento_id.compareTo(b.orden_procesamiento_id));
      } else {
        ordenes.sort((a, b) => b.orden_procesamiento_id.compareTo(a.orden_procesamiento_id));
      }
    }
  }
 
  onSelectedRow(bool selected, Orden ord) async {
    setState(() {
      if (selected) {
        selectedOrders.add(ord);
      } else {
        selectedOrders.remove(ord);
      }
    });
  }

    deleteSelected() async {
    setState(() {
      if (selectedOrders.isNotEmpty) {
        List<Orden> temp = [];
        temp.addAll(selectedOrders);
        for (Orden ord in temp) {
          eliminar();
          ordenes.remove(ord);
          selectedOrders.remove(ord);  
       }
        successDialog(
          context, 
          'Orden Eliminada Correctamente',
          neutralText: "Aceptar",
          neutralAction: (){
          },
        );
       
      }else
      {
        warningDialog(
          context, 
          'Por favor seleccione una Orden',
            negativeAction: (){
          },
        );
      }
    });
  }

  eliminar(){
    var session= Conexion();
    session.set_token(widget.data.token);
    var orden= Ordenes(session);
    borrar=true; 
    for (int i = 0;i<selectedOrders.length; i++){
    var parametro=selectedOrders[i].orden_procesamiento_id;
        orden.eliminar_orden(parametro).then((_){  
                
        });
    }
  }

  Future <List<Orden>> listar_ordenes(tipo,ini,fin)async{
  var session= Conexion();
  session.set_token(widget.data.token);
  var orden= Ordenes(session);
  if(tipo =='Fondo Social')
  {
    tipo='FondoSocial';
  }
  if(tipo =='Donaciones Cenicaña')
  {
    tipo='DonacionesCenicana';
  }
  if(tipo =='Retenciones')
  {
    tipo='Retenciones';
  }
  if(tipo =='Ingresos y Costos')
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

  if(selectedOrders.length > 0){
      return ordenes;
  }else if(borrar==true)
  {
    return ordenes;
  }
  else
  {//1618894800.0 1618981199.0
    ordenes=[];
    await orden.listar_ordenes(tipo,ini.toInt(),fin.toInt()).then((_){
    var preOrdenes=orden.obtener_ordenes();
      for ( var usuario in preOrdenes)
      {
      ordenes.add(usuario);
      } 
      print(preOrdenes);
      preOrdenes=[];       
    });
    return ordenes;
  }
  
  }

  distribuir(id,tipo,preliminar) async{
    var tipo=selectedOrders[0].tipo;
    var session= Conexion();
    session.set_token(widget.data.token);
    var verDocumentos= AdministrarDocumentos(session);
    var token=widget.data.token;
    var preEntrada;
    ms = new ProgressDialog(context);
    ms.style(message:'Se estan distribuyendo los archivos,esto puede tardar unos minutos'); 
    await ms.show();
    await verDocumentos.distribuir(id,tipo,preliminar).then((_){   
      setState(() {
        ms.hide();
        Orden orden = selectedOrders[0];
        Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => VerDistribucion(data:widget.data,orden:orden,)));
        // infoDialog(
        //   context, 
        //   'Se reali la distribución correctamente',
        //   negativeAction: (){
        //   },
        // );
      });     
    });
  }
  @override
  Widget build(BuildContext context) {
    var menu = new Menu(data:widget.data,retorno:'');
    var encabezado= new Encabezado(data:widget.data,titulo:'Admin. Órdenes',);
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
              height:1500,
              color:Colors.white,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Container(
                        padding: EdgeInsets.fromLTRB(110, 10, 56,0),
                        color:Colors.white,
                        child:boton(),
                      )
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                    Container(
                    width: 400,
                    color:Colors.white,
                    padding: EdgeInsets.fromLTRB(110, 30, 30, 10),
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
                              var marcaIniP=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0];
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
                              lastDate: DateTime(2100));
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
                      padding: EdgeInsets.fromLTRB(70, 30, 56, 10),
                      child:DateTimeField(
                        controller:_endTimeController,
                        onChanged: (text) {
                          if(_startTimeController.text!="")
                          { 
                            var fechaicambio=_startTimeController.text.split('/');
                            var fechafcambio=_endTimeController.text.split('/');
                            var ini=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0]+' 00:00:00';
                            var fin=fechafcambio[2]+'-'+fechafcambio[1]+'-'+fechafcambio[0]+' 23:59:59';
                            var marcaIniP=fechaicambio[2]+'-'+fechaicambio[1]+'-'+fechaicambio[0];
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
                    // Container(
                    //     padding: EdgeInsets.fromLTRB(70, 30, 56,0),
                    //     color:Colors.white,
                    //     child:boton(),
                    // )
                    Container(
                      width: 330,
                      color:Colors.white,
                      child:tipoDoc(context),
                    ),
                    Container(
                      color:Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(70, 42, 56, 10),
                            child:Container(
                              width: 280,
                              height: 35,
                              decoration: BoxDecoration(
                              //color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              ),
                              child: RaisedButton(
                                textColor: Color.fromRGBO(83, 86, 90, 1.0),
                                //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                                color: Color.fromRGBO(56, 124, 43, 1.0),
                                child: Text('Buscar', style: TextStyle(
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
                                    setState(() {
                                      cambiar=true;
                                    });
                                  },
                              ),
                            ),
                          ),  
                        ],
                      ),   
                    ),
                  ]),
                  // SizedBox(height:30,),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children:[
                  //   Container(
                  //     width: 400,
                  //     color:Colors.white,
                  //     child:tipoDoc(context),
                  //   ),
                  //   Container(
                  //     color:Colors.white,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: <Widget>[
                  //         Padding(
                  //           padding: EdgeInsets.fromLTRB(70, 10, 56, 10),
                  //           child:Container(
                  //             width: 280,
                  //             height: 35,
                  //             decoration: BoxDecoration(
                  //             //color: Colors.white,
                  //             borderRadius: BorderRadius.circular(14),
                  //             ),
                  //             child: RaisedButton(
                  //               textColor: Color.fromRGBO(83, 86, 90, 1.0),
                  //               //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                  //               color: Color.fromRGBO(56, 124, 43, 1.0),
                  //               child: Text('Buscar', style: TextStyle(
                  //                   color: Colors.white,
                  //                   //Color.fromRGBO(83, 86, 90, 1.0),
                  //                   fontSize: 18,
                  //                   fontWeight: FontWeight.bold
                  //               )),
                  //               shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(50.0),
                  //                 //side: BorderSide(color: Colors.white)
                  //               ),
                  //                 onPressed: () {
                  //                   setState(() {
                  //                     cambiar=true;
                  //                   });
                  //                 },
                  //             ),
                  //           ),
                  //         ),  
                  //       ],
                  //     ),   
                  //   ),
                  // ]
                  // ),
                  SizedBox(height:30),
                  cambiar?dataTable(tipo,marcaInicial,marcaFinal):Container(color:Colors.white,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget boton(){
    var token=widget.data.token;
    return DropdownButton<String>(
      value: dropdownValue,
      // icon: Icon(Icons.arrow_circle_down_rounded),
      // iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black,fontSize: 16),
      underline: Container(
        height: 2,
        color: Colors.green,
      ),
      onChanged: (String newValue) {
        if(newValue=='Eliminar')
        {
          deleteSelected();
        }else if(newValue=='Editar')
        {
          if(selectedOrders.length < 1)
          {
            warningDialog(
            context, 
            'Por favor seleccione una orden',
            negativeAction: (){
            },
          );
          }else if(selectedOrders.length > 1)
          {   
            warningDialog(
            context, 
            'Por favor seleccione solo una orden',
            negativeAction: (){
            },
            );
          }
          else{
            Orden orden = selectedOrders[0];
            final parametro=ParametrosOrden(
              parametroFechaI:_startTimeController.text,
              parametroFechaF:_endTimeController.text,
              fechaParametroF:marcaFinal,
              fechaParametroI:marcaInicial
            );
            Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => EditarOrden(true,data:widget.data,orden:orden,parametros:parametro,))); 
          }
        }else if(newValue=='Cargar Archivo')
        {
          if(selectedOrders.length < 1)
          {
            warningDialog(
            context, 
            'Por favor seleccione una orden',
            negativeAction: (){
            },
          );
          }else if(selectedOrders.length > 1)
          {   
            warningDialog(
            context, 
            'Por favor seleccione solo una orden',
            negativeAction: (){
            },
            );
          }
          else{
           Orden orden = selectedOrders[0];
            Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => RecargaDocumentos(data:widget.data,ordenModificar:orden ,)));
          }
        }else if(newValue=='Distribuir')
        {
          if(selectedOrders.length < 1)
          {
            warningDialog(
            context, 
            'Por favor seleccione una orden',
            negativeAction: (){
            },
          );
          }else if(selectedOrders.length > 1)
          {   
            warningDialog(
            context, 
            'Por favor seleccione solo una orden',
            negativeAction: (){
            },
            );
          }
          else{
           Orden orden = selectedOrders[0];
            var estadoOrden=orden.estado;
            var evaluarEstado=estadoOrden.split(" ");
            var valorEstado=evaluarEstado[0];
            if(valorEstado!='Procesamientos')
            {
              infoDialog(
                context, 
                'Su distribución es:',
                negativeText: "Preliminar",
                negativeAction: (){
                  var tipoDistribuir=orden.tipo.toString();
                  var ordenPocesamiento=orden.orden_procesamiento_id.toString();
                  distribuir(ordenPocesamiento,tipoDistribuir,preliminar=true);
                },
                neutralText: "Final",
                neutralAction: (){
                  var tipoDistribuir=orden.tipo.toString();
                  var ordenPocesamiento=orden.orden_procesamiento_id.toString();
                  distribuir(ordenPocesamiento,tipoDistribuir,preliminar=false);
                },
              );
            }else
            {
              warningDialog(
                context, 
                'La orden ya esta distribuida',
                negativeAction: (){
                },
              );
            }
          }
        }
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Opciones', 'Editar', 'Eliminar','Cargar Archivo','Distribuir']
      .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
Widget tipoDoc(context){
  return Container(
    width: 250,
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.fromLTRB(60, 32, 20,10),
    decoration: BoxDecoration(
    border: Border(bottom:BorderSide(width: 1,
      color: Color.fromRGBO(83, 86, 90, 1.0),),
    ),
    ),
    child:
      DropdownButtonHideUnderline(
        child:DropdownButton<String>(
        hint: Padding(
          padding: const EdgeInsets.fromLTRB(5, 1, 2,5),
          child: Center(
            child:Text('Seleccione un tipo de Documento', textAlign: TextAlign.center,style: TextStyle(
              fontSize: 15.0,
              fontFamily: 'Karla',
            ),
            ),
          ),
        ),
        value: dropdownDoc,
          //icon: Icon(Icons.arrow_circle_down_rounded),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.black,fontSize: 15),
          underline: Container(
            height: 2,
            color: Colors.green,
          ),
          onChanged: (newValueLiq) {
            if(newValueLiq!='Seleccione un tipo de Documento' ||( _startTimeController.text!='' && _endTimeController.text!='')) {  
              setState(() {
                dropdownDoc = newValueLiq;
                if(newValueLiq =='Fondo Social')
                {
                  tipo='FondoSocial';
                }
                if(newValueLiq =='Donaciones Cenicaña')
                {
                  tipo='DonacionesCenicana';
                }
                if(newValueLiq =='Retenciones')
                {
                  tipo='Retenciones';
                }
                if(newValueLiq =='Ingresos y Costos')
                {
                  tipo='IngresosYCostos';
                }
                if(newValueLiq =='ICA')
                {
                  tipo='Ica';
                }
                if(newValueLiq =='Anticipos')
                {
                  tipo='LiquidacionAnticipos';
                }
                if(newValueLiq =='Liquidación Caña')
                {
                  tipo='LiquidacionCana';
                }
                if(newValueLiq =='Ajuste de Mercado Excedentario')
                {
                  tipo='LiquidacionMercadoExcedentario';
                }          
              }); 
            } else { 
              setState(() {
                dropdownDoc = newValueLiq;
                warningDialog(
                context, 
                error,
                negativeAction: (){
                },
              );
              }); 
            }
          },
          items: <String>['Seleccione un tipo de Documento','Anticipos', 'Liquidación Caña', 'Ajuste de Mercado Excedentario','Donaciones Cenicaña','Fondo Social','Retenciones','Ingresos y Costos','ICA']
          .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              //child: Center(
                    child:Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5,20,10),
                      child:new Text(value,textAlign: TextAlign.center,
                        style: new TextStyle(color: Colors.black)
                      ),
                    ),
                    //),
            );
          }).toList(),
      ),),
  );
}

Widget  dataTable(tipo,ini,fin) {
  return FutureBuilder <List<Orden>>(
    future:listar_ordenes(tipo,ini,fin),
    builder:(context,snapshot){
      if(snapshot.hasData){
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
                        label: Text("Id",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Id",
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            sort = !sort;
                          });
                          onSortColum(columnIndex, ascending);
                        }
                      ),
                      DataColumn(
                        label: Text("Tipo",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Tipo",
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            sort = !sort;
                          });
                          onSortColum(columnIndex, ascending);
                        }
                      ),
                      DataColumn(
                        label: Text("Estado",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Estado",
                      ),
                      DataColumn(
                        label: Text("Distribución",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Distribución",
                      ),
                      DataColumn(
                        label: Text("Fecha",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Fecha",
                      ),
                      DataColumn(
                        label: Text("Notas",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Notas",
                      ),
                      DataColumn(
                        label: Text("Creada Por",style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:15,
                        )),
                        numeric: false,
                        tooltip: "Creada Por",
                      ),
                      ],
                      rows: ordenes.map(
                        (ord) => DataRow(
                            selected: selectedOrders.contains(ord),
                            onSelectChanged: (b) {
                              print("Onselect");
                              onSelectedRow(b, ord);
                            },
                            cells: [
                              DataCell(
                                Text(ord.orden_procesamiento_id),
                                onTap: () {
                                  print('Selected ${ord.orden_procesamiento_id}');
                                },
                              ),
                              DataCell(
                                Text(ord.descripcion_tipo),
                              ),
                              DataCell(
                                Text(ord.estado),
                              ),
                              DataCell(
                                Text(ord.preliminar?"Preliminar":"Final"),
                              ),
                              DataCell(
                                Text(ord.creation_stamp.toString()),
                              ),
                              DataCell(
                                Text(ord.notas),
                              ),
                              DataCell(
                                Text(ord.created_by),
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
          //Splash1(),
        );
      }
      },
    );
}

Widget  dataTableVacia(tipo,ini,fin) {
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
                label: Text("Nombre"),
                numeric: false,
                tooltip: "Nombre Completo",
                onSort: (columnIndex, ascending) {
                  setState(() {
                      sort = !sort;
                  });
                  onSortColum(columnIndex, ascending);
                }
              ),
              DataColumn(
                label: Text("Id"),
                numeric: false,
                tooltip: "Id",
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sort = !sort;
                  });
                   onSortColum(columnIndex, ascending);
                }
              ),
              DataColumn(
                label: Text("Tipo"),
                numeric: false,
                tooltip: "Tipo",
              ),
              DataColumn(
                label: Text("Estado"),
                numeric: false,
                tooltip: "Estado",
              ),
              DataColumn(
                label: Text("Creada Por"),
                numeric: false,
                tooltip: "Creada Por",
              ),
            ],
            rows: ordenes
              .map(
                (ord) => DataRow(
                        selected: selectedOrders.contains(ord),
                        onSelectChanged: (b) {
                          print("Onselect");
                          onSelectedRow(b, ord);
                        },
                        cells: [
                          DataCell(
                            Text(ord.orden_procesamiento_id),
                            onTap: () {
                              print('Selected ${ord.orden_procesamiento_id}');
                            },
                          ),
                          DataCell(
                            Text(ord.tipo),
                          ),
                          DataCell(
                            Text(ord.estado),
                          ),
                          DataCell(
                            Text(ord.creation_stamp.toString()),
                          ),
                           DataCell(
                            Text(ord.created_by),
                          ),
                        ]),
              ).toList(),
          ),
        ),
    );
}
}


