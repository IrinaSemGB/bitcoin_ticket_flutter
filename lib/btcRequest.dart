import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_key.dart';
import 'coin_data.dart';

const coinApiUrl = 'https://rest.coinapi.io/v1/exchangerate';

class BtcRequest {
  
  Future<dynamic> getBtcPrice(String quoteAsset) async {

    Map<String, String> prices = {};

    for (String crypto in cryptoList) {
      Uri url = Uri.parse('$coinApiUrl/$crypto/$quoteAsset?apikey=$apiKey');
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        var price = decodedData['rate'];
        prices[crypto] = price.toStringAsFixed(0);
      } else {
        print(response.statusCode);
      }
    }
    return prices;
  }
}