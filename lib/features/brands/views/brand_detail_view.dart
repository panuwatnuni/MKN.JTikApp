import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../home/widgets/home_product_card.dart';
import '../providers/brand_providers.dart';

class BrandDetailView extends ConsumerWidget {
  const BrandDetailView({super.key, required this.brandId});

  final String brandId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final brand = ref.watch(brandListProvider);
    final products = ref.watch(brandProductsProvider(brandId));
    return Scaffold(
      appBar: AppBar(
        title: Text(brandId.toUpperCase()),
        backgroundColor: Colors.transparent,
      ),
      body: brand.when(
        data: (items) {
          final selected = items.firstWhere(
            (element) => element.id == brandId,
            orElse: () => items.first,
          );
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.network(selected.heroImage ?? '', height: 200, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              Text(
                selected.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(selected.description ?? '', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: selected.categories
                    .map((category) => Chip(
                          label: Text(category),
                          backgroundColor: const Color(0xFF1F1F1F),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              Text(l10n.topDeals, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              products.when(
                data: (items) => GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final product = items[index];
                    return HomeProductCard(
                      product: product,
                      ctaLabel: l10n.addToCart,
                      onTap: () => context.go('/home/product/${product.id}'),
                      onAddToCart: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.name} added to cart')),
                      ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Text(error.toString()),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
      ),
    );
  }
}
