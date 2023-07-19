import 'package:flutter/material.dart';

String url = 'https://rest.cricketapi.com/rest/';

String access_token = '2s1531517643142598667s1608351890142269749';

var qp = {
  'access_token': access_token
};

getHeight(context){
  var h = MediaQuery.of(context).size.height;
  return h;
}

getWidth(context){
  var w = MediaQuery.of(context).size.width;
  return w;
}

responsiveWidth(BuildContext context){
  var width = MediaQuery.of(context).size.width;

  var x = (1000/(width))/100;
  return (width * x);
}

responsiveHeight(BuildContext context){
  var height = MediaQuery.of(context).size.height;

  var x = (1000/(height))/100;
  return (height * x);
}

enum ApiStatus {
  Stable,
  Success,
  Loading,
  NetworkError,
  Error,
}

MySnackbar(context,msg){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.black,
      content: Text(msg,
        style: TextStyle(
          color: Colors.white,

        ),
      ),
      duration: Duration(seconds: 3),
    ),
  );
}

MySnackbar2(context,msg){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.black,
      content: Text(msg,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      duration: Duration(seconds: 5),
    ),
  );
}

class MyLoader extends StatelessWidget {
  const MyLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getHeight(context),
      color: Colors.white70,
      width: getWidth(context),
      child: Center(
        child: CircularProgressIndicator(color: Colors.black,),
      ),
    );
  }
}