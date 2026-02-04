class Author {
  final String name;
  final String avatar;
  final String type; // 'user' or 'vendor'

  Author({required this.name, required this.avatar, required this.type});
}

class Post {
  final String id;
  final Author author;
  final String content;
  final String? image;
  final String? location;
  final String? eventType;
  final String timestamp;
  final int likes;
  final int comments;
  final String? vendorId;

  Post({
    required this.id,
    required this.author,
    required this.content,
    this.image,
    this.location,
    this.eventType,
    required this.timestamp,
    required this.likes,
    required this.comments,
    this.vendorId,
  });
}
