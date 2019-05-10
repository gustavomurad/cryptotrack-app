
class ExchangeModel{
  String symbol;
  String name;
  bool active;
  String route;

  ExchangeModel({this.symbol, this.name, this.active, this.route});

  factory ExchangeModel.fromJson(Map<String, dynamic> json) => ExchangeModel(
    symbol: json['symbol'],
    name: json['name'],
    active: json['active'],
    route: json['route'],
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ExchangeModel &&
              runtimeType == other.runtimeType &&
              name == other.name;

  @override
  int get hashCode => name.hashCode;


}