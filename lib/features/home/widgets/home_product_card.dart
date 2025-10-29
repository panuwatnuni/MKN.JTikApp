import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/data/models/product.dart';

class HomeProductCard extends StatelessWidget {
  const HomeProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.ctaLabel = 'Add to Cart',
  });

  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final String ctaLabel;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: product.currency == 'THB' ? '฿' : '', decimalDigits: 0);
    final priceText = formatter.format(product.price);
    final saleText = product.salePrice != null ? formatter.format(product.salePrice) : null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        clipBehavior: Clip.hardEdge,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF141414), Color(0xFF0B0B0B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (product.hasSale)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFD6B15E), Color(0xFFC5A253)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '-${product.discountPercent!.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.brand,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFC5A253), size: 18),
                        const SizedBox(width: 4),
                        Text('${product.rating.toStringAsFixed(1)} (${product.reviewsCount})'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          saleText ?? priceText,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: const Color(0xFFC5A253),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (saleText != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            priceText,
                            style: const TextStyle(
                              color: Colors.white54,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: onAddToCart,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          backgroundColor: const Color(0xFFC5A253),
                          foregroundColor: Colors.black,
                        ),
                        child: Text(ctaLabel),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
