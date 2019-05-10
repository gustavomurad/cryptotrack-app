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
      body: Container(
        child: Center(
          child: RefreshIndicator(
            onRefresh: () => bloc.getSummary(model: widget.market),
            child: StreamBuilder<MarketModel>(
              stream: bloc.summarySubject.stream,
              builder: (context, AsyncSnapshot<MarketModel> snapshot) {
                if (snapshot.hasData) {
                  return Card(
                    elevation: 0.0,
                    child: Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(child: Text('${snapshot.data.pair}')),
                            Container(child: Text('${snapshot.data.summary.highPrice}')),
                            Container(child: Text('${snapshot.data.summary.lastPrice}')),
                            Container(child: Text('${snapshot.data.summary.lowPrice}')),
                          ],
                        ),
                      ],
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
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    bloc.getSummary(model: widget.market);
  }
}
