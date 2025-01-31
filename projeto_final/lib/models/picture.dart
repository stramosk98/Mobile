class Picture {
  final int? id;
  final String author;
  final String date;
  final String explanation;
  final String url;

  Picture({
    this.id,
    required this.author,
    required this.date,
    required this.explanation,
    required this.url
  });

  Picture.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        author = res["author"],
        date = res["date"],
        explanation = res["explanation"],
        url = res["url"];

  get model => null;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'author': author,
      'date': date,
      'explanation': explanation,
      'url': url
    };
  }
   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = this.id;
      data['author'] = this.author;
      data['date'] = this.date;
      data['explanation'] = this.explanation;
      data['url'] = this.url;
    return data;
  }
}