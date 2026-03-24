import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/features/products/domain/entities/category.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Result<List<Product>>> getProducts({
    required int page,
    String? category,
    String? searchQuery,
  });
  Future<Result<Product>> getProductById(int id);
  Future<Result<List<Product>>> searchProducts(String query);
  Future<Result<Product>> createProduct(Map<String, dynamic> productData);
  Future<Result<Product>> updateProduct(
    int id,
    Map<String, dynamic> productData,
  );
  Future<Result<void>> deleteProduct(int id);
  Future<Result<List<Product>>> getSupplierProducts(int supplierId);
  Future<Result<List<Category>>> getCategories();
}
