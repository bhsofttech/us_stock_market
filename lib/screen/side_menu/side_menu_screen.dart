import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:us_stock_market/screen/forex/forex_screen.dart';
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
      backgroundColor: Colors.black,
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF1C2526),
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
                color: Colors.black.withOpacity(0.9),
                border: const Border(
                  bottom: BorderSide(color: Colors.white12, width: 0.5),
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
                                      color: Colors.white.withOpacity(0.1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.15),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.trending_up,
                                      size: 24,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'US Markets',
                                    style: TextStyle(
                                      fontFamily: 'SanFranciscoPro',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                      shadows: [
                                        Shadow(
                                          color: Colors.white24,
                                          blurRadius: 8,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () => Get.back(),
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white70,
                                  size: 28,
                                ),
                                splashRadius: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Your Financial Hub',
                            style: TextStyle(
                              fontFamily: 'SanFranciscoPro',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.white70,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Menu Items
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
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.white70,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'SanFranciscoPro',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.white54,
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontFamily: 'SanFranciscoPro',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: Colors.white70),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
          child: Text('Privacy Policy Screen',
              style: TextStyle(color: Colors.white))),
    );
  }
}

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Terms and Conditions',
          style: TextStyle(
            fontFamily: 'SanFranciscoPro',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: Colors.white70),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
          child: Text('Terms and Conditions Screen',
              style: TextStyle(color: Colors.white))),
    );
  }
}
