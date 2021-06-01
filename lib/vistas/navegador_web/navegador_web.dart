import 'package:flutter/material.dart';

class NavegadorWeb extends StatelessWidget {
  final String titulo;
  NavegadorWeb(this.titulo);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        children:<Widget>[
          SizedBox(height: 80,width: 150,child: Text(titulo),),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _Item('Configuración'),
              SizedBox(
                width:60,
              ),
              _Item('Consultas'),
            ],
          ),
        ],
      ),
      
    );
  }
}

class _Item extends StatelessWidget {
  final String titulo;
  const _Item(this.titulo); 
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => print("Container pressed"),
      child:Container(
      child:Text(titulo,
      style: TextStyle(fontSize: 18),
      ),
    ));
  }
}