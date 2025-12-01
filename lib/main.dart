import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:us_stock_market/controller/db_controller.dart';
import 'package:us_stock_market/controller/eu_fule_controller.dart';
import 'package:us_stock_market/controller/google_ads_controller.dart';
import 'package:us_stock_market/controller/stock_controller.dart';
import 'package:us_stock_market/controller/time_controller.dart';
import 'package:us_stock_market/controller/update_controller.dart';
import 'package:us_stock_market/controller/weather_controller.dart';
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
  final TimeController timeController = Get.put(TimeController());
  final GoogleAdsController googleAdsController =
      Get.put(GoogleAdsController());
  final UpdateController updateController = Get.put(UpdateController());
  final EUFuelController euFuelController = Get.put(EUFuelController());

  final WeatherController weatherController = Get.put(WeatherController());
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

Future<bool> checkConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult.first == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult.first == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

String convertDate({required String date}) {
  String dateInput = date;
  DateTime parsedDate = DateTime.parse(dateInput);
  String formattedDate = DateFormat('d MMMM yyyy').format(parsedDate);
  return formattedDate;
}

enum CountryList {
  United_States,
  China,
  Japan,
  Germany,
  United_Kingdom,
  France,
  India,
  Italy,
  Brazil,
  Canada,
  South_Korea,
  Russia,
  Spain,
  Australia,
  Mexico,
  Indonesia,
  Turkey,
  Netherlands,
  Switzerland,
  Saudi_Arabia,
  Argentina,
  South_Africa,
  Singapore,
  Albania,
  Andorra,
  Austria,
  Belarus,
  Belgium,
  Bosnia_and_Herzegovina,
  Bulgaria,
  Croatia,
  Cyprus,
  Czech_Republic,
  Denmark,
  Estonia,
  Euro_area,
  Faroe_Islands,
  Finland,
  Greece,
  Hungary,
  Iceland,
  Ireland,
  Kosovo,
  Latvia,
  Liechtenstein,
  Lithuania,
  Luxembourg,
  Malta,
  Moldova,
  Monaco,
  Montenegro,
  North_Macedonia,
  Norway,
  Poland,
  Portugal,
  Romania,
  Serbia,
  Slovakia,
  Slovenia,
  Sweden,
  Ukraine,
  Antigua_and_Barbuda,
  Aruba,
  Bahamas,
  Barbados,
  Belize,
  Bermuda,
  Bolivia,
  Cayman_Islands,
  Colombia,
  Costa_Rica,
  Cuba,
  Dominica,
  Dominican_Republic,
  Ecuador,
  El_Salvador,
  Grenada,
  Guatemala,
  Guyana,
  Haiti,
  Honduras,
  Jamaica,
  Nicaragua,
  Panama,
  Paraguay,
  Peru,
  Puerto_Rico,
  Suriname,
  Trinidad_and_Tobago,
  Uruguay,
  Venezuela,
  Afghanistan,
  Armenia,
  Azerbaijan,
  Bahrain,
  Bangladesh,
  Bhutan,
  Brunei,
  Cambodia,
  East_Timor,
  Georgia,
  Hong_Kong,
  Iran,
  Iraq,
  Israel,
  Jordan,
  Kazakhstan,
  Kuwait,
  Kyrgyzstan,
  Laos,
  Lebanon,
  Macao,
  Malaysia,
  Maldives,
  Mongolia,
  Myanmar,
  Nepal,
  North_Korea,
  Oman,
  Palestine,
  Pakistan,
  Philippines,
  Qatar,
  Sri_Lanka,
  Syria,
  Taiwan,
  Tajikistan,
  Thailand,
  Turkmenistan,
  United_Arab_Emirates,
  Uzbekistan,
  Vietnam,
  Yemen,
  Algeria,
  Angola,
  Benin,
  Botswana,
  Burkina_Faso,
  Burundi,
  Cameroon,
  Cape_Verde,
  Central_African_Republic,
  Chad,
  Comoros,
  Congo,
  Djibouti,
  Egypt,
  Equatorial_Guinea,
  Eritrea,
  Ethiopia,
  Gabon,
  Gambia,
  Ghana,
  Guinea,
  Guinea_Bissau,
  Ivory_Coast,
  Kenya,
  Lesotho,
  Liberia,
  Libya,
  Madagascar,
  Malawi,
  Mali,
  Mauritania,
  Mauritius,
  Morocco,
  Mozambique,
  Namibia,
  Niger,
  Nigeria,
  Rwanda,
  Senegal,
  Seychelles,
  Sierra_Leone,
  Somalia,
  South_Sudan,
  Sudan,
  Swaziland,
  Tanzania,
  Togo,
  Tunisia,
  Uganda,
  Zambia,
  Zimbabwe,
  Fiji,
  Kiribati,
  New_Caledonia,
  New_Zealand,
  Samoa,
  Solomon_Islands,
  Tonga,
  Vanuatu
}
