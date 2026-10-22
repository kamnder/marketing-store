
import 'package:flutter/material.dart';

void main() {
  runApp(const MarketingApp());
}

const gold = Color(0xFFB68D40);
const cream = Color(0xFFFAF7F0);
const ink = Color(0xFF25221F);

class Product {
  final String name;
  final String category;
  final int price;
  final IconData icon;

  const Product(this.name, this.category, this.price, this.icon);
}

const products = [
  Product('عطر ملكي', 'عطور', 25000, Icons.spa),
  Product('عطر الورد', 'عطور', 18000, Icons.local_florist),
  Product('مرطب البشرة', 'مرطبات', 12000, Icons.water_drop),
  Product('كريم العناية', 'العناية بالبشرة', 15000, Icons.face_retouching_natural),
  Product('عطر فاخر', 'عطور', 30000, Icons.auto_awesome),
  Product('مجموعة الجمال', 'مستحضرات التجميل', 22000, Icons.brush),
];

class MarketingApp extends StatelessWidget {
  const MarketingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Marketing',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: gold),
        fontFamily: 'Roboto',
      ),
      home: const StoreHome(),
    );
  }
}

class StoreHome extends StatefulWidget {
  const StoreHome({super.key});

  @override
  State<StoreHome> createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  String category = 'الكل';
  String search = '';
  final Map<Product, int> cart = {};

  final categories = [
    'الكل',
    'عطور',
    'مرطبات',
    'العناية بالبشرة',
    'مستحضرات التجميل',
  ];

  int get totalItems =>
      cart.values.fold(0, (sum, count) => sum + count);

  int get totalPrice => cart.entries.fold(
        0,
        (sum, entry) => sum + entry.key.price * entry.value,
      );

  @override
  Widget build(BuildContext context) {
    final shown = products.where((p) {
      final matchCategory = category == 'الكل' || p.category == category;
      final matchSearch = p.name.contains(search);
      return matchCategory && matchSearch;
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cream,
          title: const Text(
            'Marketing',
            style: TextStyle(
              color: ink,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'السلة',
              onPressed: _showCart,
              icon: Badge(
                label: Text('$totalItems'),
                isLabelVisible: totalItems > 0,
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF30271F), Color(0xFF756044)],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'جمالك يبدأ من هنا',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'اكتشف العطور ومنتجات العناية والجمال',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'MARKETING  •  BEAUTY & PERFUMES',
                    style: TextStyle(color: Color(0xFFE6C989), fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'ابحث عن منتج...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => search = value.trim()),
            ),
            const SizedBox(height: 22),
            const Text(
              'تسوق حسب القسم',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(item),
                      selected: category == item,
                      selectedColor: const Color(0xFFE8D8B6),
                      onSelected: (_) => setState(() => category = item),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'منتجات مختارة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shown.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                final p = shown[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFECE5D9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2EBDD),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(p.icon, size: 60, color: gold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          p.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
                        child: Text(
                          '${p.price} SDG',
                          style: const TextStyle(
                            color: gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
                        child: FilledButton.icon(
                          onPressed: () {
                            setState(() => cart[p] = (cart[p] ?? 0) + 1);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('تمت إضافة ${p.name} للسلة'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_shopping_cart, size: 18),
                          label: const Text('أضف للسلة'),
                          style: FilledButton.styleFrom(
                            backgroundColor: ink,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'سلة المشتريات',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (cart.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('السلة فارغة، أضف منتجاتك المفضلة'),
                  )
                else
                  ...cart.entries.map(
                    (entry) => ListTile(
                      title: Text(entry.key.name),
                      subtitle: Text('${entry.key.price} SDG للقطعة'),
                      leading: const Icon(Icons.shopping_bag_outlined),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (entry.value <= 1) {
                                  cart.remove(entry.key);
                                } else {
                                  cart[entry.key] = entry.value - 1;
                                }
                              });
                              Navigator.pop(context);
                              _showCart();
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text('${entry.value}'),
                          IconButton(
                            onPressed: () {
                              setState(() =>
                                  cart[entry.key] = entry.value + 1);
                              Navigator.pop(context);
                              _showCart();
                            },
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ),
                  ),
                const Divider(),
                Text(
                  'الإجمالي: $totalPrice SDG',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: cart.isEmpty
                        ? null
                        : () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'السلة جاهزة. سنضيف تأكيد الطلب في الخطوة التالية.',
                                ),
                              ),
                            );
                          },
                    child: const Text('متابعة الطلب'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
