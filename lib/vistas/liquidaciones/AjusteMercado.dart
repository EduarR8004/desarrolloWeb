import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:proveedores_manuelita/logica/AdministrarDocumentos.dart';
import 'dart:js' as js;
import 'dart:html' as html;

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
import 'package:proveedores_manuelita/vistas/liquidaciones/Liquidaciones.dart';
import 'package:proveedores_manuelita/vistas/menu.dart';
import 'package:proveedores_manuelita/vistas/verPdf/PdfViewPage.dart';

class VerMercado extends StatefulWidget {
  final Data data;
  
  VerMercado ({Key key,this.data}) : super();

  @override
  _VerMercadoState createState() => _VerMercadoState();
}

class _VerMercadoState extends State<VerMercado> {
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  var validarFecha='Por favor ingresar la Fecha Inicial y la Fecha Final para realizar la consulta de información';
  var info='No se encontraron resultados para esta consulta';
  var error="La Fecha Inicial debe ser inferior o igual a la Fecha Final";
  var opcion='Por favor seleccionar un tipo de Liquidación';
  bool sort;
  bool borrar = false;
  bool cambiar,tabla,detalle,mensaje,anticipo,liquidacion,mercado,ocultar,mostrarhacienda,hacienda;
  String selectedRegion,haciendaUnica;
  List <EntradaCana>_entrada=[];
  List<EntradaCana> _region = [];
  List <EntradaCana>entrada=[];
  List <Liquidacion>entradaGeneral=[];
  List <Ajuste>entradaAjuste=[];
  List <Ajuste>entradaAnticipo=[];
  List <EntradaCana>pasoParametro=[];
  List<String> objetos=[];
  int agnoAnterior;
  ProgressDialog ms;
  String _url='https://proveedores-cana.manuelita.com/';
  String urlPDFPath = "";
  //List <String> listaAgno=['2050'	,'2049'	,'2048'	,'2047'	,'2046'	,'2045'	,'2044'	,'2043'	,'2042'	,'2041'	,'2040'	,'2039'	,'2038'	,'2037'	,'2036'	,'2035'	,'2034'	,'2033'	,'2032'	,'2031'	,'2030'	,'2029'	,'2028'	,'2027'	,'2026'	,'2025'	,'2024'	,'2023'	,'2022'	,'2021'	,'2020'	,'2019'	,'2018'	,'2017'	,'2016'	,'2015'	,'2014'	,'2013'	,'2012'	,'2011'	,'2010'	,'2009'	,'2008'	,'2007'	,'2006'	,'2005'	,'2004'	,'2003'	,'2002'	,'2001'	,'2000'	,'1999'	,'1998'	,'1997'	,'1996'	,'1995'	,'1994'	,'1993'	,'1992'	,'1991'	,'1990'	,'1989'	,'1988'	,'1987'	,'1986'	,'1985'	,'1984'	,'1983'	,'1982'	,'1981'	,'1980'	,'1979'	,'1978'	,'1977'	,'1976'	,'1975'	,'1974'	,'1973'	,'1972'	,'1971'	,'1970'	,'1969'	,'1968'	,'1967'	,'1966'	,'1965'	,'1964'	,'1963'	,'1962'	,'1961'	,'1960'	,'1959'	,'1958'	,'1957'	,'1956'	,'1955'	,'1954'	,'1953'	,'1952'	,'1951'	,'1950'	,'1949'	,'1948'];
  List <String> listaAgno=['2050'	,'2049'	,'2048'	,'2047'	,'2046'	,'2045'	,'2044'	,'2043'	,'2042'	,'2041'	,'2040'	,'2039'	,'2038'	,'2037'	,'2036'	,'2035'	,'2034'	,'2033'	,'2032'	,'2031'	,'2030'	,'2029'	,'2028'	,'2027'	,'2026'	,'2025'	,'2024'	,'2023'	,'2022'	,'2021'	,'2020'	,'2019'	,'2018'	,'2017'	,'2016'	,'2015'	,'2014'	,'2013'	,'2012'	,'2011'	,'2010'	,'2009'	,'2008'	,'2007'	,'2006'	,'2005'	,'2004'	,'2003'	,'2002'	,'2001'	,'2000'	,'1999'	,'1998'	,'1997'	,'1996'	,'1995'	,'1994'	,'1993'	,'1992'	,'1991'	,'1990'];
  String dropdownValue,formatoAgnoAnterior,dropdownAgnoInicial,dropdownAgnoFinal,newValueLiq,valorLiquidacion;
  var now = new DateTime.now();
  Map total;
  int contador=0;
  var parametro;
  var codParametro;
  var codRespeuesta;
  var inicial;
  var fin;
  var fecha_i;
  var fecha_f;
  final format = DateFormat("dd/MM/yyyy");

 @override
  void initState() {
    sort = false;
    tabla = true;
    detalle = true;
    cambiar = true;
    anticipo= false;
    liquidacion= false;
    mercado= true;
    ocultar= true;
    newValueLiq='';
    valorLiquidacion='';
    var formatter =  DateFormat("yyyy");
    String fomatoAgno = formatter.format(now);
    agnoAnterior= int.parse(fomatoAgno)-1;
    formatoAgnoAnterior=agnoAnterior.toString();
    dropdownValue ='Ajuste de Mercado Excedentario';
    dropdownAgnoInicial=formatoAgnoAnterior;
    dropdownAgnoFinal=fomatoAgno;
    mostrarhacienda=false; 
    hacienda=false; 
    widget.data;
    _endTimeController;
    _endTimeController;
    super.initState();
  }
  List <MultiSelectDialogItem<int>> multiItem = List();

  final valuestopopulate = {
    0 : "Seleccione Las Columnas A Visualizar",
    1 : "Hacienda",
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
      for(int x in selection.toList()){
        print(valuestopopulate[x]);
        if(valuestopopulate[x]=='Hacienda')
        { setState(() {
            hacienda=true;
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
    }else{
      setState(() {
        x.remove(1);
        hacienda=false;
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

  Widget convertirMoneda( String valor){
    double flutterBalance=double.parse(valor);
    var oCcy = new NumberFormat.currency(locale: 'eu', customPattern: '\u0024 #,##.#');
    String formatted = oCcy.format(flutterBalance);
    return  Text(formatted,textAlign: TextAlign.center);
  }

  mostrar(){
    if(mercado==true)
    { 
      return dataTableAjuste(dropdownAgnoInicial,dropdownAgnoFinal,codParametro);
    }
    if(tabla==true)
    {
      return tablaVacia();
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
 
  Widget lista(){
    var token=widget.data.token;
    return Container(
      width: 300,
      height: 40,
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.fromLTRB(35, 5, 10,10),
      decoration: BoxDecoration(
        border: Border(
          bottom:BorderSide(
            width: 1,
            color: Color.fromRGBO(83, 86, 90, 1.0),
          ),
        ),
      ),
      child:
      DropdownButtonHideUnderline(
        child:DropdownButton<String>(
          hint: Padding(
            padding: const EdgeInsets.all(0),
            child: Center(
              child:Text('Ajuste de Mercado Excedentario', textAlign: TextAlign.left,style: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              fontFamily: 'Karla',
            ),),),
          ),
          value: dropdownValue,
          // icon: Icon(Icons.arrow_circle_down_rounded),
          // iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.black,fontSize: 15),
          underline: Container(
            height: 2,
            color: Colors.green,
          ),
          onChanged: (newValueLiq) {
            if(newValueLiq!='Ajuste de Mercado Excedentario')
            {   
              setState(() {
                dropdownValue = newValueLiq;
              });
              WidgetsBinding.instance.addPostFrameCallback((_) { 
                                  Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => VerLiquidaciones (data:widget.data,tipo:newValueLiq,),)); });   
            }else
            { 
              int numeroFi=int.parse(dropdownAgnoInicial);
              int numeroFf=int.parse(dropdownAgnoFinal);
              if(numeroFi < numeroFf || numeroFi == numeroFf )
              {
                setState(() {
                  dropdownValue = newValueLiq;
                  mercado=true;
                  tabla=false;
                  contador=0;
                });       
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
            }
          },
          items: <String>['Anticipos', 'Liquidación Caña','Ajuste de Mercado Excedentario']
            .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              //child: Center(
                child:Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5,40,10),
                  child:new Text(
                    value,textAlign: TextAlign.left,
                    style: new TextStyle(color: Colors.black)
                  ),
                ),
              //),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget listaAgnoInicial(){
    return Container(
      height: 40,
      width: 150,
      //alignment: Alignment.topLeft,
      margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
      //margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border(bottom:BorderSide(width: 1,
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
                ),
                ),
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
            onChanged: (String newValue) {
              int numeroFi=int.parse(newValue);
              int numeroFf=int.parse(dropdownAgnoFinal);
              if(numeroFi < numeroFf || numeroFi == numeroFf )
              {
                setState(() {
                contador=0;
                mercado=true;
                dropdownAgnoInicial= newValue;
                });       
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
            items:listaAgno
            .map<DropdownMenuItem<String>>((String value) {
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
    width: 150,
    //alignment: Alignment.topLeft,
    margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
    decoration:BoxDecoration(
      border: Border(bottom:BorderSide(width: 1,
        color: Color.fromRGBO(83, 86, 90, 1.0),
      ),
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
            if(numeroFi < numeroFf || numeroFi == numeroFf )
            {
              setState(() {
                contador=0;
                mercado=true;
                dropdownAgnoFinal= newValue;
              });         
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
          items:listaAgno
          .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value,textAlign: TextAlign.left),
            );
          }).toList(),
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
        cambiar?codParametro='':codParametro=codRespeuesta;
        return 
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget>[
              SizedBox(height:20),
              Row(
              mainAxisAlignment:MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Column(
                  mainAxisAlignment:MainAxisAlignment.start,
                  children:[
                    SizedBox(height:30),
                    mostrar(),
                  ]
                  ),
                  SizedBox(width:30),
                  Column(
                    mainAxisAlignment:MainAxisAlignment.start,
                    children:[
                      SizedBox(height:20),
                      Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:[
                            Container(
                              padding:const EdgeInsets.fromLTRB(10, 0, 10, 10) ,
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
                              padding:const EdgeInsets.fromLTRB(40, 10, 5, 10) ,
                              child:
                              Text('Año Inicial'),
                            ),
                            listaAgnoInicial(),
                          ]),
                      ),
                      Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                        child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                              padding:const EdgeInsets.fromLTRB(40, 10,15, 10) ,
                              child:Text('Año Final'),
                            ),
                            listaAgnoFinal(),
                          ]),
                      ),
                      lista(),
                      Container(
                        width: 300,
                        height: 40,
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.fromLTRB(30, 10, 0,10),
                        decoration: BoxDecoration(
                        border: Border(bottom:BorderSide(width: 1,
                                  color: Color.fromRGBO(83, 86, 90, 1.0),),),
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
                            ),),),
                            ),
                            value:selectedRegion,
                            isDense: true,
                            onChanged: (String newValue) {
                              if(dropdownAgnoInicial!=''&& dropdownAgnoFinal!="")
                              {  
                                int numeroFi=int.parse(dropdownAgnoInicial);
                                int numeroFf=int.parse(dropdownAgnoFinal);
                                if(numeroFi < numeroFf || numeroFi == numeroFf )
                                {
                                  setState(() {
                                    parametro=entrada.where((a) => a.nm_hda==newValue);
                                    codRespeuesta=parametros(parametro);
                                    cambiar = false;
                                    detalle = true;
                                    contador=0;
                                    selectedRegion = newValue;
                                  });
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
                                
                            print(selectedRegion);
                            },
                            items: _entrada.map((EntradaCana map) {
                              return new DropdownMenuItem<String>(
                                value: map.nm_hda,
                                child:Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 5, 18,2),
                                  child:new Text(map.cod_hda+' - '+map.nm_hda,textAlign: TextAlign.left,
                                    style: new TextStyle(color: Colors.black)
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  )
                ]
              ),
                // SizedBox(height:2),
                // Container(
                // padding:const EdgeInsets.fromLTRB(10, 0, 0,0),
                // alignment: Alignment.bottomLeft,
                // child:Row(children:[
                //   RaisedButton(
                //       textColor: Color.fromRGBO(83, 86, 90, 1.0),
                //       //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                //       color: Color.fromRGBO(56, 124, 43, 1.0),
                //       child: Text('Más Info', style: TextStyle(
                //         color: Colors.white,
                //         //Color.fromRGBO(83, 86, 90, 1.0),
                //         fontSize: 16,
                //         fontWeight: FontWeight.bold
                //       )),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(50.0),
                //         //side: BorderSide(color: Colors.white)
                //       ),
                //       onPressed: () {
                //         _showMultiSelect(context);
                //       },
                //   ),
                // ]),
                // ),
                
            ],
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
            Center(
              child: 
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
          //Splash1(),
        );
      }
      },
    );
  }

  Future <List<Ajuste>> listar_ajuste(ini,fin,cod_hda)async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var liquidaciones= Liquidaciones(session);
    var token=widget.data.token;
    var preEntrada;
    await liquidaciones.listar_ajuste(ini,fin,cod_hda).then((_){
    entradaAjuste=[];
    preEntrada=liquidaciones.obtener_ajustes();
    for ( var tabla_informe in preEntrada)
    {
      entradaAjuste.add(tabla_informe );
    }   
    preEntrada=[]; 
    });
    preEntrada=[]; 
    if(entradaAjuste.length > 0)
    {
      tabla = false;
      mercado = true;
      return entradaAjuste;
    }
    else{
      contador++;
      setState(() {
        tabla = true;
        mercado = false;
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

  Widget  dataTableAjuste(ini,fin,cod_hda) {
    return FutureBuilder <List<Ajuste>>(
      future:listar_ajuste(ini,fin,cod_hda),
      builder:(context,snapshot){
        if(snapshot.hasData){
          var textStyle = TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize:15,);
          contador=0;
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
                        label: mostrarhacienda?Expanded(child:Text("Hacienda",textAlign: TextAlign.center,style: textStyle)):Container(),
                        numeric: false,
                        tooltip: "Hacienda",
                      ),
                      DataColumn(
                        label:Expanded(child: Text("Fecha Liquidación",textAlign: TextAlign.center,style: textStyle)),
                        numeric: false,
                        tooltip: "Fecha Liquidación",
                      ),
                      DataColumn(
                        label: Expanded(child:Text("Valor",textAlign: TextAlign.center,style: textStyle)),
                        numeric: false,
                        tooltip: "Valor",
                      ),
                      DataColumn(
                        label: Expanded(child:Text("Detalle Liquidación",textAlign: TextAlign.center,style: textStyle)),
                        numeric: false,
                        tooltip: "Detalle Liquidación",
                      ),
                    ],
                    rows: entradaAjuste.map(
                      (entradaG) => DataRow(
                        cells: [
                          DataCell(
                            mostrarhacienda?Center(child:Text(entradaG.predio,textAlign: TextAlign.center,)):Container(),
                          ),
                          DataCell(
                            Center(child:Text(entradaG.fecha,textAlign: TextAlign.center,)),
                            //Text(entradaG.fecha,textAlign: TextAlign.center,),
                          ),
                          DataCell(
                            Center(child:convertirMoneda(entradaG.valor),),
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
          MaterialStateColor.resolveWith((states) =>Color.fromRGBO(56, 124, 43, 1.0) ),
          //Color.fromRGBO(136,139, 141, 1.0)
          sortAscending: sort,
          sortColumnIndex: 0,
          horizontalMargin:10,
          columnSpacing:10,
            columns: [
              DataColumn(
                label: Text("Fecha Liquidación"),
                numeric: false,
                tooltip: "Fecha Liquidación",
              ),
              DataColumn(
                label: Text("Valor"),
                numeric: false,
                tooltip: "Valor",
              ),
              DataColumn(
                label: Text("Detalle Liquidación"),
                numeric: false,
                tooltip: "Detalle Liquidación",
              ),
            ],
            rows: entradaGeneral
            .map(
              (entradaG) => DataRow(
                cells: [
                  DataCell(
                    Text(entradaG.fecha,textAlign: TextAlign.center,),
                  ),
                  DataCell(
                    Text(entradaG.ton_cana,textAlign: TextAlign.center,),
                  ),
                  DataCell(
                    Text(entradaG.rto_real_ing,textAlign: TextAlign.center,),
                  ), 
                                     
                ]),
            ).toList(),
        ),
      ),
    );
  }
}

