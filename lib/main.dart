import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer/themes.dart';

import 'calenderview.dart';
import 'home.dart';
void main (){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: MyBindings(),
      title: "simple tiner app",
      themeMode: ThemeMode.light,
      darkTheme: MyThemes.darkTheme,
      theme: MyThemes.lightTheme,
      debugShowCheckedModeBanner: false,
      home:const  FinalView(),
    );
  }
}
