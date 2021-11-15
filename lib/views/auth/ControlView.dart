import 'package:e_commerce_app/Controller/AuthController.dart';
import 'package:e_commerce_app/Controller/HomeController.dart';
import 'package:e_commerce_app/views/CardView.dart';
import 'package:e_commerce_app/views/ProfileView.dart';
import 'package:e_commerce_app/views/auth/LoginView.dart';
import 'package:e_commerce_app/widgets/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControlView extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return (Get.find<AuthController>().user == null)
          ? LoginView()
          : GetBuilder<HomeController>(
              init: HomeController(),
              builder: (HomeViewController) => Scaffold(
                body: HomeViewController.currentscreen,
                bottomNavigationBar: _bottomNavigationbar(),
              ),
            );
    });
  }

  Widget _bottomNavigationbar() {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (HomeViewController) => BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text("Explore"),
            ),
            label: "",
            icon: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Image.asset(
                "assets/icons/Icon_Explore.png",
                fit: BoxFit.fill,
                width: 20,
              ),
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text("card"),
            ),
            label: "",
            icon: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Image.asset(
                "assets/icons/Icon_Cart.png",
                fit: BoxFit.fill,
                width: 20,
              ),
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text("Account"),
            ),
            label: "",
            icon: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Image.asset(
                "assets/icons/Icon_User.png",
                fit: BoxFit.fill,
                width: 20,
              ),
            ),
          ),
        ],
        currentIndex: HomeViewController.navigatorvalue,
        onTap: (index) {
          HomeViewController.changeSelectedValue(index);
          print(HomeViewController.navigatorvalue);
        },
        elevation: 0,
        selectedItemColor: Colors.black,
        backgroundColor: Colors.grey.shade50,
      ),
    );
  }
}
