import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:us_stock_market/models/born_info.dart';
import 'package:us_stock_market/screen/forex/forex_screen.dart';
import 'package:us_stock_market/screen/gas/gas_price.dart';
import 'package:us_stock_market/screen/service/pages/born_page.dart';
import 'package:us_stock_market/screen/service/pages/country_list.dart';
import 'package:us_stock_market/screen/service/pages/desial_price.dart';
import 'package:us_stock_market/screen/service/pages/ev_price.dart';
import 'package:us_stock_market/screen/service/pages/weather_screen.dart';
import 'package:us_stock_market/screen/side_menu/economy_screen.dart';

class SideMenuScreen extends StatefulWidget {
  const SideMenuScreen({super.key});

  @override
  State<SideMenuScreen> createState() => _SideMenuScreenState();
}

class _SideMenuScreenState extends State<SideMenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller with longer duration for smoother effect
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Opacity animation: from 0.0 to 1.0 with softer curve
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Slide animation: slight slide-in effect from the left
    _slideAnimation = Tween<double>(begin: -20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Function to handle Share App action
  void _shareApp() {
    Share.share(
      'https://play.google.com/store/apps/details?id=com.bhinfotech.usstockmarket&hl=en',
      subject: 'Invite Friends to IPO Market',
    );
  }

  // Function to handle Rate Us action
  // Launch URL for Terms & Conditions and Privacy Policy
  Future<void> _launchUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF000000),
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF1C1C1E),
              Color(0xFF0A0E0F),
              Color(0xFF000000),
            ],
            stops: [0.0, 0.7, 1.0],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                border: const Border(
                  bottom: BorderSide(color: Color(0xFF2C2C2E), width: 0.5),
                ),
              ),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_slideAnimation.value, 0),
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFF0A84FF)
                                          .withOpacity(0.2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF0A84FF)
                                              .withOpacity(0.3),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.trending_up,
                                      size: 24,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'US Stock Market',
                                        style: TextStyle(
                                          fontFamily: 'SF Pro Display',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: Color(0xFFFFFFFF),
                                        ),
                                      ),
                                      Text(
                                        'Real-time Insights',
                                        style: TextStyle(
                                          fontFamily: 'SF Pro Text',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Color(0xFF8E8E93),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Color(0xFFFFFFFF),
                                  size: 24,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildMenuItem(
              icon: Icons.sunny,
              title: 'Weather',
              onTap: () => Get.to(() => const WeatherScreen()),
            ),
            _buildMenuItem(
              icon: Icons.gas_meter,
              title: 'Gas Price',
              onTap: () => Get.to(() => const GasPrice()),
            ),
            _buildMenuItem(
              icon: Icons.ev_station,
              title: 'EV Charging',
              onTap: () => Get.to(() => const EvPrice()),
            ),
            _buildMenuItem(
              icon: Icons.local_gas_station,
              title: 'Diesel Price',
              onTap: () => Get.to(() => const DesialPrice()),
            ),
            _buildMenuItem(
              icon: Icons.cake,
              title: 'Born Today',
              onTap: () => Get.to(() => const BornPage()),
            ),
            _buildMenuItem(
              icon: Icons.electric_meter,
              title: "Holi Day",
              onTap: () => Get.to(() => const CountryPage()),
            ),
            _buildMenuItem(
              icon: Icons.currency_exchange_rounded,
              title: 'Forex Market',
              onTap: () => Get.to(() => const ForexScreen()),
            ),
            _buildMenuItem(
              icon: Icons.chat_rounded,
              title: 'GDP',
              onTap: () => Get.to(() => const EconomyScreen(
                    type: "GDP",
                  )),
            ),
            // _buildMenuItem(
            //   icon: Icons.account_balance_wallet_rounded,
            //   title: 'Dividends',
            //   onTap: () => Get.toNamed('/dividends'),
            // ),
            _buildMenuItem(
                icon: Icons.privacy_tip_rounded,
                title: 'Privacy Policy',
                onTap: () async {
                  _launchUrl(
                    context,
                    "https://sites.google.com/d/1Hz3OWR0AzF8bd4sRRC0Z6Nj7Gs_KTfe6/p/1cLr_e0Dl9vpZbRDPy5LQI21rozbnB34h/edit",
                  );
                }),
            _buildMenuItem(
                icon: Icons.description_rounded,
                title: 'Terms and Conditions',
                onTap: () async {
                  _launchUrl(
                    context,
                    "https://sites.google.com/d/1Hz3OWR0AzF8bd4sRRC0Z6Nj7Gs_KTfe6/p/1cLr_e0Dl9vpZbRDPy5LQI21rozbnB34h/edit",
                  );
                }),
            _buildMenuItem(
              icon: Icons.share_rounded,
              title: 'Share App',
              onTap: _shareApp,
            ),
            _buildMenuItem(
                icon: Icons.star_rate_rounded,
                title: 'Rate Us',
                onTap: () async {
                  _launchUrl(
                    context,
                    "https://play.google.com/store/apps/details?id=com.bhinfotech.usstockmarket&hl=en",
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF2C2C2E).withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: const Color(0xFFFFFFFF),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFFFFFFFF),
                  letterSpacing: -0.3,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFF8E8E93),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder screen classes
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: Color(0xFFFFFFFF)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
          child: Text('Privacy Policy Screen',
              style: TextStyle(color: Color(0xFFFFFFFF)))),
    );
  }
}

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        title: const Text(
          'Terms and Conditions',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: Color(0xFFFFFFFF)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
          child: Text('Terms and Conditions Screen',
              style: TextStyle(color: Color(0xFFFFFFFF)))),
    );
  }
}
