import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:storm/common/helper/end_points.dart';


class DioHelper {
  static Dio dio;

  static void init() {
    dio = Dio(
        BaseOptions(
      baseUrl: 'https://fcm.googleapis.com/fcm/',
      receiveDataWhenStatusError: true,
    ));
  }


  static Future<Response> setData(
      {
        @required data,
      }) async {

    dio.options.headers={
      'Content-Type': 'application/json',
      'Authorization':'key=AAAAP3KG378:APA91bF6M2i-FSf-Ct1qHVdKbvMAKOslECI62RHlE3ObrYRYcjE-G_zUni6rMvmF4c3UwtSL4PmWRckxd8GjAdmz031I8Tu2RBqHCadHunE7BbiL-_1hYti6_5W6T0MuF8ACzUIujLcI'
    };

    return await dio.post(
        SEND ,
        data:data,
    );
  }


}
