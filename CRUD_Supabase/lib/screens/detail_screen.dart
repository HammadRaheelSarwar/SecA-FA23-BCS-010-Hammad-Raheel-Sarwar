import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/item_model.dart';

class DetailScreen extends StatelessWidget {
  final Item item;

  const DetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');

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
                'Item Details',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Item Name Card
                  _buildDetailCard(
                    context,
                    icon: Icons.label_outlined,
                    title: 'Item Name',
                    content: item.name,
                    iconColor: Colors.blue,
                  ),
                  const SizedBox(height: 16),

                  // Price Card
                  _buildPriceCard(context),
                  const SizedBox(height: 16),

                  // Category Card
                  _buildDetailCard(
                    context,
                    icon: Icons.category_outlined,
                    title: 'Category',
                    content: item.category,
                    iconColor: Colors.orange,
                  ),
                  const SizedBox(height: 16),

                  // Description Card
                  _buildDetailCard(
                    context,
                    icon: Icons.description_outlined,
                    title: 'Description',
                    content: item.description,
                    iconColor: Colors.green,
                  ),
                  const SizedBox(height: 16),

                  // ID Card
                  _buildDetailCard(
                    context,
                    icon: Icons.fingerprint_outlined,
                    title: 'Item ID',
                    content: item.id,
                    iconColor: Colors.purple,
                    isMonospace: true,
                  ),
                  const SizedBox(height: 16),

                  // Dates Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailCard(
                          context,
                          icon: Icons.access_time_outlined,
                          title: 'Created',
                          content: dateFormat.format(item.createdAt),
                          iconColor: Colors.teal,
                          isSmall: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDetailCard(
                          context,
                          icon: Icons.update_outlined,
                          title: 'Updated',
                          content: dateFormat.format(item.updatedAt),
                          iconColor: Colors.indigo,
                          isSmall: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade600,
                                Colors.blue.shade400,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade400.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.of(
                              context,
                            ).pushNamed('/update', arguments: item),
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.shade600,
                                Colors.red.shade400,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.shade400.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Back'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required Color iconColor,
    bool isMonospace = false,
    bool isSmall = false,
  }) {
    return Card(
      elevation: 4,
      shadowColor: iconColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: EdgeInsets.all(isSmall ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmall ? 12 : 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: isMonospace ? 'monospace' : null,
                  fontWeight: FontWeight.w500,
                  fontSize: isSmall ? 12 : 14,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.green.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade400.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.attach_money_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
