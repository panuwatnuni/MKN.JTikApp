import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../home/widgets/home_product_card.dart';
import '../providers/promotion_providers.dart';

class PromotionHubView extends ConsumerWidget {
  const PromotionHubView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promotions = ref.watch(promotionListProvider);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.promotionsHub),
        backgroundColor: Colors.transparent,
      ),
      body: promotions.when(
        data: (items) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final promotion = items[index];
            return ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              tileColor: const Color(0xFF161616),
              leading: const Icon(Icons.local_fire_department, color: Color(0xFFC5A253)),
              title: Text(promotion.title),
              subtitle: Text(promotion.description),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/promotions/${Uri.encodeComponent(promotion.id)}'),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: items.length,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
      ),
    );
  }
}

class PromotionDetailView extends ConsumerWidget {
  const PromotionDetailView({super.key, required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final promotions = ref.watch(promotionListProvider);
    return promotions.when(
      data: (items) {
        final promotion = items.firstWhere(
          (element) => element.id == tag,
          orElse: () => items.first,
        );
        final promoTag = promotion.tags.isNotEmpty ? promotion.tags.first : promotion.title;
        final products = ref.watch(promotionProductsProvider(promoTag));
        return Scaffold(
          appBar: AppBar(
            title: Text(promotion.title),
            backgroundColor: Colors.transparent,
          ),
          body: products.when(
            data: (items) => GridView.builder(
              padding: const EdgeInsets.all(16),
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
            error: (error, stackTrace) => Center(child: Text(error.toString())),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(body: Center(child: Text(error.toString()))),
    );
  }
}
