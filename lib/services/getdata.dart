import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart';
import 'api_provider.dart';

class MyData {
  String id;
  String name;

  MyData({
    required this.id,
    required this.name,
  });

}

class GetDataProvider extends ChangeNotifier {

  List upcoming = [], live =[] , completed = [];
  ApiStatus status = ApiStatus.Stable;

  getData(
      {
        BuildContext? context,
      }) async {
    status = ApiStatus.Loading;
    upcoming.clear();
    live.clear();
    completed.clear();
    notifyListeners();
    var response = await ApiProvider.get('v2/schedule/',queryParam: qp);

    // print(response);

    if (response['status'] == 200) {

      List d = response['body']['data']['months'][0]['days'];

      d.forEach((element) {
        List a = element['matches'];
        a.forEach((element) {
          if(element['status']=='completed'){
            completed.add(element);
          }else if(element['status'] == 'notstarted'){
            upcoming.add(element);
          }else{
            print(element);
            live.add(element);
          }
        });
      });

      status = ApiStatus.Success;

      notifyListeners();

      return true;

    }
    else if (response['status'] == 'No Connection') {

      status = ApiStatus.NetworkError;
      notifyListeners();
      // Navigator.push(context!, MaterialPageRoute(builder: (context)=>NetworkError()));
      return;
    }
    else {

      status = ApiStatus.Error;
      notifyListeners();
      // var a = jsonDecode(response['body']);
      // MySnackbar(context, a['msg']);
      return;
    }
  }

}

