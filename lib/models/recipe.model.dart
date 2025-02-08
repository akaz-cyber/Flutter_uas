class RecipeModel {
  final int id;
  final DateTime createdAt;
  final String? image;
  final String? title;
  final String? ingredients;
  final String? steps;
  final String? stepsImage;
  final String? description;
  final int serveAmount;
  final String? timeConsumed;
  final String userId;

  RecipeModel({
    required this.id,
    required this.createdAt,
    required this.image,
    required this.title,
    required this.ingredients,
    required this.steps,
    required this.stepsImage,
    required this.description,
    required this.serveAmount,
    required this.timeConsumed,
    required this.userId,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      image: json['image'],
      title: json['title'],
      ingredients: json['ingredients'],
      steps: json['steps'],
      stepsImage: json['steps_image'],
      description: json['description'],
      serveAmount: json['serve_amount'],
      timeConsumed: json['time_consumed'],
      userId: json['user_id'],
    );
  }
}
