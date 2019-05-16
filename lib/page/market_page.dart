import 'package:flutter/material.dart';
import 'package:cryptotrack/bloc/bloc.dart';
import 'package:cryptotrack/model/market_model.dart';
import 'package:cryptotrack/model/exchange_model.dart';
import 'package:cryptotrack/page/summary_page.dart';

class Market extends StatefulWidget {
  final ExchangeModel exchange;

  Market({@required this.exchange});

  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exchange.name),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Center(
          child: RefreshIndicator(
            onRefresh: () => bloc.getMarkets(model: widget.exchange),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StreamBuilder<List<MarketModel>>(
                  stream: bloc.marketSubject.stream,
                  builder:
                      (context, AsyncSnapshot<List<MarketModel>> snapshot) {
                    if (snapshot.hasData) {
                      return Flexible(
                        fit: FlexFit.tight,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(15.0),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, position) {
                            if (snapshot.data[position].active) {
                              return Card(
                                elevation: 0.0,
                                child: ListTile(
                                  title:
                                      Text('${snapshot.data[position].pair}'),
                                  subtitle:
                                      Text('${snapshot.data[position].pair}'),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    size: 40,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Summary(
                                                    market: snapshot
                                                        .data[position])));
                                  },
                                ),
                              );
                            }
                          },
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    bloc.getMarkets(model: widget.exchange);
  }
}
