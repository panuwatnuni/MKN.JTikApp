import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/models/product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../eservice/providers/eservice_subscription_provider.dart';
import '../../search/providers/search_provider.dart';
import '../providers/home_providers.dart';
import '../widgets/home_product_card.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final featured = ref.watch(homeFeaturedProductsProvider);
    final flashSale = ref.watch(flashSaleProductsProvider);
    final newArrivals = ref.watch(newArrivalsProvider);
    final mostReviewed = ref.watch(mostReviewedProvider);
    final categories = ref.watch(categoryListProvider);
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            pinned: true,
            expandedHeight: 100,
            flexibleSpace: _HomeHeader(
              onSearchTap: () => context.go('/home/search'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _HeroCarousel(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _EserviceCard(l10n: l10n),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _FlashSaleStrip(l10n: l10n, flashSale: flashSale),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _CategoryChips(categories: categories),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _ProductSection(
              title: l10n.topDeals,
              products: featured,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _HorizontalSection(
              title: l10n.newArrivals,
              products: newArrivals,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            sliver: _HorizontalSection(
              title: l10n.mostReviewed,
              products: mostReviewed,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onSearchTap});

  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onSearchTap,
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFC5A253), width: 1.5),
                    color: const Color(0xFF141414),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Color(0xFFC5A253)),
                      const SizedBox(width: 12),
                      Text(
                        l10n.searchHint,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                context.go('/notifications');
              },
              icon: const Icon(Icons.notifications_none, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCarousel extends ConsumerStatefulWidget {
  @override
  ConsumerState<_HeroCarousel> createState() => _HeroCarouselState();

  const _HeroCarousel({super.key});
}

class _HeroCarouselState extends ConsumerState<_HeroCarousel> {
  int _index = 0;
  final List<String> _banners = const [
    'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1512495967260-9cdb1f0b5111?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1514996937319-344454492b37?auto=format&fit=crop&w=1200&q=80',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _banners.length,
          itemBuilder: (context, index, realIndex) {
            final image = _banners[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(image, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    bottom: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Luxury Exclusives',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFDCC47E), Color(0xFFC5A253)],
                            ),
                          ),
                          child: const Text(
                            'Shop the drop',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: 210,
            viewportFraction: 0.9,
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) => setState(() => _index = index),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (index) {
            final isActive = index == _index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isActive ? 32 : 12,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFC5A253) : Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _EserviceCard extends ConsumerWidget {
  const _EserviceCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscribed = ref.watch(eserviceSubscriptionProvider);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => _showComingSoonDialog(context, ref, subscribed),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFFC5A253), size: 48),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.eserviceTitle} — ${l10n.comingSoon}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Premium concierge, repairs and on-demand services at your fingertips.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showComingSoonDialog(
    BuildContext context,
    WidgetRef ref,
    bool subscribed,
  ) async {
    final l10n = AppLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        bool localSubscribed = subscribed;
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bolt, color: Color(0xFFC5A253), size: 32),
                    const SizedBox(width: 12),
                    Text(
                      l10n.eserviceTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'We are crafting ultra-premium concierge experiences. Be first to know when we launch.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async {
                    final notifier = ref.read(eserviceSubscriptionProvider.notifier);
                    await notifier.toggleSubscription(!localSubscribed);
                    setState(() => localSubscribed = !localSubscribed);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(localSubscribed
                            ? l10n.notifyEserviceSuccess
                            : '${l10n.notifyMe} cancelled'),
                      ),
                    );
                  },
                  icon: Icon(localSubscribed ? Icons.check : Icons.notifications_active),
                  label: Text(localSubscribed ? l10n.notifySubscribed : l10n.notifyMe),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    backgroundColor: const Color(0xFFC5A253),
                    foregroundColor: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        });
      },
    );
  }
}

class _FlashSaleStrip extends ConsumerWidget {
  const _FlashSaleStrip({required this.l10n, required this.flashSale});

  final AppLocalizations l10n;
  final AsyncValue<List<Product>> flashSale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF2A1F09), Color(0xFF0B0B0B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.flashSale,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              _CountdownTimer(target: DateTime.now().add(const Duration(hours: 8))),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: flashSale.when(
              data: (items) => ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length > 10 ? 10 : items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final product = items[index];
                  return _FlashSaleItem(product: product);
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Text(error.toString()),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownTimer extends StatefulWidget {
  const _CountdownTimer({required this.target});

  final DateTime target;

  @override
  State<_CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<_CountdownTimer> {
  late Duration _remaining;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _remaining = widget.target.difference(DateTime.now());
    _ticker = Ticker((elapsed) {
      final diff = widget.target.difference(DateTime.now());
      if (diff.isNegative) return;
      setState(() => _remaining = diff);
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    final hours = twoDigits(_remaining.inHours);
    final minutes = twoDigits(_remaining.inMinutes.remainder(60));
    final seconds = twoDigits(_remaining.inSeconds.remainder(60));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC5A253)),
      ),
      child: Text('$hours:$minutes:$seconds'),
    );
  }
}

class _FlashSaleItem extends StatelessWidget {
  const _FlashSaleItem({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(product.imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            '฿${product.salePrice?.toStringAsFixed(0) ?? product.price.toStringAsFixed(0)}',
            style: const TextStyle(color: Color(0xFFC5A253), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _CategoryChips extends ConsumerWidget {
  const _CategoryChips({required this.categories});

  final AsyncValue<List<String>> categories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return categories.when(
      data: (items) => Wrap(
        spacing: 12,
        runSpacing: 12,
        children: items
            .map((category) => ChoiceChip(
                  label: Text(category),
                  selected: false,
                  onSelected: (_) {
                    ref.read(searchResultsProvider.notifier).submit(category);
                    GoRouter.of(context).go('/home/search');
                  },
                ))
            .toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text(error.toString()),
    );
  }
}

class _ProductSection extends ConsumerWidget {
  const _ProductSection({required this.title, required this.products});

  final String title;
  final AsyncValue<List<Product>> products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          products.when(
            data: (items) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final product = items[index];
                return HomeProductCard(
                  product: product,
                  ctaLabel: AppLocalizations.of(context).addToCart,
                  onTap: () => GoRouter.of(context).go('/home/product/${product.id}'),
                  onAddToCart: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} added to cart'),
                    ),
                  ),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Text(error.toString()),
          ),
        ],
      ),
    );
  }
}

class _HorizontalSection extends ConsumerWidget {
  const _HorizontalSection({required this.title, required this.products});

  final String title;
  final AsyncValue<List<Product>> products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 260,
            child: products.when(
              data: (items) => ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final product = items[index];
                  return SizedBox(
                    width: 220,
                    child: HomeProductCard(
                      product: product,
                      ctaLabel: AppLocalizations.of(context).addToCart,
                      onTap: () => GoRouter.of(context).go('/home/product/${product.id}'),
                      onAddToCart: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.name} added to cart')),
                      ),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Text(error.toString()),
            ),
          ),
        ],
      ),
    );
  }
}

class Ticker {
  Ticker(this._onTick);

  final void Function(Duration elapsed) _onTick;
  late final Stopwatch _stopwatch = Stopwatch()..start();
  late final Duration _interval = const Duration(seconds: 1);
  bool _isDisposed = false;

  void start() {
    Future<void>.delayed(_interval, _tick);
  }

  void _tick() {
    if (_isDisposed) return;
    final elapsed = _stopwatch.elapsed;
    _onTick(elapsed);
    Future<void>.delayed(_interval, _tick);
  }

  void dispose() {
    _isDisposed = true;
    _stopwatch.stop();
  }
}
