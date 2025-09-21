import 'package:flutter/material.dart';
import 'package:us_stock_market/screen/other/home_screen.dart';
import 'package:us_stock_market/screen/bonds/bond_categories_screen.dart';
import 'package:us_stock_market/screen/crypto/crypto_categories.dart';
import 'package:us_stock_market/screen/etf/etf_screen.dart';
import 'package:us_stock_market/screen/futures/futures_screen.dart';
import 'package:us_stock_market/screen/indices/indices_screen.dart';
import 'package:us_stock_market/screen/stocks/stock_categories.dart';
import 'package:us_stock_market/screen/side_menu/side_menu_screen.dart';

class HomeSetUpScreen extends StatefulWidget {
  const HomeSetUpScreen({super.key});

  @override
  State<HomeSetUpScreen> createState() => _HomeSetUpScreenState();
}

class _HomeSetUpScreenState extends State<HomeSetUpScreen> {
  int _selectedIndex = 0;

  // List of screens for navigation
  final List<Widget> _screens = [
    const HomeScreen(),
    StockCategoriesScreen(),
    CryptoCategoriesScreen(),
    const IndicesScreen(),
    const EtfScreen(),
    const FuturesScreen(),
    BondCategoriesScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 380;

    return Scaffold(
      backgroundColor: const Color(0xFF000000), // iOS Dark theme background
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFF2C2C2E),
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: isSmallScreen ? 20 : 22, // Reduced icon size
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.show_chart_rounded,
                size: isSmallScreen ? 20 : 22, // Reduced icon size
              ),
              label: 'Stocks',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.currency_bitcoin_rounded,
                size: isSmallScreen ? 20 : 22, // Reduced icon size
              ),
              label: 'Crypto',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.trending_up_rounded,
                size: isSmallScreen ? 20 : 22, // Reduced icon size
              ),
              label: 'Indices',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.pie_chart_rounded,
                size: isSmallScreen ? 20 : 22, // Reduced icon size
              ),
              label: 'ETF',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bar_chart_rounded,
                size: isSmallScreen ? 20 : 22, // Reduced icon size
              ),
              label: 'Futures',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_balance_rounded,
                size: isSmallScreen ? 20 : 22, // Reduced icon size
              ),
              label: 'Bonds',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF0A84FF), // iOS Dark theme blue
          unselectedItemColor:
              const Color(0xFF8E8E93), // iOS Dark theme secondary text
          backgroundColor:
              const Color(0xFF1C1C1E), // iOS Dark theme nav bar background
          type: BottomNavigationBarType.fixed,
          selectedFontSize: isSmallScreen ? 10 : 11, // Reduced font size
          unselectedFontSize: isSmallScreen ? 10 : 11, // Reduced font size
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            height: 1.2, // Reduced line height for tighter spacing
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            height: 1.2, // Reduced line height for tighter spacing
          ),
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
