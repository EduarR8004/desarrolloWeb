import 'package:flutter/material.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/logica/AsistenciasTecnicas.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/vistas/encabezado/Encabezado.dart';
import 'package:proveedores_manuelita/vistas/menu.dart';

class AdminRecomendacion extends StatefulWidget {
   final Data data;

  AdminRecomendacion({Key key,this.data}) : super();
  @override
  _AdminRecomendacionState createState() => _AdminRecomendacionState();
}

class _AdminRecomendacionState extends State<AdminRecomendacion> {
  TextEditingController plantillaTexto= TextEditingController();
  TextEditingController socaTexto = TextEditingController();
  double tPlantilla,tSoca,iPlantilla,iSoca,texto,textoSeleccionado,espacio;
  bool mostrarPlantilla,mostrarSoca,soca,plantilla,cambiar,mostrarLista,botonAceptar;
  Color seleccionado=Color.fromRGBO(176,188, 34, 1.0);
  Color sombra=Colors.black45;
  Color borde=Color.fromRGBO(56, 124, 43, 1.0);
  String dropdownValue = 'Seleccione una Subcategoría';
  List <String> inicio=['Seleccione una Subcategoría',''];
  List <String> listaPlantilla=['Seleccione una Subcategoría','Adecuación','Preparación','Siembra','Riego de germinación','Pre-emergente','Fertilización','Riego de levante','Plagas y enfermedades','Agostamiento',];
  List <String> listaSocas=['Seleccione una Subcategoría','Encalle','Roturación','Resiembra','Fertilización','Control de malezas','Aporque','Riego de levante','Plagas y enfermedades','Agostamiento',];
  String categoria,subCategoria,respuesta;
  int contador=0;
  @override
  void initState() {
  tPlantilla=85;
  iPlantilla=50;
  tSoca=85;
  iSoca=50;
  soca=false;
  plantilla=false;
  mostrarPlantilla=false;
  mostrarSoca=false;
  mostrarLista=false;
  respuesta='';
  texto=15;
  botonAceptar=false;
  textoSeleccionado=18;
  espacio=5;
  super.initState();
  }

    Future <Map> almacenar_texto(categoria,subcategoria,texto)async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var recomendacion= AsistenciasTecnicas(session);
     if(subcategoria=='Adecuación')
    {
      subcategoria='Adecuacion';
    }
    if(subcategoria=='Preparación')
    {
      subcategoria='Renovacion';
    }
    if(subcategoria=='Siembra')
    {
      subcategoria='Siembra';
    }
    if(subcategoria=='Riego de germinación')
    {
      subcategoria='RiegoGerminacion';
    }
    if(subcategoria=='Pre-emergente')
    {
      subcategoria='ControlMalezaPreEmergente';
    }
    if(subcategoria=='Fertilización')
    {
      subcategoria='Fertilizacion';
    }
    if(subcategoria=='Riego de levante')
    {
      subcategoria='RiegoDeLevante';
    }
    if(subcategoria=='Plagas y enfermedades')
    {
      subcategoria='ControlPlagasYEnfermedades';
    }
    if(subcategoria=='Agostamiento')
    {
      subcategoria='Agostamiento';
    }
    if(subcategoria=='Encalle')
    {
      subcategoria='Encalle';
    }
    if(subcategoria=='Roturación')
    {
      subcategoria='Roturacion';
    }
    if(subcategoria=='Resiembra')
    {
      subcategoria='Resiembra';
    }
    if(subcategoria=='Control de malezas')
    {
      subcategoria='ControlDeMalezas';
    }
    if(subcategoria=='Aporque')
    {
      subcategoria='Aporque';
    }
    await recomendacion.almacenar_texto(categoria,subcategoria,texto).then((_){
      successDialog(
        context, 
        'Se publicó la recomendación correctamente',
        neutralText: "Aceptar",
        neutralAction: (){

        },
      );        
    });        
}

Future <String> recuperar_texto(categoria,subcategoria)async{
    var session= Conexion();
    session.set_token(widget.data.token);
    var recomendacion= AsistenciasTecnicas(session);
    Map textoRespuesta;
     if(subcategoria=='Adecuación')
    {
      subcategoria='Adecuacion';
    }
    if(subcategoria=='Preparación')
    {
      subcategoria='Renovacion';
    }
    if(subcategoria=='Siembra')
    {
      subcategoria='Siembra';
    }
    if(subcategoria=='Riego de germinación')
    {
      subcategoria='RiegoGerminacion';
    }
    if(subcategoria=='Pre-emergente')
    {
      subcategoria='ControlMalezaPreEmergente';
    }
    if(subcategoria=='Fertilización')
    {
      subcategoria='Fertilizacion';
    }
    if(subcategoria=='Riego de levante')
    {
      subcategoria='RiegoDeLevante';
    }
    if(subcategoria=='Plagas y enfermedades')
    {
      subcategoria='ControlPlagasYEnfermedades';
    }
    if(subcategoria=='Agostamiento')
    {
      subcategoria='Agostamiento';
    }
    if(subcategoria=='Encalle')
    {
      subcategoria='Encalle';
    }
    if(subcategoria=='Roturación')
    {
      subcategoria='Roturacion';
    }
    if(subcategoria=='Resiembra')
    {
      subcategoria='Resiembra';
    }
    if(subcategoria=='Control de malezas')
    {
      subcategoria='ControlDeMalezas';
    }
    if(subcategoria=='Aporque')
    {
      subcategoria='Aporque';
    }
    await recomendacion.recuperar_texto(categoria,subcategoria).then((_){
      textoRespuesta=recomendacion.establecer_texto();       
    });    
    if(categoria=='Socas'){
      respuesta=textoRespuesta['texto'].toString();
      socaTexto.text=respuesta;
      return respuesta;
    }else if(categoria=='Plantilla')
    {
      respuesta=textoRespuesta['texto'].toString();
      plantillaTexto.text=respuesta;
      return respuesta;
    }                  
}
  @override
  Widget build(BuildContext context) {
    var menu = new Menu(data:widget.data,retorno:'');
    var encabezado= new Encabezado(data:widget.data,titulo:'Asistencia Técnica',);
    return WillPopScope(
    onWillPop: () {  },
      child: SafeArea(
        child:Scaffold(
          appBar: new AppBar(
            flexibleSpace:encabezado, 
            backgroundColor: Colors.transparent,
          ),
          drawer: menu,
          body:SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  width: 800,
                  height: 120,
                  margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
                  child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:<Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              tPlantilla=60;
                              iPlantilla=35;
                              tSoca=60;
                              iSoca=35;
                              plantilla=true;
                              soca=false;
                              mostrarPlantilla=true;
                              mostrarSoca=false;
                              inicio=listaPlantilla;
                              categoria='Plantilla';
                              dropdownValue ='Seleccione una Subcategoría';
                              plantillaTexto.text='';
                              socaTexto.text='';
                              mostrarLista=true;
                              botonAceptar=true;
                            });
                          }, 
                          child:
                          Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                height: tPlantilla,
                                width: tPlantilla,
                                decoration: BoxDecoration(
                                  color:plantilla?seleccionado:Colors.white,
                                  border:Border.all(
                                    color:plantilla?seleccionado:Color.fromRGBO(56, 124, 43, 1.0),
                                    width:4,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: plantilla?Colors.black45:Colors.white,
                                      offset: Offset(6,6),
                                      blurRadius: 6,  
                                    ),
                                  ],
                                ),
                                child:Center(
                                  child: 
                                  Container(
                                    height: iPlantilla,
                                    width: iPlantilla,
                                    padding: new EdgeInsets.all(30.0),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                      image: AssetImage('images/PLANTILLAF.png'),
                                      fit: BoxFit.contain)),
                                  ) ,
                                ),
                              ),
                              SizedBox(height:10),
                              Text('Plantilla',style: TextStyle(
                                color: plantilla?seleccionado:Color.fromRGBO(83, 86, 90, 1.0),
                                fontSize:plantilla?textoSeleccionado:texto,
                                fontWeight: FontWeight.bold
                              ),
                              ),
                            ]
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              tPlantilla=60;
                              iPlantilla=35;
                              tSoca=60;
                              iSoca=35;
                              mostrarPlantilla=false;
                              mostrarSoca=true;
                              plantilla=false;
                              soca=true;
                              inicio=listaSocas;
                              categoria='Socas';
                              dropdownValue ='Seleccione una Subcategoría';
                              plantillaTexto.text='';
                              socaTexto.text='';
                              mostrarLista=true;
                              botonAceptar=true;
                            });
                          }, 
                          child:
                          Column(
                            children: <Widget>[
                              Container(
                              alignment: Alignment.center,
                              height: tSoca,
                              width: tSoca,
                              decoration: BoxDecoration(
                              color: soca?seleccionado:Colors.white,
                              border:Border.all(
                                color: soca?seleccionado:Color.fromRGBO(56, 124, 43, 1.0),
                                width:4,
                              ),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [BoxShadow(
                                color: soca?Colors.black45:Colors.white,
                                  offset: Offset(6,6),
                                  blurRadius: 6,  
                              ),
                              ],
                              ),
                              child:Center(
                                child: Container(
                                  height: iSoca,
                                  width: iSoca,
                                  padding: new EdgeInsets.all(30.0),
                                  decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('images/SOCASF.png'),
                                  fit: BoxFit.contain)),
                                ) ,
                              ),
                              ),
                              SizedBox(height:10),
                              Text('Socas',style: TextStyle(
                                color: soca?seleccionado: Color.fromRGBO(83, 86, 90, 1.0),
                                fontSize:soca?textoSeleccionado:texto,
                                fontWeight: FontWeight.bold
                              ),),
                            ]
                          ),
                        ),
                      ],
                    ),
                ),
                    //SizedBox(height:5),
                mostrarLista?boton():Container(),
                SizedBox(height:20),
                mostrarPlantilla?Container(
                  padding: new EdgeInsets.fromLTRB(5,0,5,0),
                  width: 800,
                  child:TextFormField(
                    controller:plantillaTexto,
                    minLines:null,
                    maxLines:null,
                    decoration: InputDecoration(
                      hintText: 'Recomendación Planilla',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ):Container(),
                mostrarSoca?Container(
                  width: 800,
                  padding: new EdgeInsets.fromLTRB(5,0,5,0),
                  child:TextFormField(
                    controller:socaTexto,
                    minLines:null,
                    maxLines:null,
                    decoration: InputDecoration(
                      hintText: 'Recomendación Soca',
                      border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ):Container(),
                SizedBox(height:10),
                botonAceptar?Container(
                  width: 300,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.fromLTRB(7,2, 5,5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                  ),
                  child: RaisedButton.icon(
                    textColor: Color.fromRGBO(83, 86, 90, 1.0),
                    //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                    color: Color.fromRGBO(56, 124, 43, 1.0),
                    icon: Icon(Icons.spa_rounded ,color:Colors.white ,),
                    label:Text('Aceptar', style: TextStyle(
                      color: Colors.white,
                      //Color.fromRGBO(83, 86, 90, 1.0),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    onPressed:(){
                      if(subCategoria =='Seleccione una Subcategoría' || dropdownValue =='Seleccione una Subcategoría')
                      { 
                          warningDialog(
                          context, 
                          'Por favor seleccione una Subcategoría',
                          negativeAction: (){
                          },
                        );
                      }else{
                        if(mostrarSoca==true && socaTexto.text!="" || mostrarPlantilla==true && plantillaTexto.text!="")
                        { 

                          mostrarPlantilla?almacenar_texto(categoria,subCategoria,plantillaTexto.text):almacenar_texto(categoria,subCategoria,socaTexto.text);
                        }
                        else{
                          warningDialog(
                          context, 
                          'Por favor ingrese un texto como recomendación',
                            negativeAction: (){
                            }
                          );
                        }
                      } 
                    },
                  ),
                ):Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget boton(){
    var token=widget.data.token;
    return Container(
      height: 40,
      margin: const EdgeInsets.fromLTRB(38, 5, 38,10),
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
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
            subCategoria=newValue;
            recuperar_texto(categoria,subCategoria);
          });
        },
        items:inicio
        .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child:Padding(
              padding: const EdgeInsets.fromLTRB(0, 5,25,10),
              child:new Text(value,textAlign: TextAlign.center,
                style: new TextStyle(color: Colors.black)
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}