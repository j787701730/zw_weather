import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const key  = '&key=c10ca07640754ec3878ff6df49399eaa';

showADialog(context, msg) {
  showDialog(
      context: context,
      builder: (_) => new AlertDialog(title: new Text("提示"), content: new Text(msg), actions: <Widget>[
            new FlatButton(
              child: new Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]));
}

ajax(String url, Object data, toast, sucFun, failFun, context) async {
  try {
    Response response;
    response = await Dio().get(
      "$url$key",
//      data: data,
//      options: new Options(
////            contentType: ContentType.parse("application/x-www-form-urlencoded"),
////            contentType: ContentType.json,
//          headers: {
//            'X-Requested-With': 'XMLHttpRequest',
//            // 'Content-Type': 'application/x-www-form-urlencoded',
//          }),
    );

//    if (response.data['err_code'] == 0) {
//      if (toast == true) {
//        showADialog(context, response.data['err_msg']);
//      }
//      if (sucFun != null) {
//        sucFun(response.data);
//      }
//    } else if (response.data['err_code'] == 88888) {
//      // 登录处理
//      showADialog(context, response.data['err_msg']);
//    } else {
//      showADialog(context, response.data['err_code']);
//      if (failFun != null) {
//        failFun(response.data);
//      }
//    }
    sucFun(response.data);
  } catch (e) {
    return print(e);
  }
}
