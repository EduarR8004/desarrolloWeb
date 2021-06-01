import 'dart:convert';

class ObtenerDocumento {
  String ruta;
  ObtenerDocumento({
    this.ruta,
  });

  Map<String, dynamic> toMap() {
    return {
      'ruta': ruta,
    };
  }

  factory ObtenerDocumento.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
  
    return ObtenerDocumento(
      ruta: json['ruta'],
    );
  }

}
