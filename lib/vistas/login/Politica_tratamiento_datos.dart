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
  double anchoContainer=700;
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
            height: 80,
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
                  child:Text("Política de Tratamiento de Datos Personales",textAlign: TextAlign.center,
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ],
            ) ,
                //padding: EdgeInsets.symmetric(horizontal:10),
          ),
          Expanded(child:
            Container(
              width: 800,
              child:texto(),
            ),
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
          width:anchoContainer,
          padding: EdgeInsets.all(10),
          child: 
          Text(
            "Autorizo libre y voluntariamente a Manuelita S.A. como responsable del tratamiento de los datos," 
            "para la recolección, almacenamiento, uso, transmisión y/o transferencia de los datos personales" 
            "suministrados a la compañía, para que sean tratados conforme a las siguientes finalidades:" 
            ,textAlign: TextAlign.justify,
            style: TextStyle(
              color:Colors.black,
              fontSize:16,
              height:1.5,
            )
          ),
        ),
        Container(
          width:anchoContainer,
          padding: EdgeInsets.fromLTRB(10,5,10,5),
          child: 
          Text(
            "i. Atender las funcionalidades internas del sistema tales como creación de usuario, uso de la " 
            "aplicación, actualizaciones de la aplicación."
            ,textAlign: TextAlign.justify,
            style: TextStyle(
              color:Colors.black,
              fontSize:16,
              height:1.5,
            )
          ),
        ),
        Container(
          width:anchoContainer,
          padding: EdgeInsets.fromLTRB(10,5,10,5),
          child: 
          Text(
            "ii. Recibir notificaciones vía correo electrónico, mensajes de texto -SMS-, Whatsapp, llamada " 
            "telefónica."
            ,textAlign: TextAlign.justify,
            style: TextStyle(
              color:Colors.black,
              fontSize:16,
              height:1.5,
            )
          ),
        ),
        Container(
          width:anchoContainer,
          padding: EdgeInsets.fromLTRB(10,5,10,5),
          child: 
          Text(
            "iii. Acceder a información referente a la relación comercial/contractual establecida con " 
            "Manuelita S.A. (entradas de caña, liquidaciones, cronológicos, producciones, certificados " 
            "tributarios, recomendaciones de asistencia técnica)."
            ,textAlign: TextAlign.justify,
            style: TextStyle(
              color:Colors.black,
              fontSize:16,
              height:1.5,
            )
          ),
        ),
        Container(
          width:anchoContainer,
          padding: EdgeInsets.fromLTRB(10,5,10,5),
          child: 
          Text(
            "iv. Actualizar mis datos personales para la verificación ante centrales de riesgo, emisión de " 
            "certificados tributarios y demás actividades administrativas, contables y fiscales que se " 
            "derivan de dicha relación comercial/contractual."
            ,textAlign: TextAlign.justify,
            style: TextStyle(
              color:Colors.black,
              fontSize:16,
              height:1.5,
            )
          ),
        ),
        Container(
          width:anchoContainer,
          padding: EdgeInsets.fromLTRB(10,5,10,5),
          child: 
          Text(
            "Como Titular de los datos tengo derecho a conocer, actualizar, rectificar, suprimir y revocar la " 
            "autorización y el procedimiento para ejercer mis derechos lo puedo consultar en la Política "
            "de protección de datos personales publicada en www.manuelita.com o puede dirigir sus preguntas," 
            "quejas, reclamos o solicitudes al correo:"
            ,textAlign: TextAlign.justify,
            style: TextStyle(
              color:Colors.black,
              fontSize:16,
              height:1.5,
            )
          ),
        ),
        Container(
          width:anchoContainer,
          padding: EdgeInsets.fromLTRB(10,5,10,5),
          child: 
          Text(
            "protecciondedatos@manuelita.co"
            ,textAlign: TextAlign.center,
            style: TextStyle(
              color:Colors.black,
              fontSize:16,
              height:1.5,
              fontWeight: FontWeight.bold,
            )
          ),
        ),
      ]
    );
  }
}