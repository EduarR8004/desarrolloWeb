

import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:proveedores_manuelita/modelos/response_status.dart';
import 'package:proveedores_manuelita/utiles/Utiles.dart';



abstract class LoginCallBack {  
  //void onLoginSuccess(Users user);  
  void onLoginError(String error);  
}  

class Conexion extends ChangeNotifier{
  
  String _token;
  bool validar;
  bool _aceptar;
  String mensaje;
  ResponseStatus status = new ResponseStatus();
  String _url='https://proveedores-cana.manuelita.com';

  autenticar(user,pass) async {
    var url = Uri.parse('https://proveedores-cana.manuelita.com/autenticar');
    Response response;
    try{
        response = await http.post(url,headers:{
        "content-type" : "application/json",
    }, body: jsonEncode(<String, String>{
        'usuario': user,
        'clave_acceso': pass
     }));
      Map data = json.decode(response.body);
      if (response.statusCode == 200) {
      status.message = data['response_status']['message'];
      status.code = data['response_status']['code'];
      status.traceback = data['response_status']['traceback'];
      status.payload = data['payload'];
        
      if( status.code == "0000")
      {
        Map lis = new Map.from(status.payload);
        this._token=lis['token'];
        this._aceptar=lis['aceptacion'];
        this.validar= true;
        notifyListeners();
        return status.code;
      }else if(status.code == "A003"){
        return mensaje='Excedió el número de intentos de validación';
      }else if(status.code == "A004"){
        return mensaje='Usuario Inactivo';
      }else if(status.code == "A001"){
        return mensaje='Usuario/Clave de Acceso inválida(s)';
      }
      else
        return mensaje=status.message;
        throw new Exception(status.message);
    }
    }catch(e){
        e.toString();
      //throw new SessionNotFound('The "set-cookie" header was not found');
    }
  }

  String get_session(){
   return this._token;
 }

  bool get_aceptar(){
     return this._aceptar;
  }

  String set_token(token){
     this._token=token;
  }

  callMethod( String webservice,params)async {
    var url = Uri.parse('https://proveedores-cana.manuelita.com/'+webservice);
    var sess=this._token;
    Response response;

    try{
         response = await http.post(url, headers: {
        "Content-Type": "application/json",
        "Authorization": sess,

      }, body: jsonEncode(params));
      Map data = json.decode(response.body);
      if(response.statusCode==401){
        throw new AutenticationFailure('');
      }

    }catch(e){
      throw new ConnectionError(e.toString());
    }
    
    try{
      var data;
      data = jsonDecode(response.body);
       if (response.statusCode == 200) {
        status.message = data['response_status']['message'];
        status.code = data['response_status']['code'];
        status.traceback = data['response_status']['traceback'];
        status.payload = data['payload'];
        if( status.code == "0000")
        {
         List<String> lis = new List<String>.from( status.payload );
         //Map lis = Map.from(status.payload);
         return lis;
        }
        else
          return mensaje=status.message;
          throw new Exception(status.message);
      }
    }catch(e){
      throw new JsonDecodingError(e.toString());
    }

 }

  callMethodList( String webservice,params)async {
    var sess=this._token;
    Response response;
    var url = Uri.parse('https://proveedores-cana.manuelita.com/'+webservice);
    try{
         response = await http.post(url, headers: {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": sess,

      }, body: jsonEncode(params));
      Map data = json.decode(response.body);
      if(response.statusCode==401){
        throw new AutenticationFailure('');
      }
    }catch(e){
  
      throw new ConnectionError(e.toString());
    }
    
    try{
      var data;
      data =jsonDecode(response.body);
       if (response.statusCode == 200) {
        status.message = data['response_status']['message'];
        status.code = data['response_status']['code'];
        status.traceback = data['response_status']['traceback'];
        status.payload = data['payload'];
        if( status.code == "0000")
        {
         List<Map> lis = new List<Map>.from( status.payload );
         print(lis);
         //Map lis = Map.from(status.payload);
         return lis;
        }
        else
          return mensaje=status.message;
          throw new Exception(status.message);
      }
    }catch(e){
      throw new JsonDecodingError(e.toString());
    }

  }

   callMethodListS( String webservice,Map params)async {
    var sess=this._token;
    Response response;
    var url = Uri.parse('https://proveedores-cana.manuelita.com/'+webservice);
    try{
         response = await http.post(url, headers: {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": sess,

      }, body: jsonEncode(params));
      Map data = json.decode(response.body);
      if(response.statusCode==401){
        throw new AutenticationFailure('');
      }
    }catch(e){
  
      throw new ConnectionError(e.toString());
    }
    
    try{
      var data;
      data =jsonDecode(response.body);
       if (response.statusCode == 200) {
        status.message = data['response_status']['message'];
        status.code = data['response_status']['code'];
        status.traceback = data['response_status']['traceback'];
        status.payload = data['payload'];
        if( status.code == "0000")
        {
         List<Map> lis = new List<Map>.from( status.payload );
         //Map lis = Map.from(status.payload);
         return lis;
        }
        else if(data['response_status']['code']!= "0000")
        {  
          List<Map> lis;
          Map map = Map.from(data['response_status']);
          lis.add(map);
          return lis;
        }
      }
    }catch(e){
      throw new JsonDecodingError(e.toString());
    }

 }
//OrdenProcesamientoDocumentos2a2a20f696c4f5233e45b014022c37709bc8fb9a
 callMethodOne( String webservice,Map params)async {
    var sess=this._token;
    Response response;
    var url = Uri.parse('https://proveedores-cana.manuelita.com/'+webservice);
    try{
         response = await http.post(url, headers: {
        "Content-Type": "application/json",
        "Authorization": sess,

      }, body: jsonEncode(params));
      Map data = json.decode(response.body);
      if(response.statusCode==401){
        throw new AutenticationFailure('');
      }
    }catch(e){
      //return 'Sin conexión al servidor';
      throw new ConnectionError('Sin conexión al servidor'); 
    }
    try{
      var data;
      data = jsonDecode(response.body);
       if (response.statusCode == 200) {
        status.message = data['response_status']['message'];
        status.code = data['response_status']['code'];
        status.traceback = data['response_status']['traceback'];
        status.payload = data['payload'];
        if( status.code == "0000")
        {
         //List<Map> lis = new List<Map>.from( status.payload );
         if(status.payload==false){
            return status.payload;
         }else{
           Map lis = Map.from(status.payload);
           return lis;
         }
         
        }
        else if(data['response_status']['code']!= "0000")
          { 
            Map lis = Map.from(data['response_status']);
            return lis;
          }
          //throw new Exception(status.message);
      }
    }catch(e){
      throw new JsonDecodingError(e.toString());
    }

 }


   Future<http.StreamedResponse> callMethodFile(String filepath)async {
    var sess=this._token;
    var request=http.MultipartRequest('PATCH',Uri.parse(this._url+"/api/admin_documentos/cargar_fuente_en_orden"));
     request.fields.addAll({'id':'hjdahdkjadsa'});
     request.files.add(await http.MultipartFile.fromPath('archivo', filepath));
     request.headers.addAll({
       "Content-Type": "application/pdf",
        "Authorization": sess,
     });
      var response=request.send();
      return response;

 }

  solicitar(email) async {
    Response response;
    var url = Uri.parse('https://proveedores-cana.manuelita.com/solicitar_recuperar_clave');
    try{
        response = await http.post(url,headers:{
          "content-type" : "application/json",
        }, body: jsonEncode(<String, String>{
          'email': email,
      }));
    
      Map data = json.decode(response.body);
      if (response.statusCode == 200) {
        status.message = data['response_status']['message'];
        status.code = data['response_status']['code'];
        status.traceback = data['response_status']['traceback'];
        status.payload = data['payload'];
        
        if( status.code == "0000")
        {
          Map lis = new Map.from(status.payload);
          this._token=lis['token'];
          this.validar= true;
          return status.code;
        }else if(status.code == "P001"){
          return mensaje="El correo electronico $email no se encuentra registrado en el sistema";
        }else if(status.code == "A004"){
          return mensaje='Usuario Inactivo';
        }else if(status.code == "A001"){
          return mensaje='Usuario/Clave de Acceso inválida(s)';
        }
        else{
          return mensaje=status.message;
          throw new Exception(status.message);
        }
          
      }
    }catch(e){
          e.toString();
        //throw new SessionNotFound('The "set-cookie" header was not found');
    }
  }

  nombre_usuario(String token) async {
    Response response;
    var url = Uri.parse('https://proveedores-cana.manuelita.com/api/usuario_actual');
    try{
      response = await http.post(url,headers:{
        "content-type" : "application/json",
        "Authorization": token,
      }, body: jsonEncode(<String, String>{
      }));
    
      Map data = json.decode(response.body);
      if (response.statusCode == 200) {
        status.message = data['response_status']['message'];
        status.code = data['response_status']['code'];
        status.traceback = data['response_status']['traceback'];
        status.payload = data['payload'];
        
        if( status.code == "0000")
        {
          this.validar= true;
          Map lis = new Map.from(status.payload);
          for (var val in lis.values) {
              return val;
          }
        }else{
          return mensaje=status.message;
          throw new Exception(status.message);
        }   
      }
    }catch(e){
      e.toString();
    //throw new SessionNotFound('The "set-cookie" header was not found');
    }
  }

  recuperar(pass,token,dinamica) async {
    Response response;
    var url = Uri.parse('https://proveedores-cana.manuelita.com/recuperar_clave');
    try{
      response = await http.post(url,headers:{  
        "content-type" : "application/json",
      }, body: jsonEncode(<String, String>{
        'nueva_clave': pass,
        'token':token,
        'clave_dinamica':dinamica
      }));
    
      Map data = json.decode(response.body);
      if (response.statusCode == 200) {
      status.message = data['response_status']['message'];
      status.code = data['response_status']['code'];
      status.traceback = data['response_status']['traceback'];
      status.payload = data['payload'];
        
      if( status.code == "0000")
      {
        Map lis = new Map.from(status.payload);
        this._token=lis['token'];
        this._aceptar=lis['aceptacion'];
        this.validar= true;
        return status.code;
      }else if(status.code == "P002"){
        return mensaje='Clave dinámica incorrecta.';
      }else if(status.code == "P003"){
        return mensaje='El token de refresco de clavede acceso no existe';
      }else if(status.code == "A004"){
        return mensaje='Usuario Inactivo';
      }
    }
    }catch(e){
      e.toString();
    //throw new SessionNotFound('The "set-cookie" header was not found');
    }
  }

  crear_usuario(usuario,nombre_completo,telefono1,telefono2,telefono3,email,email_alternativo,nits,roles) async {
    var token=this._token;
    var now = new DateTime.now().millisecond;
    var url = Uri.parse('https://proveedores-cana.manuelita.com/api/usuarios/crear_usuario');
    Response response;
    try{
        response = await http.post(url,headers:{
        
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": token,
    }, body: utf8.encode(jsonEncode({
        "usuario":usuario,
        "nombre_completo":nombre_completo,
        "clave_acceso":'',
        "telefono1":telefono1,
        "telefono2":telefono2,
        "telefono3":telefono3,
        "email":email,
        "email_alternativo":email_alternativo,
        "nits":nits,
        "roles":roles,     
        })));
    
        Map data = json.decode(response.body);
        if (response.statusCode == 200) {
        status.message = data['response_status']['message'];
        status.code = data['response_status']['code'];
        status.traceback = data['response_status']['traceback'];
        status.payload = data['payload'];
         
          Map lis = new Map.from(status.payload);
          // for (var val in lis.values) {
          //   this._token = val;
            
          // }
        if( status.code == "0000")
        {
          this.validar= true;
          return status.code;
        }
        else
          return mensaje=status.message;
          throw new Exception(status.message);
      }
      }catch(e){
         e.toString();
        //throw new SessionNotFound('The "set-cookie" header was not found');
      }
  }

  editar_usuario(usuario_id,usuario,nombre_completo,telefono1,telefono2,telefono3,email,email_alternativo,nits,roles,bloqueo) async {
  var token=this._token;
  var now = new DateTime.now().millisecond;
  var url = Uri.parse('https://proveedores-cana.manuelita.com/api/usuarios/actualizar_usuario');
    
    Response response;
    try{
        response = await http.post(url,headers:{
        
        "content-type" : "application/json",
        "Authorization": token,
    }, body: jsonEncode({
        "usuario_id":usuario_id,
        "usuario":usuario,
        "nombre_completo":nombre_completo,
        "clave_acceso":"",
        "reintentos_acceso":0,
        "telefono1":telefono1,
        "telefono2":telefono2,
        "telefono3":telefono3,
        "email":email,
        "email_alternativo":email_alternativo,
        "nits":nits,
        "bloqueo":bloqueo=="Activo"?false:true,
        "clave_acceso":"",
        "reintentos_acceso":0,
        "creation_stamp":0,
        "created_by": "",
        "modification_stamp":now,
        "modified_by": "",
        "roles":roles,     
        }));
    
        Map data = json.decode(response.body);
        if (response.statusCode == 200) {
        status.message = data['response_status']['message'];
        status.code = data['response_status']['code'];
        status.traceback = data['response_status']['traceback'];
        status.payload = data['payload'];
        Map lis = new Map.from(status.payload);
        if( status.code == "0000")
        {
          this.validar= true;
          return status.code;
        }
        else
          return mensaje=status.message;
          throw new Exception(status.message);
      }
      }catch(e){
         e.toString();
        //throw new SessionNotFound('The "set-cookie" header was not found');
      }
  }

  Future<http.StreamedResponse> enviar_archivo(fileBytes,String id)async{
  var token=this._token;

  var request = http.MultipartRequest('POST',Uri.parse(_url+"/api/admin_documentos/cargar_fuente_en_orden"));
  request.fields["orden_id"]=id;
  
  request.files.add(await http.MultipartFile.fromBytes("archivo",fileBytes));
  var totalByteLength = request.contentLength;
  request.headers.addAll({
    "Content-type":"multipat/form-data",
    "Authorization":token,
  });
  var response= await request.send();
  
  if (response.statusCode == 200) print('Uploaded!');
  }

  Future<http.StreamedResponse> enviar_archivo_datos(fileBytes,String webService)async{
  var token=this._token;
  var request = http.MultipartRequest('POST',Uri.parse(_url+webService));
  request.files.add(await http.MultipartFile.fromPath("archivo",fileBytes));
  var totalByteLength = request.contentLength;
  request.headers.addAll({
    "Content-type":"multipat/form-data",
    "Authorization":token,
  });
  var response= await request.send();
  
  if (response.statusCode == 200) print('Uploaded!');
  }

  Future<http.StreamedResponse> enviar_archivo_datos_web(String webService, String nombre, fileBytes)async{
  var token=this._token;
  //var stream = new http.ByteStream(DelegatingStream.typed(fileBytes.openRead()));
  var request = http.MultipartRequest('POST',Uri.parse(_url+webService));
  request.files.add(await http.MultipartFile.fromBytes("archivo", fileBytes));
  var totalByteLength = request.contentLength;
  request.headers.addAll({
    "Content-type":"multipat/form-data",
    "Authorization":token,
  });
  var response= await request.send();
  
  if (response.statusCode == 200) print('Uploaded!');
  }

  getFile(String url) async{

  var uri = Uri.parse(url);
  var token=this._token;
  Map body = {'Authorization': token};
  try {
    final data = await http.get(uri,
        headers: {
          "Authorization":token
        });

    if (data.contentLength == 0){
      return;
    }
    var bytes = data.bodyBytes;
    if(Platform.isAndroid){
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdfonline.pdf");
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    }else{
      return bytes;
    }
    
  }
  catch (value) {
    throw Exception("Error opening url file");
  }
  }

}