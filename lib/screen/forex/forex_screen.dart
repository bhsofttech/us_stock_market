import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:us_stock_market/controller/stock_controller.dart';
import 'package:us_stock_market/main.dart';
import 'package:us_stock_market/widget/snap_helper_widget.dart';
import 'package:us_stock_market/widget/svg_icon_widget.dart';

class ForexScreen extends StatefulWidget {
  const ForexScreen({
    super.key,
  });

  @override
  State<ForexScreen> createState() => _ForexScreenState();
}

class _ForexScreenState extends State<ForexScreen> {
  StockController stockController = Get.find();

  final ScrollController _verticalBodyController = ScrollController();
  final ScrollController _verticalColumnController = ScrollController();
  final ScrollController _horizontalBodyController = ScrollController();
  final ScrollController _horizontalHeaderController = ScrollController();

  @override
  void initState() {
    super.initState();
    stockController.loadForex(
        "https://in.tradingview.com/markets/currencies/rates-americas/");

    // sync vertical
    _verticalBodyController.addListener(() {
      if (_verticalColumnController.offset != _verticalBodyController.offset) {
        _verticalColumnController.jumpTo(_verticalBodyController.offset);
      }
    });
    _verticalColumnController.addListener(() {
      if (_verticalBodyController.offset != _verticalColumnController.offset) {
        _verticalBodyController.jumpTo(_verticalColumnController.offset);
      }
    });

    // sync horizontal
    _horizontalBodyController.addListener(() {
      if (_horizontalHeaderController.offset !=
          _horizontalBodyController.offset) {
        _horizontalHeaderController.jumpTo(_horizontalBodyController.offset);
      }
    });
    _horizontalHeaderController.addListener(() {
      if (_horizontalBodyController.offset !=
          _horizontalHeaderController.offset) {
        _horizontalBodyController.jumpTo(_horizontalHeaderController.offset);
      }
    });
  }

  @override
  void dispose() {
    _verticalBodyController.dispose();
    _verticalColumnController.dispose();
    _horizontalBodyController.dispose();
    _horizontalHeaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    const minWidth = 120.0;
    double colWidth = (screenWidth / 5).clamp(minWidth, 160);

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        title: const Text(
          "US Forex Market",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16, // Reduced font size
            color: Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: Row(
              children: [
                Icon(
                  Icons.swipe_outlined,
                  size: 16,
                  color: Color(0xFFFFFFFF),
                ),
                SizedBox(width: 4),
                Text(
                  'Scroll',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SnapHelperWidget(
          future: stockController.forexFuture.value,
          initialData: cachedbForexFuture,
          loadingWidget: const SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 2.0, // Slightly reduced stroke width
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF0A84FF)),
                  ),
                  SizedBox(height: 12), // Reduced spacing
                  Text(
                    "Loading forex data...", // Updated text to reflect ETF
                    style: TextStyle(
                      color: Color(0xFF8E8E93),
                      fontSize: 13, // Reduced font size
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          onSuccess: (data) {
            // Get the first ETF for the fixed row
            final firstIndex = data.first;
            // Get the remaining ETFs for the scrollable area
            final remainingIndices = data.skip(1).toList();
            return Container(
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
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(12), // Slightly reduced border radius
                child: data.isEmpty
                    ? const SizedBox(
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bar_chart_rounded,
                                size: 36, // Reduced icon size
                                color: Color(0xFF8E8E93),
                              ),
                              SizedBox(height: 8), // Reduced spacing
                              Text(
                                "No ETFs found", // Updated text to reflect ETF
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16, // Reduced font size
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4), // Reduced spacing
                              Text(
                                "Try refreshing or check your connection",
                                style: TextStyle(
                                  color: Color(0xFF8E8E93),
                                  fontSize: 13, // Reduced font size
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
                            height: 40, // Reduced from 44
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
                                  height: 40, // Reduced from 44
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12), // Reduced padding
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF1C1C1E),
                                    border: Border(
                                      right: BorderSide(
                                          color: Color(0xFF2C2C2E), width: 1.0),
                                    ),
                                  ),
                                  child: const Row(
                                    children: [
                                      SizedBox(width: 6), // Reduced spacing
                                      Expanded(
                                        child: Text(
                                          "ETF", // Updated to reflect ETF
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12, // Reduced font size
                                            color: Color(0xFF8E8E93),
                                            letterSpacing: 0.5,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Icon(
                                        Icons.filter_list_rounded,
                                        size: 14, // Reduced icon size
                                        color: Color(0xFF8E8E93),
                                      ),
                                    ],
                                  ),
                                ),
                                // Scrollable data for header row
                                Expanded(
                                  child: SingleChildScrollView(
                                    controller: _horizontalHeaderController,
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        _buildHeaderCell(
                                            firstIndex.price, colWidth),
                                        _buildHeaderCell(
                                            firstIndex.changePercent, colWidth),
                                        _buildHeaderCell(
                                            firstIndex.volume, colWidth),
                                        _buildHeaderCell(
                                            firstIndex.relativeVolume,
                                            colWidth),
                                        _buildHeaderCell(
                                            firstIndex.marketCap, colWidth),
                                        _buildHeaderCell(
                                            firstIndex.peRatio, colWidth),
                                        _buildHeaderCell(
                                            firstIndex.epsDilTTM, colWidth),
                                        // _buildHeaderCell(
                                        //     firstIndex.epsDilGrowthYoY,
                                        //     colWidth),
                                        // _buildHeaderCell(
                                        //     firstIndex.dividendYield, colWidth),
                                        // _buildHeaderCell(
                                        //     firstIndex.sector, colWidth),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Scrollable body for remaining rows
                          Expanded(
                            child: Row(
                              children: [
                                // Fixed Symbol column for remaining rows
                                SingleChildScrollView(
                                  controller: _verticalColumnController,
                                  child: Column(
                                    children: remainingIndices
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      final i = entry.key;
                                      final index = entry.value;
                                      return Container(
                                        width: 200,
                                        height: 44, // Reduced from 48
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6), // Reduced padding
                                        decoration: BoxDecoration(
                                          color: i.isEven
                                              ? const Color(0xFF1C1C1E)
                                              : const Color(0xFF171717),
                                          border: Border(
                                            right: const BorderSide(
                                                color: Color(0xFF2C2C2E),
                                                width: 1.0),
                                            bottom: BorderSide(
                                              color: i ==
                                                      remainingIndices.length -
                                                          1
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
                                            index.image.isEmpty
                                                ? Container(
                                                    height: 32,
                                                    width: 32,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                    ),
                                                    child: const Center(
                                                      child: Text("S"),
                                                    ),
                                                  )
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.3),
                                                          blurRadius: 4,
                                                          offset: const Offset(
                                                              0, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: CircleSvgAvatar(
                                                      url: index.image,
                                                      size:
                                                          28, // Reduced avatar size
                                                      stock: index.symbol,
                                                    ),
                                                  ),
                                            const SizedBox(
                                                width: 4), // Reduced spacing
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    index.shortName,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize:
                                                          12, // Reduced font size
                                                      color: Color(0xFFFFFFFF),
                                                      letterSpacing: -0.2,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  const SizedBox(height: 0),
                                                  Text(
                                                    index.symbol,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          9, // Reduced font size
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
                                    controller: _horizontalBodyController,
                                    scrollDirection: Axis.horizontal,
                                    child: SingleChildScrollView(
                                      controller: _verticalBodyController,
                                      child: Column(
                                        children: remainingIndices
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          final i = entry.key;
                                          final index = entry.value;

                                          return Container(
                                            height: 44, // Reduced from 48
                                            decoration: BoxDecoration(
                                              color: i.isEven
                                                  ? const Color(0xFF1C1C1E)
                                                  : const Color(0xFF171717),
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: i ==
                                                          remainingIndices
                                                                  .length -
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
                                                    index.price, colWidth, i),
                                                _buildChangeCell(
                                                    index.changePercent,
                                                    colWidth,
                                                    i),
                                                _buildDataCell(
                                                    index.volume, colWidth, i),
                                                _buildDataCell(
                                                    index.relativeVolume,
                                                    colWidth,
                                                    i),
                                                _buildDataCell(index.marketCap,
                                                    colWidth, i),
                                                _buildDataCell(
                                                    index.peRatio, colWidth, i),
                                                _buildDataCell(index.epsDilTTM,
                                                    colWidth, i),
                                                // _buildDataCell(
                                                //     index.epsDilGrowthYoY,
                                                //     colWidth,
                                                //     i),
                                                // _buildDataCell(
                                                //     index.dividendYield,
                                                //     colWidth,
                                                //     i),
                                                // _buildDataCell(
                                                //     index.sector, colWidth, i),
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
                      ),
              ),
            );
          }),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      height: 40, // Reduced from 44
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10), // Reduced padding
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
          fontSize: 11, // Reduced font size
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
      height: 44, // Reduced from 48
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10), // Reduced padding
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
          fontSize: 12, // Reduced font size
          fontWeight: FontWeight.w500,
          color: textColor,
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  Widget _buildChangeCell(String value, double width, int rowIndex) {
    final isNegative = value.contains("âˆ’") || value.contains("−");
    final color =
        isNegative ? const Color(0xFFFF453A) : const Color(0xFF30D158);
    final icon =
        isNegative ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded;

    return Container(
      width: width,
      height: 44, // Reduced from 48
      padding: const EdgeInsets.symmetric(horizontal: 10), // Reduced padding
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
            size: 12, // Reduced icon size
            color: color,
          ),
          const SizedBox(width: 4), // Reduced spacing
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12, // Reduced font size
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
}
