import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search.filter.provider.dart';
import '../models/product.model.dart';
import '../widgets/product.card.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<SearchFilterProvider, List<Product>>(
      selector: (_, provider) => provider.filteredProducts,
      shouldRebuild: (previous, next) => true, // We want to rebuild when the filtered list changes
      builder: (context, filteredProducts, _) {
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40), // Increased bottom padding to 40px
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = filteredProducts[index];
                return ProductCard(product: product);
              },
              childCount: filteredProducts.length,
            ),
          ),
        );
      },
    );
  }
}