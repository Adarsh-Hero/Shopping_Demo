import 'package:http/http.dart' as http;

const url =
    'https://debug.qart.fashion/api/product/GetProductsWithSizes?retailerCode=40984';
const okStatusCode = 200;

 Future<String> getProductList() async{
  try {
    var res=await http.get( Uri.parse(url));
    if(res.statusCode ==okStatusCode){
      return res.body;
    }
    return 'error';
  } catch (e) {
    return e.toString();
  }
}
