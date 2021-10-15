import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class Product {
  String? season;
  String? brand;
  String? mood;
  String? gender;
  String? theme;
  String? category;
  String? name;
  String? color;
  String? option;
  double? mrp;
  String? subCategory;
  String? collection;
  String? fit;
  String? description;
  String? qrCode;
  String? looks;
  String? looksImageUrl;
  String? looksImage;
  String? fabric;
  dynamic ean;
  String? finish;
  dynamic availableSizes;
  String? sizeWiseStock;
  dynamic offerMonths;
  int? productClass;
  String? promoted;
  String? secondry;
  String? deactivated;
  int? defaultSize;
  String? material;
  String? quality;
  String? qrCode2;
  String? displayName;
  int? displayOrder;
  int? minQuantity;
  int? maxQuantiy;
  String? qpsCode;
  String? demandType;
  String? image;
  String? imageUrl;
  String? adShoot;
  String? technology;
  String? imageAlt;
  String? technologyImage;
  String? technologyImageUrl;
  String? isCore;
  int? minimumArticleQuantity;
  double? likeablity;
  String? brandRank;
Product();
  Product.fromJson(Map<dynamic, dynamic> data,
      {bool isForDatabaseModel = false}) {
    season = data['Season'] ?? '';
    brand = data['Brand'] ?? '';
    mood = data['Mood'] ?? '';
    gender = data['Gender'] ?? '';
    theme = data['Theme'] ?? '';
    category = data['Category'] ?? '';
    name = data['Name'] ?? '';
    color = data['Color'] ?? '';
    option = data['Option'] ?? '';
    mrp = data['MRP'] ?? 0.0;
    subCategory = data['SubCategory'] ?? '';
    collection = data['Collection'] ?? '';
    fit = data['FIT'] ?? '';
    description = data['Description'] ?? '';
    qrCode = data['QRCode'] ?? '';
    looks = data['Looks'] ?? '';
    looksImageUrl = data['LooksImageUrl'] ?? '';
    looksImage = data['looksImage'] ?? '';
    fabric = data['Fabric'] ?? '';
    var _ean = data['EAN'];
    if (isForDatabaseModel) {
      ean = json.encode(_ean);
    } else {
      ean = {};
      if (_ean != null && _ean.isNotEmpty) {
        _ean.forEach((k, v) {
          ean!['$k'] = v;
        });
      }
    }
    var _avalableSizes = data['AvailableSizes'];
    finish = data['Finish'] ?? '';
    if (isForDatabaseModel) {
      availableSizes = json.encode(availableSizes);
    } else {
      availableSizes = [];
      if (_avalableSizes != null && _avalableSizes.isNotEmpty) {
        for (var item in _avalableSizes) {
          availableSizes!.add(item);
        }
      }
    }
    var om = data['OfferMonths'];
    sizeWiseStock = data['SizeWiseStock'] ?? '';
    if (isForDatabaseModel) {
      offerMonths = json.encode(om);
    } else {
      offerMonths = [];

      if (om != null && om.isNotEmpty) {
        for (var item in om) {
          offerMonths!.add(item);
        }
      }
    }
    productClass = data['ProductClass'];
    promoted =
        (data['Promoted'] != null && data['Promoted'] == true) ? '1' : '0';
    secondry =
        (data['Secondary'] != null && data['Secondary'] == true) ? '1' : '0';
    deactivated = (data['Deactivated'] != null && data['Deactivated'] == true)
        ? '1'
        : '0';
    defaultSize = data['DefaultSize'];
    material = data['Material'] ?? '';
    quality = data['Stretch'] ?? '';
    qrCode2 = data['QRCode2'] ?? '';
    displayName = data['DisplayName'] ?? '';
    displayOrder = data['DisplayOrder'] ?? 0;
    minQuantity = data['MinQuantity'] ?? 0;
    maxQuantiy = data['MaxQuantity'] ?? 0;
    qpsCode = data['QPSCode'] ?? '';
    demandType = data['DemandType'] ?? '';
    image = data['Image'] ?? '';
    imageUrl = data['ImageUrl'] ?? '';
    adShoot = (data['AdShoot'] != null && data['AdShoot'] == true) ? '1' : '0';
    technology = data['Technology'] ?? '';
    imageAlt = data['ImageAlt'] ?? '';
    technologyImage = data['TechnologyImage'] ?? '';
    technologyImageUrl = data['TechnologyImageUrl'] ?? '';
    isCore = (data['IsCore'] != null && data['IsCore'] == true) ? '1' : '0';
    minimumArticleQuantity = data['MinimumArticleQuantity'] ?? 0;
    likeablity = data['Likeabilty'] ?? 0.00;
    brandRank = data['BrandRank'] ?? '';
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "season": season,
      "brand": brand,
      "mood": mood,
      "gender": gender,
      "theme": theme,
      "category": category,
      "name": name,
      "color": color,
      "option": option,
      "mrp": mrp,
      "subCategory": subCategory,
      " collection": collection,
      "fit": fit,
      "description": description,
      "qrCode": qrCode,
      "looks": looks,
      "looksImageUrl": looksImageUrl,
      "looksImage": looksImage,
      "fabric": fabric,
      "EAN": ean,
      "finish": finish,
      "availableSizes": availableSizes,
      " sizeWiseStock": sizeWiseStock,
      "offerMonths": offerMonths,
      "productClass": productClass,
      "promoted": promoted,
      "secondry": secondry,
      "deactivated": deactivated,
      "defaultSize": defaultSize,
      " material": material,
      "quality": quality,
      "qrCode2": qrCode2,
      "displayName": displayName,
      "displayOrder": displayOrder,
      "minQuantity": minQuantity,
      "maxQuantiy": maxQuantiy,
      "qpsCode": qpsCode,
      "demandType": demandType,
      "image": image,
      "imageUrl": imageUrl,
      "adShoot": adShoot,
      "technology": technology,
      "imageAlt": imageAlt,
      "technologyImage": technologyImage,
      "technologyImageUrl": technologyImageUrl,
      "isCore": isCore,
      "minimumArticleQuantity": minimumArticleQuantity,
      "likeablity": likeablity,
      "brandRank": brandRank,
    };
    return map;
  }

  static Future<Product> insert(Database db, Product data) async {
    await db.insert('products', data.toMap());
    return data;
  }

  static Future<List<Map<dynamic, dynamic>?>> getItems(Database db,
      {String? qrCode, String? option}) async {
    List<Map> maps = await db.query('products',
        columns: null,
        where: 'qrCode = ? OR option = ?',
        whereArgs: [qrCode, option!.toUpperCase()]);
    if (maps.length > 0) {
      var products = <Map<dynamic, dynamic>?>[];
      for (var i = 0; i < maps.length; i++) {
        products.add(maps[i]);
      }
      return products;
    }
    return [];
  }


}
