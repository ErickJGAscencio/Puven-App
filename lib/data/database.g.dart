// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasSizesMeta = const VerificationMeta(
    'hasSizes',
  );
  @override
  late final GeneratedColumn<bool> hasSizes = GeneratedColumn<bool>(
    'has_sizes',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_sizes" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isByGramsMeta = const VerificationMeta(
    'isByGrams',
  );
  @override
  late final GeneratedColumn<bool> isByGrams = GeneratedColumn<bool>(
    'is_by_grams',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_by_grams" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [productId, name, hasSizes, isByGrams];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('has_sizes')) {
      context.handle(
        _hasSizesMeta,
        hasSizes.isAcceptableOrUnknown(data['has_sizes']!, _hasSizesMeta),
      );
    }
    if (data.containsKey('is_by_grams')) {
      context.handle(
        _isByGramsMeta,
        isByGrams.isAcceptableOrUnknown(data['is_by_grams']!, _isByGramsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productId};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      hasSizes: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_sizes'],
      )!,
      isByGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_by_grams'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int productId;
  final String name;
  final bool hasSizes;
  final bool isByGrams;
  const Product({
    required this.productId,
    required this.name,
    required this.hasSizes,
    required this.isByGrams,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_id'] = Variable<int>(productId);
    map['name'] = Variable<String>(name);
    map['has_sizes'] = Variable<bool>(hasSizes);
    map['is_by_grams'] = Variable<bool>(isByGrams);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      productId: Value(productId),
      name: Value(name),
      hasSizes: Value(hasSizes),
      isByGrams: Value(isByGrams),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      productId: serializer.fromJson<int>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      hasSizes: serializer.fromJson<bool>(json['hasSizes']),
      isByGrams: serializer.fromJson<bool>(json['isByGrams']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<int>(productId),
      'name': serializer.toJson<String>(name),
      'hasSizes': serializer.toJson<bool>(hasSizes),
      'isByGrams': serializer.toJson<bool>(isByGrams),
    };
  }

  Product copyWith({
    int? productId,
    String? name,
    bool? hasSizes,
    bool? isByGrams,
  }) => Product(
    productId: productId ?? this.productId,
    name: name ?? this.name,
    hasSizes: hasSizes ?? this.hasSizes,
    isByGrams: isByGrams ?? this.isByGrams,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      hasSizes: data.hasSizes.present ? data.hasSizes.value : this.hasSizes,
      isByGrams: data.isByGrams.present ? data.isByGrams.value : this.isByGrams,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('hasSizes: $hasSizes, ')
          ..write('isByGrams: $isByGrams')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(productId, name, hasSizes, isByGrams);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.hasSizes == this.hasSizes &&
          other.isByGrams == this.isByGrams);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> productId;
  final Value<String> name;
  final Value<bool> hasSizes;
  final Value<bool> isByGrams;
  const ProductsCompanion({
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.hasSizes = const Value.absent(),
    this.isByGrams = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.productId = const Value.absent(),
    required String name,
    this.hasSizes = const Value.absent(),
    this.isByGrams = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Product> custom({
    Expression<int>? productId,
    Expression<String>? name,
    Expression<bool>? hasSizes,
    Expression<bool>? isByGrams,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (hasSizes != null) 'has_sizes': hasSizes,
      if (isByGrams != null) 'is_by_grams': isByGrams,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? productId,
    Value<String>? name,
    Value<bool>? hasSizes,
    Value<bool>? isByGrams,
  }) {
    return ProductsCompanion(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      hasSizes: hasSizes ?? this.hasSizes,
      isByGrams: isByGrams ?? this.isByGrams,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (hasSizes.present) {
      map['has_sizes'] = Variable<bool>(hasSizes.value);
    }
    if (isByGrams.present) {
      map['is_by_grams'] = Variable<bool>(isByGrams.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('hasSizes: $hasSizes, ')
          ..write('isByGrams: $isByGrams')
          ..write(')'))
        .toString();
  }
}

class $ProductSizesTable extends ProductSizes
    with TableInfo<$ProductSizesTable, ProductSize> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductSizesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productSizeIdMeta = const VerificationMeta(
    'productSizeId',
  );
  @override
  late final GeneratedColumn<int> productSizeId = GeneratedColumn<int>(
    'product_size_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [productSizeId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_sizes';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductSize> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_size_id')) {
      context.handle(
        _productSizeIdMeta,
        productSizeId.isAcceptableOrUnknown(
          data['product_size_id']!,
          _productSizeIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productSizeId};
  @override
  ProductSize map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductSize(
      productSizeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_size_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $ProductSizesTable createAlias(String alias) {
    return $ProductSizesTable(attachedDatabase, alias);
  }
}

class ProductSize extends DataClass implements Insertable<ProductSize> {
  final int productSizeId;
  final String name;
  const ProductSize({required this.productSizeId, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_size_id'] = Variable<int>(productSizeId);
    map['name'] = Variable<String>(name);
    return map;
  }

  ProductSizesCompanion toCompanion(bool nullToAbsent) {
    return ProductSizesCompanion(
      productSizeId: Value(productSizeId),
      name: Value(name),
    );
  }

  factory ProductSize.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductSize(
      productSizeId: serializer.fromJson<int>(json['productSizeId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productSizeId': serializer.toJson<int>(productSizeId),
      'name': serializer.toJson<String>(name),
    };
  }

  ProductSize copyWith({int? productSizeId, String? name}) => ProductSize(
    productSizeId: productSizeId ?? this.productSizeId,
    name: name ?? this.name,
  );
  ProductSize copyWithCompanion(ProductSizesCompanion data) {
    return ProductSize(
      productSizeId: data.productSizeId.present
          ? data.productSizeId.value
          : this.productSizeId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductSize(')
          ..write('productSizeId: $productSizeId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(productSizeId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductSize &&
          other.productSizeId == this.productSizeId &&
          other.name == this.name);
}

class ProductSizesCompanion extends UpdateCompanion<ProductSize> {
  final Value<int> productSizeId;
  final Value<String> name;
  const ProductSizesCompanion({
    this.productSizeId = const Value.absent(),
    this.name = const Value.absent(),
  });
  ProductSizesCompanion.insert({
    this.productSizeId = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<ProductSize> custom({
    Expression<int>? productSizeId,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (productSizeId != null) 'product_size_id': productSizeId,
      if (name != null) 'name': name,
    });
  }

  ProductSizesCompanion copyWith({
    Value<int>? productSizeId,
    Value<String>? name,
  }) {
    return ProductSizesCompanion(
      productSizeId: productSizeId ?? this.productSizeId,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productSizeId.present) {
      map['product_size_id'] = Variable<int>(productSizeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductSizesCompanion(')
          ..write('productSizeId: $productSizeId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ProductVariantsTable extends ProductVariants
    with TableInfo<$ProductVariantsTable, ProductVariant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductVariantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productVariantIdMeta = const VerificationMeta(
    'productVariantId',
  );
  @override
  late final GeneratedColumn<int> productVariantId = GeneratedColumn<int>(
    'product_variant_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (product_id)',
    ),
  );
  static const VerificationMeta _productSizeIdMeta = const VerificationMeta(
    'productSizeId',
  );
  @override
  late final GeneratedColumn<int> productSizeId = GeneratedColumn<int>(
    'product_size_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES product_sizes (product_size_id)',
    ),
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pricePerKgMeta = const VerificationMeta(
    'pricePerKg',
  );
  @override
  late final GeneratedColumn<double> pricePerKg = GeneratedColumn<double>(
    'price_per_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    productVariantId,
    productId,
    productSizeId,
    price,
    pricePerKg,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_variants';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductVariant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_variant_id')) {
      context.handle(
        _productVariantIdMeta,
        productVariantId.isAcceptableOrUnknown(
          data['product_variant_id']!,
          _productVariantIdMeta,
        ),
      );
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_size_id')) {
      context.handle(
        _productSizeIdMeta,
        productSizeId.isAcceptableOrUnknown(
          data['product_size_id']!,
          _productSizeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productSizeIdMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('price_per_kg')) {
      context.handle(
        _pricePerKgMeta,
        pricePerKg.isAcceptableOrUnknown(
          data['price_per_kg']!,
          _pricePerKgMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productVariantId};
  @override
  ProductVariant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductVariant(
      productVariantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_variant_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      productSizeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_size_id'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      ),
      pricePerKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_per_kg'],
      ),
    );
  }

  @override
  $ProductVariantsTable createAlias(String alias) {
    return $ProductVariantsTable(attachedDatabase, alias);
  }
}

class ProductVariant extends DataClass implements Insertable<ProductVariant> {
  final int productVariantId;
  final int productId;
  final int productSizeId;
  final double? price;
  final double? pricePerKg;
  const ProductVariant({
    required this.productVariantId,
    required this.productId,
    required this.productSizeId,
    this.price,
    this.pricePerKg,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_variant_id'] = Variable<int>(productVariantId);
    map['product_id'] = Variable<int>(productId);
    map['product_size_id'] = Variable<int>(productSizeId);
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    if (!nullToAbsent || pricePerKg != null) {
      map['price_per_kg'] = Variable<double>(pricePerKg);
    }
    return map;
  }

  ProductVariantsCompanion toCompanion(bool nullToAbsent) {
    return ProductVariantsCompanion(
      productVariantId: Value(productVariantId),
      productId: Value(productId),
      productSizeId: Value(productSizeId),
      price: price == null && nullToAbsent
          ? const Value.absent()
          : Value(price),
      pricePerKg: pricePerKg == null && nullToAbsent
          ? const Value.absent()
          : Value(pricePerKg),
    );
  }

  factory ProductVariant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductVariant(
      productVariantId: serializer.fromJson<int>(json['productVariantId']),
      productId: serializer.fromJson<int>(json['productId']),
      productSizeId: serializer.fromJson<int>(json['productSizeId']),
      price: serializer.fromJson<double?>(json['price']),
      pricePerKg: serializer.fromJson<double?>(json['pricePerKg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productVariantId': serializer.toJson<int>(productVariantId),
      'productId': serializer.toJson<int>(productId),
      'productSizeId': serializer.toJson<int>(productSizeId),
      'price': serializer.toJson<double?>(price),
      'pricePerKg': serializer.toJson<double?>(pricePerKg),
    };
  }

  ProductVariant copyWith({
    int? productVariantId,
    int? productId,
    int? productSizeId,
    Value<double?> price = const Value.absent(),
    Value<double?> pricePerKg = const Value.absent(),
  }) => ProductVariant(
    productVariantId: productVariantId ?? this.productVariantId,
    productId: productId ?? this.productId,
    productSizeId: productSizeId ?? this.productSizeId,
    price: price.present ? price.value : this.price,
    pricePerKg: pricePerKg.present ? pricePerKg.value : this.pricePerKg,
  );
  ProductVariant copyWithCompanion(ProductVariantsCompanion data) {
    return ProductVariant(
      productVariantId: data.productVariantId.present
          ? data.productVariantId.value
          : this.productVariantId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productSizeId: data.productSizeId.present
          ? data.productSizeId.value
          : this.productSizeId,
      price: data.price.present ? data.price.value : this.price,
      pricePerKg: data.pricePerKg.present
          ? data.pricePerKg.value
          : this.pricePerKg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductVariant(')
          ..write('productVariantId: $productVariantId, ')
          ..write('productId: $productId, ')
          ..write('productSizeId: $productSizeId, ')
          ..write('price: $price, ')
          ..write('pricePerKg: $pricePerKg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    productVariantId,
    productId,
    productSizeId,
    price,
    pricePerKg,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductVariant &&
          other.productVariantId == this.productVariantId &&
          other.productId == this.productId &&
          other.productSizeId == this.productSizeId &&
          other.price == this.price &&
          other.pricePerKg == this.pricePerKg);
}

class ProductVariantsCompanion extends UpdateCompanion<ProductVariant> {
  final Value<int> productVariantId;
  final Value<int> productId;
  final Value<int> productSizeId;
  final Value<double?> price;
  final Value<double?> pricePerKg;
  const ProductVariantsCompanion({
    this.productVariantId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productSizeId = const Value.absent(),
    this.price = const Value.absent(),
    this.pricePerKg = const Value.absent(),
  });
  ProductVariantsCompanion.insert({
    this.productVariantId = const Value.absent(),
    required int productId,
    required int productSizeId,
    this.price = const Value.absent(),
    this.pricePerKg = const Value.absent(),
  }) : productId = Value(productId),
       productSizeId = Value(productSizeId);
  static Insertable<ProductVariant> custom({
    Expression<int>? productVariantId,
    Expression<int>? productId,
    Expression<int>? productSizeId,
    Expression<double>? price,
    Expression<double>? pricePerKg,
  }) {
    return RawValuesInsertable({
      if (productVariantId != null) 'product_variant_id': productVariantId,
      if (productId != null) 'product_id': productId,
      if (productSizeId != null) 'product_size_id': productSizeId,
      if (price != null) 'price': price,
      if (pricePerKg != null) 'price_per_kg': pricePerKg,
    });
  }

  ProductVariantsCompanion copyWith({
    Value<int>? productVariantId,
    Value<int>? productId,
    Value<int>? productSizeId,
    Value<double?>? price,
    Value<double?>? pricePerKg,
  }) {
    return ProductVariantsCompanion(
      productVariantId: productVariantId ?? this.productVariantId,
      productId: productId ?? this.productId,
      productSizeId: productSizeId ?? this.productSizeId,
      price: price ?? this.price,
      pricePerKg: pricePerKg ?? this.pricePerKg,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productVariantId.present) {
      map['product_variant_id'] = Variable<int>(productVariantId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productSizeId.present) {
      map['product_size_id'] = Variable<int>(productSizeId.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (pricePerKg.present) {
      map['price_per_kg'] = Variable<double>(pricePerKg.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductVariantsCompanion(')
          ..write('productVariantId: $productVariantId, ')
          ..write('productId: $productId, ')
          ..write('productSizeId: $productSizeId, ')
          ..write('price: $price, ')
          ..write('pricePerKg: $pricePerKg')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
    'order_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _folioMeta = const VerificationMeta('folio');
  @override
  late final GeneratedColumn<String> folio = GeneratedColumn<String>(
    'folio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _processStatusMeta = const VerificationMeta(
    'processStatus',
  );
  @override
  late final GeneratedColumn<String> processStatus = GeneratedColumn<String>(
    'process_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant("Pendiente"),
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deliveredAtMeta = const VerificationMeta(
    'deliveredAt',
  );
  @override
  late final GeneratedColumn<DateTime> deliveredAt = GeneratedColumn<DateTime>(
    'delivered_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    orderId,
    folio,
    createdAt,
    totalAmount,
    processStatus,
    paymentMethod,
    notes,
    deliveredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Order> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    }
    if (data.containsKey('folio')) {
      context.handle(
        _folioMeta,
        folio.isAcceptableOrUnknown(data['folio']!, _folioMeta),
      );
    } else if (isInserting) {
      context.missing(_folioMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('process_status')) {
      context.handle(
        _processStatusMeta,
        processStatus.isAcceptableOrUnknown(
          data['process_status']!,
          _processStatusMeta,
        ),
      );
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('delivered_at')) {
      context.handle(
        _deliveredAtMeta,
        deliveredAt.isAcceptableOrUnknown(
          data['delivered_at']!,
          _deliveredAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {orderId};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_id'],
      )!,
      folio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folio'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      processStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}process_status'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      deliveredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}delivered_at'],
      ),
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class Order extends DataClass implements Insertable<Order> {
  final int orderId;
  final String folio;
  final DateTime createdAt;
  final double totalAmount;
  final String processStatus;
  final String? paymentMethod;
  final String? notes;
  final DateTime? deliveredAt;
  const Order({
    required this.orderId,
    required this.folio,
    required this.createdAt,
    required this.totalAmount,
    required this.processStatus,
    this.paymentMethod,
    this.notes,
    this.deliveredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['order_id'] = Variable<int>(orderId);
    map['folio'] = Variable<String>(folio);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['total_amount'] = Variable<double>(totalAmount);
    map['process_status'] = Variable<String>(processStatus);
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || deliveredAt != null) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt);
    }
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      orderId: Value(orderId),
      folio: Value(folio),
      createdAt: Value(createdAt),
      totalAmount: Value(totalAmount),
      processStatus: Value(processStatus),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      deliveredAt: deliveredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveredAt),
    );
  }

  factory Order.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      orderId: serializer.fromJson<int>(json['orderId']),
      folio: serializer.fromJson<String>(json['folio']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      processStatus: serializer.fromJson<String>(json['processStatus']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      notes: serializer.fromJson<String?>(json['notes']),
      deliveredAt: serializer.fromJson<DateTime?>(json['deliveredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'orderId': serializer.toJson<int>(orderId),
      'folio': serializer.toJson<String>(folio),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'processStatus': serializer.toJson<String>(processStatus),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'notes': serializer.toJson<String?>(notes),
      'deliveredAt': serializer.toJson<DateTime?>(deliveredAt),
    };
  }

  Order copyWith({
    int? orderId,
    String? folio,
    DateTime? createdAt,
    double? totalAmount,
    String? processStatus,
    Value<String?> paymentMethod = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> deliveredAt = const Value.absent(),
  }) => Order(
    orderId: orderId ?? this.orderId,
    folio: folio ?? this.folio,
    createdAt: createdAt ?? this.createdAt,
    totalAmount: totalAmount ?? this.totalAmount,
    processStatus: processStatus ?? this.processStatus,
    paymentMethod: paymentMethod.present
        ? paymentMethod.value
        : this.paymentMethod,
    notes: notes.present ? notes.value : this.notes,
    deliveredAt: deliveredAt.present ? deliveredAt.value : this.deliveredAt,
  );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      folio: data.folio.present ? data.folio.value : this.folio,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      processStatus: data.processStatus.present
          ? data.processStatus.value
          : this.processStatus,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      notes: data.notes.present ? data.notes.value : this.notes,
      deliveredAt: data.deliveredAt.present
          ? data.deliveredAt.value
          : this.deliveredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('orderId: $orderId, ')
          ..write('folio: $folio, ')
          ..write('createdAt: $createdAt, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('processStatus: $processStatus, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('notes: $notes, ')
          ..write('deliveredAt: $deliveredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    orderId,
    folio,
    createdAt,
    totalAmount,
    processStatus,
    paymentMethod,
    notes,
    deliveredAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.orderId == this.orderId &&
          other.folio == this.folio &&
          other.createdAt == this.createdAt &&
          other.totalAmount == this.totalAmount &&
          other.processStatus == this.processStatus &&
          other.paymentMethod == this.paymentMethod &&
          other.notes == this.notes &&
          other.deliveredAt == this.deliveredAt);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<int> orderId;
  final Value<String> folio;
  final Value<DateTime> createdAt;
  final Value<double> totalAmount;
  final Value<String> processStatus;
  final Value<String?> paymentMethod;
  final Value<String?> notes;
  final Value<DateTime?> deliveredAt;
  const OrdersCompanion({
    this.orderId = const Value.absent(),
    this.folio = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.processStatus = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.notes = const Value.absent(),
    this.deliveredAt = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.orderId = const Value.absent(),
    required String folio,
    this.createdAt = const Value.absent(),
    required double totalAmount,
    this.processStatus = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.notes = const Value.absent(),
    this.deliveredAt = const Value.absent(),
  }) : folio = Value(folio),
       totalAmount = Value(totalAmount);
  static Insertable<Order> custom({
    Expression<int>? orderId,
    Expression<String>? folio,
    Expression<DateTime>? createdAt,
    Expression<double>? totalAmount,
    Expression<String>? processStatus,
    Expression<String>? paymentMethod,
    Expression<String>? notes,
    Expression<DateTime>? deliveredAt,
  }) {
    return RawValuesInsertable({
      if (orderId != null) 'order_id': orderId,
      if (folio != null) 'folio': folio,
      if (createdAt != null) 'created_at': createdAt,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (processStatus != null) 'process_status': processStatus,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (notes != null) 'notes': notes,
      if (deliveredAt != null) 'delivered_at': deliveredAt,
    });
  }

  OrdersCompanion copyWith({
    Value<int>? orderId,
    Value<String>? folio,
    Value<DateTime>? createdAt,
    Value<double>? totalAmount,
    Value<String>? processStatus,
    Value<String?>? paymentMethod,
    Value<String?>? notes,
    Value<DateTime?>? deliveredAt,
  }) {
    return OrdersCompanion(
      orderId: orderId ?? this.orderId,
      folio: folio ?? this.folio,
      createdAt: createdAt ?? this.createdAt,
      totalAmount: totalAmount ?? this.totalAmount,
      processStatus: processStatus ?? this.processStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      deliveredAt: deliveredAt ?? this.deliveredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (folio.present) {
      map['folio'] = Variable<String>(folio.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (processStatus.present) {
      map['process_status'] = Variable<String>(processStatus.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (deliveredAt.present) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('orderId: $orderId, ')
          ..write('folio: $folio, ')
          ..write('createdAt: $createdAt, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('processStatus: $processStatus, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('notes: $notes, ')
          ..write('deliveredAt: $deliveredAt')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTable extends OrderItems
    with TableInfo<$OrderItemsTable, OrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _orderItemIdMeta = const VerificationMeta(
    'orderItemId',
  );
  @override
  late final GeneratedColumn<int> orderItemId = GeneratedColumn<int>(
    'order_item_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (order_id)',
    ),
  );
  static const VerificationMeta _variantIdMeta = const VerificationMeta(
    'variantId',
  );
  @override
  late final GeneratedColumn<int> variantId = GeneratedColumn<int>(
    'variant_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES product_variants (product_variant_id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _quantityDecimalMeta = const VerificationMeta(
    'quantityDecimal',
  );
  @override
  late final GeneratedColumn<double> quantityDecimal = GeneratedColumn<double>(
    'quantity_decimal',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    orderItemId,
    orderId,
    variantId,
    quantity,
    quantityDecimal,
    unitPrice,
    subtotal,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('order_item_id')) {
      context.handle(
        _orderItemIdMeta,
        orderItemId.isAcceptableOrUnknown(
          data['order_item_id']!,
          _orderItemIdMeta,
        ),
      );
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('variant_id')) {
      context.handle(
        _variantIdMeta,
        variantId.isAcceptableOrUnknown(data['variant_id']!, _variantIdMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('quantity_decimal')) {
      context.handle(
        _quantityDecimalMeta,
        quantityDecimal.isAcceptableOrUnknown(
          data['quantity_decimal']!,
          _quantityDecimalMeta,
        ),
      );
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {orderItemId};
  @override
  OrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItem(
      orderItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_item_id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_id'],
      )!,
      variantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}variant_id'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      quantityDecimal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity_decimal'],
      ),
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $OrderItemsTable createAlias(String alias) {
    return $OrderItemsTable(attachedDatabase, alias);
  }
}

class OrderItem extends DataClass implements Insertable<OrderItem> {
  final int orderItemId;
  final int orderId;
  final int? variantId;
  final int quantity;
  final double? quantityDecimal;
  final double unitPrice;
  final double subtotal;
  final String? notes;
  const OrderItem({
    required this.orderItemId,
    required this.orderId,
    this.variantId,
    required this.quantity,
    this.quantityDecimal,
    required this.unitPrice,
    required this.subtotal,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['order_item_id'] = Variable<int>(orderItemId);
    map['order_id'] = Variable<int>(orderId);
    if (!nullToAbsent || variantId != null) {
      map['variant_id'] = Variable<int>(variantId);
    }
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || quantityDecimal != null) {
      map['quantity_decimal'] = Variable<double>(quantityDecimal);
    }
    map['unit_price'] = Variable<double>(unitPrice);
    map['subtotal'] = Variable<double>(subtotal);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  OrderItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsCompanion(
      orderItemId: Value(orderItemId),
      orderId: Value(orderId),
      variantId: variantId == null && nullToAbsent
          ? const Value.absent()
          : Value(variantId),
      quantity: Value(quantity),
      quantityDecimal: quantityDecimal == null && nullToAbsent
          ? const Value.absent()
          : Value(quantityDecimal),
      unitPrice: Value(unitPrice),
      subtotal: Value(subtotal),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory OrderItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItem(
      orderItemId: serializer.fromJson<int>(json['orderItemId']),
      orderId: serializer.fromJson<int>(json['orderId']),
      variantId: serializer.fromJson<int?>(json['variantId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      quantityDecimal: serializer.fromJson<double?>(json['quantityDecimal']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'orderItemId': serializer.toJson<int>(orderItemId),
      'orderId': serializer.toJson<int>(orderId),
      'variantId': serializer.toJson<int?>(variantId),
      'quantity': serializer.toJson<int>(quantity),
      'quantityDecimal': serializer.toJson<double?>(quantityDecimal),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'subtotal': serializer.toJson<double>(subtotal),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  OrderItem copyWith({
    int? orderItemId,
    int? orderId,
    Value<int?> variantId = const Value.absent(),
    int? quantity,
    Value<double?> quantityDecimal = const Value.absent(),
    double? unitPrice,
    double? subtotal,
    Value<String?> notes = const Value.absent(),
  }) => OrderItem(
    orderItemId: orderItemId ?? this.orderItemId,
    orderId: orderId ?? this.orderId,
    variantId: variantId.present ? variantId.value : this.variantId,
    quantity: quantity ?? this.quantity,
    quantityDecimal: quantityDecimal.present
        ? quantityDecimal.value
        : this.quantityDecimal,
    unitPrice: unitPrice ?? this.unitPrice,
    subtotal: subtotal ?? this.subtotal,
    notes: notes.present ? notes.value : this.notes,
  );
  OrderItem copyWithCompanion(OrderItemsCompanion data) {
    return OrderItem(
      orderItemId: data.orderItemId.present
          ? data.orderItemId.value
          : this.orderItemId,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      variantId: data.variantId.present ? data.variantId.value : this.variantId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      quantityDecimal: data.quantityDecimal.present
          ? data.quantityDecimal.value
          : this.quantityDecimal,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItem(')
          ..write('orderItemId: $orderItemId, ')
          ..write('orderId: $orderId, ')
          ..write('variantId: $variantId, ')
          ..write('quantity: $quantity, ')
          ..write('quantityDecimal: $quantityDecimal, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('subtotal: $subtotal, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    orderItemId,
    orderId,
    variantId,
    quantity,
    quantityDecimal,
    unitPrice,
    subtotal,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItem &&
          other.orderItemId == this.orderItemId &&
          other.orderId == this.orderId &&
          other.variantId == this.variantId &&
          other.quantity == this.quantity &&
          other.quantityDecimal == this.quantityDecimal &&
          other.unitPrice == this.unitPrice &&
          other.subtotal == this.subtotal &&
          other.notes == this.notes);
}

class OrderItemsCompanion extends UpdateCompanion<OrderItem> {
  final Value<int> orderItemId;
  final Value<int> orderId;
  final Value<int?> variantId;
  final Value<int> quantity;
  final Value<double?> quantityDecimal;
  final Value<double> unitPrice;
  final Value<double> subtotal;
  final Value<String?> notes;
  const OrderItemsCompanion({
    this.orderItemId = const Value.absent(),
    this.orderId = const Value.absent(),
    this.variantId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.quantityDecimal = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.notes = const Value.absent(),
  });
  OrderItemsCompanion.insert({
    this.orderItemId = const Value.absent(),
    required int orderId,
    this.variantId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.quantityDecimal = const Value.absent(),
    required double unitPrice,
    required double subtotal,
    this.notes = const Value.absent(),
  }) : orderId = Value(orderId),
       unitPrice = Value(unitPrice),
       subtotal = Value(subtotal);
  static Insertable<OrderItem> custom({
    Expression<int>? orderItemId,
    Expression<int>? orderId,
    Expression<int>? variantId,
    Expression<int>? quantity,
    Expression<double>? quantityDecimal,
    Expression<double>? unitPrice,
    Expression<double>? subtotal,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (orderItemId != null) 'order_item_id': orderItemId,
      if (orderId != null) 'order_id': orderId,
      if (variantId != null) 'variant_id': variantId,
      if (quantity != null) 'quantity': quantity,
      if (quantityDecimal != null) 'quantity_decimal': quantityDecimal,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (subtotal != null) 'subtotal': subtotal,
      if (notes != null) 'notes': notes,
    });
  }

  OrderItemsCompanion copyWith({
    Value<int>? orderItemId,
    Value<int>? orderId,
    Value<int?>? variantId,
    Value<int>? quantity,
    Value<double?>? quantityDecimal,
    Value<double>? unitPrice,
    Value<double>? subtotal,
    Value<String?>? notes,
  }) {
    return OrderItemsCompanion(
      orderItemId: orderItemId ?? this.orderItemId,
      orderId: orderId ?? this.orderId,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
      quantityDecimal: quantityDecimal ?? this.quantityDecimal,
      unitPrice: unitPrice ?? this.unitPrice,
      subtotal: subtotal ?? this.subtotal,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (orderItemId.present) {
      map['order_item_id'] = Variable<int>(orderItemId.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<int>(variantId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (quantityDecimal.present) {
      map['quantity_decimal'] = Variable<double>(quantityDecimal.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsCompanion(')
          ..write('orderItemId: $orderItemId, ')
          ..write('orderId: $orderId, ')
          ..write('variantId: $variantId, ')
          ..write('quantity: $quantity, ')
          ..write('quantityDecimal: $quantityDecimal, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('subtotal: $subtotal, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $ProductSizesTable productSizes = $ProductSizesTable(this);
  late final $ProductVariantsTable productVariants = $ProductVariantsTable(
    this,
  );
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderItemsTable orderItems = $OrderItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    productSizes,
    productVariants,
    orders,
    orderItems,
  ];
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> productId,
      required String name,
      Value<bool> hasSizes,
      Value<bool> isByGrams,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> productId,
      Value<String> name,
      Value<bool> hasSizes,
      Value<bool> isByGrams,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductVariantsTable, List<ProductVariant>>
  _productVariantsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productVariants,
    aliasName: $_aliasNameGenerator(
      db.products.productId,
      db.productVariants.productId,
    ),
  );

  $$ProductVariantsTableProcessedTableManager get productVariantsRefs {
    final manager =
        $$ProductVariantsTableTableManager($_db, $_db.productVariants).filter(
          (f) =>
              f.productId.productId.sqlEquals($_itemColumn<int>('product_id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _productVariantsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasSizes => $composableBuilder(
    column: $table.hasSizes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isByGrams => $composableBuilder(
    column: $table.isByGrams,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productVariantsRefs(
    Expression<bool> Function($$ProductVariantsTableFilterComposer f) f,
  ) {
    final $$ProductVariantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableFilterComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasSizes => $composableBuilder(
    column: $table.hasSizes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isByGrams => $composableBuilder(
    column: $table.isByGrams,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get hasSizes =>
      $composableBuilder(column: $table.hasSizes, builder: (column) => column);

  GeneratedColumn<bool> get isByGrams =>
      $composableBuilder(column: $table.isByGrams, builder: (column) => column);

  Expression<T> productVariantsRefs<T extends Object>(
    Expression<T> Function($$ProductVariantsTableAnnotationComposer a) f,
  ) {
    final $$ProductVariantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableAnnotationComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({bool productVariantsRefs})
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> productId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> hasSizes = const Value.absent(),
                Value<bool> isByGrams = const Value.absent(),
              }) => ProductsCompanion(
                productId: productId,
                name: name,
                hasSizes: hasSizes,
                isByGrams: isByGrams,
              ),
          createCompanionCallback:
              ({
                Value<int> productId = const Value.absent(),
                required String name,
                Value<bool> hasSizes = const Value.absent(),
                Value<bool> isByGrams = const Value.absent(),
              }) => ProductsCompanion.insert(
                productId: productId,
                name: name,
                hasSizes: hasSizes,
                isByGrams: isByGrams,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productVariantsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productVariantsRefs) db.productVariants,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productVariantsRefs)
                    await $_getPrefetchedData<
                      Product,
                      $ProductsTable,
                      ProductVariant
                    >(
                      currentTable: table,
                      referencedTable: $$ProductsTableReferences
                          ._productVariantsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ProductsTableReferences(
                        db,
                        table,
                        p0,
                      ).productVariantsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.productId == item.productId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({bool productVariantsRefs})
    >;
typedef $$ProductSizesTableCreateCompanionBuilder =
    ProductSizesCompanion Function({
      Value<int> productSizeId,
      required String name,
    });
typedef $$ProductSizesTableUpdateCompanionBuilder =
    ProductSizesCompanion Function({
      Value<int> productSizeId,
      Value<String> name,
    });

final class $$ProductSizesTableReferences
    extends BaseReferences<_$AppDatabase, $ProductSizesTable, ProductSize> {
  $$ProductSizesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductVariantsTable, List<ProductVariant>>
  _productVariantsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productVariants,
    aliasName: $_aliasNameGenerator(
      db.productSizes.productSizeId,
      db.productVariants.productSizeId,
    ),
  );

  $$ProductVariantsTableProcessedTableManager get productVariantsRefs {
    final manager =
        $$ProductVariantsTableTableManager($_db, $_db.productVariants).filter(
          (f) => f.productSizeId.productSizeId.sqlEquals(
            $_itemColumn<int>('product_size_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _productVariantsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductSizesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductSizesTable> {
  $$ProductSizesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get productSizeId => $composableBuilder(
    column: $table.productSizeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productVariantsRefs(
    Expression<bool> Function($$ProductVariantsTableFilterComposer f) f,
  ) {
    final $$ProductVariantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productSizeId,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.productSizeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableFilterComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductSizesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductSizesTable> {
  $$ProductSizesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get productSizeId => $composableBuilder(
    column: $table.productSizeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductSizesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductSizesTable> {
  $$ProductSizesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get productSizeId => $composableBuilder(
    column: $table.productSizeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> productVariantsRefs<T extends Object>(
    Expression<T> Function($$ProductVariantsTableAnnotationComposer a) f,
  ) {
    final $$ProductVariantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productSizeId,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.productSizeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableAnnotationComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductSizesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductSizesTable,
          ProductSize,
          $$ProductSizesTableFilterComposer,
          $$ProductSizesTableOrderingComposer,
          $$ProductSizesTableAnnotationComposer,
          $$ProductSizesTableCreateCompanionBuilder,
          $$ProductSizesTableUpdateCompanionBuilder,
          (ProductSize, $$ProductSizesTableReferences),
          ProductSize,
          PrefetchHooks Function({bool productVariantsRefs})
        > {
  $$ProductSizesTableTableManager(_$AppDatabase db, $ProductSizesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductSizesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductSizesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductSizesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> productSizeId = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => ProductSizesCompanion(
                productSizeId: productSizeId,
                name: name,
              ),
          createCompanionCallback:
              ({
                Value<int> productSizeId = const Value.absent(),
                required String name,
              }) => ProductSizesCompanion.insert(
                productSizeId: productSizeId,
                name: name,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductSizesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productVariantsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productVariantsRefs) db.productVariants,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productVariantsRefs)
                    await $_getPrefetchedData<
                      ProductSize,
                      $ProductSizesTable,
                      ProductVariant
                    >(
                      currentTable: table,
                      referencedTable: $$ProductSizesTableReferences
                          ._productVariantsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProductSizesTableReferences(
                            db,
                            table,
                            p0,
                          ).productVariantsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.productSizeId == item.productSizeId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductSizesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductSizesTable,
      ProductSize,
      $$ProductSizesTableFilterComposer,
      $$ProductSizesTableOrderingComposer,
      $$ProductSizesTableAnnotationComposer,
      $$ProductSizesTableCreateCompanionBuilder,
      $$ProductSizesTableUpdateCompanionBuilder,
      (ProductSize, $$ProductSizesTableReferences),
      ProductSize,
      PrefetchHooks Function({bool productVariantsRefs})
    >;
typedef $$ProductVariantsTableCreateCompanionBuilder =
    ProductVariantsCompanion Function({
      Value<int> productVariantId,
      required int productId,
      required int productSizeId,
      Value<double?> price,
      Value<double?> pricePerKg,
    });
typedef $$ProductVariantsTableUpdateCompanionBuilder =
    ProductVariantsCompanion Function({
      Value<int> productVariantId,
      Value<int> productId,
      Value<int> productSizeId,
      Value<double?> price,
      Value<double?> pricePerKg,
    });

final class $$ProductVariantsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ProductVariantsTable, ProductVariant> {
  $$ProductVariantsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(
          db.productVariants.productId,
          db.products.productId,
        ),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.productId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductSizesTable _productSizeIdTable(_$AppDatabase db) =>
      db.productSizes.createAlias(
        $_aliasNameGenerator(
          db.productVariants.productSizeId,
          db.productSizes.productSizeId,
        ),
      );

  $$ProductSizesTableProcessedTableManager get productSizeId {
    final $_column = $_itemColumn<int>('product_size_id')!;

    final manager = $$ProductSizesTableTableManager(
      $_db,
      $_db.productSizes,
    ).filter((f) => f.productSizeId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productSizeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
  _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderItems,
    aliasName: $_aliasNameGenerator(
      db.productVariants.productVariantId,
      db.orderItems.variantId,
    ),
  );

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager($_db, $_db.orderItems).filter(
      (f) => f.variantId.productVariantId.sqlEquals(
        $_itemColumn<int>('product_variant_id')!,
      ),
    );

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductVariantsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductVariantsTable> {
  $$ProductVariantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get productVariantId => $composableBuilder(
    column: $table.productVariantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pricePerKg => $composableBuilder(
    column: $table.pricePerKg,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductSizesTableFilterComposer get productSizeId {
    final $$ProductSizesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productSizeId,
      referencedTable: $db.productSizes,
      getReferencedColumn: (t) => t.productSizeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductSizesTableFilterComposer(
            $db: $db,
            $table: $db.productSizes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> orderItemsRefs(
    Expression<bool> Function($$OrderItemsTableFilterComposer f) f,
  ) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productVariantId,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.variantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductVariantsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductVariantsTable> {
  $$ProductVariantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get productVariantId => $composableBuilder(
    column: $table.productVariantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pricePerKg => $composableBuilder(
    column: $table.pricePerKg,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductSizesTableOrderingComposer get productSizeId {
    final $$ProductSizesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productSizeId,
      referencedTable: $db.productSizes,
      getReferencedColumn: (t) => t.productSizeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductSizesTableOrderingComposer(
            $db: $db,
            $table: $db.productSizes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductVariantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductVariantsTable> {
  $$ProductVariantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get productVariantId => $composableBuilder(
    column: $table.productVariantId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get pricePerKg => $composableBuilder(
    column: $table.pricePerKg,
    builder: (column) => column,
  );

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductSizesTableAnnotationComposer get productSizeId {
    final $$ProductSizesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productSizeId,
      referencedTable: $db.productSizes,
      getReferencedColumn: (t) => t.productSizeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductSizesTableAnnotationComposer(
            $db: $db,
            $table: $db.productSizes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> orderItemsRefs<T extends Object>(
    Expression<T> Function($$OrderItemsTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productVariantId,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.variantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductVariantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductVariantsTable,
          ProductVariant,
          $$ProductVariantsTableFilterComposer,
          $$ProductVariantsTableOrderingComposer,
          $$ProductVariantsTableAnnotationComposer,
          $$ProductVariantsTableCreateCompanionBuilder,
          $$ProductVariantsTableUpdateCompanionBuilder,
          (ProductVariant, $$ProductVariantsTableReferences),
          ProductVariant,
          PrefetchHooks Function({
            bool productId,
            bool productSizeId,
            bool orderItemsRefs,
          })
        > {
  $$ProductVariantsTableTableManager(
    _$AppDatabase db,
    $ProductVariantsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductVariantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductVariantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductVariantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> productVariantId = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<int> productSizeId = const Value.absent(),
                Value<double?> price = const Value.absent(),
                Value<double?> pricePerKg = const Value.absent(),
              }) => ProductVariantsCompanion(
                productVariantId: productVariantId,
                productId: productId,
                productSizeId: productSizeId,
                price: price,
                pricePerKg: pricePerKg,
              ),
          createCompanionCallback:
              ({
                Value<int> productVariantId = const Value.absent(),
                required int productId,
                required int productSizeId,
                Value<double?> price = const Value.absent(),
                Value<double?> pricePerKg = const Value.absent(),
              }) => ProductVariantsCompanion.insert(
                productVariantId: productVariantId,
                productId: productId,
                productSizeId: productSizeId,
                price: price,
                pricePerKg: pricePerKg,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductVariantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                productId = false,
                productSizeId = false,
                orderItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (orderItemsRefs) db.orderItems],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (productId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productId,
                                    referencedTable:
                                        $$ProductVariantsTableReferences
                                            ._productIdTable(db),
                                    referencedColumn:
                                        $$ProductVariantsTableReferences
                                            ._productIdTable(db)
                                            .productId,
                                  )
                                  as T;
                        }
                        if (productSizeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productSizeId,
                                    referencedTable:
                                        $$ProductVariantsTableReferences
                                            ._productSizeIdTable(db),
                                    referencedColumn:
                                        $$ProductVariantsTableReferences
                                            ._productSizeIdTable(db)
                                            .productSizeId,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (orderItemsRefs)
                        await $_getPrefetchedData<
                          ProductVariant,
                          $ProductVariantsTable,
                          OrderItem
                        >(
                          currentTable: table,
                          referencedTable: $$ProductVariantsTableReferences
                              ._orderItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductVariantsTableReferences(
                                db,
                                table,
                                p0,
                              ).orderItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.variantId == item.productVariantId,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductVariantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductVariantsTable,
      ProductVariant,
      $$ProductVariantsTableFilterComposer,
      $$ProductVariantsTableOrderingComposer,
      $$ProductVariantsTableAnnotationComposer,
      $$ProductVariantsTableCreateCompanionBuilder,
      $$ProductVariantsTableUpdateCompanionBuilder,
      (ProductVariant, $$ProductVariantsTableReferences),
      ProductVariant,
      PrefetchHooks Function({
        bool productId,
        bool productSizeId,
        bool orderItemsRefs,
      })
    >;
typedef $$OrdersTableCreateCompanionBuilder =
    OrdersCompanion Function({
      Value<int> orderId,
      required String folio,
      Value<DateTime> createdAt,
      required double totalAmount,
      Value<String> processStatus,
      Value<String?> paymentMethod,
      Value<String?> notes,
      Value<DateTime?> deliveredAt,
    });
typedef $$OrdersTableUpdateCompanionBuilder =
    OrdersCompanion Function({
      Value<int> orderId,
      Value<String> folio,
      Value<DateTime> createdAt,
      Value<double> totalAmount,
      Value<String> processStatus,
      Value<String?> paymentMethod,
      Value<String?> notes,
      Value<DateTime?> deliveredAt,
    });

final class $$OrdersTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersTable, Order> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
  _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderItems,
    aliasName: $_aliasNameGenerator(db.orders.orderId, db.orderItems.orderId),
  );

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager($_db, $_db.orderItems).filter(
      (f) => f.orderId.orderId.sqlEquals($_itemColumn<int>('order_id')!),
    );

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get folio => $composableBuilder(
    column: $table.folio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get processStatus => $composableBuilder(
    column: $table.processStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deliveredAt => $composableBuilder(
    column: $table.deliveredAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> orderItemsRefs(
    Expression<bool> Function($$OrderItemsTableFilterComposer f) f,
  ) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get folio => $composableBuilder(
    column: $table.folio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get processStatus => $composableBuilder(
    column: $table.processStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deliveredAt => $composableBuilder(
    column: $table.deliveredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<String> get folio =>
      $composableBuilder(column: $table.folio, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get processStatus => $composableBuilder(
    column: $table.processStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get deliveredAt => $composableBuilder(
    column: $table.deliveredAt,
    builder: (column) => column,
  );

  Expression<T> orderItemsRefs<T extends Object>(
    Expression<T> Function($$OrderItemsTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdersTable,
          Order,
          $$OrdersTableFilterComposer,
          $$OrdersTableOrderingComposer,
          $$OrdersTableAnnotationComposer,
          $$OrdersTableCreateCompanionBuilder,
          $$OrdersTableUpdateCompanionBuilder,
          (Order, $$OrdersTableReferences),
          Order,
          PrefetchHooks Function({bool orderItemsRefs})
        > {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> orderId = const Value.absent(),
                Value<String> folio = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<String> processStatus = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> deliveredAt = const Value.absent(),
              }) => OrdersCompanion(
                orderId: orderId,
                folio: folio,
                createdAt: createdAt,
                totalAmount: totalAmount,
                processStatus: processStatus,
                paymentMethod: paymentMethod,
                notes: notes,
                deliveredAt: deliveredAt,
              ),
          createCompanionCallback:
              ({
                Value<int> orderId = const Value.absent(),
                required String folio,
                Value<DateTime> createdAt = const Value.absent(),
                required double totalAmount,
                Value<String> processStatus = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> deliveredAt = const Value.absent(),
              }) => OrdersCompanion.insert(
                orderId: orderId,
                folio: folio,
                createdAt: createdAt,
                totalAmount: totalAmount,
                processStatus: processStatus,
                paymentMethod: paymentMethod,
                notes: notes,
                deliveredAt: deliveredAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$OrdersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({orderItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (orderItemsRefs) db.orderItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orderItemsRefs)
                    await $_getPrefetchedData<Order, $OrdersTable, OrderItem>(
                      currentTable: table,
                      referencedTable: $$OrdersTableReferences
                          ._orderItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$OrdersTableReferences(db, table, p0).orderItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.orderId == item.orderId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$OrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdersTable,
      Order,
      $$OrdersTableFilterComposer,
      $$OrdersTableOrderingComposer,
      $$OrdersTableAnnotationComposer,
      $$OrdersTableCreateCompanionBuilder,
      $$OrdersTableUpdateCompanionBuilder,
      (Order, $$OrdersTableReferences),
      Order,
      PrefetchHooks Function({bool orderItemsRefs})
    >;
typedef $$OrderItemsTableCreateCompanionBuilder =
    OrderItemsCompanion Function({
      Value<int> orderItemId,
      required int orderId,
      Value<int?> variantId,
      Value<int> quantity,
      Value<double?> quantityDecimal,
      required double unitPrice,
      required double subtotal,
      Value<String?> notes,
    });
typedef $$OrderItemsTableUpdateCompanionBuilder =
    OrderItemsCompanion Function({
      Value<int> orderItemId,
      Value<int> orderId,
      Value<int?> variantId,
      Value<int> quantity,
      Value<double?> quantityDecimal,
      Value<double> unitPrice,
      Value<double> subtotal,
      Value<String?> notes,
    });

final class $$OrderItemsTableReferences
    extends BaseReferences<_$AppDatabase, $OrderItemsTable, OrderItem> {
  $$OrderItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders.createAlias(
    $_aliasNameGenerator(db.orderItems.orderId, db.orders.orderId),
  );

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.orderId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductVariantsTable _variantIdTable(_$AppDatabase db) =>
      db.productVariants.createAlias(
        $_aliasNameGenerator(
          db.orderItems.variantId,
          db.productVariants.productVariantId,
        ),
      );

  $$ProductVariantsTableProcessedTableManager? get variantId {
    final $_column = $_itemColumn<int>('variant_id');
    if ($_column == null) return null;
    final manager = $$ProductVariantsTableTableManager(
      $_db,
      $_db.productVariants,
    ).filter((f) => f.productVariantId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_variantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get orderItemId => $composableBuilder(
    column: $table.orderItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantityDecimal => $composableBuilder(
    column: $table.quantityDecimal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductVariantsTableFilterComposer get variantId {
    final $$ProductVariantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.productVariantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableFilterComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get orderItemId => $composableBuilder(
    column: $table.orderItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantityDecimal => $composableBuilder(
    column: $table.quantityDecimal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductVariantsTableOrderingComposer get variantId {
    final $$ProductVariantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.productVariantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableOrderingComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get orderItemId => $composableBuilder(
    column: $table.orderItemId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get quantityDecimal => $composableBuilder(
    column: $table.quantityDecimal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductVariantsTableAnnotationComposer get variantId {
    final $$ProductVariantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.productVariantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableAnnotationComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderItemsTable,
          OrderItem,
          $$OrderItemsTableFilterComposer,
          $$OrderItemsTableOrderingComposer,
          $$OrderItemsTableAnnotationComposer,
          $$OrderItemsTableCreateCompanionBuilder,
          $$OrderItemsTableUpdateCompanionBuilder,
          (OrderItem, $$OrderItemsTableReferences),
          OrderItem,
          PrefetchHooks Function({bool orderId, bool variantId})
        > {
  $$OrderItemsTableTableManager(_$AppDatabase db, $OrderItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> orderItemId = const Value.absent(),
                Value<int> orderId = const Value.absent(),
                Value<int?> variantId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double?> quantityDecimal = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => OrderItemsCompanion(
                orderItemId: orderItemId,
                orderId: orderId,
                variantId: variantId,
                quantity: quantity,
                quantityDecimal: quantityDecimal,
                unitPrice: unitPrice,
                subtotal: subtotal,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> orderItemId = const Value.absent(),
                required int orderId,
                Value<int?> variantId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double?> quantityDecimal = const Value.absent(),
                required double unitPrice,
                required double subtotal,
                Value<String?> notes = const Value.absent(),
              }) => OrderItemsCompanion.insert(
                orderItemId: orderItemId,
                orderId: orderId,
                variantId: variantId,
                quantity: quantity,
                quantityDecimal: quantityDecimal,
                unitPrice: unitPrice,
                subtotal: subtotal,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrderItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderId = false, variantId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (orderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.orderId,
                                referencedTable: $$OrderItemsTableReferences
                                    ._orderIdTable(db),
                                referencedColumn: $$OrderItemsTableReferences
                                    ._orderIdTable(db)
                                    .orderId,
                              )
                              as T;
                    }
                    if (variantId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.variantId,
                                referencedTable: $$OrderItemsTableReferences
                                    ._variantIdTable(db),
                                referencedColumn: $$OrderItemsTableReferences
                                    ._variantIdTable(db)
                                    .productVariantId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OrderItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderItemsTable,
      OrderItem,
      $$OrderItemsTableFilterComposer,
      $$OrderItemsTableOrderingComposer,
      $$OrderItemsTableAnnotationComposer,
      $$OrderItemsTableCreateCompanionBuilder,
      $$OrderItemsTableUpdateCompanionBuilder,
      (OrderItem, $$OrderItemsTableReferences),
      OrderItem,
      PrefetchHooks Function({bool orderId, bool variantId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$ProductSizesTableTableManager get productSizes =>
      $$ProductSizesTableTableManager(_db, _db.productSizes);
  $$ProductVariantsTableTableManager get productVariants =>
      $$ProductVariantsTableTableManager(_db, _db.productVariants);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db, _db.orderItems);
}
