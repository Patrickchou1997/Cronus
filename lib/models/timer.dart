// Data models
class TimmerData {
  int id;
  String title;
  String description;

  TimmerData({
    required this.id,
    required this.title,
    required this.description,
  });

  factory TimmerData.fromJson(Map<String, dynamic> json) {
    return TimmerData(
        id: json['id'], title: json['title'], description: json['description']);
  }
}

class Rating {
  num? rate;
  int? count;

  Rating({this.rate, this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(rate: json['rate'], count: json['count']);
  }
}
