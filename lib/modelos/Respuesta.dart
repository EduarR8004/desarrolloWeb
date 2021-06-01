

// class Respuesta {
//   ResponseStatus responseStatus;
//   Payload payload;

//   Respuesta({this.responseStatus, this.payload});

//   Respuesta.fromJson(Map<String, dynamic> json) {
//     responseStatus = json['response_status'] != null
//         ? new ResponseStatus.fromJson(json['response_status'])
//         : null;
//     payload =
//         json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.responseStatus != null) {
//       data['response_status'] = this.responseStatus.toJson();
//     }
//     if (this.payload != null) {
//       data['payload'] = this.payload.toJson();
//     }
//     return data;
//   }
// }

// class ResponseStatus {
//   String code;
//   String message;
//   String traceback;

//   ResponseStatus({this.code, this.message, this.traceback});

//   ResponseStatus.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     message = json['message'];
//     traceback = json['traceback'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['code'] = this.code;
//     data['message'] = this.message;
//     data['traceback'] = this.traceback;
//     return data;
//   }
// }


// class Payload {
//   String token;

//   Payload({this.token});

//   Payload.fromJson(Map<String, dynamic> json) {
//     token = json['token'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['token'] = this.token;
//     return data;
//   }
  
// }
