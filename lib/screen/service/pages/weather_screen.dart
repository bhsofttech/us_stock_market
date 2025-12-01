import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:us_stock_market/controller/google_ads_controller.dart';
import 'package:us_stock_market/controller/weather_controller.dart';
import 'package:us_stock_market/models/weather_indo.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  final WeatherController _weatherController = Get.find();
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<WeatherInfo> _filteredWeatherList = [];

  // iOS Dark theme color palette
  final Color primaryBlue = const Color(0xFF0A84FF);
  final Color darkBlue = const Color(0xFF0A4B9A);
  final Color lightBlue = const Color(0xFF5AC8FA);
  final Color backgroundGray = const Color(0xFF000000);
  final Color cardWhite = const Color(0xFF1C1C1E);
  final Color textPrimary = const Color(0xFFFFFFFF);
  final Color textSecondary = const Color(0xFF8E8E93);
  final Color separatorGray = const Color(0xFF2C2C2E);
  final Color successGreen = const Color(0xFF30D158);
  final Color warningOrange = const Color(0xFFFF9500);
  final Color errorRed = const Color(0xFFFF453A);
  final Color purpleAccent = const Color(0xFFAF52DE);

  @override
  void initState() {
    super.initState();
    Get.find<GoogleAdsController>().showAds();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
      _slideController.forward();
      _fadeController.forward();
    });

    // Initialize filtered list with current data
    _filteredWeatherList = _weatherController.getWeather;
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> init() async {
    await _weatherController.fetchWeather();
  }

  String _formatTimeTo12Hour(String time) {
    try {
      // Handle different time formats
      String timeString = time;

      // If time is in 24-hour format like "14:30" or "14:30:00"
      if (time.contains(':')) {
        List<String> parts = time.split(':');
        if (parts.isNotEmpty) {
          int hour = int.tryParse(parts[0]) ?? 0;
          String minute = parts.length > 1 ? parts[1] : '00';

          // Handle minute part if it has seconds
          if (minute.contains(' ')) {
            minute = minute.split(' ')[0];
          }

          minute = minute.padLeft(2, '0');
          final period = hour >= 12 ? 'PM' : 'AM';
          final twelveHour = hour % 12;
          final displayHour = twelveHour == 0 ? 12 : twelveHour;

          return '$displayHour:$minute $period';
        }
      }

      return time; // Return original if parsing fails
    } catch (e) {
      return time;
    }
  }

  List<WeatherInfo> _filterWeatherList(
      List<WeatherInfo> weatherList, String query) {
    if (query.isEmpty) {
      return weatherList;
    }

    return weatherList.where((weather) {
      return weather.city.toLowerCase().contains(query.toLowerCase()) ||
          (weather.country.toLowerCase().contains(query.toLowerCase())) ||
          weather.temp.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredWeatherList =
          _filterWeatherList(_weatherController.getWeather, query);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _filteredWeatherList = _weatherController.getWeather;
    });
  }

  void _navigateToDetailPage(WeatherInfo weatherInfo) {
    // Navigate to weather detail page
    Get.toNamed('/weather-detail', arguments: weatherInfo);
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: cardWhite,
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.1),
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      centerTitle: true,
      title: Text(
        "World Weather".toUpperCase(),
        style: TextStyle(
          color: textPrimary,
          fontFamily: "SF Pro Display",
          fontSize: 16.0, // Reduced font size
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: cardWhite,
          border: Border(
            bottom: BorderSide(
              color: separatorGray,
              width: 0.33,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGray,
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              SizedBox(
                height: 4,
              ),
              // Search Bar
              _buildSearchBar(),
              const SizedBox(height: 8),
              // Section Header
              _buildSectionHeader(),
              const SizedBox(height: 6),

              // Use Obx to reactively update when weather data changes
              Expanded(
                child: Obx(() {
                  // Update filtered list when weather data changes
                  if (_searchController.text.isEmpty) {
                    _filteredWeatherList = _weatherController.getWeather;
                  }
                  return _weatherController.showLoading.value
                      ? _buildLoadingIndicator()
                      : _buildWeatherGrid();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: cardWhite,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search cities...',
                hintStyle: TextStyle(
                  color: textSecondary,
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: textSecondary,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: textSecondary,
                        ),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                filled: true,
                fillColor: cardWhite,
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'Weather Forecast',
            style: TextStyle(
              color: textPrimary,
              fontFamily: "SF Pro Display",
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          Text(
            '${_filteredWeatherList.length} cities',
            style: TextStyle(
              color: textSecondary,
              fontFamily: "SF Pro Text",
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherGrid() {
    if (_filteredWeatherList.isEmpty) {
      return _buildNoResults();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: _filteredWeatherList.length,
      itemBuilder: (context, index) {
        final info = _filteredWeatherList[index];
        return _buildWeatherCard(info);
      },
    );
  }

  Widget _buildWeatherCard(WeatherInfo info) {
    final gradient = [
      primaryBlue,
      lightBlue,
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.transparent,
              Colors.black.withOpacity(0.1),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // City and Weather Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: gradient[0].withOpacity(0.5),
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              info.city,
                              style: const TextStyle(
                                fontFamily: 'SF-Pro-Display',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.3,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 3,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTimeTo12Hour(info.time),
                        style: TextStyle(
                          fontFamily: 'SF-Pro-Display',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 0.2,
                          shadows: const [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: SvgPicture.network(
                    "https:${info.image}",
                    height: 30,
                    width: 30,
                  ),
                ),
              ],
            ),

            // Temperature and Weather Info
            Text(
              info.temp,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'SF-Pro-Display',
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                shadows: [
                  Shadow(
                    offset: Offset(0, 2),
                    blurRadius: 4,
                    color: Colors.black38,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          const Text(
            'No cities found',
            style: TextStyle(
              fontFamily: 'SF-Pro-Display',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(
              fontFamily: 'SF-Pro-Display',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: Colors.white,
          ),
          const SizedBox(height: 12), // Reduced spacing
          Text(
            "Loading...",
            style: TextStyle(
              color: textSecondary,
              fontSize: 14, // Reduced font size
              fontWeight: FontWeight.w600,
              fontFamily: "SF Pro Text",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(0),
        _buildDot(1),
        _buildDot(2),
      ],
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
    );
  }
}
