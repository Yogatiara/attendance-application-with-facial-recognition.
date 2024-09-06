// import 'dart:ffi';

// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:network_info_plus/network_info_plus.dart';

// class Controller {
//   final String data;

//   Controller({
//     required this.data,
//   });

//   factory Controller.createController(Map<String, dynamic> object) {
//     return Controller(
//       data: object['data'],
//     );
//   }

//   static Future<Controller> getApi(String path) async {
//     var apiResult = await http.get(Uri.https('reqres.in', '/api/$path'));

//     if (apiResult.statusCode == 200) {
//       var jsonData = jsonDecode(apiResult.body);
//       return Controller.createController(jsonData);
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
// }

// Future<void> connectToApi() async {
//   try {
//     await Controller.getApi();
//     debugPrint('Successfully connected to API ');
//     Controller.isLoading = true;
//     // Use the data received from the API as needed
//   } catch (e) {
//     debugPrint('Failed to connect to API. Error: $e');
//   }
// }

class Controller {
  final int id;
  final String name;
  // final String job;
  // final String created;

  Controller({
    required this.id,
    required this.name,
    // required this.job,
    // required this.created
  });

  factory Controller.createController(Map<String, dynamic> object) {
    return Controller(
      id: object['id'],
      name: object['first_name'],
      // job: object['job'],
      // created: object['createdAt']
    );
  }

  static Future<Controller> getApi([int? id]) async {
    id ??= 2;
    var apiResult = await http.get(Uri.https('reqres.in', '/api/users/$id'));
    var jsonData = jsonDecode(apiResult.body);
    var userData = (jsonData as Map<String, dynamic>)['data'];
    return Controller.createController(userData);
  }

  // static Future<Controller> connectToApi(String name, String job) async {
  //   var apiResult = await http.post(Uri.https('reqres.in', '/api/users'),
  //       body: {'name': name, 'job': job});
  //   var jsonData = jsonDecode(apiResult.body);

  //   return Controller.createController(jsonData);
  // }
}
