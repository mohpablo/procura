import 'package:saas_app/core/api/api_consumer.dart';
import 'package:saas_app/core/api/api_endpoints.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

class ProductRemoteDataSource {
  final ApiConsumer api;

  ProductRemoteDataSource(this.api);

  Future<List<ProductModel>> getProducts({
    required int page,
    String? category,
    String? searchQuery,
  }) async {
    try {
      final queryParams = <String, dynamic>{APIKeys.page: page};

      if (category != null) queryParams[APIKeys.categoryId] = category;
      if (searchQuery != null) queryParams[APIKeys.search] = searchQuery;

      final response = await api.get(
        EndPoints.products,
        queryParameters: queryParams,
      );

      final dynamic rawData = response[APIKeys.data];
      final List<dynamic> productList;
      if (rawData is List) {
        productList = rawData;
      } else if (rawData is Map && rawData.containsKey('data')) {
        productList = rawData['data'] is List ? rawData['data'] : [];
      } else {
        productList = [];
      }

      return productList
          .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await api.get(EndPoints.productDetails(id));
      return ProductModel.fromJson(response[APIKeys.data]);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> getSupplierProducts() async {
    try {
      final response = await api.get(
        EndPoints.supplierProducts,
        withToken: true,
      );

      final dynamic rawData = response[APIKeys.data];
      final List<dynamic> productList;
      if (rawData is List) {
        productList = rawData;
      } else if (rawData is Map && rawData.containsKey('data')) {
        productList = rawData['data'] is List ? rawData['data'] : [];
      } else {
        productList = [];
      }

      return productList
          .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductModel> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await api.post(
        EndPoints.supplierProducts,
        body: productData,
        withToken: true,
      );
      return ProductModel.fromJson(response[APIKeys.data]);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductModel> updateProduct(
    int id,
    Map<String, dynamic> productData,
  ) async {
    try {
      final response = await api.put(
        EndPoints.updateSupplierProduct(id),
        body: productData,
        withToken: true,
      );
      return ProductModel.fromJson(response[APIKeys.data]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await api.delete(EndPoints.deleteSupplierProduct(id), withToken: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await api.get(
        EndPoints.products,
        queryParameters: {APIKeys.search: query},
      );

      final dynamic rawData = response[APIKeys.data];
      final List<dynamic> productList;
      if (rawData is List) {
        productList = rawData;
      } else if (rawData is Map && rawData.containsKey('data')) {
        productList = rawData['data'] is List ? rawData['data'] : [];
      } else {
        productList = [];
      }

      return productList
          .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await api.get(EndPoints.categories);
      final List<dynamic> categoryList = response[APIKeys.data] ?? [];
      return categoryList
          .map((c) => CategoryModel.fromJson(c as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
