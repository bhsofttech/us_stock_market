import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:us_stock_market/screen/stocks/stock_list_screen.dart';

class StockCategoriesScreen extends StatelessWidget {
  StockCategoriesScreen({super.key});

  final List<StockCategory> categories = [
    StockCategory(
      title: "All stocks",
      icon: Icons.list_alt,
      color: const Color(0xFF0A84FF), // iOS Dark theme blue
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-all-stocks/',
    ),
    StockCategory(
      title: "Top gainers",
      icon: Icons.trending_up,
      color:const Color(0xFF30D158), // iOS Dark theme green
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-gainers/',
    ),
    StockCategory(
      title: "Biggest losers",
      icon: Icons.trending_down,
      color:const Color(0xFFFF453A), // iOS Dark theme red
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-losers/',
    ),
    StockCategory(
      title: "All Time High",
      icon: Icons.nightlight_round,
      color:const Color(0xFFAF52DE), // iOS Dark theme purple
      route: 'https://in.tradingview.com/markets/stocks-usa/market-movers-ath/',
    ),
    StockCategory(
      title: "All Time Low",
      icon: Icons.bedtime,
      color:const Color(0xFF5E5CE6), // iOS Dark theme indigo
      route: 'https://in.tradingview.com/markets/stocks-usa/market-movers-atl/',
    ),
    StockCategory(
      title: "52 Week High",
      icon: Icons.bedtime,
      color:const Color(0xFFFF2D55), // iOS Dark theme pink
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-52wk-high/',
    ),
    StockCategory(
      title: "52 Week Low",
      icon: Icons.emoji_events,
      color:const Color(0xFFFF9F0A), // iOS Dark theme amber
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-52wk-low/',
    ),
    StockCategory(
      title: "Large-cap",
      icon: Icons.business,
      color:const Color(0xFFBF5AF2), // iOS Dark theme purple
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-large-cap/',
    ),
    StockCategory(
      title: "Small-cap",
      icon: Icons.business_center,
      color:const Color(0xFFFF9500), // iOS Dark theme orange
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-small-cap/',
    ),
    StockCategory(
      title: "Largest-Employers",
      icon: Icons.attach_money,
      color:const Color(0xFF00C4B4), // iOS Dark theme teal
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-largest-employers/',
    ),
    StockCategory(
      title: "High Dividend",
      icon: Icons.bar_chart,
      color:const Color(0xFF5856D6), // iOS Dark theme indigo
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-high-dividend/',
    ),
    StockCategory(
      title: "Highest Net Income",
      icon: Icons.show_chart,
      color:const Color(0xFFFF375F), // iOS Dark theme pink
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-highest-net-income/',
    ),
    StockCategory(
      title: "Highest Cash",
      icon: Icons.arrow_upward,
      color:const Color(0xFF30D158), // iOS Dark theme green
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-highest-cash/',
    ),
    StockCategory(
      title: "Highest Profit Per Employee",
      icon: Icons.arrow_downward,
      color:const Color(0xFFFF453A), // iOS Dark theme red
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-highest-profit-per-employee/',
    ),
    StockCategory(
      title: "highest Revenue Per Employee",
      icon: Icons.star,
      color:const Color(0xFFFF9F0A), // iOS Dark theme amber
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-highest-revenue-per-employee/',
    ),
    StockCategory(
      title: "Most Active",
      icon: Icons.warning,
      color:const Color(0xFFFF3B30), // iOS Dark theme deep orange
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-active/',
    ),
    StockCategory(
      title: "Pre Market Gainers",
      icon: Icons.volume_up,
      color:const Color(0xFF8E8E93), // iOS Dark theme grey
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-pre-market-gainers/',
    ),
    StockCategory(
      title: "Pre Market Losers",
      icon: Icons.money_off,
      color:const Color(0xFF8B6F47), // iOS Dark theme brown
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-pre-market-losers/',
    ),
    StockCategory(
      title: "Highest Revenue",
      icon: Icons.account_balance,
      color:const Color(0xFF32D74B), // iOS Dark theme light green
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-highest-revenue/',
    ),
    StockCategory(
      title: "Most Expensive",
      icon: Icons.account_balance_wallet,
      color:const Color(0xFFD0FD3E), // iOS Dark theme lime
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-most-expensive/',
    ),
    StockCategory(
      title: "Penny Stocks",
      icon: Icons.emoji_people,
      color:const Color(0xFF66D9E8), // iOS Dark theme teal accent
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-penny-stocks/ ',
    ),
    StockCategory(
      title: "Overbought",
      icon: Icons.work,
      color:const Color(0xFF0A84FF), // iOS Dark theme blue accent
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-overbought/',
    ),
    StockCategory(
      title: "Oversold",
      icon: Icons.nightlight_round,
      color:const Color(0xFF8A4AF3), // iOS Dark theme deep purple
      route:
          'https://in.tradingview.com/markets/stocks-usa/market-movers-oversold/',
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
          "Stock Categories",
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
            color:const Color(0xFF2C2C2E), // iOS Dark theme border
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
                "Browse by Category",
                style: TextStyle(
                  fontSize: 18, // Reduced font size
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFFFFFF), // iOS Dark theme text
                ),
              ),
              const SizedBox(height: 4), // Reduced spacing
              const Text(
                "Explore different stock market segments and filters",
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
            color:const Color(0xFF1C1C1E), // iOS Dark theme card background
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
                    style:const TextStyle(
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
