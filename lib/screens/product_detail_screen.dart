import 'dart:ui' as ui;
import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _bottomSheetController;
  late Animation<double> _bottomSheetAnimation;

  int _quantity = 1;
  final List<String> _backgroundImages = [
    'assets/images/watch1.png',
    'assets/images/watch2.png',
    'assets/images/watch3.png',
  ];
  int _currentImageIndex = 0;
  String _selectedSize = '40 mm';
  String _selectedColor = 'Blue';
  bool _isAvailable = true;
  bool _isFavorite = false;
  bool _isExpanded = false;
  final PageController _pageController = PageController();
  final DraggableScrollableController _dragController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _bottomSheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bottomSheetAnimation = CurvedAnimation(
      parent: _bottomSheetController,
      curve: Curves.easeInOut,
    );

    if (widget.product['img'] != null) {
      _currentImageIndex = _backgroundImages.indexOf(widget.product['img']);
      if (_currentImageIndex == -1) _currentImageIndex = 0;
    }
  }

  @override
  void dispose() {
    _bottomSheetController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _updateQuantity(int change) {
    setState(() {
      int newQuantity = _quantity + change;
      if (newQuantity > 0 && newQuantity <= 10) {
        _quantity = newQuantity;
      }
    });
  }

  void _addToCart() {
    if (_isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.shopping_bag, color: Colors.white),
              const SizedBox(width: 8),
              Text('Added to bag (${_quantity}x)'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _toggleWishlist() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _buyNow() {
    if (_isAvailable) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full Screen Image Gallery
          Container(
            height: screenHeight,
            width: double.infinity,
            child: PhotoViewGallery.builder(
              pageController: _pageController,
              itemCount: _backgroundImages.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: AssetImage(_backgroundImages[index]),
                  minScale: PhotoViewComputedScale.contained * 0.9,
                  maxScale: PhotoViewComputedScale.covered * 2.0,
                  heroAttributes: PhotoViewHeroAttributes(tag: 'product_image_$index'),
                );
              },
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
            ),
          ),

          // Top Navigation Bar
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        const Icon(Icons.close, color: Colors.white, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.share, color: Colors.white, size: 24),
                      const SizedBox(width: 20),
                      const Icon(Icons.more_horiz, color: Colors.white, size: 24),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Image Indicators
          Positioned(
            right: 20,
            top: screenHeight * 0.45,
            child: Column(
              children: List.generate(
                _backgroundImages.length,
                    (index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentImageIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),

          // Draggable Bottom Sheet
          DraggableScrollableSheet(
            controller: _dragController,
            initialChildSize: 0.35,
            minChildSize: 0.35,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Drag Handle
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 16),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Fixed Content (Always Visible)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name and Price
                          Text(
                            product['name'] ?? 'MOON 316L STAINLESS STEEL',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                product['price'] ?? '\$17,200',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '/ Price Incl. all Taxes',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Size Selection
                          Row(
                            children: [
                              _buildSizeChip('36 mm', false),
                              const SizedBox(width: 8),
                              _buildSizeChip('40 mm', true),
                              const SizedBox(width: 8),
                              _buildSizeChip('45 mm', false),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4A90E2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _addToCart,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4A90E2),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'ADD TO BAG',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade600),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: _isFavorite ? Colors.red : Colors.white,
                                  ),
                                  onPressed: _toggleWishlist,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade600),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                                  onPressed: _buyNow,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),

                            // Product Details Section
                            _buildSection(
                              'Product Details',
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDetailRow('Movement', 'Automatic'),
                                  _buildDetailRow('Case Material', '316L Stainless Steel'),
                                  _buildDetailRow('Case Diameter', '40mm'),
                                  _buildDetailRow('Water Resistance', '100m'),
                                  _buildDetailRow('Crystal', 'Sapphire'),
                                  _buildDetailRow('Strap Material', 'Leather'),
                                  _buildDetailRow('Warranty', '2 Years International'),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Description Section
                            _buildSection(
                              'Description',
                              const Text(
                                'A luxurious timepiece with premium craftsmanship. This watch features a stunning blue dial with intricate details, housed in a robust 316L stainless steel case. The automatic movement ensures precision and reliability, while the sapphire crystal provides excellent clarity and scratch resistance. Perfect for both formal and casual occasions.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Color Selection
                            _buildSection(
                              'Available Colors',
                              Row(
                                children: [
                                  _buildColorOption(Colors.blue, 'Blue', true),
                                  const SizedBox(width: 12),
                                  _buildColorOption(Colors.black, 'Black', false),
                                  const SizedBox(width: 12),
                                  _buildColorOption(Colors.grey, 'Silver', false),
                                  const SizedBox(width: 12),
                                  _buildColorOption(Colors.amber, 'Gold', false),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Quantity Selection
                            _buildSection(
                              'Quantity',
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade600),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove, color: Colors.white),
                                          onPressed: () => _updateQuantity(-1),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          child: Text(
                                            '$_quantity',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add, color: Colors.white),
                                          onPressed: () => _updateQuantity(1),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    'Available: 5 pieces',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Reviews Section
                            _buildSection(
                              'Reviews',
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        children: List.generate(5, (index) => Icon(
                                          index < 4 ? Icons.star : Icons.star_border,
                                          color: Colors.amber,
                                          size: 20,
                                        )),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        '4.8 out of 5',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Based on 124 reviews',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Shipping Info
                            _buildSection(
                              'Shipping & Returns',
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildShippingRow(Icons.local_shipping, 'Free shipping on orders over \$100'),
                                  _buildShippingRow(Icons.replay, '30-day return policy'),
                                  _buildShippingRow(Icons.security, 'Secure payment processing'),
                                  _buildShippingRow(Icons.support_agent, '24/7 customer support'),
                                ],
                              ),
                            ),

                            const SizedBox(height: 50),
                          ],
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
    );
  }

  Widget _buildSizeChip(String size, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF4A90E2) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? const Color(0xFF4A90E2) : Colors.grey.shade600,
        ),
      ),
      child: Text(
        size,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade300,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color, String name, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = name;
        });
      },
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                width: isSelected ? 3 : 1,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4A90E2), size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}