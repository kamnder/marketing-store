import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const ForYouApp());

const ink = Color(0xFF211A19), gold = Color(0xFFB68A45), cream = Color(0xFFFAF6F0), rose = Color(0xFFEAD9D1);

class Product {
  final String name, category;
  final int price;
  final IconData icon;
  const Product(this.name, this.category, this.price, this.icon);
}

const products = <Product>[
  Product('عطر ملكي', 'عطور', 450, Icons.spa),
  Product('عطر الورد', 'عطور', 320, Icons.local_florist),
  Product('مسك أبيض', 'عطور', 280, Icons.auto_awesome),
  Product('مجموعة العناية', 'العناية بالبشرة', 390, Icons.spa_outlined),
  Product('مرطب البشرة', 'العناية بالبشرة', 220, Icons.water_drop_outlined),
  Product('أحمر شفاه', 'مستحضرات التجميل', 180, Icons.brush_outlined),
  Product('ماسكارا', 'مستحضرات التجميل', 210, Icons.remove_red_eye_outlined),
  Product('هدية الجمال', 'هدايا', 550, Icons.card_giftcard),
];

class ForYouApp extends StatelessWidget {
  const ForYouApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'For You',
    theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: cream,
      colorScheme: ColorScheme.fromSeed(seedColor: gold, primary: ink),
      appBarTheme: const AppBarTheme(backgroundColor: cream, foregroundColor: ink)),
    home: const AnimatedSplash(),
  );
}

class AnimatedSplash extends StatefulWidget {
  const AnimatedSplash({super.key});
  @override
  State<AnimatedSplash> createState() => _AnimatedSplashState();
}

class _AnimatedSplashState extends State<AnimatedSplash> with SingleTickerProviderStateMixin {
  late final AnimationController _motion = AnimationController(
    vsync: this, duration: const Duration(seconds: 9),
  )..repeat();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const StoreHome(),
            transitionDuration: const Duration(milliseconds: 700),
            transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: AnimatedBuilder(
      animation: _motion,
      builder: (context, _) => Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFF100804), Color(0xFF321707), Color(0xFF170B05)],
              ),
            ),
          ),
          CustomPaint(painter: GoldThreadsPainter(_motion.value)),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 260, height: 260,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF190D08),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0xFFD6AC62), width: 1.4),
                        boxShadow: [BoxShadow(color: const Color(0xFFD6AC62).withOpacity(.22), blurRadius: 30, spreadRadius: 3)],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/for_you_logo.png', fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text('عطور ومستحضرات التجميل', textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Color(0xFFE9C991), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 13),
                    const Text('B E A U T Y   •   P E R F U M E   •   C A R E',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Color(0xFFE9C991), letterSpacing: 1)),
                    const SizedBox(height: 46),
                    const SizedBox(width: 22, height: 22,
                      child: CircularProgressIndicator(strokeWidth: 1.7, color: Color(0xFFE9C991))),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class GoldThreadsPainter extends CustomPainter {
  final double progress;
  GoldThreadsPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [const Color(0xFFFFE4A1), const Color(0xFFD6A34F), const Color(0xFF9A6125)];
    for (var strand = 0; strand < 12; strand++) {
      final path = Path();
      final phase = progress * math.pi * 2 + strand * .24;
      for (var step = 0; step <= 90; step++) {
        final t = step / 90;
        final x = t * size.width;
        final wave = math.sin(t * math.pi * 2.1 + phase) * size.height * .065;
        final bend = math.sin(t * math.pi + phase * .55) * size.height * .06;
        final y = size.height * (strand < 6 ? .13 + strand * .014 : .82 + (strand - 6) * .014)
          + wave + bend;
        if (step == 0) { path.moveTo(x, y); } else { path.lineTo(x, y); }
      }
      final paint = Paint()
        ..color = colors[strand % colors.length].withOpacity(strand % 3 == 0 ? .82 : .38)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strand % 4 == 0 ? 1.45 : .65
        ..strokeCap = StrokeCap.round
        ..maskFilter = strand % 4 == 0 ? const MaskFilter.blur(BlurStyle.normal, 1.4) : const MaskFilter.blur(BlurStyle.normal, .35);
      canvas.drawPath(path, paint);
    }
    for (var i = 0; i < 18; i++) {
      final x = ((i * 73.0 + progress * size.width * .45) % size.width);
      final y = size.height * (.12 + ((i * 37) % 76) / 100);
      final pulse = .5 + .5 * math.sin(progress * math.pi * 4 + i);
      final paint = Paint()..color = const Color(0xFFFFD780).withOpacity(.2 + pulse * .65);
      canvas.drawCircle(Offset(x, y), .7 + pulse * 1.2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant GoldThreadsPainter oldDelegate) => oldDelegate.progress != progress;
}

class StoreHome extends StatefulWidget {
  const StoreHome({super.key});
  @override
  State<StoreHome> createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> with SingleTickerProviderStateMixin {
  late final AnimationController _backgroundMotion = AnimationController(
    vsync: this, duration: const Duration(seconds: 12),
  )..repeat();

  @override
  void dispose() {
    _backgroundMotion.dispose();
    super.dispose();
  }
  String category = 'الكل', search = '';
  final Map<Product, int> cart = {};
  final categories = const ['الكل', 'عطور', 'العناية بالبشرة', 'مستحضرات التجميل', 'هدايا'];
  int get totalItems => cart.values.fold(0, (s, n) => s + n);
  int get totalPrice => cart.entries.fold(0, (s, e) => s + e.key.price * e.value);

  @override
  Widget build(BuildContext context) {
    final shown = products.where((p) =>
      (category == 'الكل' || p.category == category) &&
      (p.name.contains(search) || p.category.contains(search))).toList();
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      appBar: AppBar(
      backgroundColor: const Color(0xFF170B05),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      foregroundColor: const Color(0xFFF4D28D),
      title: const Row(children: [
        Icon(Icons.local_florist, color: gold, size: 27), SizedBox(width: 8),
        Text('For You', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
      ]), actions: [
        IconButton(tooltip: 'سلة المشتريات', onPressed: _showCart,
          icon: Badge(isLabelVisible: totalItems > 0, label: Text('$totalItems'),
            child: const Icon(Icons.shopping_bag_outlined, size: 27))),
        const SizedBox(width: 8),
      ]),
      body: Stack(fit: StackFit.expand, children: [
        const DecoratedBox(decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF100804), Color(0xFF321707), Color(0xFF170B05)]))),
        AnimatedBuilder(animation: _backgroundMotion, builder: (context, _) =>
          CustomPaint(painter: GoldThreadsPainter(_backgroundMotion.value))),
        ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 28), children: [
        Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft,
            colors: [Color(0xFF332320), Color(0xFF795848)]),
          borderRadius: BorderRadius.circular(24)),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('لأنك تستحق التميّز', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('اكتشف عطورك المفضلة ومنتجات الجمال والعناية المختارة لك.',
              style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.6)),
            SizedBox(height: 18),
            Row(children: [Icon(Icons.auto_awesome, color: Color(0xFFE9C991), size: 17),
              SizedBox(width: 7), Text('YOUR BEAUTY. YOUR MOMENT.',
              style: TextStyle(color: Color(0xFFE9C991), fontSize: 11, fontWeight: FontWeight.bold))]),
          ])),
        const SizedBox(height: 18),
        TextField(textDirection: TextDirection.rtl, onChanged: (v) => setState(() => search = v.trim()),
          decoration: InputDecoration(hintText: 'ابحث عن عطر أو منتج...', prefixIcon: const Icon(Icons.search),
            filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(vertical: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
        const SizedBox(height: 22),
        const Text('تسوق حسب القسم', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: const Color(0xFFF8E8CB))),
        const SizedBox(height: 12),
        SizedBox(height: 43, child: ListView(scrollDirection: Axis.horizontal,
          children: categories.map((c) => Padding(padding: const EdgeInsets.only(left: 8),
            child: ChoiceChip(label: Text(c), selected: category == c,
              selectedColor: const Color(0xFFE8D6B8), onSelected: (_) => setState(() => category = c)))).toList())),
        const SizedBox(height: 22),
        Row(children: [const Expanded(child: Text('اختيارات For You',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFF8E8CB)))),
          Text('${shown.length} منتجات', style: const TextStyle(color: Color(0xFFD9C8B2)))]),
        const SizedBox(height: 14),
        if (shown.isEmpty) const Padding(padding: EdgeInsets.all(28),
          child: Center(child: Text('لا توجد منتجات مطابقة للبحث'))),
        GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          itemCount: shown.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .67),
          itemBuilder: (context, index) {
            final p = shown[index];
            return Container(decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.circular(19), border: Border.all(color: const Color(0xFFECE3D8))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Expanded(child: Container(margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(gradient: const LinearGradient(
                    colors: [Color(0xFFF6EDE5), Color(0xFFEAD9D1)]),
                    borderRadius: BorderRadius.circular(15)),
                  child: Stack(children: [
                    const Positioned(top: 10, right: 10, child: Icon(Icons.auto_awesome, size: 16, color: gold)),
                    Center(child: Icon(p.icon, size: 58, color: const Color(0xFF8D6545))),
                  ]))),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                Padding(padding: const EdgeInsets.fromLTRB(10, 5, 10, 4),
                  child: Text(p.category, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54, fontSize: 11))),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: Text('${p.price} ج.م', style: const TextStyle(color: gold, fontWeight: FontWeight.w800, fontSize: 16))),
                Padding(padding: const EdgeInsets.fromLTRB(8, 3, 8, 8),
                  child: FilledButton.icon(onPressed: () {
                    setState(() => cart[p] = (cart[p] ?? 0) + 1);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('تمت إضافة ${p.name} إلى السلة'),
                      duration: const Duration(seconds: 1)));
                  }, icon: const Icon(Icons.add, size: 18), label: const Text('أضف للسلة'),
                    style: FilledButton.styleFrom(backgroundColor: ink, foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 9)))),
              ]));
          }),
        const SizedBox(height: 20),
        const Center(child: Text('جمالك يبدأ من اختيارك',
          style: TextStyle(color: Color(0xFFD9C8B2), fontSize: 12))),
        ]),
      ]),
    ));
  }

  void _showCart() {
    showModalBottomSheet(context: context, isScrollControlled: true, showDragHandle: true,
      builder: (sheetContext) => Directionality(textDirection: TextDirection.rtl,
        child: SafeArea(child: StatefulBuilder(builder: (context, refreshSheet) =>
          Padding(padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('سلة المشتريات', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (cart.isEmpty) const Padding(padding: EdgeInsets.all(24),
                child: Text('السلة فارغة. أضف منتجاتك المفضلة أولاً.'))
              else ...cart.entries.toList().map((e) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(backgroundColor: rose, child: Icon(Icons.shopping_bag_outlined, color: ink)),
                title: Text(e.key.name), subtitle: Text('${e.key.price} ج.م للقطعة'),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(onPressed: () { setState(() {
                    if (e.value <= 1) { cart.remove(e.key); } else { cart[e.key] = e.value - 1; }
                  }); refreshSheet(() {}); }, icon: const Icon(Icons.remove_circle_outline)),
                  Text('${cart[e.key] ?? 0}'),
                  IconButton(onPressed: () { setState(() => cart[e.key] = (cart[e.key] ?? 0) + 1);
                    refreshSheet(() {}); }, icon: const Icon(Icons.add_circle_outline)),
                ]))),
              const Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('الإجمالي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('$totalPrice ج.م', style: const TextStyle(fontSize: 20, color: gold, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 14),
              SizedBox(width: double.infinity, child: FilledButton(
                onPressed: cart.isEmpty ? null : () { Navigator.pop(sheetContext); _showCheckout(); },
                style: FilledButton.styleFrom(backgroundColor: ink, foregroundColor: Colors.white, padding: const EdgeInsets.all(14)),
                child: const Text('إتمام الطلب'))),
            ]))))));
  }

  void _showCheckout() {
    final name = TextEditingController(), phone = TextEditingController(), address = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(context: context, builder: (dialogContext) => Directionality(textDirection: TextDirection.rtl,
      child: AlertDialog(title: const Text('بيانات توصيل الطلب'),
        content: Form(key: formKey, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('إجمالي طلبك: $totalPrice ج.م', style: const TextStyle(fontWeight: FontWeight.bold, color: gold)),
          const SizedBox(height: 14),
          TextFormField(controller: name, decoration: const InputDecoration(labelText: 'الاسم بالكامل', border: OutlineInputBorder()),
            validator: (v) => v == null || v.trim().isEmpty ? 'اكتب اسمك' : null),
          const SizedBox(height: 10),
          TextFormField(controller: phone, keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'رقم الهاتف', border: OutlineInputBorder()),
            validator: (v) => v == null || v.trim().length < 7 ? 'اكتب رقم هاتف صحيحاً' : null),
          const SizedBox(height: 10),
          TextFormField(controller: address, maxLines: 2,
            decoration: const InputDecoration(labelText: 'عنوان التوصيل بالتفصيل', border: OutlineInputBorder()),
            validator: (v) => v == null || v.trim().isEmpty ? 'اكتب عنوان التوصيل' : null),
        ]))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
          FilledButton(onPressed: () async {
            if (!formKey.currentState!.validate()) return;
            final orderLines = cart.entries.map((e) =>
              '- ${e.key.name} × ${e.value} = ${e.key.price * e.value} ج.م').join('\n');
            final message = 'طلب جديد من متجر For You\n'
              'الاسم: ${name.text.trim()}\n'
              'هاتف العميل: ${phone.text.trim()}\n'
              'عنوان التوصيل: ${address.text.trim()}\n'
              'المنتجات والكميات:\n$orderLines\n'
              'الإجمالي: $totalPrice ج.م';
            final uri = Uri.https('wa.me', '/249915121132', {'text': message});
            final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
            if (!opened) {
              if (dialogContext.mounted) {
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(content: Text('تعذر فتح واتساب. تأكد من تثبيته واتصالك بالإنترنت.')));
              }
              return;
            }
            if (dialogContext.mounted) Navigator.pop(dialogContext);
          }, child: const Text('إرسال الطلب عبر واتساب')),
        ],
      )));
  }
}
