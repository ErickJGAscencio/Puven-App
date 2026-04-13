import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:localix/data/tables/product_size.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/products.dart';
import 'tables/product_variants.dart';

part 'database.g.dart';

class DatabaseProvider {
  static final AppDatabase instance = AppDatabase();
}

@DriftDatabase(tables: [Products, ProductVariants, ProductSizes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      // Se ejecuta la primera vez que se crea la base
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from == 7) {
        // Definir que hacer al pasar de version X a Y
        //await m.addColumn(products, products.price);
        print("ACTUAIZA");
        await m.createTable(productVariants);
        await customStatement('''
        INSERT INTO product_variants (id, product_id, size, price, price_per_kg)
        SELECT id, product_id, size, price, price_per_kg FROM product_variants_old;
      ''');
        // /////////
        //         // 1. Añadir la columna en la nueva tabla
        //       await m.addColumn(productVariants, productVariants.pricePerKg);

        //       // 2. Copiar datos de la columna antigua a la nueva
        //       await customStatement('''
        //         UPDATE product_variants
        //         SET price_per_kg = (
        //           SELECT price_per_kg FROM products
        //           WHERE products.id = product_variants.product_id
        //         )
        //       ''');
      }
    },
    beforeOpen: (details) async {
      // Para acciones antes de abrir la base
    },
  );

  // CRUD operations for Products
  Future<int> insertProduct(ProductsCompanion product) =>
      into(products).insert(product);

  Stream<List<Product>> watchProducts() {
    return select(products).watch();
  }

  Future<List<Product>> getAllProducts() => select(products).get();

  Future deleteProduct(int id) =>
      (delete(products)..where((tbl) => tbl.id.equals(id))).go();

  Future updateProduct(Product product) => update(products).replace(product);

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

  // CRUD operations for Sizes
  Future<int> insertSize(ProductSizesCompanion size) =>
      into(productSizes).insert(size);

  Stream<List<ProductSize>> watchSizes() => select(productSizes).watch();

  Future<List<ProductSize>> getAllSizes() => select(productSizes).get();

  Future deleteSize(int id) =>
      (delete(productSizes)..where((tbl) => tbl.id.equals(id))).go();

  Future updateSize(ProductSize size) => update(productSizes).replace(size);
}

//conexión SQLite
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}
