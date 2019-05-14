import 'package:cryptotrack/bloc/bloc.dart';
import 'package:cryptotrack/model/market_model.dart';
import 'package:flutter/material.dart';

class Summary extends StatefulWidget {
  final MarketModel market;

  Summary({@required this.market});

  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.market.pair),
      ),
      body: StreamBuilder<MarketModel>(
        stream: bloc.summarySubject.stream,
        builder: (context, AsyncSnapshot<MarketModel> snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              height: 120,
              child: GestureDetector(
                onTap: (){
                  MarketModel _market = snapshot.data;
                  _market.selected = !_market.selected;
                  bloc.saveSummary(market: _market);
                },
                child: Card(
                  elevation: 10,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //TODO Criptocurrency icon
                            Icon(Icons.attach_money, size: 60,),
                          ],
                        ),
                        SizedBox(
                          width: 245,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Base name: ${snapshot.data.pairs.base.name} (${snapshot.data.pairs.base.symbol})'),
                              Text('Quote name: ${snapshot.data.pairs.quote.name} (${snapshot.data.pairs.quote.symbol})'),
                              Text('Hight price: ${snapshot.data.summary.highPrice}'),
                              Text('Last price: ${snapshot.data.summary.lastPrice}'),
                              Text('Low price: ${snapshot.data.summary.lowPrice}'),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            snapshot.data.selected ?
                              Icon(  Icons.favorite, size: 30, color: Colors.red,) :
                              Icon(  Icons.favorite_border, size: 30, color: Colors.black,),
                          ],
                        ),

                      ],
                    ),
                  ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    bloc.getSummary(model: widget.market);
  }
}
