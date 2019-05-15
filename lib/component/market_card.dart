import 'package:cryptotrack/model/market_model.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

class MarketCard extends StatelessWidget {
  final MarketModel marketModel;
  const MarketCard({
    Key key,
    this.marketModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _image = 'assets/images/icons/${marketModel.pairs.base.symbol}.png';

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
              Image(
                image: AssetImage(_image),
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
                Text(
                    'Base name: ${marketModel.pairs.base.name}'
                        ' (${marketModel.pairs.base.symbol})'),
                Text(
                    'Quote name: ${marketModel.pairs.quote.name}'
                        ' (${marketModel.pairs.quote.symbol})'),
                Text('Hight price: ${marketModel.summary.highPrice}'),
                Text('Last price: ${marketModel.summary.lastPrice}'),
                Text('Low price: ${marketModel.summary.lowPrice}'),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              marketModel.selected
                  ? Icon(
                      Icons.favorite,
                      size: 30,
                      color: Colors.red,
                    )
                  : Icon(
                      Icons.favorite_border,
                      size: 30,
                      color: Colors.black,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
