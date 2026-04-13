// import 'dart:developer';
//
// import 'package:dio/dio.dart';
// import 'package:smartpay_entity/src/service/storage_service/storage_services.dart';
//
// import '../../core/keys.dart';
//
// class ApiServices {
//   StorageServices storageServices = StorageServices();
//
//   static Future<dynamic> auth(
//       {required String api, Map<String, dynamic>? body, Map<String, dynamic>? queryParameters}) async {
//     try {
//       final dio = Dio(
//         BaseOptions(
//           headers: {
//             "Content-Type": "application/json",
//           },
//         ),
//       );
//
//       log("*** Request ***");
//       log("URI : $api");
//
//       log("$body");
//
//       final response = await dio.post(
//         api,
//         data: body,
//         queryParameters: queryParameters,
//       );
//
//       if (response.statusCode == 200) {
//         log("*** response ***");
//         log("the status code is ${response.statusCode}");
//         log("URI : $api");
//
//         log("${response.data}");
//
//         return response.data;
//       }
//
//       log("status code ${response.statusCode} || API : $api :: Response ${response.data}");
//       return response.data;
//     } catch (e) {
//       log(e.toString());
//     }
//   }
//
//   static Future<dynamic> login({required String api, Map<String, dynamic>? body}) async {
//     try {
//       final dio = Dio(
//         BaseOptions(
//           headers: {
//             "Content-Type": "application/json",
//           },
//         ),
//       );
//       log("*** Request ***");
//       log("URI : $api");
//
//       log("$body");
//
//       final response = await dio.post(
//         api,
//         data: body,
//       );
//
//       if (response.statusCode == 200) {
//         log("*** response ***");
//         log("URI : $api");
//
//         log("${response.data}");
//
//         return response.data;
//       }
//
//       log("status code ${response.statusCode} || API : $api");
//       return response.data;
//     } catch (e) {
//       log(e.toString());
//     }
//     return null;
//   }
//
//   static Future<dynamic> get({required String api, String? id, Map<String, dynamic>? body}) async {
//     try {
//       final token = await StorageServices().read(tokenKey);
//
//       if (body != null) {
//         log("*** Request ***");
//         log("URI : $api");
//
//         log("$body");
//       }
//       final dio = Dio(
//         BaseOptions(
//           headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer $token",
//           },
//         ),
//       );
//
//       final response = await dio.get(api, data: body);
//
//       if (response.statusCode == 200) {
//         log("*** response ***");
//         log("URI : $api");
//
//         log("${response.data}");
//
//         return response.data;
//       }
//
//       log("status code ${response.statusCode} || API : $api");
//       return response.data;
//     } catch (e) {
//       log(e.toString());
//     }
//   }
//
//   static Future<dynamic> post({required String api, String? id, Map<String, dynamic>? body}) async {
//     try {
//       final token = await StorageServices().read(tokenKey);
//       log("token $token");
//       final dio = Dio(
//         BaseOptions(
//           headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer $token",
//           },
//         ),
//       );
//
//       log("*** Request ***");
//       log("URI : $api");
//
//       log("$body");
//
//       final response = await dio.post(
//         api,
//         data: body,
//       );
//
//       if (response.statusCode == 200) {
//         log("*** response ***");
//         log("URI : $api");
//
//         log("${response.data}");
//
//         return response.data;
//       }
//
//       log("status code ${response.statusCode} || API : $api :: Response ${response.data}");
//       return response.data;
//     } catch (e) {
//       log("error : *** $e *** ");
//     }
//   }
// }


