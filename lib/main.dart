import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_demo/product_detail_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopping_demo/models/product_model.dart';
import 'package:shopping_demo/network_repository/get_products.dart';

import 'network_repository/local_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Product?> _products = [];
  bool _isShimmerEnabled = true;
  TextEditingController _searchController = TextEditingController();
  List _searchedProducts = [];
  late Database db;

  @override
  void initState() {
    super.initState();
    _initializeDataBase();
    _getProductListAndSave();
  }

  void _initializeDataBase() async {
    await Repository().open();
    db = Repository().db;
  }

  void _getProductListAndSave() async {
    setState(() {
      _isShimmerEnabled = true;
    });
    var data = json.decode(await getProductList());
    if (data['Products'] != null && data['Products'].isNotEmpty) {
      var productList = data['Products'];
      await _saveData(productList);
      setState(() {
        _isShimmerEnabled = false;
      });
    }
  }

   _saveData(data) async {
    for (var item in data) {
      _products.add(Product.fromJson(item));
      var itemTobeInsertedInDataBase =
      Product.fromJson(item, isForDatabaseModel: true);
      await Product.insert(db, itemTobeInsertedInDataBase);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async => _getProductListAndSave(),
          child: Container(
              height: size.height,
              width: size.width,
              child: Column(
                children: [
                  _buildHeader(size),
                  _searchedProducts.isNotEmpty
                      ? _buildSearchedData(size)
                      : Container(),
                  _searchedProducts.isEmpty
                      ? Expanded(child: _buildProductGrid(size))
                      : Container(),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.brown, spreadRadius: 5)
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Icon(Icons.search),
          SizedBox(
            width: 10,
          ),
          Container(
            width: size.width * .70,
            height: size.height * 0.08,
            child: TextField(
              controller: _searchController,
              onChanged: (searchedPhrase) async {
                _searchedProducts = await Product.getItems(db,
                    qrCode: searchedPhrase,
                    option: searchedPhrase);
                setState(() {});
              },
              style: TextStyle(
                color: Colors.brown,
              ),
            ),
          ),
          _searchController.text != ''
              ? Container(
            child: IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  _searchController.text = '';
                  _searchedProducts = [];
                  setState(() {});
                }),
          )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildSearchedData(Size size) {
    return Expanded(
      child: ListView.builder(
        itemCount: _searchedProducts.length,
        itemBuilder: (context, index) {
          var eanKeys = json
              .decode(_searchedProducts[index]['ean']!)
              .keys
              .toString();
          eanKeys =
              eanKeys.substring(1, eanKeys.length - 1);
          return InkWell(
            onTap: () => _moveToProductDetailScreen(context, _searchedProducts[index], true),
            child: Container(
              height: 150,
              width: size.width * .70,
              padding: EdgeInsets.only(right: 10, left: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white70),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(_searchedProducts[index]['qrCode']),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        width: size.width * .35,
                        color: Colors.grey,
                        padding: EdgeInsets.all(10),
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              Container(
                                width: 40,
                                height: 40,
                                child: Center(
                                  child:
                                  CircularProgressIndicator(
                                    backgroundColor:
                                    Colors.green,
                                    valueColor:
                                    AlwaysStoppedAnimation<
                                        Color>(
                                        Colors.white),
                                  ),
                                ),
                              ),
                          imageUrl: _searchedProducts[index]
                          ['imageUrl'],
                          imageBuilder:
                              (context, imageProvider) =>
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(
                                      Radius.circular(10)),
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) =>
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius:
                                  BorderRadius.circular(20),
                                ),
                                child: Image.asset(
                                    "assets/place_holder.jpeg",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity),
                              ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 100,
                        width: size.width * .30,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(_searchedProducts[index]
                            ['color']),
                            SizedBox(
                              height: 5,
                            ),
                            Text(_searchedProducts[index]
                            ['option']),
                            SizedBox(
                              height: 5,
                            ),
                            Text(_searchedProducts[index]
                            ['mrp']),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 100,
                        width: size.width * .20,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(eanKeys),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(Size size) {
    if (_isShimmerEnabled) {
      return SizedBox(
        height: size.height * .75,
        width: size.width,
        child: GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(0),
            children: List.generate(10, (index) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  enabled: _isShimmerEnabled,
                  child: Container(
                    height: size.width * .35,
                    width: size.height * .35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ),
              );
            })),
      );
    }
    return Container(
      padding: EdgeInsets.all(10),
      child: GridView.builder(
          addAutomaticKeepAlives: true,
          itemCount: _products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 10),
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () => _moveToProductDetailScreen(context, _products[index], false),
                child: Container(
            decoration: BoxDecoration(
            color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.brown, spreadRadius: 5)
                ]),
            child: SizedBox(
            height: size.height * 0.4,
            width: size.width * 0.3,
            child: Stack(
            children: [
            Container(
            height: size.height * 0.15,
            child: CachedNetworkImage(
            placeholder: (context, url) => Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
            child: CircularProgressIndicator(
            backgroundColor: Colors.green,
            valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white),
            ),
            ),
            ),
            imageUrl: _products[index]!.imageUrl!,
            imageBuilder: (context, imageProvider) => Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5)),
            image: DecorationImage(
            image: imageProvider, fit: BoxFit.cover),
            ),
            ),
            errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset("assets/place_holder.jpeg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity),
            ),
            ),
            ),
            Positioned(
            bottom: 10,
            left: 10,
            child: Row(
            children: [
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
            _products[index]!.name!,
            style: TextStyle(fontSize: 20),
            ),
            SizedBox(
            width: 15,
            ),
            Text(
            _products[index]!.brand!,
            style: TextStyle(fontSize: 20),
            ),
            ],
            ),
            SizedBox(
            width: 10,
            ),
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
            _products[index]!.category!,
            style: TextStyle(fontSize: 20),
            ),
            SizedBox(
            width: 10,
            ),
            Text(
            "\$" + _products[index]!.mrp.toString(),
            style: TextStyle(fontSize: 20),
            ),
            ],
            ),
            ],
            )),
            ],
            ),
            ))
            ,
            );
          }),
    );
  }

  SliverAppBar showSliverAppBar(String screenTitle) {
    return SliverAppBar(
      backgroundColor: Colors.purple,
      floating: true,
      pinned: true,
      snap: false,
      title: Text(screenTitle),
      bottom: TabBar(
        tabs: [
          Tab(
            icon: Icon(Icons.home),
            text: 'Home',
          ),
          Tab(
            icon: Icon(Icons.settings),
            text: 'Setting',
          )
        ],
      ),
    );
  }


  void _moveToProductDetailScreen(context, data, bool isSearchedItem) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (ctx){
        if(isSearchedItem){
          return  ProductDetail(
            productDetail: data,
            isFromSearch: isSearchedItem,
          );
        }
          return  ProductDetail(
            myProduct: data,
            isFromSearch: isSearchedItem,
          );
      }
    ),
  );
}
}
