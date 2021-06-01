import 'package:flutter/material.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/utiles/Conexion.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/logica/Usuarios.dart';
import 'package:proveedores_manuelita/vistas/index.dart';
import 'package:proveedores_manuelita/vistas/login/login.dart';

class PoliticaTratamientoDatos extends StatefulWidget {
  final Data data;
  String retorno;
  PoliticaTratamientoDatos({this.data,this.retorno});
  @override
  _PoliticaTratamientoDatosState createState() => _PoliticaTratamientoDatosState();
}

class _PoliticaTratamientoDatosState extends State<PoliticaTratamientoDatos> {
@override
  void initState() {
    super.initState();
  }

 Future aceptar_politica()async{
  var session= Conexion();
  session.set_token(widget.data.token);
  var usuario= Usuarios(session);
  usuario.aceptar_politica().then((_){
    Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Inicio(data:widget.data,retorno:'')));
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => Inicio(data:widget.data,retorno:''),)); });
  });
   
 }
  @override
  Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () {  },
      child:SafeArea(
        child: Scaffold(
          body:dataBody(),
        ),
      ),
  );
}
Widget dataBody() {
  return Container(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        //margin: EdgeInsets.only(top:21),
        decoration: BoxDecoration(
          color: Colors.white,  
            //borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage('images/titulop.png'),
            fit: BoxFit.cover
          ),
        ),
        child:Row(
          mainAxisAlignment : MainAxisAlignment.center,
          children:<Widget>[
            Center(
              child:Text("Política de Tratamiento de Datos Personales",textAlign: TextAlign.center,style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),),
            )
          ],
        ) ,
            //padding: EdgeInsets.symmetric(horizontal:10),
      ),
      Expanded(
        child: SizedBox(
          child:texto(),)
      ),
      Container(
        height: 60,
          width: 700,
          margin: EdgeInsets.only(top:21),
          child:Row(
            mainAxisAlignment : MainAxisAlignment.center,
            children:<Widget>[
              Container(
              height: 50,
                width: 120,
                  //padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: RaisedButton(
                    textColor: Color.fromRGBO(83, 86, 90, 1.0),
                    //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                    color: Colors.white,
                    child: Text('Aceptar', style: TextStyle(
                      color:  Color.fromRGBO(83, 86, 90, 1.0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    )),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(color: Colors.white)
                    ),
                    onPressed: () {
                        aceptar_politica();
                    },
                  )
              ),
              SizedBox(
              width:20,
              ),
              Container(
              height: 50,
              width: 120,
                //padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: RaisedButton(
                  textColor: Color.fromRGBO(83, 86, 90, 1.0),
                  //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                  color: Colors.white,
                  child: Text('Cancelar', style: TextStyle(
                    color:  Color.fromRGBO(83, 86, 90, 1.0),
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  )),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    side: BorderSide(color: Colors.white)
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Login(true))); 
                  },
                )
              ),
            ],
          ) ,
          //padding: EdgeInsets.symmetric(horizontal:10),
      ),
      SizedBox(height:20,),
    ],
  ),
    );
}
Widget texto() {
  return  
    ListView(
      children:[
        Container(
        padding: EdgeInsets.all(10),
        child: Text("La información contenida en las bases de datos de Manuelita, es sometida a distintas formas de tratamiento, tales como: recolección, intercambio, actualización, procesamiento, reproducción, corrección, uso, organización, almacenamiento, circulación o supresión, entre otras, todo lo anterior en cumplimiento de las finalidades y los objetivos establecidos en la presente Política de Tratamiento de Datos Personales."
                    "La información referenciada, podrá ser entregada, transmitida o transferida a entidades públicas, socios comerciales, contratistas, empleados, afiliados, y/o compañías filiales, subsidiarias o vinculadas, única y exclusivamente con el fin de cumplir con las finalidades de la base de datos correspondiente."
                    "También podrá ser transmitida o transferida a los titulares, sus causahabientes y representantes legales. En todo caso, la entrega, transmisión o transferencia se hará previa suscripción de los compromisos que sean necesarios para salvaguardar la confidencialidad y privacidad de la información autorizada para tratar. A su vez, en cumplimiento de deberes legales,Manuelita. podrá suministrar la información personal a entidades judiciales o administrativas."
                    "También podrá ser transmitida o transferida a los titulares, sus causahabientes y representantes legales. En todo caso, la entrega, transmisión o transferencia se hará previa suscripción de los compromisos que sean necesarios para salvaguardar la confidencialidad y privacidad de la información autorizada para tratar. A su vez, en cumplimiento de deberes legales,Manuelita. podrá suministrar la información personal a entidades judiciales o administrativas."
                    "Manuelita, velará por el correcto uso de datos personales de menores de edad, garantizando que se cumpla con las exigencias legales aplicables y que todo tratamiento esté previamente autorizado y se encuentre justificado en el interés superior de los menores.",textAlign: TextAlign.justify),
        ),
      ]
    );
}
}