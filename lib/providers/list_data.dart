class List_data {
  final String base, quote, type;
  final double lastPrice, volume;

List_data(
  {
    required this.base,
    required this.quote,
    required this.type,
    required this.lastPrice,
    required this.volume
});

factory List_data.fromJson(Map<String, dynamic> json) => List_data(
  base: json["base"],
  quote: json["quote"],
  type: json["type"],
  lastPrice: double.parse(json["lastPrice"].toString()),
  volume: double.parse(json["volume"].toString()),
);

}
