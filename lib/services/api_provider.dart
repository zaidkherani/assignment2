import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart' as constant;
import 'connection.dart';
import 'package:dio/dio.dart';

enum Status {
  Success,
  Loading,
  NetworkError,
  Error,
}

class ApiProvider {
  // for all get request
  static Future get(String url, {required Map<String, dynamic> queryParam}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = Dio();
    var _response;
    // print(queryParam);
    // print("Url:");
    // print(constant.url+ url);
    if (!await Connection.isConnected()) {
      return {'status': 'No Connection', 'body': 'No Internet Connection'};
    }

    if (queryParam == null) {
      try {
        _response = await dio.get(
          '${constant.url}$url',
        );
      } on DioError catch (e) {
        return {'status': e.response!.statusCode, 'body': e.response!.data};
      }
    } else {
      try {
        _response =
        await dio.get('${constant.url}$url', queryParameters: queryParam,
        );

        // print("printing _response");
        // print(_response);
      } on DioError catch (e) {
        return {'status': e.response!.statusCode, 'body': e.response!.data};
      }
    }

    return {'status': _response.statusCode, 'body': _response.data};
  }

  // for all post request
  static Future post({String? url,Map<String, dynamic> body = const {}}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var dio = Dio();
    FormData formData = FormData.fromMap(body);

    print(formData);

    if (!await Connection.isConnected()) {
      return {'status': 'No Connection', 'body': 'No Internet Connection'};
    }

    // print("yoooooo");
    // print(constant.api);

    var _response = await dio.post(
      '${constant.url}$url',
      data: formData,

      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! <= 500;
        },
        headers: {
          // "Authorization": 'Bearer 09ee8fea6e00342600fcc71782e0b10e',
          // 88b415a0b001209b88b415a0b001209b88b415a0b001209b88b415a0b001209b
          // "Authorization": 'Bearer ${prefs.getString('api_token')}',
        },
      ),
    );
    // log(_response.data.toString());
    // log(response['body']['data'][0]['title'].toString());
    return {'status': _response.statusCode, 'body': _response.data};

    // if (_response.statusCode == 200) {
    //   print('api_provider successfull');
    //   return {'status': '${_response.statusCode}', 'body': _response.data};
    // } else {
    //   print('api_provider error ${_response.statusCode} : ${_response.data}');
    //   return {'status': '${_response.statusCode}', 'body': _response.data};
    // }
  }


}
