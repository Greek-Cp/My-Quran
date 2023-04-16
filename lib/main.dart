import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_quran/model/controller_response.dart';
import 'package:my_quran/model/response_doa.dart';
import 'package:my_quran/pages/baca_surat.dart';
import 'package:my_quran/pages/doa.dart';
import 'package:my_quran/pages/home.dart';
import 'package:my_quran/pages/intro.dart';
import 'package:my_quran/pages/uji.dart';
import 'package:provider/provider.dart';

import 'httpovveride.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ControllerAPI>(
      create: (context) => ControllerAPI(),
      child: MaterialApp(
        title: 'My Quran',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: Intro.routingName.toString(),
        routes: {
          Intro.routingName.toString(): (context) => Intro(),
          Home.routeName.toString(): (context) => Home(),
          MyWidget.routeName.toString(): (context) => MyWidget(),
          PageDoa.routeName.toString(): (context) => PageDoa(),
          BacaSurat.routeName.toString(): (context) => BacaSurat()
        },
      ),
    );
  }
}
