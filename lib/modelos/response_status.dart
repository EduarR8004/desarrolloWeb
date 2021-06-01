import 'package:flutter/material.dart';

class ResponseStatus{

  String code;
  String message;
  String traceback;
  Object payload;

  Map<String, dynamic> to_Map() =>{
      "code":code,
      "message":message,
      "traceback":traceback,
      payload: payload
  };

}