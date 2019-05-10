import 'package:flutter/material.dart';
import 'package:cryptotrack/bloc/bloc.dart';
import 'package:cryptotrack/model/exchange_model.dart';
import 'package:cryptotrack/page/market_page.dart';

class Exchange extends StatefulWidget {
  static const String routeName = '/exchange';

  @override
  _ExchangeState createState() => _ExchangeState();
}

class _ExchangeState extends State<Exchange> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exchanges'),
      ),
      body: Container(
        child: Center(
          child: RefreshIndicator(
            onRefresh: () => bloc.getExchanges(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StreamBuilder<List<ExchangeModel>>(
                  stream: bloc.exchangeSubject.stream,
                  builder:
                      (context, AsyncSnapshot<List<ExchangeModel>> snapshot) {
                    if (snapshot.hasData) {
                      return Flexible(
                        fit: FlexFit.tight,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(15.0),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, position) {
                            return Card(
                              elevation: 0.0,
                              child: ListTile(
                                title: Text('${snapshot.data[position].name}'),
                                subtitle:
                                    Text('${snapshot.data[position].symbol}'),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  size: 40,
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Market(
                                                  exchange: snapshot
                                                      .data[position])));
                                },
                              ),
                            );
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
    bloc.getExchanges();
  }
}
