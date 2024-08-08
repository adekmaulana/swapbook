import 'user.model.dart';

class Book {
  int? id;
  String? bookApiId;
  String? apiLink;
  String? title;
  List<String>? author;
  List<String>? genres;
  String? synopsis;
  double? averageRating;
  double? ratingCount;
  double? rating;
  String? image;
  String? imageLink;
  BookStatus? status;
  User? user;
  bool? isBookmarked;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  Book({
    this.id,
    this.bookApiId,
    this.apiLink,
    this.title,
    this.author,
    this.genres,
    this.synopsis,
    this.averageRating,
    this.ratingCount,
    this.rating,
    this.image,
    this.imageLink,
    this.status,
    this.user,
    this.isBookmarked,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      bookApiId: json['book_api_id'],
      apiLink: json['api_link'],
      title: json['title'],
      author: json['author'] != null
          ? List<String>.from(json['author'])
          : <String>[],
      genres: json['genres'] != null
          ? List<String>.from(json['genres'])
          : <String>[],
      synopsis: json['synopsis'],
      averageRating: json['average_rating'] is int
          ? (json['average_rating'] as int).toDouble()
          : json['average_rating'],
      rating: json['rating'] is int
          ? (json['rating'] as int).toDouble()
          : json['rating'],
      ratingCount: json['rating_count'] is int
          ? (json['rating_count'] as int).toDouble()
          : json['rating_count'],
      image: json['image'],
      imageLink: json['image_link'],
      status: BookStatus.values.firstWhere(
        (e) => e.index == json['status'],
      ),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      isBookmarked: json['is_bookmarked'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookApiId': bookApiId,
      'apiLink': apiLink,
      'title': title,
      'author': author,
      'genres': genres,
      'synopsis': synopsis,
      'averageRating': averageRating,
      'ratingCount': ratingCount,
      'rating': rating,
      'image': image,
      'imageLink': imageLink,
      'status': status?.index,
      'user': user?.toJson(),
      'isBookmarked': isBookmarked,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}

enum BookStatus {
  available,
  swap,
  finished,
  deleted,
}
