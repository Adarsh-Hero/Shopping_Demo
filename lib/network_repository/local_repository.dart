import 'package:sqflite/sqflite.dart';

class Repository {
  static String dbName = "shopping.db";
  late Database db;

  static final Repository _singleton = Repository._internal();

  factory Repository() {
    return _singleton;
  }

  Repository._internal();

  Future open() async {
    db = await openDatabase(dbName, version: 1,
        onCreate: (db, version) async {
      var batch = db.batch();
      // We create all the tables
      _createTableProducts(batch);
      await batch.commit();
    });
  }

  Future close() async {
      await db.close();
  }

  void _createTableProducts(Batch batch) {
  batch.execute('DROP TABLE IF EXISTS products');
  batch.execute('''CREATE TABLE products (
  season TEXT,
  brand TEXT,
  mood TEXT,
  gender TEXT,
  theme TEXT,
  category TEXT,
  name TEXT,
  color TEXT,
  option TEXT,
  mrp TEXT,
  subCategory TEXT,
  collection TEXT,
  fit TEXT,
  description TEXT,
  qrCode TEXT,
  looks TEXT,
  looksImageUrl TEXT,
  looksImage TEXT,
  fabric TEXT,
  ean TEXT,
  finish TEXT,
  availableSizes TEXT,
  sizeWiseStock TEXT,
  offerMonths TEXT,
  productClass TEXT,
  promoted TEXT,
  secondry TEXT,
  deactivated TEXT,
  defaultSize TEXT,
  material TEXT,
  quality TEXT,
  qrCode2 TEXT,
  displayName TEXT,
  displayOrder TEXT,
  minQuantity TEXT,
  maxQuantiy TEXT,
  qpsCode TEXT,
  demandType TEXT,
  image TEXT,
  imageUrl TEXT,
  adShoot TEXT,
  technology TEXT,
  imageAlt TEXT,
  technologyImage TEXT,
  technologyImageUrl TEXT,
  isCore TEXT,
  minimumArticleQuantity TEXT,
  likeablity TEXT,
  brandRank TEXT
)''');
  }
}
