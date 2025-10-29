import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/models/product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/product_detail_provider.dart';

class ProductDetailView extends ConsumerWidget {
  const ProductDetailView({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productDetailProvider(productId));
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Colors.transparent,
      ),
      body: product.when(
        data: (item) {
          if (item == null) {
            return Center(child: Text(l10n.emptyState));
          }
          return _ProductDetailContent(product: item);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
      ),
    );
  }
}

class _ProductDetailContent extends StatefulWidget {
  const _ProductDetailContent({required this.product});

  final Product product;

  @override
  State<_ProductDetailContent> createState() => _ProductDetailContentState();
}

class _ProductDetailContentState extends State<_ProductDetailContent> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final product = widget.product;
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        CarouselSlider.builder(
          itemCount: product.imageUrls.length,
          itemBuilder: (context, index, realIndex) {
            final url = product.imageUrls[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.network(url, fit: BoxFit.cover, width: double.infinity),
            );
          },
          options: CarouselOptions(
            height: 320,
            viewportFraction: 0.85,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) => setState(() => _index = index),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(product.imageUrls.length, (index) {
            final isActive = index == _index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 24 : 10,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFC5A253) : Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFC5A253)),
                  const SizedBox(width: 6),
                  Text('${product.rating} (${product.reviewsCount} ${l10n.reviews})'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    '฿${(product.salePrice ?? product.price).toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: const Color(0xFFC5A253)),
                  ),
                  if (product.hasSale) ...[
                    const SizedBox(width: 12),
                    Text(
                      '฿${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white54,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              Text(product.description, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                children: product.promoTags
                    .map((tag) => Chip(
                          label: Text(tag),
                          backgroundColor: const Color(0xFF1F1F1F),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              Text(l10n.productSpecs, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              ...product.specs.entries.map(
                (entry) => ListTile(
                  dense: true,
                  leading: const Icon(Icons.check_circle_outline, color: Color(0xFFC5A253)),
                  title: Text('${entry.key}: ${entry.value}'),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.name} ${l10n.addToCart}')),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        backgroundColor: const Color(0xFFC5A253),
                        foregroundColor: Colors.black,
                      ),
                      child: Text(l10n.addToCart),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.name} ${l10n.buyNow}')),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFC5A253)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        foregroundColor: const Color(0xFFC5A253),
                      ),
                      child: Text(l10n.buyNow),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
