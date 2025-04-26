import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.provider.dart';
import '../providers/product.detail.provider.dart';

class ProductScreen extends StatelessWidget {
  final String productId;
  const ProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    // Create provider without triggering immediate data fetch
    return ChangeNotifierProvider(
      create: (context) => ProductDetailProvider(
        Provider.of<ProductProvider>(context, listen: false),
        productId,
      ),
      child: _ProductScreenContent(),
    );
  }
}

class _ProductScreenContent extends StatefulWidget {
  @override
  State<_ProductScreenContent> createState() => _ProductScreenContentState();
}

class _ProductScreenContentState extends State<_ProductScreenContent> {
  @override
  void initState() {
    super.initState();
    // Schedule the initialization after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<ProductDetailProvider>(context, listen: false).initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailProvider = Provider.of<ProductDetailProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(detailProvider.product?.name ?? 'Product Details'),
      ),
      body: _buildBody(context, detailProvider),
    );
  }

  Widget _buildBody(BuildContext context, ProductDetailProvider detailProvider) {
    if (detailProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (detailProvider.error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${detailProvider.error}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => detailProvider.refreshProduct(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (detailProvider.product == null) {
      return const Center(child: Text('Product not found'));
    }

    // Product details view when loaded successfully
    return RefreshIndicator(
      onRefresh: () => detailProvider.refreshProduct(),
      child: _ProductDetailView(detailProvider: detailProvider),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  final ProductDetailProvider detailProvider;

  const _ProductDetailView({required this.detailProvider});

  @override
  Widget build(BuildContext context) {
    final product = detailProvider.product!;
    final imageList = product.images ?? [product.mainImage];
    final variants = product.variants ?? [];

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image carousel
          SizedBox(
            height: 300,
            child: PageView.builder(
              itemCount: imageList.length,
              onPageChanged: (index) => detailProvider.setSelectedImageIndex(index),
              itemBuilder: (context, index) {
                return Image.network(
                  imageList[index],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, size: 50),
                    );
                  },
                );
              },
            ),
          ),

          // Image indicators
          if (imageList.length > 1)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  imageList.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: detailProvider.selectedImageIndex == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),

          // Product details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    if (product.isNew)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'NEW',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Type and rating
                Row(
                  children: [
                    Text(
                      product.type,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Variants
                if (variants.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Variants',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: variants.length,
                          itemBuilder: (context, index) {
                            final variant = variants[index];
                            final isSelected = detailProvider.selectedVariantIndex == index;
                            
                            return GestureDetector(
                              onTap: () => detailProvider.setSelectedVariantIndex(index),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? Theme.of(context).colorScheme.primary 
                                      : Theme.of(context).colorScheme.surface,
                                  border: Border.all(
                                    color: isSelected 
                                        ? Theme.of(context).colorScheme.primary 
                                        : Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      variant.name,
                                      style: TextStyle(
                                        color: isSelected 
                                            ? Theme.of(context).colorScheme.onPrimary 
                                            : Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                
                const SizedBox(height: 16),
                
                // Price
                Text(
                  '\$${variants.isNotEmpty ? variants[detailProvider.selectedVariantIndex].price.toStringAsFixed(2) : product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Description
                Text(
                  'About this item',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.fullDescription ?? product.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}