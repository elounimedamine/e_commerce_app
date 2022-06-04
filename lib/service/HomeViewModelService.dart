// @dart=2.9

import 'package:e_commerce_app/models/Category.dart';
import 'package:e_commerce_app/models/Product.dart';
import 'package:e_commerce_app/models/favoriteProduct.dart';
import 'package:e_commerce_app/service/ApplicationDb.dart';
import 'package:e_commerce_app/service/sqflitedatabase/EcommerceDatabasehelper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeViewModelService extends GetxController {
  ValueNotifier<bool> _IsLoding = ValueNotifier(false);
  ValueNotifier<bool> get IsLoding => _IsLoding;
  bool _isHomePageReady = false;
  bool get isHomePageReady => _isHomePageReady;

  var _CategoryList = <Category>[];

  List<Category> get CategoryList => _CategoryList;

  var _ProductList = <Product>[];
  var _original_allProduct = <Product>[];

  List<Product> get ProductList => _ProductList;

  List<favoriteProduct> _favoriteproduct = [];
  List<favoriteProduct> get favoriteproduct =>
      _favoriteproduct.where((element) => element.isfavorite == true).toList();

// for view list or grid
  bool _isList = true;
  bool get isList => _isList;

  var dbHelper = EcommerceDatabasehelper.db;

  HomeViewModelService() {
    getCategories().then((value) {});
    // getProducts(null);
    getProducts().then((value) {
      _isHomePageReady = true;
      update();
    });
    _original_allProduct = _ProductList;
  }

  onchangeListView() {
    _isList = !isList;
    update();
  }

  searchByProductName(String productName) {
    print('searching...');
    _ProductList = _ProductList.where((element) => element.name
        .toString()
        .toLowerCase()
        .contains(productName.toLowerCase())).toList();

    update();
  }

  clearSearch() {
    print('clear search');
    _ProductList = _original_allProduct;
    textserach.value = '';
    update();
  }

  filterbyCategory(String categoryId) {
    // _ProductList.where((element) => element.categoryId == categoryId).toList();
    //NOTE make isselected category equal true and filter data depends on category if selected or not
    _CategoryList.forEach((element) {
      if (element.categoryId == categoryId) {
        element.isselected = !element.isselected;
        if (element.isselected == true) {
          _ProductList = _original_allProduct
              .where((element) => element.categoryId == categoryId)
              .toList();
        } else {
          //NOTE if no category selected clear filter
          _ProductList = _original_allProduct;
        }
      }
    });

// NOTE unselect other categories
    _CategoryList.forEach((element) {
      if (element.categoryId != categoryId) {
        element.isselected = false;
      }
    });

    update();
  }

// set favorite product to firestore but not recomanded
  // setfavorite(String docid, bool isfavorite) {
  //   _ProductList.forEach((product) {
  //     if (product.id == docid) product.isfavorite = !product.isfavorite;
  //     ApplicationDb().setFavoriteProduct(docid, isfavorite);
  //   });
  //   update();
  // }

  addProductTofavorite(Product product, bool isfavorite) async {
    dbHelper = EcommerceDatabasehelper.db;

    //print("lenght of favorite ${_favoriteproduct.length ?? 0}");
    if (_favoriteproduct.length > 0) {
      var contain = _favoriteproduct
          .where((favproduct) => favproduct.product.id == product.id);
      // product not exist
      if (contain.isEmpty) {
        print("not exist");
        _favoriteproduct = await dbHelper.addfavoriteproduct(
            new favoriteProduct(product: product, isfavorite: isfavorite));
      } else {
        print("Exist");
        _favoriteproduct = await dbHelper.updatefavoriteProduct(
            new favoriteProduct(product: product, isfavorite: isfavorite));
      }
    } else {
      // no data in favorite product
      _favoriteproduct = await dbHelper.addfavoriteproduct(
          new favoriteProduct(product: product, isfavorite: isfavorite));
    }
    //update to favorite product

    // _favoriteproduct.forEach((element) {
    //   print(element.productId + " ---- " + element.isfavorite.toString());
    // });
    Notify_productlist();
    update();
  }

  Future<void> getCategories() async {
    _IsLoding.value = true;
    await ApplicationDb().getCategories().then((value) {
      for (int i = 0; i < value.length; i++) {
        _CategoryList.add(Category.fromjson(value[i].data()));
      }
      _IsLoding.value = false;

      update();
    });
  }

  Future<void> getProducts() async {
    _IsLoding.value = true;
    _favoriteproduct = await dbHelper.getallfavoriteproducts();
    //print(_favoriteproduct.length);
    // _favoriteproduct.forEach((element) {
    //   print("HomeView   ---" +
    //       element.productId +
    //       " : " +
    //       element.isfavorite.toString());
    // });
    await ApplicationDb().getProducts().then((value) {
      for (int i = 0; i < value.length; i++) {
        //   print(value[i].data());
        _ProductList.add(Product.fromJson(value[i].data()));
      }

      _IsLoding.value = false;
      update();

      Notify_productlist();
      //print(" product :${ProductList.length}");
    });
  }

  Notify_productlist() {
    // print(_favoriteproduct.length);
    if (_ProductList.length > 0)
      _ProductList.forEach((product) async {
        if (_favoriteproduct.length > 0)
          _favoriteproduct.forEach((favproduct) {
            if (product.id == favproduct.product.id) {
              product.isfavorite = favproduct.isfavorite;
            }
          });
      });
    update();
  }

  //NOTE search text -----------------------
  var textserach = "".obs;
  ontyping(String value) {
    textserach.value = value.trim();
  }
}
