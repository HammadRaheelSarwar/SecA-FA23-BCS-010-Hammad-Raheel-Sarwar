import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/supabase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<Item> items = [];
  bool isLoading = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => isLoading = true);
    try {
      final response = await _supabaseService.getAllItems();
      setState(() {
        items = response.map((json) => Item.fromJson(json)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading items: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _searchItems() async {
    if (searchQuery.isEmpty) {
      _loadItems();
      return;
    }
    setState(() => isLoading = true);
    try {
      final response = await _supabaseService.searchItems(searchQuery);
      setState(() {
        items = response.map((json) => Item.fromJson(json)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error searching items: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteItem(String id) async {
    try {
      await _supabaseService.deleteItem(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item deleted successfully')),
      );
      _loadItems();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting item: $e')));
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
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'My Items',
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
          // Search Bar Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search items...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.deepPurple,
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() => searchQuery = '');
                            _loadItems();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.deepPurple.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.deepPurple.shade200,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.deepPurple.shade600,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.deepPurple.shade50,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) => setState(() => searchQuery = value),
                onSubmitted: (_) => _searchItems(),
              ),
            ),
          ),
          // Items List
          isLoading
              ? SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepPurple.shade600,
                    ),
                  ),
                )
              : items.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.inbox_outlined,
                            size: 80,
                            color: Colors.deepPurple.shade300,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No items found',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your first item to get started',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: _buildItemCard(context, item),
                    );
                  }, childCount: items.length),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed('/create').then((_) {
          _loadItems();
        }),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, Item item) {
    return Card(
      elevation: 4,
      shadowColor: Colors.deepPurple.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(
          context,
        ).pushNamed('/detail', arguments: item).then((_) => _loadItems()),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item.category,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue.shade600),
                      onPressed: () => Navigator.of(context)
                          .pushNamed('/update', arguments: item)
                          .then((_) => _loadItems()),
                      tooltip: 'Edit',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red.shade600),
                      onPressed: () =>
                          _showDeleteDialog(context, item.id, item.name),
                      tooltip: 'Delete',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteItem(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
