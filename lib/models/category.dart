

class Category {

  String code;

  String name;

  String slug;

  String description;

  int position = 0;

  int productsCount = 0;

  Category({this.code, this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      code: json['code'],
      name: json['name'],
      // slug: json['slug'],
      // description: json['description']
    );
  }
  
}