import 'package:flutter/material.dart';
import 'package:cryptotrack/page/exchange_page.dart';
import 'package:cryptotrack/bloc/bloc.dart';
import 'package:cryptotrack/model/market_model.dart';

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
                          return SizedBox(
                            height: 120,
                            child: GestureDetector(
                              onTap: (){
                                MarketModel _market = snapshot.data[position];
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
                                          Text('Base name: ${snapshot.data[position].pairs.base.name} (${snapshot.data[position].pairs.base.symbol})'),
                                          Text('Quote name: ${snapshot.data[position].pairs.quote.name} (${snapshot.data[position].pairs.quote.symbol})'),
                                          Text('Hight price: ${snapshot.data[position].summary.highPrice}'),
                                          Text('Last price: ${snapshot.data[position].summary.lastPrice}'),
                                          Text('Low price: ${snapshot.data[position].summary.lowPrice}'),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        snapshot.data[position].selected ?
                                        Icon(  Icons.favorite, size: 30, color: Colors.red,) :
                                        Icon(  Icons.favorite_border, size: 30, color: Colors.black,),
                                      ],
                                    ),

                                  ],
                                ),
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
