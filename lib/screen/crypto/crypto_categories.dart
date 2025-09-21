import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:us_stock_market/screen/stocks/stock_list_screen.dart';

class CryptoCategoriesScreen extends StatelessWidget {
  CryptoCategoriesScreen({super.key});

  final List<StockCategory> categories = [
    StockCategory(
      title: "All Coins",
      icon: Icons.list_alt_rounded,
      color: Color(0xFF0A84FF), // iOS Dark theme blue
      route: 'https://in.tradingview.com/markets/cryptocurrencies/prices-all/',
    ),
    StockCategory(
      title: "Top Gainers",
      icon: Icons.trending_up_rounded,
      color: Color(0xFF30D158), // iOS Dark theme green
      route:
          'https://in.tradingview.com/markets/cryptocurrencies/prices-gainers/',
    ),
    StockCategory(
      title: "Biggest Losers",
      icon: Icons.trending_down_rounded,
      color: Color(0xFFFF453A), // iOS Dark theme red
      route:
          'https://in.tradingview.com/markets/cryptocurrencies/prices-losers/',
    ),
    StockCategory(
      title: "DeFi Coins",
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFF5E5CE6), // iOS Dark theme indigo
      route: 'https://in.tradingview.com/markets/cryptocurrencies/prices-defi/',
    ),
    StockCategory(
      title: "Large Cap",
      icon: Icons.diamond_rounded,
      color: Color(0xFFBF5AF2), // iOS Dark theme purple
      route:
          'https://in.tradingview.com/markets/cryptocurrencies/prices-large-cap/',
    ),
    StockCategory(
      title: "Small Cap",
      icon: Icons.emoji_objects_rounded,
      color: Color(0xFFFF9F0A), // iOS Dark theme orange
      route:
          'https://in.tradingview.com/markets/cryptocurrencies/prices-small-cap/',
    ),
    StockCategory(
      title: "52 Week High",
      icon: Icons.arrow_upward_rounded,
      color: Color(0xFF30D158), // iOS Dark theme green
      route:
          'https://in.tradingview.com/markets/cryptocurrencies/prices-52-week-high/',
    ),
    StockCategory(
      title: "52 Week Low",
      icon: Icons.arrow_downward_rounded,
      color: Color(0xFFFF453A), // iOS Dark theme red
      route:
          'https://in.tradingview.com/markets/cryptocurrencies/prices-52-week-low/',
    ),
    StockCategory(
      title: "All Time High",
      icon: Icons.rocket_launch_rounded,
      color: Color(0xFFFF2D55), // iOS Dark theme pink
      route:
          'https://in.tradingview.com/markets/cryptocurrencies/prices-all-time-high/',
    ),
    StockCategory(
      title: "All Time Low",
      icon: Icons.water_drop_rounded,
      color: Color(0xFF66D9E8), // iOS Dark theme teal
      route:
          'https://in.tradingview.com/markets/cryptocurrencies/prices-all-time-low/',
    ),
    StockCategory(
      title: "NFT Coins",
      icon: Icons.image_rounded,
      color: Color(0xFFAF52DE), // iOS Dark theme purple
      route: 'https://in.tradingview.com/markets/cryptocurrencies/prices-nft/',
    ),
    StockCategory(
      title: "Meme Coins",
      icon: Icons.emoji_emotions_rounded,
      color: Color(0xFFFF9500), // iOS Dark theme orange
      route: 'https://in.tradingview.com/markets/cryptocurrencies/prices-meme/',
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
          "Crypto Categories",
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
                "Crypto Market Categories",
                style: TextStyle(
                  fontSize: 18, // Reduced font size
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFFFFFF), // iOS Dark theme text
                ),
              ),
              const SizedBox(height: 4), // Reduced spacing
              const Text(
                "Explore different cryptocurrency segments and market trends",
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
          Get.to(() => StockListScreen(url: category.route));
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
