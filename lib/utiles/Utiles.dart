import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class SessionNotFound implements Exception {
String cause;
SessionNotFound(this.cause);
}

class ConnectionError implements Exception {
String cause;
ConnectionError(this.cause);
}

class JsonDecodingError implements Exception {
String cause;
JsonDecodingError(this.cause);
}


class AutenticationFailure implements Exception {
String cause;
AutenticationFailure(this.cause);
}