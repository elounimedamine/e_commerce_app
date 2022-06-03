import 'package:e_commerce_app/Controller/CartController.dart';
import 'package:e_commerce_app/Controller/ProfileController.dart';
import 'package:e_commerce_app/Controller/ShippingController.dart';
import 'package:e_commerce_app/service/HomeViewModelService.dart';
import 'package:e_commerce_app/helper/localStorageUserData.dart';
import 'package:e_commerce_app/views/auth/ControlView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/helper/Binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //Get.put(HomeViewModelService());
  Get.put(CartController());
  Get.put(ShippingController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // bind the dependency
      initialBinding: Binding(),
      home: Scaffold(
        body: ControlView(),
      ),
    );
  }
}
