import 'package:cryptotrack/model/summary_model.dart';
import 'package:cryptotrack/model/pair_model.dart';

class MarketModel {
  int id;
  String exchange;
  String pair;
  bool active;
  String route;
  SummaryModel summary;
  PairModel pairs;

  MarketModel({this.id, this.exchange, this.pair, this.active, this.route, this.pairs});

  factory MarketModel.fromJson(Map<String, dynamic> json) => MarketModel(
        id: json['id'],
        exchange: json['exchange'],
        pair: json['pair'],
        active: json['active'],
        route: json['route'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MarketModel &&
              runtimeType == other.runtimeType &&
              pair == other.pair;

  @override
  int get hashCode => pair.hashCode;


}
