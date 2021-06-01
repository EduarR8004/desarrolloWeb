import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';   
import 'package:intl/intl.dart';
import 'package:proveedores_manuelita/utiles/Informacion.dart';
import 'package:proveedores_manuelita/modelos/Data.dart';
import 'package:proveedores_manuelita/vistas/cronologico/Crono.dart';
import 'package:proveedores_manuelita/vistas/entradaCana/EntradasCana.dart';
import 'package:proveedores_manuelita/vistas/infoProduccion/InfoProduccion.dart';

class Mensaje extends StatefulWidget {

  final Data data;
  final String titulo;
  String mensaje;
  
  Mensaje ({Key key,this.data,this.titulo,this.mensaje}) : super();
  @override
  _MensajeState createState() => _MensajeState();
}

class _MensajeState extends State<Mensaje> {
var menssage='Hola';
String mensaje;
 todayDate() {
    var now = new DateTime.now();
    DateTime lastDayOfMonth = new DateTime(now.year, now.month,now.day -now.day +1, 0);
    var fecha_final;
    var last=lastDayOfMonth.day.toString();
    var formatter =  DateFormat("dd/MM/yyyy");
    var formatter1 = new DateFormat('MM');
    String formattedTime = DateFormat('kk:mm:a').format(now);
    String formattedDate = formatter.format(now);
    String formattedDate1 = formatter1.format(now);
    fecha_final=formattedDate.split('/');
    return '01/'+fecha_final[1]+'/'+fecha_final[2]+'-'+formattedDate;
  }
   
  @override
  void initState() {
    mensaje=widget.mensaje.toString();
    widget.data;
    widget.titulo;
    super.initState();
  }

  mensaje_mostrar(mensaje)
  {

    if(mensaje=='entrada')
    {
     return _buildAlertDialog();
    }

    if(mensaje=='informe')
    {
      return _informeProduccion();
    }

    if(mensaje=='crono')
    {
    //   successDialog(
    //     context, 
    //     'Usuario Editado con Éxito',
    //     neutralText: "Aceptar",
    //     neutralAction: (){
         
    //     },
    // );
     return _cronologico();
    }

  }
    Future crear() async{
      return widget.data;
    }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () {  },
    child:Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading:false,
        shadowColor: Colors.transparent,
        flexibleSpace:Container(
          //height: 60,
          //width: 500,
          margin: EdgeInsets.only(top:1),
            decoration: BoxDecoration(
              color: Colors.white,  
                //borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage('images/titulop.png'),
                  fit: BoxFit.cover),
            ),
            child: Center(child: Text(widget.titulo,style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
            ),
            ),
          //color: Colors.blue,     
        )
      ),
      body:Center(
          child:mensaje_mostrar(mensaje)
      ) 
    ),);
  }

  Widget _buildAlertDialog() {
    return Column(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                Container(
                  height: 260,
                  width: 300,
                  decoration: BoxDecoration(
                  color: Colors.white,
                  border:Border.all(
                    color: Color.fromRGBO(56, 124, 43, 1.0),
                    width:1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  // boxShadow: [BoxShadow(
                  //   color: Colors.black45,
                  //   offset: Offset(6,6),
                  //   blurRadius: 6,  
                  // ),
                  // ],
                  ),
                  child:Column(children: [
                    Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.only(top:25),
                          decoration: BoxDecoration(
                            color: Colors.white,  
                              //borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage('images/tractor_verde.png'),
                                fit: BoxFit.cover),
                          ),
                    ),
                    SizedBox(height: 10),
                    Text('Esta es la producción parcial de la caña entrada en el periodo:\n('+todayDate()+').\nSí desea consultar otros periodos,favor digitar el rango de fecha.',textAlign: TextAlign.center,style: TextStyle(
                        color: Color.fromRGBO(83, 86, 90, 1.0),
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 10),
                    Padding(
                    padding: EdgeInsets.all(10.0),
                    child:Container(
                      width: 200,
                      decoration: BoxDecoration(
                      //color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: RaisedButton(
                      textColor: Color.fromRGBO(83, 86, 90, 1.0),
                      //textColor: Color.fromRGBO(255, 210, 0, 1.0),
                      color: Color.fromRGBO(56, 124, 43, 1.0),
                      child: Text('Aceptar',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        //side: BorderSide(color: Colors.white)
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                                     MaterialPageRoute(builder: (context) => EntradasCanas (data:widget.data)));
                      },
                    ),
                    ),
                    ),
                  ],)
                ),
              ],
            );
  }

  Widget _cronologico() {
    return Column(
      mainAxisAlignment:MainAxisAlignment.center,
      children: [
        Container(
          height: 260,
          width: 300,
          decoration: BoxDecoration(
          color: Colors.white,
          border:Border.all(
            color: Color.fromRGBO(56, 124, 43, 1.0),
            width:1,
          ),
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [BoxShadow(
          //   color: Colors.black45,
          //   offset: Offset(6,6),
          //   blurRadius: 6,  
          // ),
          // ],
          ),
          child:Column(children: [
            Container(height: 50,
              width: 50,
              margin: EdgeInsets.only(top:25),
                  decoration: BoxDecoration(
                    color: Colors.white,  
                      //borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage('images/calendario.png'),
                        fit: BoxFit.cover),
                    ),
            ),
            SizedBox(height: 10),
            Text('Señor proveedor por favor tenga\nen cuenta que la información\naquí suministrada es preliminar\ny está sujeta a verificación y a posibles cambios.',textAlign: TextAlign.center,style: TextStyle(
                color: Color.fromRGBO(83, 86, 90, 1.0),
                fontSize: 15,
                fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 10),
            Padding(
            padding: EdgeInsets.all(10.0),
            child:Container(
              width: 200,
              decoration: BoxDecoration(
              //color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: RaisedButton(
              textColor: Color.fromRGBO(83, 86, 90, 1.0),
              //textColor: Color.fromRGBO(255, 210, 0, 1.0),
              color: Color.fromRGBO(56, 124, 43, 1.0),
              child: Text('Aceptar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
                //side: BorderSide(color: Colors.white)
              ),
              onPressed: () {
                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => VerCronologico (data:widget.data)));
              },
            ),
            ),
            ),
          ],)
        ),
      ],
    );
  }


  Widget _informeProduccion() {
    return Column(
      mainAxisAlignment:MainAxisAlignment.center,
      children: [
        Container(
          height: 260,
          width: 300,
          decoration: BoxDecoration(
          color: Colors.white,
          border:Border.all(
            color: Color.fromRGBO(56, 124, 43, 1.0),
            width:1,
          ),
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [BoxShadow(
          //   color: Colors.black45,
          //   offset: Offset(6,6),
          //   blurRadius: 6,  
          // ),
          // ],
          ),
          child:Column(children: [
            Container(height: 50,
              width: 50,
              margin: EdgeInsets.only(top:25),
                  decoration: BoxDecoration(
                    color: Colors.white,  
                      //borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage('images/estadisticas.png'),
                        fit: BoxFit.cover),
                    ),
            ),
            SizedBox(height: 10),
            Text('En el siguiente informe puede\nvalidar la producción de cada\nuna las suertes. En la columna\nCierre puede identificar si la\n información es parcial o cerrada.',textAlign: TextAlign.center,style: TextStyle(
                color: Color.fromRGBO(83, 86, 90, 1.0),
                fontSize: 15,
                fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 10),
            Padding(
            padding: EdgeInsets.all(10.0),
            child:Container(
              width: 200,
              decoration: BoxDecoration(
              //color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: RaisedButton(
              textColor: Color.fromRGBO(83, 86, 90, 1.0),
              //textColor: Color.fromRGBO(255, 210, 0, 1.0),
              color: Color.fromRGBO(56, 124, 43, 1.0),
              child: Text('Aceptar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
                //side: BorderSide(color: Colors.white)
              ),
              onPressed: () {
                Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => InfoProduccion (data:widget.data)));
              },
            ),
            ),
            ),
          ],)
        ),
      ],
      );
  }

}