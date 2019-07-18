import 'package:flutter/material.dart';
import 'package:cryptotrack/bloc/bloc.dart';
import 'package:cryptotrack/model/exchange_model.dart';
import 'package:cryptotrack/model/market_model.dart';
import 'package:cryptotrack/component/market_card.dart';

class Exchange extends StatefulWidget {
  static const String routeName = '/exchange';

  @override
  _ExchangeState createState() => _ExchangeState();
}

class _ExchangeState extends State<Exchange> {
  ExchangeModel _exchange;
  MarketModel _market;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exchanges'),
      ),
      body: Container(
        child: Center(
          child: RefreshIndicator(
            onRefresh: () => bloc.refreshExchanges(),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  StreamBuilder<List<ExchangeModel>>(
                      stream: bloc.exchangeSubject,
                      builder: (context,
                          AsyncSnapshot<List<ExchangeModel>> snapshot) {
                        List<DropdownMenuItem<ExchangeModel>> _items = [];
                        if (snapshot.hasData) {
                          _items = snapshot.data
                              .map<DropdownMenuItem<ExchangeModel>>(
                                  (ExchangeModel model) {
                            return DropdownMenuItem<ExchangeModel>(
                              value: model,
                              child: Text(model.name),
                            );
                          }).toList();
                        }

                        return DropdownButtonFormField<ExchangeModel>(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            filled: false,
                            labelText: 'Exchange.',
                          ),
                          items: _items,
                          onChanged: (ExchangeModel newValue) {
                            bloc.getMarkets(model: newValue);
                            setState(() {
                              _exchange = newValue;
                            });
                          },
                          value: _exchange,
                        );
                      }),
                  StreamBuilder<List<MarketModel>>(
                      stream: bloc.marketSubject,
                      builder:
                          (context, AsyncSnapshot<List<MarketModel>> snapshot) {
                        List<DropdownMenuItem<MarketModel>> _items = [];
                        if (snapshot.hasData) {
                          _items = snapshot.data
                              .map<DropdownMenuItem<MarketModel>>(
                                  (MarketModel model) {
                            return DropdownMenuItem<MarketModel>(
                              value: model,
                              child: Text(model.pair),
                            );
                          }).toList();

                          return DropdownButtonFormField<MarketModel>(
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              filled: false,
                              labelText: 'Markets.',
                            ),
                            items: _items,
                            onChanged: (MarketModel newValue) {
                              bloc.getSummary(model: newValue);
                              setState(() {
                                _market = newValue;
                              });
                            },
                            value: _market,
                          );
                        } else {
                          if (_exchange != null) {
                            return Center(
                              child: Container(
                                child: CircularProgressIndicator(),
                                padding: EdgeInsets.all(50),
                              ),
                            );
                          } else {
                            return Container(
                              child: null,
                            );
                          }
                        }
                      }),
                  StreamBuilder<MarketModel>(
                    stream: bloc.summarySubject,
                    builder: (context, AsyncSnapshot<MarketModel> snapshot) {
                      if (snapshot.hasData) {
                        return WillPopScope(
                          child: SizedBox(
                            height: 120,
                            child: MarketCard(
                              marketModel: snapshot.data,
                              onPressed: () async {
                                await bloc.selectSummary(market: snapshot.data);
                              },
                            ),
                          ),
                          onWillPop: () async {
                            snapshot.data.selected
                                ? await bloc.saveSummary(market: snapshot.data)
                                : await bloc.deleteSummary(
                                    market: snapshot.data);

                            bloc.removeData();
                            return new Future(() => true);
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        if (_market != null) {
                          return Center(
                            child: Container(
                              child: CircularProgressIndicator(),
                              padding: EdgeInsets.all(50),
                            ),
                          );
                        } else {
                          return Container(
                            child: null,
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    bloc.getExchanges();
  }
}
