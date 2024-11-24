import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG, // 메시지 길이 (Short / Long)
    gravity: ToastGravity.BOTTOM, // 위치 (TOP, BOTTOM, CENTER)
    timeInSecForIosWeb: 2, // iOS 및 Web에서의 표시 시간
    backgroundColor: Colors.black, // 배경색
    textColor: Colors.white, // 텍스트 색
    fontSize: 16.0, // 폰트 크기
  );
}
