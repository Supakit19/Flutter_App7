import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_Route.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  List<Item> cartItems = []; // List to hold items in the cart

  // Method to add item to the cart
  void addToCart(Item item) {
    setState(() {
      cartItems.add(item);
    });
  }

  // Calculate the total price of the items in the cart
  double get totalPrice => cartItems.fold(0, (sum, item) => sum + item.price);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          // Allow scrolling
          child: Column(
            children: [
              // ส่วนหัวที่มีกรอบสีเขียว
              Container(
                decoration: const BoxDecoration(
                  color: Colors.green,
                ),
                height: 230, // ความสูงของกรอบสีเขียว
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20), // ลดระยะห่างจากด้านบน
                      // แสดงภาพจาก assets
                      Image.asset(
                        'assets/images/marker_icon.png',
                        height: 100, // กำหนดความสูงของภาพ
                      ),
                      const SizedBox(
                          height: 20), // ระยะห่างระหว่างภาพและช่องสินค้า
                      Transform.translate(
                        offset: const Offset(0, 30), // ขยับบล็อกลงไป
                        child: Wrap(
                          spacing: 16.0,
                          runSpacing: 16.0,
                          children: List.generate(4, (index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: 80,
                              height: 35,
                              alignment: Alignment.center,
                              child: Text(
                                'สินค้า ${index + 1}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ใช้ GridView.builder
              GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 25.0,
                  mainAxisSpacing: 16.0,
                ),
                itemBuilder: (context, index) {
                  // ดึงข้อมูลจาก mockItems
                  final item = mockItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            item.imageUrl, // โหลดรูปภาพจาก URL
                            height: 100, // กำหนดความสูงของรูปภาพ
                          ),
                          const SizedBox(height: 10),
                          Text(item.name), // แสดงชื่อสินค้า
                          Text('${item.price} ฿'), // แสดงราคาสินค้า
                          ElevatedButton(
                            onPressed: () {
                              addToCart(item); // Add the item to the cart
                            },
                            child: const Text('เพิ่มลงตะกร้า'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: mockItems.length, // ใช้จำนวน item จาก mockItems
                shrinkWrap: true, // ใช้พื้นที่ที่มันต้องการเท่านั้น
                physics:
                    const NeverScrollableScrollPhysics(), // ปิดการเลื่อนของ GridView
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            color: Colors.green,
            child: GestureDetector(
              onTap: () async {
                Navigator.pushNamed(
                  context,
                  AppRouter.main3,
                  arguments: {
                    'cartItems':
                        cartItems, // ส่ง List<Item> ด้วยคีย์ 'cartItems'
                    'address': 'ไม่พบที่อยู่', // ส่ง address ด้วยคีย์ 'address'
                  },
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  Text(
                    'จำนวนสินค้า: ${cartItems.length}   ${totalPrice.toStringAsFixed(2)} ฿',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// สร้างคลาส Item
class Item {
  final String name;
  final double price;
  final String imageUrl;

  Item({required this.name, required this.price, required this.imageUrl});
}

// สร้าง mock items
List<Item> mockItems = [
  Item(
      name: 'Cheese',
      price: 10.0,
      imageUrl:
          'assets/images/marker_icon.png'), // โหลดรูปภาพจาก assets โดยใช้ Image.asset
  Item(
      name: 'Sticky Rice with Mango',
      price: 20.0,
      imageUrl: 'assets/images/marker_icon.png'),
  Item(
      name: 'Mango Sticky Rice',
      price: 30.0,
      imageUrl: 'assets/images/marker_icon.png'),
  Item(name: 'Dessert', price: 40.0, imageUrl: 'assets/images/marker_icon.png'),
];
