import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:ecommerce_app/screens/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _selectedIndex = 2;
  final List<Map<String, dynamic>> _cartItems = [
    {'img': 'assets/images/watch1.png', 'name': 'Moon 316L Stainless Steel', 'price': 17200.0, 'quantity': 1},
    {'img': 'assets/images/watch2.png', 'name': 'Astronome Twin Tour', 'price': 378.0, 'quantity': 1},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      int newQuantity = _cartItems[index]['quantity'] + change;
      if (newQuantity > 0) _cartItems[index]['quantity'] = newQuantity;
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
      _controller.forward(from: 0);
    });
  }

  double _calculateTotal() {
    return _cartItems.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  void _proceedToCheckout() {
    if (_cartItems.isNotEmpty) {
      final totalAmount = _calculateTotal();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CheckoutScreen(
            cartItems: _cartItems,
            totalAmount: totalAmount, // Passing the required totalAmount
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFF7DA7FF);

    return Scaffold(
      backgroundColor: Colors.black,
      body: _cartItems.isEmpty
          ? _buildEmptyCart(accent)
          : CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 120,
            collapsedHeight: 60,
            backgroundColor: Colors.transparent,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [accent.withOpacity(0.45), Colors.black87], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white), onPressed: () => Navigator.pop(context)),
                          const Text('My Cart', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.white), onPressed: () => setState(() => _cartItems.clear())),
                        ],
                      ),
                      Text('${_cartItems.length} ${_cartItems.length == 1 ? 'Item' : 'Items'}', style: TextStyle(fontSize: 16, color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildCartItem(index, accent),
              childCount: _cartItems.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTotalSection(accent),
                  const SizedBox(height: 20),
                  _buildCheckoutButton(accent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(Color accent) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart, color: accent, size: 80),
          const SizedBox(height: 20),
          const Text('Your Cart is Empty', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          const Text('Start shopping to add items to your cart!', style: TextStyle(fontSize: 16, color: Colors.white70)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/categories'),
            style: ElevatedButton.styleFrom(backgroundColor: accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12)),
            child: const Text('Shop Now', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(int index, Color accent) {
    final item = _cartItems[index];
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, _animation.value * -10),
        child: Opacity(
          opacity: _animation.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.black87, Colors.grey[900]!], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                      child: Image.asset(item['img'], height: 100, width: 100, fit: BoxFit.cover),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(height: 5),
                            Text('\$${item['price'].toStringAsFixed(2)}', style: TextStyle(fontSize: 14, color: accent, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(icon: const Icon(Icons.remove, color: Colors.white70), onPressed: () => _updateQuantity(index, -1)),
                                    Text('${item['quantity']}', style: const TextStyle(fontSize: 16, color: Colors.white)),
                                    IconButton(icon: const Icon(Icons.add, color: Colors.lightBlueAccent), onPressed: () => _updateQuantity(index, 1)),
                                  ],
                                ),
                                IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () => _removeItem(index)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalSection(Color accent) {
    final total = _calculateTotal();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.black87, Colors.grey[900]!], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          Text('\$${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accent)),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(Color accent) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _proceedToCheckout,
        style: ElevatedButton.styleFrom(backgroundColor: accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), padding: const EdgeInsets.symmetric(vertical: 15), elevation: 5),
        child: const Text('Proceed to Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}