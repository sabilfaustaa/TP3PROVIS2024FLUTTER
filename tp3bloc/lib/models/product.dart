class Product {
  final int id;
  final String title;
  final String price;
  final String category;
  final double rating;
  final int reviews;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      category: json['category'],
      rating: json['rating'],
      reviews: json['reviews'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'category': category,
      'rating': rating,
      'reviews': reviews,
      'image': image,
    };
  }
}
