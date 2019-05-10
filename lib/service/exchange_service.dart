import 'package:cryptotrack/service/service_provider.dart';
import 'package:cryptotrack/model/exchange_model.dart';
import 'package:cryptotrack/model/market_model.dart';
import 'package:cryptotrack/model/summary_model.dart';
import 'package:meta/meta.dart';

class Service extends ServiceProvider{

  Future<List<ExchangeModel>> getExchanges() async {
    final response =  await httpGet(service: 'exchanges');
    final data =  response.data['result'];
    final listExchanges = data.map((json) {
      return ExchangeModel.fromJson(json);
    }).toList();
    return listExchanges.cast<ExchangeModel>();
  }

  Future<List<MarketModel>>getMarkets({@required ExchangeModel exchange}) async{
    final response = await httpGet(service: 'markets/${exchange.symbol}');
    final data = response.data['result'];
    final listMarkets = data.map((json){
      return MarketModel.fromJson(json);
    }).toList();

    return listMarkets.cast<MarketModel>();
  }

  Future<MarketModel> getSummary({@required MarketModel market}) async{
    final response = await httpGet(service: 'markets/${market.exchange}/${market.pair}/summary');
    final data = response.data['result'];
    market.summary = SummaryModel.fromJson(data);
    return market;
  }

}