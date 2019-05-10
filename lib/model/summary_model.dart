class SummaryModel{
  double lastPrice;
  double highPrice;
  double lowPrice;
  double changePercentage;
  double changeAbsolute;
  double volume;
  double volumeQuote;

  SummaryModel({this.lastPrice, this.highPrice, this.lowPrice,
      this.changePercentage, this.changeAbsolute, this.volume,
      this.volumeQuote});

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> price = json['price'];
    Map<String, dynamic> change = price['change'];

    return SummaryModel(
      lastPrice: price['last'] == 0 ? 0.0 : price['last'],
      highPrice: price['high'] == 0 ? 0.0 : price['high'],
      lowPrice: price['low']  == 0 ? 0.0 : price['low'],
      changePercentage: change['percentage'] == 0 ? 0.0 : price['percentage'],
      changeAbsolute: change['absolute'] == 0 ? 0.0 : price['absolute'],
      volume: json['volume'] == 0 ? 0.0 : price['volume'],
      volumeQuote: json['volumeQuote'] == 0 ? 0.0 : price['volumeQuote'],
    );
  }
}