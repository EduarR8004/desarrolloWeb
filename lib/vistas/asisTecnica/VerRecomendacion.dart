import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerRecomendacion extends StatefulWidget {
  final String titulo;
  final String icono;
  final String texto;

  const VerRecomendacion({Key key,this.titulo,this.icono,this.texto}) : super(key: key);
  @override
  _VerRecomendacionState createState() => _VerRecomendacionState();
}

class _VerRecomendacionState extends State<VerRecomendacion> {
  String texto;
  @override
  void initState() {
   widget.texto==null?texto='Pendiente por Información':texto= widget.texto;
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
         height: 60,
          //margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          decoration: BoxDecoration(
            color: Colors.white,  
              //borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage('images/titulop.png'),
                fit: BoxFit.cover),
            ),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child:Text(widget.titulo,style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),),
              ),
            ],
          ) ,
          //padding: EdgeInsets.symmetric(horizontal:10),
      ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
              child: 
                Column(
                  children: <Widget>[
                    SizedBox(height: 5),
                    Container(
                    alignment: Alignment.center,
	                  height: 65,
	                  margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
	                  child: 
	                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
	                      children:<Widget>[
                          InkWell(
                            onTap: () {
                             
                            }, 
                            child:
                              Column(
	                              children: <Widget>[
	                              Container(
                                  alignment: Alignment.center,
	                                height: 60,
	                                width: 60,
	                                decoration: BoxDecoration(
	                                color:Colors.white,
	                                border:Border.all(
	                                  color: Color.fromRGBO(56, 124, 43, 1.0),
	                                  width:4,
	                                ),
	                                borderRadius: BorderRadius.circular(50),
	                                // boxShadow: [BoxShadow(
	                                //   color: Colors.black45,
	                                //   offset: Offset(6,6),
	                                //   blurRadius: 6,  
	                                // ),
	                                // ],
	                                ),
	                                child:Center(
	                                  child: 
                                    Container(
	                                  height: 30,
	                                  width: 30,
	                                  padding: new EdgeInsets.all(10.0),
	                                  decoration: BoxDecoration(
	                                    image: DecorationImage(
	                                    image: AssetImage(widget.icono),
	                                    fit: BoxFit.contain)),
	                                ) ,
	                                ),
	                              ),
	                          ]
	                          ),
                          ),
	                      ],
	                    ),
	                  ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                      child:
                      Text(texto,textAlign:TextAlign.justify,style: TextStyle(
                      color: Colors.black,
                      fontSize:17,
                      height:1.5,
                    ),),)
                    ]
                  ),
      ),
    );
  }
}