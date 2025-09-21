import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:us_stock_market/screen/bonds/bonds_screen.dart';
import 'package:us_stock_market/screen/stocks/stock_list_screen.dart';

class BondCategoriesScreen extends StatelessWidget {
  BondCategoriesScreen({super.key});

  final List<StockCategory> categories = [
    StockCategory(
      title: "Government Bonds",
      icon: Icons.account_balance,
      color: Color(0xFF0A84FF), // iOS Dark theme blue
      route: 'https://in.tradingview.com/markets/bonds/prices-usa/',
    ),
    StockCategory(
      title: "Corporate Bonds",
      icon: Icons.business,
      color: Color(0xFF30D158), // iOS Dark theme green
      route:
          'https://in.tradingview.com/markets/corporate-bonds/rates-highest-yield/',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF000000), // iOS Dark theme background
      appBar: AppBar(
        title: const Text(
          "Bond Categories",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16, // Reduced font size
            color: Color(0xFFFFFFFF), // iOS Dark theme text
          ),
        ),
        backgroundColor: const Color(0xFF1C1C1E), // iOS Dark theme app bar
        foregroundColor: const Color(0xFFFFFFFF), // iOS Dark theme foreground
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            height: 0.5,
            color: Color(0xFF2C2C2E), // iOS Dark theme border
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.all(isSmallScreen ? 8.0 : 12.0), // Reduced padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4), // Reduced spacing
              const Text(
                "Bond Market Categories",
                style: TextStyle(
                  fontSize: 18, // Reduced font size
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFFFFFF), // iOS Dark theme text
                ),
              ),
              const SizedBox(height: 4), // Reduced spacing
              const Text(
                "Explore different bond market segments and investment opportunities",
                style: TextStyle(
                  fontSize: 14, // Reduced font size
                  color: Color(0xFF8E8E93), // iOS Dark theme secondary text
                ),
              ),
              const SizedBox(height: 12), // Reduced spacing
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isLargeScreen ? 3 : 2,
                    crossAxisSpacing: isSmallScreen ? 8 : 12, // Reduced spacing
                    mainAxisSpacing: isSmallScreen ? 8 : 12, // Reduced spacing
                    childAspectRatio: isSmallScreen
                        ? 2.0
                        : 2.2, // Increased to reduce item height
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _buildCategoryCard(category);
                  },
                ),
              ),
              // Reduced spacing
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(StockCategory category) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.to(() => BondsScreen(url: category.route));
        },
        borderRadius:
            BorderRadius.circular(12), // Slightly reduced border radius
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF1C1C1E), // iOS Dark theme card background
            borderRadius:
                BorderRadius.circular(12), // Slightly reduced border radius
            border: Border.all(
              color: category.color.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12), // Reduced padding
            child: Row(
              children: [
                Container(
                  width: 36, // Reduced size
                  height: 36, // Reduced size
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size: 18, // Reduced icon size
                  ),
                ),
                const SizedBox(width: 8), // Reduced spacing
                Expanded(
                  child: Text(
                    category.title,
                    style: TextStyle(
                      fontSize: 14, // Reduced font size
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFFFFFF), // iOS Dark theme text
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

class StockCategory {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  StockCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
  });
}
