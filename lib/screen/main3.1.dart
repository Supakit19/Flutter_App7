import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_Route.dart';
import 'package:flutter_application_1/screen/main2.dart';

class Main3 extends StatefulWidget {
  const Main3({super.key});

  @override
  State<Main3> createState() => _Main3State();
}

class _Main3State extends State<Main3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'สั่งซื้อสินค้า',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddressSection(),
            SizedBox(height: 20),
            Expanded(
                child:
                    ProductList()), // ใช้ Expanded เพื่อป้องกันการเกิด overflow
            PriceSummary(),
          ],
        ),
      ),
    );
  }
}

class AddressSection extends StatelessWidget {
  const AddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูล arguments จาก route
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String address = arguments != null && arguments.containsKey('address')
        ? arguments['address']
        : 'ไม่พบที่อยู่'; // แสดงข้อความนี้ถ้าไม่มีข้อมูล

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ที่อยู่จัดส่ง',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_pin, color: Colors.green),
              const SizedBox(width: 10),
              Expanded(child: Text(address)),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // ดึงรายการสินค้าจาก arguments
    final List<Item>? items = arguments?['cartItems'] as List<Item>?;

    // ถ้าไม่มีสินค้าหรือไม่มีข้อมูล ให้แสดงข้อความ "ไม่มีสินค้าในตะกร้า"
    if (items == null || items.isEmpty) {
      return const Center(child: Text('ไม่มีสินค้าในตะกร้า'));
    }

    return ListView.builder(
      shrinkWrap: true, // ใช้ shrinkWrap เพื่อให้มันปรับขนาดอัตโนมัติใน Column
      physics: const NeverScrollableScrollPhysics(), // ปิดการเลื่อน
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ProductItem(
          name: item.name,
          price: '${item.price} บาท',
          color: Colors.green.shade50,
        );
      },
    );
  }
}

class ProductItem extends StatelessWidget {
  final String name;
  final String price;
  final Color color;

  const ProductItem(
      {super.key,
      required this.name,
      required this.price,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(Icons.shopping_bag, color: Colors.green),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 16))),
          Text(price, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class PriceSummary extends StatefulWidget {
  const PriceSummary({super.key});

  @override
  State<PriceSummary> createState() => _PriceSummaryState();
}

class _PriceSummaryState extends State<PriceSummary> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade100,
      ),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ค่าส่ง', style: TextStyle(fontSize: 16)),
              Text('5.00 บาท', style: TextStyle(fontSize: 16)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('รายการรวม', style: TextStyle(fontSize: 16)),
              Text('10.00 บาท', style: TextStyle(fontSize: 16)),
            ],
          ),
          SizedBox(height: 16),
          OrderButton(),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({super.key});

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  double _scale = 1.0;
  Color _color = Colors.green;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _scale = 0.9;
          _color = Colors.greenAccent;
        });
      },
      onTapUp: (_) {
        setState(() {
          _scale = 1.0;
          _color = Colors.green;
        });
      },
      onTapCancel: () {
        setState(() {
          _scale = 1.0;
          _color = Colors.green;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_scale),
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            minimumSize: const Size(150, 50),
            elevation: 0,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('ยืนยันการสั่งซื้อ'),
                  content: const Text('คุณต้องการสั่งซื้อสินค้านี้หรือไม่?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, AppRouter.main1);
                      },
                      child: const Text('ยกเลิก'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('สั่งซื้อสำเร็จ!')),
                        );
                      },
                      child: const Text('ยืนยัน'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('ถัดไป', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
