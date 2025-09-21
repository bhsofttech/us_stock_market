import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:us_stock_market/main.dart';
import 'package:us_stock_market/models/stock_data.dart';

class DashBordController extends GetxController {
  List<StockData> dbTopGstocks = [];
  Rx<Future<List<StockData>>> topGstocksFuture =
      Future<List<StockData>>(() => []).obs;
  Future<List<StockData>> fetchdbTopGstocks(String url) async {
    try {
      dbTopGstocks = [];
      Uri dataLink = Uri.parse(url);
      final response = await http.get(dataLink);
      dom.Document html = dom.Document.html(response.body);
      var cell = html.getElementsByTagName("table")[0];
      var tr = cell.getElementsByTagName("tr");

      for (int i = 0; i < tr.length; i++) {
        StockData tempStock = StockData(
          image: i == 0 || tr[i].children[0].getElementsByTagName("img").isEmpty
              ? ""
              : tr[i]
                  .children[0]
                  .getElementsByTagName("img")
                  .first
                  .attributes["src"]
                  .toString(),
          url: i == 0 || tr[i].children[0].getElementsByTagName("a").isEmpty
              ? ""
              : tr[i]
                  .children[0]
                  .getElementsByTagName("a")
                  .first
                  .attributes["href"]
                  .toString(),
          shortName:
              i == 0 || tr[i].children[0].getElementsByTagName("a").isEmpty
                  ? ""
                  : tr[i]
                      .children[0]
                      .getElementsByTagName("a")
                      .first
                      .text
                      .toString()
                      .trim(),
          symbol: () {
            String shortName =
                i == 0 || tr[i].children[0].getElementsByTagName("a").isEmpty
                    ? ""
                    : tr[i]
                        .children[0]
                        .getElementsByTagName("a")
                        .first
                        .text
                        .toString()
                        .trim();
            String rawSymbol = tr[i].children[0].text.toString().trim();
            int charsToRemove = shortName.length;
            return rawSymbol.length >= charsToRemove
                ? rawSymbol.substring(charsToRemove).trim()
                : rawSymbol;
          }(),
          price: tr[i].children[1].text.toString().trim(),
          changePercent: tr[i].children[2].text.toString().trim(),
          volume: tr[i].children[3].text.toString().trim(),
          relativeVolume: tr[i].children[4].text.toString().trim(),
          marketCap: tr[i].children[5].text.toString().trim(),
          peRatio: tr[i].children[6].text.toString().trim(),
          epsDilTTM: tr[i].children[7].text.toString().trim(),
          epsDilGrowthYoY: tr[i].children[8].text.toString().trim(),
          dividendYield: tr[i].children[9].text.toString().trim(),
          sector: tr[i].children[10].text.toString().trim(),
        );
        dbTopGstocks.add(tempStock);
      }
      return dbTopGstocks; // Return the populated list
    } catch (e) {
      rethrow; // Propagate errors to the Future
    }
  }

  // Method to trigger the future update
  void loadTopGstocks(String url) async {
    topGstocksFuture.value = fetchdbTopGstocks(url);
    cachedbGStocksFuture = await topGstocksFuture.value;
    update(); // Trigger UI rebuild if needed
  }

  List<StockData> dbTopLstocks = [];
  Rx<Future<List<StockData>>> topLstocksFuture =
      Future<List<StockData>>(() => []).obs;

  Future<List<StockData>> fetchdbTopLstocks(String url) async {
    try {
      dbTopLstocks = [];
      Uri dataLink = Uri.parse(url);
      final response = await http.get(dataLink);
      dom.Document html = dom.Document.html(response.body);
      var cell = html.getElementsByTagName("table")[0];
      var tr = cell.getElementsByTagName("tr");

      for (int i = 0; i < tr.length; i++) {
        StockData tempStock = StockData(
          image: i == 0 || tr[i].children[0].getElementsByTagName("img").isEmpty
              ? ""
              : tr[i]
                  .children[0]
                  .getElementsByTagName("img")
                  .first
                  .attributes["src"]
                  .toString(),
          url: i == 0 || tr[i].children[0].getElementsByTagName("a").isEmpty
              ? ""
              : tr[i]
                  .children[0]
                  .getElementsByTagName("a")
                  .first
                  .attributes["href"]
                  .toString(),
          shortName:
              i == 0 || tr[i].children[0].getElementsByTagName("a").isEmpty
                  ? ""
                  : tr[i]
                      .children[0]
                      .getElementsByTagName("a")
                      .first
                      .text
                      .toString()
                      .trim(),
          symbol: () {
            String shortName =
                i == 0 || tr[i].children[0].getElementsByTagName("a").isEmpty
                    ? ""
                    : tr[i]
                        .children[0]
                        .getElementsByTagName("a")
                        .first
                        .text
                        .toString()
                        .trim();
            String rawSymbol = tr[i].children[0].text.toString().trim();
            int charsToRemove = shortName.length;
            return rawSymbol.length >= charsToRemove
                ? rawSymbol.substring(charsToRemove).trim()
                : rawSymbol;
          }(),
          price: tr[i].children[1].text.toString().trim(),
          changePercent: tr[i].children[2].text.toString().trim(),
          volume: tr[i].children[3].text.toString().trim(),
          relativeVolume: tr[i].children[4].text.toString().trim(),
          marketCap: tr[i].children[5].text.toString().trim(),
          peRatio: tr[i].children[6].text.toString().trim(),
          epsDilTTM: tr[i].children[7].text.toString().trim(),
          epsDilGrowthYoY: tr[i].children[8].text.toString().trim(),
          dividendYield: tr[i].children[9].text.toString().trim(),
          sector: tr[i].children[10].text.toString().trim(),
        );
        dbTopLstocks.add(tempStock);
      }
      return dbTopLstocks; // Return the populated list
    } catch (e) {
      rethrow; // Propagate errors to the Future
    }
  }

  // Method to trigger the future update
  void loadTopLstocks(String url) async {
    topLstocksFuture.value = fetchdbTopLstocks(url);
    cachedbLossStocksFuture = await topLstocksFuture.value;
    update(); // Trigger UI rebuild if needed
  }

  List<StockData> dbLargrCapstocks = [];
  // Reactive Future variable for Large Cap Stocks
  Rx<Future<List<StockData>>> dbLargeCapStocksFuture =
      Future<List<StockData>>(() => []).obs;

  // Updated function to return Future<List<StockData>>
  Future<List<StockData>> fetchdbLargeCapStocks(String url) async {
    try {
      dbLargrCapstocks = [];
      Uri dataLink = Uri.parse(url);
      final response = await http.get(dataLink);
      dom.Document html = dom.Document.html(response.body);
      var cell = html.getElementsByTagName("table")[0];
      var tr = cell.getElementsByTagName("tr");

      for (int i = 0; i < tr.length; i++) {
        StockData tempStock = StockData(
          image: i == 0 || tr[i].children[0].getElementsByTagName("img").isEmpty
              ? ""
              : tr[i]
                  .children[0]
                  .getElementsByTagName("img")
                  .first
                  .attributes["src"]
                  .toString(),
          url: i == 0 || tr[i].children[0].getElementsByTagName("a").isEmpty
              ? ""
              : tr[i]
                  .children[0]
                  .getElementsByTagName("a")
                  .first
                  .attributes["href"]
                  .toString(),
          shortName:
              i == 0 || tr[i].children[0].getElementsByTagName("a").isEmpty
                  ? ""
                  : tr[i]
                      .children[0]
                      .getElementsByTagName("a")
                      .first
                      .text
                      .toString()
                      .trim(),
          symbol: () {
            String shortName =
                i == 0 || tr[i].children[0].getElementsByTagName("a").isEmpty
                    ? ""
                    : tr[i]
                        .children[0]
                        .getElementsByTagName("a")
                        .first
                        .text
                        .toString()
                        .trim();
            String rawSymbol = tr[i].children[0].text.toString().trim();
            int charsToRemove = shortName.length;
            return rawSymbol.length >= charsToRemove
                ? rawSymbol.substring(charsToRemove).trim()
                : rawSymbol;
          }(),
          price: tr[i].children[1].text.toString().trim(),
          changePercent: tr[i].children[2].text.toString().trim(),
          volume: tr[i].children[3].text.toString().trim(),
          relativeVolume: tr[i].children[4].text.toString().trim(),
          marketCap: tr[i].children[5].text.toString().trim(),
          peRatio: tr[i].children[6].text.toString().trim(),
          epsDilTTM: tr[i].children[7].text.toString().trim(),
          epsDilGrowthYoY: tr[i].children[8].text.toString().trim(),
          dividendYield: tr[i].children[9].text.toString().trim(),
          sector: tr[i].children[10].text.toString().trim(),
        );
        dbLargrCapstocks.add(tempStock);
      }
      return dbLargrCapstocks;
    } catch (e) {
      rethrow;
    }
  }

  // Method to trigger the future update (call this when you want to fetch data)
  void loadLargeCapStocks(String url) async {
    dbLargeCapStocksFuture.value = fetchdbLargeCapStocks(url);
    cachedbLargeCapStocksFuture = await dbLargeCapStocksFuture.value;
    update(); // Trigger UI rebuild if needed
  }
}
