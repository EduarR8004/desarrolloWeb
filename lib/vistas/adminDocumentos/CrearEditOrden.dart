import 'package:flutter/material.dart';
import 'package:proveedores_manuelita/logica/Ordenes.dart';
import 'dart:convert' show utf8;
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/modelos/Orden.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/utiles/Utiles.dart';
import 'package:proveedores_manuelita/vistas/adminDocumentos/AdminOrden.dart';


class EditarOrden extends StatefulWidget {
  final bool editar;
  Data data;
  final Orden orden;
  final ParametrosOrden parametros;
 
  EditarOrden(this.editar,{this.data,this.orden,this.parametros}): assert(editar == true || orden ==null);
 @override
 _EditarOrdenState createState() => _EditarOrdenState();
}

class _EditarOrdenState extends State<EditarOrden> {
var usuario_id;
var creacion="Rol creado correctamente\nDesea crear un nuevo Rol?";
FocusNode not;
String _token,tipo;
String dropdownValue;
bool pruebaTipo;
  @override
void initState() {
    super.initState();
    pruebaTipo=false;
    widget.parametros;
    if(widget.orden.tipo =='FondoSocial')
    {
      dropdownValue='Fondo Social';
    }
    if(widget.orden.tipo =='DonacionesCenicana')
    {
      dropdownValue='Donaciones Cenicaña';
    }
    if(widget.orden.tipo =='Retenciones')
    {
      dropdownValue='Retención';
    }
    if(widget.orden.tipo =='IngresosYCostos')
    {
      dropdownValue='Ingr.Cost';
    }
    if(widget.orden.tipo =='Ica')
    {
      dropdownValue='ICA';
    }
    if(widget.orden.tipo =='LiquidacionAnticipos')
    {
      dropdownValue='Anticipos';
    }
    if(widget.orden.tipo =='LiquidacionCana')
    {
      dropdownValue='Liquidación Caña';
    } 
    not = FocusNode();
    widget.data;
    if(widget.editar == true){
      notas.text =widget.orden.notas; 
    }
  }
 
 GlobalKey<FormState> keyForm = new GlobalKey();
 TextEditingController  orden = new TextEditingController();
 TextEditingController  notas = new TextEditingController();



editar_orden()async{
  var session= Conexion();
  session.set_token(widget.data.token);
  var ordenes= Ordenes(session);
  var nuevoTipo=pruebaTipo?tipo:widget.orden.tipo;
   await ordenes.editar_orden( id:widget.orden.orden_procesamiento_id,notas:notas.text,tipo:nuevoTipo).then((_){
     successDialog(
        context, 
        "Orden editada correctamente",
        neutralText: "Aceptar",
        neutralAction: (){
          final data = Data(
                            token:widget.data.token ,
                            obj: widget.data.obj,
                            usuario_actual:widget.data.usuario_actual, 
                            parametro:'');
                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => AdministrarOrdenesT(data:data,parametros:widget.parametros,orden:widget.orden ,))); 
        },
    );
  }).catchError( (onError){
     'Error interno '+ onError.toString();
     if(onError is SessionNotFound){
      //return 'Usuario o Contraseña Incorrecta';                
    }else if(onError is ConnectionError){

    errorDialog(
      context, 
      "Sin conexión al servidor",
      negativeAction: (){
      },
    );              
    }else{
                         
    }                                           
  });
}
 
@override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    orden.dispose(); 
    notas.dispose();
    super.dispose();
  }
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     home: new Scaffold(
      //  appBar: new AppBar(
      //    title: new Text('Registrarse'),
      //  ),
       body: new SingleChildScrollView(
         child: new Container(
           margin: new EdgeInsets.all(4.0),
           child: new Form(
             key: keyForm,
             child: formUI(),
           ),
         ),
       ),
     ),
   );
 }

 formItemsDesign(icon, item) {
   return Padding(
     padding: EdgeInsets.symmetric(vertical:4),
     child: Card(child: ListTile(leading: Icon(icon), title: item)),
   );
 }

   Widget lista(context){
    var token=widget.data.token;
    return Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.fromLTRB(30, 5, 30,10),
              decoration: BoxDecoration(
              border: Border(bottom:BorderSide(width: 1,
                        color: Color.fromRGBO(83, 86, 90, 1.0),),
              ),
              // borderRadius: BorderRadius.circular(10), 
              //color: Color.fromRGBO(83, 86, 90, 1.0),
              ),
              child:
              DropdownButtonHideUnderline(
              child:DropdownButton<String>(
                hint: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 1, 10,5),
                      child: Center(
                        child:Text(dropdownValue, textAlign: TextAlign.center,style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Karla',
                      ),),),),
                value: dropdownValue,
                //icon: Icon(Icons.arrow_circle_down_rounded),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black,fontSize: 15),
                underline: Container(
                  height: 2,
                  color: Colors.green,
                ),
                onChanged: (newValueLiq) {
                  setState(() {
                    dropdownValue = newValueLiq;
                    pruebaTipo=true;
                    if(newValueLiq =='Fondo Social')
                    {
                      tipo='FondoSocial';
                    }
                    if(newValueLiq =='Donaciones Cenicaña')
                    {
                      tipo='DonacionesCenicana';
                    }
                    if(newValueLiq =='Retención')
                    {
                      tipo='Retenciones';
                    }
                    if(newValueLiq =='Ingr.Cost')
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
                  });
                },
                items: <String>['Anticipos', 'Liquidación Caña', 'Ajuste de Mercado Excedentario','Donaciones Cenicaña','Fondo Social','Retenciones','Ingresos y Costos','Ica']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    //child: Center(
                          child:Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5,40,10),
                          child:new Text(value,textAlign: TextAlign.center,
                                              style: new TextStyle(color: Colors.black)),
                          ),
                          //),
                  );
                }).toList(),
            ),),);
  }


 Widget formUI() {
   return  Column(
     children: <Widget>[
       Container(
         height: 60,
          width: 600,
          margin: EdgeInsets.only(top:21),
          decoration: BoxDecoration(
            color: Colors.white,  
              //borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage('images/titulop.png'),
                fit: BoxFit.cover),
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
                child:Text(widget.editar?"Editar Orden":'Crear Rol',style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),),
              )
            ],
          ) ,
          //padding: EdgeInsets.symmetric(horizontal:10),
      ),
        lista(context),
        //formItemsDesign(
           //Icons.person,
           Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.fromLTRB(30, 5, 30,10),
              child:TextFormField(
             controller: notas,
             focusNode: not,
             autofocus: true,
             decoration: new InputDecoration(
               labelText: 'Notas',
             ),
             validator: (value){
               if (value.isEmpty) {
                return 'Por favor Ingrese el Rol';
              }
            },
             //validator: validateName,
        ),),
        //),
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
          child: Text(widget.editar?"Editar Orden":'Crear Rol', style: TextStyle(
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
            if(notas.text==''){
              not.requestFocus();
            }                   
          //   if (!keyForm.currentState.validate()){
          //     warningDialog(
          //     context, 
          //     "Por favor revise la información ingresada",
          //     negativeAction: (){
          //     },
          //   );
          //     Scaffold.of(context).showSnackBar(
          //       SnackBar(content: Text('Processing Data'))
          //     );
                                        
          //   }else{
              
          // }
          editar_orden();
        },
      ),
      ),
      ),
     ],
   );
 }
}

