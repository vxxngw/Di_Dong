class Tour {
  final String id;
  final String title;
  final String image;
  final String date;
  final String days;
  final String price;
  final bool isSaved;
  final bool isLiked;
  final int likes;

  Tour({
    required this.id,
    required this.title,
    required this.image,
    required this.date,
    required this.days,
    required this.price,
    this.isSaved = false,
    this.isLiked = false,
    this.likes = 0,
  });

  factory Tour.fromFirestore(String id, Map<String, dynamic> data) {
    return Tour(
      id: id,
      title: data['title'] ?? '',
      image: data['image'] ?? '',
      date: data['date'] ?? '',
      days: data['days'] ?? '',
      price: data['price'] ?? '',
      isSaved: data['isSaved'] ?? false,
      isLiked: data['isLiked'] ?? false,
      likes: data['likes'] ?? 0,
    );
  }

  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      date: json['date'] ?? '',
      days: json['days'] ?? '',
      price: json['price'] ?? '',
      isSaved: json['isSaved'] ?? false,
      isLiked: json['isLiked'] ?? false,
      likes: json['likes'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'image': image,
      'date': date,
      'days': days,
      'price': price,
      'isSaved': isSaved,
      'isLiked': isLiked,
      'likes': likes,
    };
  }
}

class Guide {
  final String id;
  final String name;
  final String image;
  final String role;
  final int reviews;

  Guide({
    required this.id,
    required this.name,
    required this.image,
    required this.role,
    this.reviews = 0,
  });

  factory Guide.fromFirestore(String id, Map<String, dynamic> data) {
    return Guide(
      id: id,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      role: data['role'] ?? '',
      reviews: data['reviews'] ?? 0,
    );
  }

  factory Guide.fromJson(Map<String, dynamic> json) {
    return Guide(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      role: json['role'] ?? '',
      reviews: json['reviews'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'image': image,
      'role': role,
      'reviews': reviews,
    };
  }
}

class Experience {
  final String id;
  final String title;
  final String image;
  final String avatar;
  final String name;
  final String location;

  Experience({
    required this.id,
    required this.title,
    required this.image,
    required this.avatar,
    required this.name,
    required this.location,
  });

  factory Experience.fromFirestore(String id, Map<String, dynamic> data) {
    return Experience(
      id: id,
      title: data['title'] ?? '',
      image: data['image'] ?? '',
      avatar: data['avatar'] ?? '',
      name: data['name'] ?? '',
      location: data['location'] ?? '',
    );
  }

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      avatar: json['avatar'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'image': image,
      'avatar': avatar,
      'name': name,
      'location': location,
    };
  }
}

class Trip {
  final String id;
  final String title;
  final String location;
  final String date;
  final String time;
  final String image;
  final String avatar;

  Trip({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.time,
    required this.image,
    required this.avatar,
  });

  factory Trip.fromFirestore(String id, Map<String, dynamic> data) {
    return Trip(
      id: id,
      title: data['title'] ?? '',
      location: data['location'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      image: data['image'] ?? '',
      avatar: data['avatar'] ?? '',
    );
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      image: json['image'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }
}
