// @dart=2.9

import 'package:e_commerce_app/models/Category.dart';
import 'package:e_commerce_app/models/Product.dart';
import 'package:e_commerce_app/service/ApplicationDb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeViewModelService extends GetxController {
  ValueNotifier<bool> _IsLoding = ValueNotifier(false);
  ValueNotifier<bool> get IsLoding => _IsLoding;

  var _CategoryList = <Category>[];

  List<Category> get CategoryList => _CategoryList;

  var _ProductList = <Product>[];

  List<Product> get ProductList => _ProductList;

  HomeViewModelService() {
    getCategories();
    getProducts();
  }

  setfavorite(String docid, bool isfavorite) {
    _ProductList.forEach((product) {
      if (product.id == docid) product.isfavorite = !product.isfavorite;
      ApplicationDb().setFavoriteProduct(docid, isfavorite);
    });
    update();
  }

  getCategories() async {
    _IsLoding.value = true;
    await ApplicationDb().getCategories().then((value) {
      for (int i = 0; i < value.length; i++) {
        _CategoryList.add(Category.fromjson(value[i].data()));
      }
      _IsLoding.value = false;

      update();
    });
  }

  getProducts() async {
    _IsLoding.value = true;
    await ApplicationDb().getProducts().then((value) {
      for (int i = 0; i < value.length; i++) {
        _ProductList.add(Product.fromJson(value[i].data()));
        print("${_ProductList[i].name}  : ${_ProductList[i].isfavorite}");
      }
      _IsLoding.value = false;

      //print(" product :${ProductList.length}");
      update();
    });
  }
}
