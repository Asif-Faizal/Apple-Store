import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.provider.dart';
import '../providers/theme.provider.dart';
import '../providers/product.provider.dart';
import '../providers/search.filter.provider.dart';
import '../widgets/product.gridview.dart';
import '../widgets/search.header.dart';
import 'auth.screen.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // We'll move this to build method
    });
  }

  final TextEditingController _searchController = TextEditingController();

  void _showFilterDialog(BuildContext context) {
    final searchFilterProvider = Provider.of<SearchFilterProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Products'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String?>(
              title: const Text('All'),
              value: null,
              groupValue: searchFilterProvider.selectedType,
              onChanged: (value) {
                searchFilterProvider.setSelectedType(value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String?>(
              title: const Text('iPhone'),
              value: 'iPhone',
              groupValue: searchFilterProvider.selectedType,
              onChanged: (value) {
                searchFilterProvider.setSelectedType(value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String?>(
              title: const Text('MacBook'),
              value: 'MacBook',
              groupValue: searchFilterProvider.selectedType,
              onChanged: (value) {
                searchFilterProvider.setSelectedType(value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String?>(
              title: const Text('iPad'),
              value: 'iPad',
              groupValue: searchFilterProvider.selectedType,
              onChanged: (value) {
                searchFilterProvider.setSelectedType(value);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final searchFilterProvider = Provider.of<SearchFilterProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Fetch products when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productProvider.fetchProducts();
    });

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

    // Update filtered products when products change
    if (productProvider.products.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        searchFilterProvider.filterProducts(productProvider.products);
      });
    }

    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(),
                child: Text('Apple Store', style: Theme.of(context).textTheme.titleLarge,),
              ),
              ListTile(
                title: Text('Logout', style: Theme.of(context).textTheme.bodyLarge,),
                onTap: () => authProvider.signOut(),
                trailing: const Icon(Icons.logout),
              ),
            ],
          ),
        ),
        body: CustomScrollView(
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
                    Text('Welcome,', style: Theme.of(context).textTheme.bodyLarge,),
                    Text(authProvider.user?.displayName ?? 'User', style: Theme.of(context).textTheme.titleLarge,),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
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
                child: SearchHeader(
                  controller: _searchController,
                  onFilterTap: () => _showFilterDialog(context),
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
              const ProductGrid(),
          ],
        ),
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