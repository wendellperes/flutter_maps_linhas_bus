import 'package:appmapas/maps_page.dart';
import 'package:appmapas/mercado_pago_integration.dart';
import 'package:appmapas/paypalservices/paypalview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: paypalview(),
    );
  }
}

