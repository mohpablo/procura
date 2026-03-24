import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/errors/app_exceptions.dart';
import 'package:saas_app/features/products/domain/entities/product.dart';
import 'package:saas_app/features/products/domain/entities/category.dart';
import 'package:saas_app/features/products/domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<Product>>> getProducts({
    required int page,
    String? category,
    String? searchQuery,
  }) async {
    try {
      final models = await remoteDataSource.getProducts(
        page: page,
        category: category,
        searchQuery: searchQuery,
      );
      final products = models.map((m) => m.toEntity()).toList();
      return Result.success(products);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to fetch products: ${e.toString()}');
    }
  }

  @override
  Future<Result<Product>> getProductById(int id) async {
    try {
      final model = await remoteDataSource.getProductById(id);
      return Result.success(model.toEntity());
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to fetch product: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<Product>>> getSupplierProducts(int supplierId) async {
    try {
      final models = await remoteDataSource.getSupplierProducts();
      final products = models.map((m) => m.toEntity()).toList();
      return Result.success(products);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure(
        'Failed to fetch supplier products: ${e.toString()}',
      );
    }
  }

  @override
  Future<Result<Product>> createProduct(
    Map<String, dynamic> productData,
  ) async {
    try {
      final model = await remoteDataSource.createProduct(productData);
      return Result.success(model.toEntity());
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to create product: ${e.toString()}');
    }
  }

  @override
  Future<Result<Product>> updateProduct(
    int id,
    Map<String, dynamic> productData,
  ) async {
    try {
      final model = await remoteDataSource.updateProduct(id, productData);
      return Result.success(model.toEntity());
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to update product: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> deleteProduct(int id) async {
    try {
      await remoteDataSource.deleteProduct(id);
      return Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to delete product: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<Product>>> searchProducts(String query) async {
    try {
      final models = await remoteDataSource.searchProducts(query);
      final products = models.map((m) => m.toEntity()).toList();
      return Result.success(products);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to search products: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<Category>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Result.success(categories);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to fetch categories: ${e.toString()}');
    }
  }
}
