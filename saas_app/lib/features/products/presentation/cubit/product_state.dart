part of 'product_cubit.dart';

sealed class ProductState {
  const ProductState();
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  final int currentPage;
  final bool hasMoreProducts;

  const ProductsLoaded({
    required this.products,
    required this.currentPage,
    this.hasMoreProducts = true,
  });
}

class ProductDetailLoading extends ProductState {
  const ProductDetailLoading();
}

class ProductDetailLoaded extends ProductState {
  final Product product;

  const ProductDetailLoaded(this.product);
}

class ProductSearchLoading extends ProductState {
  const ProductSearchLoading();
}

class ProductSearchResults extends ProductState {
  final List<Product> results;

  const ProductSearchResults(this.results);
}

class ProductCreated extends ProductState {
  final Product product;

  const ProductCreated(this.product);
}

class ProductUpdated extends ProductState {
  final Product product;

  const ProductUpdated(this.product);
}

class ProductDeleted extends ProductState {
  final int productId;

  const ProductDeleted(this.productId);
}

class ProductSupplierProductsLoaded extends ProductState {
  final List<Product> products;

  const ProductSupplierProductsLoaded(this.products);
}

class ProductCategoriesLoaded extends ProductState {
  final List<Category> categories;

  const ProductCategoriesLoaded(this.categories);
}

class ProductError extends ProductState {
  final String message;
  final String? code;

  const ProductError(this.message, {this.code});
}
