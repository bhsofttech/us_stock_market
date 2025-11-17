import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:us_stock_market/controller/db_controller.dart';
import 'package:us_stock_market/controller/google_ads_controller.dart';
import 'package:us_stock_market/controller/stock_controller.dart';
import 'package:us_stock_market/main.dart';
import 'package:us_stock_market/screen/side_menu/side_menu_screen.dart';
import 'package:us_stock_market/widget/snap_helper_widget.dart';
import 'package:us_stock_market/widget/svg_icon_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DashBordController dashBordController = Get.find();
  StockController stockController = Get.find();

  // Scroll controllers for each category
  final Map<String, ScrollController> _verticalBodyControllers = {
    'lcap': ScrollController(),
    'topG': ScrollController(),
    'topL': ScrollController(),
    'indices': ScrollController(),
    'etf': ScrollController(),
    'futures': ScrollController(),
    'bonds': ScrollController(),
  };
  final Map<String, ScrollController> _verticalColumnControllers = {
    'lcap': ScrollController(),
    'topG': ScrollController(),
    'topL': ScrollController(),
    'indices': ScrollController(),
    'etf': ScrollController(),
    'futures': ScrollController(),
    'bonds': ScrollController(),
  };
  final Map<String, ScrollController> _horizontalBodyControllers = {
    'lcap': ScrollController(),
    'topG': ScrollController(),
    'topL': ScrollController(),
    'indices': ScrollController(),
    'etf': ScrollController(),
    'futures': ScrollController(),
    'bonds': ScrollController(),
  };
  final Map<String, ScrollController> _horizontalHeaderControllers = {
    'lcap': ScrollController(),
    'topG': ScrollController(),
    'topL': ScrollController(),
    'indices': ScrollController(),
    'etf': ScrollController(),
    'futures': ScrollController(),
    'bonds': ScrollController(),
  };

  @override
  void initState() {
    super.initState();
    Get.find<GoogleAdsController>().showAds();

    // Fetch data for all categories
    dashBordController.loadLargeCapStocks(
        "https://in.tradingview.com/markets/stocks-usa/market-movers-large-cap/");
    dashBordController.loadTopGstocks(
        "https://in.tradingview.com/markets/stocks-usa/market-movers-gainers/");
    dashBordController.loadTopLstocks(
        "https://in.tradingview.com/markets/stocks-usa/market-movers-losers/");
    stockController
        .loadIndices("https://in.tradingview.com/markets/indices/quotes-us/");
    stockController
        .loadETF("https://in.tradingview.com/markets/etfs/funds-usa/");
    stockController
        .loadFutures("https://in.tradingview.com/markets/futures/quotes-all/");
    stockController
        .fetchBonds("https://in.tradingview.com/markets/bonds/prices-usa/");

    // Sync vertical and horizontal scrolling for each category
    _verticalBodyControllers.forEach((key, controller) {
      controller.addListener(() {
        if (_verticalColumnControllers[key]!.offset != controller.offset) {
          _verticalColumnControllers[key]!.jumpTo(controller.offset);
        }
      });
      _verticalColumnControllers[key]!.addListener(() {
        if (controller.offset != _verticalColumnControllers[key]!.offset) {
          controller.jumpTo(_verticalColumnControllers[key]!.offset);
        }
      });
      _horizontalBodyControllers[key]!.addListener(() {
        if (_horizontalHeaderControllers[key]!.offset !=
            _horizontalBodyControllers[key]!.offset) {
          _horizontalHeaderControllers[key]!
              .jumpTo(_horizontalBodyControllers[key]!.offset);
        }
      });
      _horizontalHeaderControllers[key]!.addListener(() {
        if (_horizontalBodyControllers[key]!.offset !=
            _horizontalHeaderControllers[key]!.offset) {
          _horizontalBodyControllers[key]!
              .jumpTo(_horizontalHeaderControllers[key]!.offset);
        }
      });
    });
  }

  @override
  void dispose() {
    _verticalBodyControllers.values
        .forEach((controller) => controller.dispose());
    _verticalColumnControllers.values
        .forEach((controller) => controller.dispose());
    _horizontalBodyControllers.values
        .forEach((controller) => controller.dispose());
    _horizontalHeaderControllers.values
        .forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const minWidth = 105.0;
    double colWidth = (screenWidth / 5).clamp(minWidth, 160);

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      drawer: const SideMenuScreen(),
      appBar: AppBar(
        title: const Text(
          "Market Overview",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Row(
              children: [
                Icon(
                  Icons.swipe_outlined,
                  size: 18,
                  color: Color(0xFFFFFFFF),
                ),
                SizedBox(width: 4),
                Text(
                  'Scroll',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF121212), Color(0xFF000000)],
            stops: [0.0, 0.8],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 24,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SnapHelperWidget(
                  future: dashBordController.dbLargeCapStocksFuture.value,
                  initialData: cachedbLargeCapStocksFuture,
                  loadingWidget: _buildLoading(),
                  onSuccess: (data) => _buildCategorySection(
                    context,
                    'Large Cap',
                    data,
                    colWidth,
                    'lcap',
                  ),
                ),
                const SizedBox(height: 24),
                SnapHelperWidget(
                  future: dashBordController.topGstocksFuture.value,
                  initialData: cachedbGStocksFuture,
                  loadingWidget: _buildLoading(),
                  onSuccess: (data) => _buildCategorySection(
                    context,
                    'Top Gainers',
                    data,
                    colWidth,
                    'topG',
                  ),
                ),
                const SizedBox(height: 24),
                SnapHelperWidget(
                  future: dashBordController.topLstocksFuture.value,
                  initialData: cachedbLossStocksFuture,
                  loadingWidget: _buildLoading(),
                  onSuccess: (data) => _buildCategorySection(
                    context,
                    'Biggest losers',
                    data,
                    colWidth,
                    'topL',
                  ),
                ),
                const SizedBox(height: 24),
                SnapHelperWidget(
                  future: stockController.indicesFuture.value,
                  initialData: cachedbIndicesFuture,
                  loadingWidget: _buildLoading(),
                  onSuccess: (data) => _buildCategorySection(
                    context,
                    'Indices',
                    data,
                    colWidth,
                    'indices',
                  ),
                ),
                const SizedBox(height: 24),
                SnapHelperWidget(
                  future: stockController.etfFuture.value,
                  initialData: cachedbETFFuture,
                  loadingWidget: _buildLoading(),
                  onSuccess: (data) => _buildCategorySection(
                    context,
                    'ETFs',
                    data,
                    colWidth,
                    'etf',
                  ),
                ),
                const SizedBox(height: 24),
                SnapHelperWidget(
                  future: stockController.futuresFuture.value,
                  initialData: cachedbfuturesFuture,
                  loadingWidget: _buildLoading(),
                  onSuccess: (data) => _buildCategorySection(
                    context,
                    'Futures',
                    data,
                    colWidth,
                    'futures',
                  ),
                ),
                const SizedBox(height: 24),
                // _buildCategorySection(
                //   context,
                //   'Government bonds',
                //   stockController.getBonds,
                //   colWidth,
                //   'bonds',
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildLoading() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      height: 220,
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, String title,
      List<dynamic> dataList, double colWidth, String categoryKey) {
    final items = dataList.take(6).toList();
    final firstItem = items.first;
    final remainingItems = items.skip(1).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Todo
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     Text(
      //       title,
      //       style: const TextStyle(
      //         fontFamily: 'Roboto',
      //         fontWeight: FontWeight.w500,
      //         fontSize: 16,
      //         color: Color(0xFFFFFFFF),
      //       ),
      //     ),
      //   ],
      // ),
      // const SizedBox(height: 8),
      Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: dataList.isEmpty
                  ? Container(
                      height: 150,
                      padding: const EdgeInsets.all(12),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.bar_chart_rounded,
                              size: 36,
                              color: Color(0xFF8E8E93),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "No $title found",
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                color: Color(0xFFFFFFFF),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Try refreshing or check your connection",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Color(0xFF8E8E93),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        // Fixed header row
                        Container(
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1C1C1E),
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFF2C2C2E),
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Fixed Symbol column for header
                              Container(
                                width: 200,
                                height: 40,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1C1C1E),
                                  border: Border(
                                    right: BorderSide(
                                        color: Color(0xFF2C2C2E), width: 1.0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        title.toUpperCase(),
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.filter_list_rounded,
                                      size: 14,
                                      color: Color(0xFF8E8E93),
                                    ),
                                  ],
                                ),
                              ),
                              // Scrollable data for header row
                              Expanded(
                                child: SingleChildScrollView(
                                  controller:
                                      _horizontalHeaderControllers[categoryKey],
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _buildHeaderCell(
                                        firstItem.price,
                                        colWidth,
                                      ),
                                      _buildHeaderCell(
                                        firstItem.changePercent,
                                        colWidth,
                                      ),
                                      _buildHeaderCell(
                                        firstItem.volume,
                                        colWidth,
                                      ),
                                      _buildHeaderCell(
                                        firstItem.relativeVolume,
                                        colWidth,
                                      ),
                                      _buildHeaderCell(
                                        firstItem.marketCap,
                                        colWidth,
                                      ),
                                      if (categoryKey != 'futures' ||
                                          categoryKey != 'bond') ...[
                                        _buildHeaderCell(
                                          firstItem.peRatio,
                                          colWidth,
                                        ),
                                        _buildHeaderCell(
                                          firstItem.epsDilTTM,
                                          colWidth,
                                        ),
                                        _buildHeaderCell(
                                          firstItem.epsDilGrowthYoY,
                                          colWidth,
                                        ),
                                        _buildHeaderCell(
                                          firstItem.dividendYield,
                                          colWidth,
                                        ),
                                        _buildHeaderCell(
                                          firstItem.sector,
                                          colWidth,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Scrollable body for remaining rows
                        SizedBox(
                          height: remainingItems.length * 44.0,
                          child: Row(
                            children: [
                              // Fixed Symbol column for remaining rows
                              SingleChildScrollView(
                                controller:
                                    _verticalColumnControllers[categoryKey],
                                child: Column(
                                  children: remainingItems
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final i = entry.key;
                                    final item = entry.value;
                                    return Container(
                                      width: 200,
                                      height: 44,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: i.isEven
                                            ? const Color(0xFF1C1C1E)
                                            : const Color(0xFF171717),
                                        border: Border(
                                          right: const BorderSide(
                                              color: Color(0xFF2C2C2E),
                                              width: 1.0),
                                          bottom: BorderSide(
                                            color:
                                                i == remainingItems.length - 1
                                                    ? Colors.transparent
                                                    : const Color(0xFF2C2C2E),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: CircleSvgAvatar(
                                              url: item.image,
                                              size: 28,
                                              stock: item.symbol,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  item.shortName,
                                                  style: const TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    color: Color(0xFFFFFFFF),
                                                    letterSpacing: -0.2,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                const SizedBox(height: 0),
                                                Text(
                                                  item.symbol,
                                                  style: const TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 9,
                                                    color: Color(0xFF8E8E93),
                                                    letterSpacing: -0.2,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              // Scrollable body for remaining rows
                              Expanded(
                                child: SingleChildScrollView(
                                  controller:
                                      _horizontalBodyControllers[categoryKey],
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                    controller:
                                        _verticalBodyControllers[categoryKey],
                                    child: Column(
                                      children: remainingItems
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        final i = entry.key;
                                        final item = entry.value;

                                        return Container(
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: i.isEven
                                                ? const Color(0xFF1C1C1E)
                                                : const Color(0xFF171717),
                                            border: Border(
                                              bottom: BorderSide(
                                                color: i ==
                                                        remainingItems.length -
                                                            1
                                                    ? Colors.transparent
                                                    : const Color(0xFF2C2C2E),
                                                width: 1.0,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              _buildDataCell(
                                                  item.price, colWidth, i),
                                              _buildChangeCell(
                                                  item.changePercent,
                                                  colWidth,
                                                  i),
                                              _buildDataCell(
                                                  item.volume, colWidth, i),
                                              _buildDataCell(
                                                  item.relativeVolume,
                                                  colWidth,
                                                  i),
                                              _buildDataCell(
                                                  item.marketCap, colWidth, i),
                                              if (categoryKey != 'futures') ...[
                                                _buildDataCell(
                                                    item.peRatio, colWidth, i),
                                                _buildDataCell(item.epsDilTTM,
                                                    colWidth, i),
                                                _buildDataCell(
                                                    item.epsDilGrowthYoY,
                                                    colWidth,
                                                    i),
                                                _buildDataCell(
                                                    item.dividendYield,
                                                    colWidth,
                                                    i),
                                                _buildDataCell(
                                                    item.sector, colWidth, i),
                                              ],
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )))
    ]);
  }
}

Widget _buildHeaderCell(
  String text,
  double width,
) {
  return Container(
    width: width,
    height: 40,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: const BoxDecoration(
      border: Border(
        right: BorderSide(color: Color(0xFF2C2C2E), width: 1.0),
      ),
    ),
    child: Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Color(0xFF8E8E93),
        letterSpacing: 0.3,
      ),
    ),
  );
}

Widget _buildDataCell(String text, double width, int rowIndex) {
  final isPositive = text.contains("+");
  final isNegative = text.contains("âˆ’") || text.contains("−");

  Color textColor = const Color(0xFFFFFFFF);
  if (isPositive) textColor = const Color(0xFF30D158);
  if (isNegative) textColor = const Color(0xFFFF453A);

  return Container(
    width: width,
    height: 44,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: const BoxDecoration(
      border: Border(
        right: BorderSide(color: Color(0xFF2C2C2E), width: 1.0),
      ),
    ),
    child: Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: -0.2,
      ),
    ),
  );
}

Widget _buildChangeCell(String value, double width, int rowIndex) {
  final isNegative = value.contains("âˆ’") || value.contains("−");
  final color = isNegative ? const Color(0xFFFF453A) : const Color(0xFF30D158);
  final icon =
      isNegative ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded;

  return Container(
    width: width,
    height: 44,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: const BoxDecoration(
      border: Border(
        right: BorderSide(color: Color(0xFF2C2C2E), width: 1.0),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: -0.2,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    ),
  );
}
