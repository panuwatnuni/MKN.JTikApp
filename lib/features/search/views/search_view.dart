import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../home/widgets/home_product_card.dart';
import '../providers/search_provider.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    final history = ref.watch(searchHistoryProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          onSubmitted: (value) => ref.read(searchResultsProvider.notifier).submit(value),
          decoration: InputDecoration(
            hintText: 'ค้นหาใน JTikApp',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: const Color(0xFF141414),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: Color(0xFFC5A253)),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (history.isNotEmpty) ...[
              Text('การค้นหาล่าสุด', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: history
                    .map(
                      (item) => ActionChip(
                        label: Text(item),
                        onPressed: () => ref.read(searchResultsProvider.notifier).submit(item),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: results.when(
                data: (items) {
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'ยังไม่มีข้อมูล',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  }
                  return GridView.builder(
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
                        ctaLabel: 'หยิบใส่รถเข็น',
                        onTap: () => context.go('/home/product/${product.id}'),
                        onAddToCart: () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('เพิ่ม ${product.name} ลงในรถเข็นแล้ว')),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(child: Text(error.toString())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
