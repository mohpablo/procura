import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../entities/category.dart';
import 'package:saas_app/features/products/domain/entities/product.dart';
import 'package:saas_app/features/products/domain/repositories/product_repository.dart';

class GetProductsUseCase implements UseCase<List<Product>, GetProductsParams> {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<Result<List<Product>>> call(GetProductsParams params) async {
    return await repository.getProducts(
      page: params.page,
      category: params.category,
      searchQuery: params.searchQuery,
    );
  }
}

class GetProductsParams {
  final int page;
  final String? category;
  final String? searchQuery;

  GetProductsParams({required this.page, this.category, this.searchQuery});
}

// Get single product by ID
class GetProductByIdUseCase implements UseCase<Product, int> {
  final ProductRepository repository;

  GetProductByIdUseCase(this.repository);

  @override
  Future<Result<Product>> call(int productId) async {
    if (productId <= 0) {
      return Result.failure('Invalid product ID');
    }
    return await repository.getProductById(productId);
  }
}

// Search products
class SearchProductsUseCase implements UseCase<List<Product>, String> {
  final ProductRepository repository;

  SearchProductsUseCase(this.repository);

  @override
  Future<Result<List<Product>>> call(String query) async {
    if (query.trim().isEmpty) {
      return Result.failure('Search query cannot be empty');
    }
    return await repository.searchProducts(query);
  }
}

// Create product (supplier only)
class CreateProductUseCase implements UseCase<Product, CreateProductParams> {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  @override
  Future<Result<Product>> call(CreateProductParams params) async {
    if (params.name.trim().isEmpty) {
      return Result.failure('Product name is required');
    }
    if (params.price <= 0) {
      return Result.failure('Product price must be greater than 0');
    }

    final productData = {
      'name': params.name,
      'description': params.description,
      'price': params.price,
      'stock': params.quantity,
      'category_id': params.categoryId,
      'unit': params.unit,
    };

    return await repository.createProduct(productData);
  }
}

class CreateProductParams {
  final String name;
  final String description;
  final double price;
  final int quantity;
  final int categoryId;
  final String unit;

  CreateProductParams({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.categoryId,
    required this.unit,
  });
}

// Update product (supplier only)
class UpdateProductUseCase implements UseCase<Product, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  @override
  Future<Result<Product>> call(UpdateProductParams params) async {
    if (params.id <= 0) {
      return Result.failure('Invalid product ID');
    }

    final productData = {
      'name': params.name,
      'description': params.description,
      'price': params.price,
      'stock': params.quantity,
      'category_id': params.categoryId,
      'unit': params.unit,
    };

    return await repository.updateProduct(params.id, productData);
  }
}

class UpdateProductParams {
  final int id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final int categoryId;
  final String unit;

  UpdateProductParams({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.categoryId,
    required this.unit,
  });
}

// Delete product (supplier only)
class DeleteProductUseCase implements UseCase<void, int> {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<Result<void>> call(int productId) async {
    if (productId <= 0) {
      return Result.failure('Invalid product ID');
    }
    return await repository.deleteProduct(productId);
  }
}

// Get supplier's products
class GetSupplierProductsUseCase implements UseCase<List<Product>, int> {
  final ProductRepository repository;

  GetSupplierProductsUseCase(this.repository);

  @override
  Future<Result<List<Product>>> call(int supplierId) async {
    if (supplierId <= 0) {
      return Result.failure('Invalid supplier ID');
    }
    return await repository.getSupplierProducts(supplierId);
  }
}

// Get all categories
class GetCategoriesUseCase implements UseCase<List<Category>, NoParams> {
  final ProductRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Result<List<Category>>> call(NoParams params) async {
    return await repository.getCategories();
  }
}
