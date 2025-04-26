import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.provider.dart';
import '../providers/theme.provider.dart';
import '../providers/product.provider.dart';
import '../models/product.model.dart';
import 'auth.screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthScreen()));
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return SafeArea(
              child: Scaffold(
                drawer: Drawer(
                  child: ListView(
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(
                        ),
                        child: Text('Apple Store',style: Theme.of(context).textTheme.titleLarge,),
                      ),
                      ListTile(title: Text('Logout',style: Theme.of(context).textTheme.bodyLarge,),onTap: () => authProvider.signOut(),trailing: const Icon(Icons.logout),),
                    ],
                  ),
                ),
                body: Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          floating: true,
                          pinned: false,
                          expandedHeight: MediaQuery.of(context).size.height * 0.1,
                          flexibleSpace: FlexibleSpaceBar(
                            titlePadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2,),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Welcome,',style: Theme.of(context).textTheme.bodyLarge,),
                                Text(authProvider.user?.displayName ?? 'User',style: Theme.of(context).textTheme.titleLarge,),
                              ],
                            ),
                          ),
                          actions: [
                            IconButton(
                              icon: Icon(
                                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                              ),
                              onPressed: () => themeProvider.toggleTheme(),
                            ),
                            IconButton(
                              icon: const Icon(Icons.notifications),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          floating: false,
                          delegate: _SliverSearchDelegate(
                            child: Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              padding: const EdgeInsets.all(16),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search products...',
                                  prefixIcon: Icon(Icons.search,color: Theme.of(context).colorScheme.primary,),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.filter_list),
                                    onPressed: () {
                                      // TODO: Implement filter functionality
                                    },
                                  ),
                                  filled: true,
                                  fillColor: Theme.of(context).cardColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (productProvider.isLoading)
                          const SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          )
                        else if (productProvider.error.isNotEmpty)
                          SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  productProvider.error,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          SliverPadding(
                            padding: const EdgeInsets.all(16),
                            sliver: SliverGrid(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final product = productProvider.products[index];
                                  return ProductCard(product: product);
                                },
                                childCount: productProvider.products.length,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                product.mainImage,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (product.isNew)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'NEW',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.rating.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverSearchDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverSearchDelegate({required this.child});

  @override
  double get minExtent => 80;
  @override
  double get maxExtent => 80;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverSearchDelegate oldDelegate) {
    return false;
  }
}