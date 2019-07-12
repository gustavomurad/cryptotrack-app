import 'package:cryptotrack/bloc/bloc.dart';
import 'package:cryptotrack/model/market_model.dart';
import 'package:flutter/material.dart';
import 'package:cryptotrack/component/market_card.dart';

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
        stream: bloc.summarySubject,
        builder: (context, AsyncSnapshot<MarketModel> snapshot) {
          if (snapshot.hasData) {
            return WillPopScope(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 120,
                  child: MarketCard(
                    marketModel: snapshot.data,
                    onPressed: () async {
                      await bloc.selectSummary(market: snapshot.data);
                    },
                  ),
                ),
              ),
              onWillPop: () async {
                snapshot.data.selected
                    ? await bloc.saveSummary(market: snapshot.data)
                    : await bloc.deleteSummary(market: snapshot.data);

                return new Future(() => true);
              },
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
