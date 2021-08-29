import 'btcRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'coinCard.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = currenciesList.first;
  Map<String, String> coinPrices = {};
  String quoteAsset = '';

  void initState() {
    super.initState();
    getCards();
  }

  Column getCards() {
    List<CoinCard> cards = [];
    for (String crypto in cryptoList) {
      cards.add(CoinCard(
        baseAsset: crypto,
        bitcoinValue: (coinPrices[crypto] == null) ? '?' : coinPrices[crypto],
        quoteAsset: quoteAsset,
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cards,
    );
  }

  void updateIU(dynamic prices, String quoteAssetFromPicker) {
    setState(() {
      coinPrices = prices;
      quoteAsset = quoteAssetFromPicker;
    });
  }

  DropdownButton<String> androidDropDown() {

    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (quoteAssetFromPicker) async {
        var prices = await BtcRequest().getBtcPrice(quoteAssetFromPicker);
        if (prices != null) {
          updateIU(prices, quoteAssetFromPicker);
          selectedCurrency = quoteAssetFromPicker;
        }
      },
    );
  }
  CupertinoPicker iOSPicker() {

    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 24.0,
      onSelectedItemChanged: (int index) async {
        var price = await BtcRequest().getBtcPrice(currenciesList[index]);
        String quoteAssetFromPicker = currenciesList[index];
        if (price != null) {
          updateIU(price, quoteAssetFromPicker);
        }
      },
      children: pickerItems,
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          getCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}



