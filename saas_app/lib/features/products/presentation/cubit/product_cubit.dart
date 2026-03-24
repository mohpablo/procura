import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import 'package:saas_app/features/products/domain/entities/category.dart';
import '../../domain/entities/product.dart';
import 'package:saas_app/features/products/domain/usecases/product_usecases.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final GetProductByIdUseCase getProductByIdUseCase;
  final SearchProductsUseCase searchProductsUseCase;
  final CreateProductUseCase createProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;
  final GetSupplierProductsUseCase getSupplierProductsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  ProductCubit({
    required this.getProductsUseCase,
    required this.getProductByIdUseCase,
    required this.searchProductsUseCase,
    required this.createProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
    required this.getSupplierProductsUseCase,
    required this.getCategoriesUseCase,
  }) : super(const ProductInitial());

  /// Fetch products with pagination and optional filtering
  Future<void> getProducts({
    int page = 1,
    String? category,
    String? searchQuery,
  }) async {
    emit(const ProductLoading());

    final result = await getProductsUseCase(
      GetProductsParams(
        page: page,
        category: category,
        searchQuery: searchQuery,
      ),
    );

    result.when(
      onSuccess: (products) {
        emit(
          ProductsLoaded(
            products: products,
            currentPage: page,
            hasMoreProducts: products.isNotEmpty,
          ),
        );
      },
      onFailure: (message, code) {
        emit(ProductError(message, code: code));
      },
    );
  }

  /// Load more products (pagination)
  Future<void> loadMoreProducts({
    required int nextPage,
    String? category,
    String? searchQuery,
  }) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      emit(const ProductLoading());

      final result = await getProductsUseCase(
        GetProductsParams(
          page: nextPage,
          category: category,
          searchQuery: searchQuery,
        ),
      );

      result.when(
        onSuccess: (newProducts) {
          final allProducts = [...currentState.products, ...newProducts];
          emit(
            ProductsLoaded(
              products: allProducts,
              currentPage: nextPage,
              hasMoreProducts: newProducts.isNotEmpty,
            ),
          );
        },
        onFailure: (message, code) {
          emit(ProductError(message, code: code));
        },
      );
    }
  }

  /// Get product details by ID
  Future<void> getProductById(int productId) async {
    emit(const ProductDetailLoading());

    final result = await getProductByIdUseCase(productId);

    result.when(
      onSuccess: (product) {
        emit(ProductDetailLoaded(product));
      },
      onFailure: (message, code) {
        emit(ProductError(message, code: code));
      },
    );
  }

  /// Search products by query
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      emit(const ProductSearchResults([]));
      return;
    }

    emit(const ProductSearchLoading());

    final result = await searchProductsUseCase(query);

    result.when(
      onSuccess: (results) {
        emit(ProductSearchResults(results));
      },
      onFailure: (message, code) {
        emit(ProductError(message, code: code));
      },
    );
  }

  /// Create new product (supplier only)
  Future<void> createProduct({
    required String name,
    required String description,
    required double price,
    required int quantity,
    required int categoryId,
    required String unit,
  }) async {
    emit(const ProductLoading());

    final result = await createProductUseCase(
      CreateProductParams(
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        categoryId: categoryId,
        unit: unit,
      ),
    );

    result.when(
      onSuccess: (product) {
        emit(ProductCreated(product));
      },
      onFailure: (message, code) {
        emit(ProductError(message, code: code));
      },
    );
  }

  /// Update product (supplier only)
  Future<void> updateProduct({
    required int id,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required int categoryId,
    required String unit,
  }) async {
    emit(const ProductLoading());

    final result = await updateProductUseCase(
      UpdateProductParams(
        id: id,
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        categoryId: categoryId,
        unit: unit,
      ),
    );

    result.when(
      onSuccess: (product) {
        emit(ProductUpdated(product));
      },
      onFailure: (message, code) {
        emit(ProductError(message, code: code));
      },
    );
  }

  /// Delete product (supplier only)
  Future<void> deleteProduct(int productId) async {
    emit(const ProductLoading());

    final result = await deleteProductUseCase(productId);

    result.when(
      onSuccess: (_) {
        emit(ProductDeleted(productId));
      },
      onFailure: (message, code) {
        emit(ProductError(message, code: code));
      },
    );
  }

  /// Get supplier's products
  Future<void> getSupplierProducts(int supplierId) async {
    emit(const ProductLoading());

    final result = await getSupplierProductsUseCase(supplierId);

    result.when(
      onSuccess: (products) {
        emit(ProductSupplierProductsLoaded(products));
      },
      onFailure: (message, code) {
        emit(ProductError(message, code: code));
      },
    );
  }

  /// Fetch all categories
  Future<void> getCategories() async {
    emit(const ProductLoading());

    final result = await getCategoriesUseCase(NoParams());

    result.when(
      onSuccess: (categories) {
        emit(ProductCategoriesLoaded(categories));
      },
      onFailure: (message, code) {
        emit(ProductError(message, code: code));
      },
    );
  }

  /// Clear error state
  void clearError() {
    emit(const ProductInitial());
  }
}
