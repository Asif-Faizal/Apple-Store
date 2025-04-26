import 'package:flutter/material.dart';
import '../providers/search.filter.provider.dart';
import 'package:provider/provider.dart';

class SearchHeader extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilterTap;

  const SearchHeader({
    super.key,
    required this.controller,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<SearchFilterProvider, String?>(
      selector: (_, provider) => provider.selectedType,
      builder: (context, selectedType, _) {
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selectedType != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        Provider.of<SearchFilterProvider>(context, listen: false).resetFilters();
                        controller.clear();
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: onFilterTap,
                  ),
                ],
              ),
              filled: true,
              fillColor: Theme.of(context).cardColor,
            ),
            onChanged: (value) {
              Provider.of<SearchFilterProvider>(context, listen: false).setSearchQuery(value);
            },
          ),
        );
      },
    );
  }
}