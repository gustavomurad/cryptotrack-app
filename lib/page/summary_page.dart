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
  bool _selectedIcon = false;

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
                  setState(() {
                    _selectedIcon = !_selectedIcon;
                  });
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
                            Icon(Icons.attach_money, size: 60,),
                          ],
                        ),
                        Column(
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(_selectedIcon ? Icons.star : Icons.star_border, size: 30, color: Colors.orange,),
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
            return Container(
              child: CircularProgressIndicator(),
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
