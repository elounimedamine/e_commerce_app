import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ShippingController extends GetxController {
  String firstname, lastname, address, state, city, postcode;

  var country = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey();
}
