import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/features/products/domain/entities/product.dart';
import 'package:saas_app/features/products/domain/entities/category.dart';
import 'package:saas_app/features/products/presentation/cubit/product_cubit.dart';

class AddEditProductView extends StatefulWidget {
  final Product? product;

  const AddEditProductView({super.key, this.product});

  @override
  State<AddEditProductView> createState() => _AddEditProductViewState();
}

class _AddEditProductViewState extends State<AddEditProductView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _qtyController;
  late TextEditingController _unitController;
  final selectedCategoryIdNotifier = ValueNotifier<int?>(null);
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _qtyController = TextEditingController(
      text: widget.product?.quantity.toString() ?? '',
    );
    _unitController = TextEditingController(
      text: widget.product?.unit ?? 'pcs',
    );
    selectedCategoryIdNotifier.value = widget.product?.categoryId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductCubit>().getCategories();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    _unitController.dispose();
    selectedCategoryIdNotifier.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      if (selectedCategoryIdNotifier.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      final name = _nameController.text;
      final desc = _descController.text;
      final price = double.parse(_priceController.text);
      final qty = int.parse(_qtyController.text);
      final unit = _unitController.text;

      if (widget.product == null) {
        context.read<ProductCubit>().createProduct(
          name: name,
          description: desc,
          price: price,
          quantity: qty,
          categoryId: selectedCategoryIdNotifier.value!,
          unit: unit,
        );
      } else {
        context.read<ProductCubit>().updateProduct(
          id: widget.product!.id,
          name: name,
          description: desc,
          price: price,
          quantity: qty,
          categoryId: selectedCategoryIdNotifier.value!,
          unit: unit,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductCreated || state is ProductUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Product ${isEditing ? 'updated' : 'added'} successfully',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state is ProductCategoriesLoaded) {
            setState(() {
              _categories = state.categories;
              if (selectedCategoryIdNotifier.value != null &&
                  !_categories.any(
                    (c) => c.id == selectedCategoryIdNotifier.value,
                  )) {
                selectedCategoryIdNotifier.value = null;
              }
            });
          } else if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    isEditing ? 'Edit Product' : 'Add Product',
                    style: const TextStyle(
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  centerTitle: false,
                ),
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverToBoxAdapter(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('General Information'),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _nameController,
                          label: 'Product Name',
                          hint: 'e.g. Premium Cotton Yarn',
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _descController,
                          label: 'Description',
                          hint: 'Provide details about your product...',
                          maxLines: 4,
                        ),
                        const SizedBox(height: 32),
                        _buildSectionHeader('Pricing & Inventory'),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _priceController,
                                label: 'Price (\$)',
                                hint: '0.00',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                controller: _qtyController,
                                label: 'Quantity',
                                hint: '0',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _unitController,
                          label: 'Unit',
                          hint: 'e.g. kg, pcs, box',
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSectionHeader('Category'),
                            TextButton.icon(
                              onPressed: () =>
                                  context.read<ProductCubit>().getCategories(),
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text('Refresh'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ValueListenableBuilder<int?>(
                          valueListenable: selectedCategoryIdNotifier,
                          builder: (context, selectedId, _) {
                            return DropdownButtonFormField<int>(
                              value: selectedId,
                              items: _categories.map((c) {
                                return DropdownMenuItem<int>(
                                  value: c.id,
                                  child: Text(c.name),
                                );
                              }).toList(),
                              onChanged: (val) =>
                                  selectedCategoryIdNotifier.value = val,
                              decoration: const InputDecoration(
                                hintText: 'Select a category',
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 48),
                        state is ProductLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: _saveProduct,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 56),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  isEditing ? 'Save Changes' : 'Create Product',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF64748B),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
        ),
      ],
    );
  }
}
