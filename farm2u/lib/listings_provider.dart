import 'package:farm2u/product.dart';
import 'package:flutter/material.dart';


class ListingProductProvider with ChangeNotifier {

  ListingProduct _product = ListingProduct(products: []);

  ListingProduct get product => _product;

  void setProductObject(ListingProduct product) {
    _product = product;
    notifyListeners();
  }

  void setProducts(List<Map<String, dynamic>> products)
  {
    _product.products = products;
    notifyListeners();
  }

  void setProduct(Map<String, dynamic> product){
    if(product != null){
      _product.products.add(product);
    }
    notifyListeners();
  }

  void clearProducts() {
    _product.products.clear();
    notifyListeners();
  }

}