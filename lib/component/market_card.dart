import 'package:cryptotrack/model/market_model.dart';
import 'package:flutter/material.dart';
import 'package:cryptotrack/bloc/bloc.dart';
import 'dart:io' as io;

class MarketCard extends StatelessWidget {
  final MarketModel marketModel;
  const MarketCard({
    Key key,
    this.marketModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                Text('Base name: ${marketModel.pairs.base.name}'
                    ' (${marketModel.pairs.base.symbol})'),
                Text('Quote name: ${marketModel.pairs.quote.name}'
                    ' (${marketModel.pairs.quote.symbol})'),
                Text('Hight price: ${marketModel.summary.highPrice}'),
                Text('Last price: ${marketModel.summary.lastPrice}'),
                Text('Low price: ${marketModel.summary.lowPrice}'),
                Text('Change percentage: ${marketModel.summary.changePercentage.toStringAsPrecision(2)}%'),
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
