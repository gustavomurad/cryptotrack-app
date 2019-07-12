import 'package:cryptotrack/bloc/bloc.dart';
import 'package:cryptotrack/component/market_card.dart';
import 'package:cryptotrack/model/market_model.dart';
import 'package:cryptotrack/page/exchange_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoTrack',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(title: 'Cryptocurrency Tracker'),
      routes: {
        Exchange.routeName: (context) => Exchange(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, Exchange.routeName);
        },
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: RefreshIndicator(
          onRefresh: () => bloc.markets(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<List<MarketModel>>(
                stream: bloc.favoritesSubject.stream,
                builder: (context, AsyncSnapshot<List<MarketModel>> snapshot) {
                  if (snapshot.hasData) {
                    return Flexible(
                      fit: FlexFit.tight,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(15.0),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, position) {
                          return Dismissible(
                            key: Key(position.toString()),
                            onDismissed: (direction) {
                              snapshot.data[position].selected = false;
                              bloc.deleteSummary(
                                  market: snapshot.data[position]);
                            },
                            child: SizedBox(
                              height: 120,
                              child: MarketCard(
                                marketModel: snapshot.data[position],
                                onPressed: (){
                                  bloc.deleteSummary(market: snapshot.data[position]);
                                },
                              ),
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
    );
  }

  @override
  void initState() {
    super.initState();
    bloc.markets();
  }
}
