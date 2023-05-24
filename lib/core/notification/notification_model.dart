class NotificationModel {
  const NotificationModel({
    required this.text,
    this.title,
    this.image,
    this.name,
  });
  final String text;
  final String? title;
  final String? image;
  final String? name;

  factory NotificationModel.fromJson(Map<String, String> json) {
    return NotificationModel(
      text: json['text'] ?? '',
      title: json['title'],
      image: json['image'],
      name: json['name'],
    );
  }

  Map<String, String?> toJson() {
    return {
      "text": text,
      "title": title,
      "image": image,
      "name": name,
    };
  }
}
