import 'package:cryptotrack/model/exchange_model.dart';
import 'package:cryptotrack/model/market_model.dart';
import 'package:cryptotrack/service/exchange_service.dart';
import 'package:meta/meta.dart';

class Repository{
  Future<List<ExchangeModel>> getExchanges() async {
    return await Service().getExchanges();
  }

  Future<List<MarketModel>>getMarkets({@required ExchangeModel exchange}) async{
    return await Service().getMarkets(exchange: exchange);
  }

  Future<MarketModel> getSummary({@required MarketModel market}) async{
    return await Service().getSummary(market: market);
  }
}