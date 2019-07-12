import 'package:cryptotrack/bloc/bloc.dart';
import 'package:cryptotrack/model/market_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class MarketCard extends StatelessWidget {
  final MarketModel marketModel;
  const MarketCard({
    Key key,
    this.marketModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final highPrice = FlutterMoneyFormatter(amount: marketModel.summary.highPrice);
    final lastPrice = FlutterMoneyFormatter(amount: marketModel.summary.lastPrice);
    final lowPrice = FlutterMoneyFormatter(amount: marketModel.summary.lowPrice);
    final changePercentage = FlutterMoneyFormatter(amount: marketModel.summary.changePercentage);

    return Card(
      elevation: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/icons/${marketModel.pairs.base.symbol}.png',
                fit: BoxFit.scaleDown,
                width: 60,
                height: 60,
              ),
            ],
          ),
          SizedBox(
            width: 245,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Exchange: ${marketModel.exchange}'),
                Text('Name: ${marketModel.pairs.base.name}'
                    ' Pair: ${marketModel.pairs.base.symbol} / ${marketModel.pairs.quote.symbol}'),
                Text(
                    'High: ${highPrice.output.nonSymbol} '
                    'Last: ${lastPrice.output.nonSymbol} '
                    'Low: ${lowPrice.output.nonSymbol}'),
                Text(
                    'Change percentage: ${changePercentage.output.nonSymbol}%'
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (marketModel.selected) {
                    marketModel.selected = false;
                    bloc.deleteMarket(market: marketModel);
                  } else {
                    marketModel.selected = true;
                    bloc.saveSummary(market: marketModel);
                  }
                },
                child: marketModel.selected
                    ? Icon(Icons.star, size: 30, color: Colors.amber[700])
                    : Icon(Icons.star, size: 30, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
