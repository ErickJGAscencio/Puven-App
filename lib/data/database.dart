import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/products.dart';
import 'tables/product_variants.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Products, ProductVariants])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> insertProduct(ProductsCompanion product) =>
      into(products).insert(product);

  Stream<List<Product>> watchProducts() {
    return select(products).watch();
  }

  Future<List<Product>> getAllProducts() => select(products).get();

  Future deleteProduct(int id) =>
      (delete(products)..where((tbl) => tbl.id.equals(id))).go();

  Future updateProduct(Product product) => update(products).replace(product);

  ///////////////
  ///

  Future<int> insertVariant(ProductVariantsCompanion variant) =>
      into(productVariants).insert(variant);

  Stream<List<ProductVariant>> watchVariants(int productId) {
    return (select(
      productVariants,
    )..where((tbl) => tbl.productId.equals(productId))).watch();
  }

  Future deleteVariantsByProduct(int productId) => (delete(
    productVariants,
  )..where((tbl) => tbl.productId.equals(productId))).go();
}

//conexión SQLite
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}
