import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _createItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final data = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'category': _categoryController.text,
        'price': double.parse(_priceController.text),
      };

      await _supabaseService.createItem(data);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item created successfully')),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating item: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Professional App Bar with Gradient
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.deepPurple.shade600,
            expandedHeight: 100,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Create New Item',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple.shade600,
                      Colors.deepPurple.shade400,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildFormSection(
                        title: 'Item Name',
                        child: _buildTextField(
                          controller: _nameController,
                          label: 'Item Name',
                          hint: 'Enter item name',
                          icon: Icons.label_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an item name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildFormSection(
                        title: 'Description',
                        child: _buildTextField(
                          controller: _descriptionController,
                          label: 'Description',
                          hint: 'Enter item description',
                          icon: Icons.description_outlined,
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildFormSection(
                        title: 'Category',
                        child: _buildTextField(
                          controller: _categoryController,
                          label: 'Category',
                          hint: 'Enter category',
                          icon: Icons.category_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a category';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildFormSection(
                        title: 'Price',
                        child: _buildTextField(
                          controller: _priceController,
                          label: 'Price',
                          hint: 'Enter price',
                          icon: Icons.attach_money_outlined,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid price';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Submit Button
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepPurple.shade600,
                              Colors.deepPurple.shade400,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.shade400.withOpacity(
                                0.4,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _createItem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Create Item',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.deepPurple.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.deepPurple.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.deepPurple.shade200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.deepPurple.shade600, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.deepPurple.shade50,
        labelStyle: TextStyle(
          color: Colors.deepPurple.shade600,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(color: Colors.grey.shade400),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
