import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projeto3/ui/home_Page.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
