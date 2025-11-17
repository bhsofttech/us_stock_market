import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:us_stock_market/controller/db_controller.dart';
import 'package:us_stock_market/controller/google_ads_controller.dart';
import 'package:us_stock_market/controller/stock_controller.dart';
import 'package:us_stock_market/models/stock_data.dart';
import 'package:us_stock_market/screen/gas/gas_controller.dart';
import 'package:us_stock_market/screen/other/splash_screen.dart';

List<StockData>? cachedbLargeCapStocksFuture;
List<StockData>? cachedbLossStocksFuture;
List<StockData>? cachedbGStocksFuture;
List<StockData>? cachedbIndicesFuture;
List<StockData>? cachedbETFFuture;
List<StockData>? cachedbfuturesFuture;
List<StockData>? cachedbForexFuture;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyDhEgxgIP0RmdvGVXE37I4pmsInPBpNDlQ',
    appId: '1:370827623843:android:090991a890d0dda27dee16',
    messagingSenderId: '370827623843',
    projectId: 'us-stock-market-e54ea',
    storageBucket: 'com.bhinfotech.usstockmarket',
  ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final StockController stockController = Get.put(StockController());
  final DashBordController dashBordController = Get.put(DashBordController());
  final GasController gasController = Get.put(GasController());
  final GoogleAdsController googleAdsController =
      Get.put(GoogleAdsController());
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    FirebaseAnalyticsObserver(analytics: analytics);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme:
            const AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
        fontFamily: GoogleFonts.openSans().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
