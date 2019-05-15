import 'package:cryptotrack/model/exchange_model.dart';
import 'package:cryptotrack/model/market_model.dart';
import 'package:cryptotrack/repository/exchange_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class Bloc {
  final _exchangeSubject = BehaviorSubject<List<ExchangeModel>>();
  final _marketSubject = BehaviorSubject<List<MarketModel>>();
  final _summarySubject = BehaviorSubject<MarketModel>();
  final _favoritesSubject = BehaviorSubject<List<MarketModel>>();

  List<MarketModel> _favorites = [];

  Future<void> saveSummary({@required MarketModel market}) async {
    try {
      _summarySubject.sink.add(market);
      _favorites.add(market);
      _favoritesSubject.sink.add(_favorites);

      Repository().createOrUpdate(market: market);
    }catch(e){
      _summarySubject.addError(e);
    }
  }

  Future<void> deleteMarket({@required MarketModel market}) async {
    try{
      Repository().delete(market: market);
      _favorites.remove(market);
      _favoritesSubject.sink.add(_favorites);
    }catch(e){
      _summarySubject.addError(e);
    }
  }

  Future<void> markets() async{
    try{
      List<MarketModel> markets = await Repository().markets();
      _favorites.addAll(markets);
      _favoritesSubject.sink.add(markets);
    }catch(e){
      _favoritesSubject.addError(e);
    }
  }

  Future<void> getExchanges() async {
    try {
      _exchangeSubject.sink.add(null);
      List<ExchangeModel> exchanges = await Repository().getExchanges();
      exchanges.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

      _exchangeSubject.sink.add(exchanges);
    } catch (e) {
      _exchangeSubject.addError(e);
    }
  }

  Future<void> getMarkets({@required ExchangeModel model}) async {
    try {
      _marketSubject.sink.add(null);
      List<MarketModel> markets =
          await Repository().getMarkets(exchange: model);
      markets.sort((a, b) {
        return a.pair.toLowerCase().compareTo(b.pair.toLowerCase());
      });

      _marketSubject.sink.add(markets);
    } catch (e) {
      _marketSubject.addError(e);
    }
  }

  Future<void> getSummary({@required MarketModel model}) async {
    try {
      _summarySubject.sink.add(null);
      MarketModel market = await Repository().getSummary(market: model);

      _summarySubject.sink.add(market);
    } catch (e) {
      _summarySubject.addError(e);
    }
  }

  dispose() {
    _exchangeSubject.close();
    _marketSubject.close();
  }

  BehaviorSubject<List<ExchangeModel>> get exchangeSubject => _exchangeSubject;
  BehaviorSubject<List<MarketModel>> get marketSubject => _marketSubject;
  BehaviorSubject<MarketModel> get summarySubject => _summarySubject;
  BehaviorSubject<List<MarketModel>> get favoritesSubject => _favoritesSubject;
}

final bloc = Bloc();
