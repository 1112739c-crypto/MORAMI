import 'package:flutter/material.dart';

void main() {
  runApp(const ClothingApp());
}

class ClothingItem {
  int id;
  String name;
  String size;
  String color;
  double costPrice;
  double sellingPrice;
  int quantity;
  String imageUrl; // إضافة خانة رابط الصورة

  ClothingItem({
    required this.id,
    required this.name,
    required this.size,
    required this.color,
    required this.costPrice,
    required this.sellingPrice,
    required this.quantity,
    required this.imageUrl,
  });
}

class ClothingApp extends StatelessWidget {
  const ClothingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.amber,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String storeName = "MORAMI STORE";

  // قائمة الموديلات مع روابط صور افتراضية للتجربة
  List<ClothingItem> inventory = [
    ClothingItem(
      id: 101,
      name: 'هودي شتوي فاخر',
      size: 'XL',
      color: 'أسود',
      costPrice: 15000,
      sellingPrice: 25000,
      quantity: 3,
      imageUrl: 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=300', // رابط صورة هودي
    ),
    ClothingItem(
      id: 102,
      name: 'قميص صيفي كلاسيك',
      size: 'M',
      color: 'أبيض',
      costPrice: 8000,
      sellingPrice: 15000,
      quantity: 10,
      imageUrl: 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=300', // رابط صورة قميص
    ),
  ];

  double totalProfit = 0.0;

  void sellOneItem(ClothingItem item) {
    if (item.quantity > 0) {
      setState(() {
        item.quantity--;
        totalProfit += (item.sellingPrice - item.costPrice);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم بيع قطعة من: ${item.name}'),
          backgroundColor: Colors.amber.shade800,
        ),
      );
    }
  }

  void restockItem(ClothingItem item) {
    setState(() {
      item.quantity += 5;
    });
  }

  // نافذة إضافة منتج جديد مع حقل الصورة
  void showAddModelDialog() {
    String name = '';
    String size = 'L';
    double cost = 0;
    double price = 0;
    int qty = 1;
    String imgUrl = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Row(
            children: [
              Icon(Icons.add_a_photo, color: Colors.amber),
              SizedBox(width: 8),
              Text('إضافة موديل جديد', style: TextStyle(color: Colors.amber)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'اسم الموديل', labelStyle: TextStyle(color: Colors.grey)),
                  onChanged: (val) => name = val,
                ),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'رابط صورة الموديل (اختياري)', labelStyle: TextStyle(color: Colors.grey)),
                  onChanged: (val) => imgUrl = val,
                ),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'المقاس (S/M/L/XL)', labelStyle: TextStyle(color: Colors.grey)),
                  onChanged: (val) => size = val,
                ),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'سعر التكلفة (د.
                  ع)', labelStyle: TextStyle(color: Colors.grey)),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => cost = double.tryParse(val) ?? 0,
                ),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'سعر البيع (د.ع)', labelStyle: TextStyle(color: Colors.grey)),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => price = double.tryParse(val) ?? 0,
                ),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'الكمية', labelStyle: TextStyle(color: Colors.grey)),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => qty = int.tryParse(val) ?? 1,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty && price > 0) {
                  setState(() {
                    inventory.add(ClothingItem(
                      id: DateTime.now().millisecondsSinceEpoch % 1000,
                      name: name,
                      size: size,
                      color: 'أسود',
                      costPrice: cost,
                      sellingPrice: price,
                      quantity: qty,
                      imageUrl: imgUrl.isNotEmpty
                          ? imgUrl
                          : 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=300', // صورة افتراضية
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
              child: const Text('حفظ الموديل', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.storefront, color: Colors.amber),
            const SizedBox(width: 8),
            Text(storeName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            // بطاقة الأرباح
            Card(
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: Colors.amber, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.analytics, color: Colors.black),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('أرباح  ', style: TextStyle(fontSize: 14, color: Colors.grey)),
                          Text('${totalProfit.toStringAsFixed(0)} د.ع', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ),
            const SizedBox(height: 15),
            const Text('سجل الموديلات والمخزون:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),

            for (var item in inventory)
              Card(
                color: const Color(0xFF1E1E1E),
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: item.quantity == 0 ? Colors.redAccent : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: ListTile(
                  // 🖼️ دائرة عرض صورة الموديل
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                  title: Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: item.quantity == 0 ? Colors.redAccent : Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    item.quantity == 0
                        ? '⚠️ نفد من المخزون (المتبقي: 0)'
                        : 'المقاس: ${item.size} | المتبقي: ${item.quantity} قطعة',
                    style: TextStyle(color: item.quantity == 0 ? Colors.red.shade300 : Colors.grey),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${item.sellingPrice.toStringAsFixed(0)} د.ع',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                      const SizedBox(height: 6),
                      item.quantity > 0
                          ? InkWell(
                              onTap: () => sellOneItem(item),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(5)),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add_shopping_cart, size: 14, color: Colors.black),
                                    SizedBox(width: 4),
                                    Text('بيع 1', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                                  ],
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () => restockItem(item),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5)),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.refresh, size: 14, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text('+ تجديد (5)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                  ],
                                  ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: showAddModelDialog,
        backgroundColor: Colors.amber,
        icon: const Icon(Icons.add_a_photo, color: Colors.black),
        label: const Text('إضافة موديل', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
