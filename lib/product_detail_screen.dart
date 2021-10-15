import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'components/my_edit_field.dart';
import 'models/product_model.dart';

class ProductDetail extends StatefulWidget {
  final Map<dynamic, dynamic>? productDetail;
  final isFromSearch;
  final Product? myProduct;
  const ProductDetail(
      {Key? key, this.productDetail, this.myProduct, this.isFromSearch = false})
      : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    var offMonths = widget.isFromSearch
        ? widget.productDetail!['offerMonths']!
            .substring(2, widget.productDetail!['offerMonths'].length - 2)
        : '';
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: widget.isFromSearch
            ? Text('Q-Art ${widget.productDetail!['qrCode']}')
            : Text('Q-Art ${widget.myProduct!.qrCode}'),
        backgroundColor: Colors.white70,
        leading: IconButton(
          onPressed: ()=> Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                height: size.height * 0.5,
                width: size.width,
                color: Colors.white,
                child: GridView.builder(
                    addAutomaticKeepAlives: true,
                    itemCount: 30,
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: index == _selectedIndex
                                          ? Colors.brown
                                          : Colors.grey,
                                      spreadRadius: 5)
                                ]),
                            child: SizedBox(
                              height: size.height * 0.5,
                              width: size.width * 0.25,
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        bottom: 30,
                                        top: 5),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.green,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ),
                                      ),
                                      imageUrl: !widget.isFromSearch
                                          ? widget.myProduct!.imageUrl
                                          : widget.productDetail!['imageUrl']!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5)),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
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
                                  Positioned(
                                      bottom: 30,
                                      left: 0,
                                      child: Container(
                                        width: size.width * 0.5,
                                        height: size.height * 0.06,
                                        color: Colors.black.withOpacity(0.5),
                                        child: Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  !widget.isFromSearch
                                                      ? widget.myProduct!
                                                          .displayName
                                                      : widget.productDetail![
                                                          'displayName']!,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  !widget.isFromSearch
                                                      ? widget.myProduct!.color
                                                      : widget.productDetail![
                                                          'color'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                widget.isFromSearch == true
                                                    ? Text(
                                                        "\$ " +
                                                            widget.productDetail![
                                                                'mrp']!,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : Text(
                                                        "\$ " +
                                                            widget
                                                                .myProduct!.mrp
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                  Positioned(
                                    bottom: 5,
                                    left: 10,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        ...List.generate(
                                          5,
                                          (index) => _buildStar(),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('(5.0)'),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      bottom: size.height * 0.1,
                                      left: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(16),
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: Image.asset(
                                          'assets/rate_star.png',
                                          height: 16,
                                          width: 16,
                                          color: Colors.brown,
                                        ),
                                      )),
                                  Positioned(
                                      bottom: size.height * 0.1,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(16),
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                        child: Image.asset(
                                          'assets/rate_star.png',
                                          height: 16,
                                          width: 16,
                                          color: Colors.brown,
                                        ),
                                      )),
                                ],
                              ),
                            )),
                      );
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Container(
                        height: size.height * 0.07,
                        width: size.width * 0.95,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: MyEditText(
                          placeholder: !widget.isFromSearch
                              ? '${widget.myProduct!.brand}-${widget.myProduct!.category}-${widget.myProduct!.collection}'
                              : '${widget.productDetail!['brand']}-${widget.productDetail!['category']}-${widget.productDetail!['collection']}',
                          text: 'Brand-Cate_gory-Collection',
                        )),
                    Container(
                        height: size.height * 0.07,
                        width: size.width * 0.95,
                        decoration: BoxDecoration(
                          color: Colors.green,
                        ),
                        child: MyEditText(
                          placeholder: !widget.isFromSearch
                              ? '${widget.myProduct!.gender}-${widget.myProduct!.name}-${widget.myProduct!.subCategory}'
                              : '${widget.productDetail!['gender']}-${widget.productDetail!['name']}-${widget.productDetail!['subCategory']}',
                          text: 'Gender-Name-Subcategory',
                        )),
                    Container(
                        height: size.height * 0.07,
                        width: size.width * 0.95,
                        decoration: BoxDecoration(
                          color: Colors.green,
                        ),
                        child: MyEditText(
                          placeholder: !widget.isFromSearch
                              ? '${widget.myProduct!.fit}-${widget.myProduct!.theme}-${widget.myProduct!.finish}'
                              : '${widget.productDetail!['fit']}-${widget.productDetail!['theme']}-${widget.productDetail!['finish']}',
                          text: 'Fit-Theme-Finish',
                        )),
                    Container(
                      height: size.height * 0.07,
                      width: size.width * 0.95,
                      decoration: BoxDecoration(
                        color: Colors.green,
                      ),
                      child: MyEditText(
                        placeholder: !widget.isFromSearch
                            ? '${widget.myProduct!.offerMonths}-${widget.myProduct!.mood}'
                            : '$offMonths-${widget.productDetail!['mood']}',
                        text: 'OFF_MONTH-Mo_od',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: size.height * 0.07,
                width: size.width * 0.95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Text('Description'),
                    SizedBox(
                      height: 5,
                    ),
                    !widget.isFromSearch
                        ? Text('${widget.myProduct!.description}')
                        : Text('${widget.productDetail!['description']}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStar() {
    return Row(
      children: [
        Image.asset(
          'assets/rate_star.png',
          height: 16,
          width: 16,
          color: Colors.brown,
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}
