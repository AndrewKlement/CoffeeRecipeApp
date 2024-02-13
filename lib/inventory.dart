class Recipe{
  String itemName;
  String itemCategory;
  List ingredients;
  String notes;
  List timeline;
  int duration; 
  List journalquestion;

  Recipe(this.itemName, this.itemCategory, this.ingredients, this.duration, this.notes, this.timeline, this.journalquestion);
  

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    json['itemName'] as String,
    json['itemCategory'] as String,
    json['ingredients'] as List,
    json['duration'] as int,
    json['notes'] as String,
    json['timeline'] as List,
    json['journalquestion'] as List
  );

  Map<String, dynamic> toJson(){
    return {
      'itemName': itemName,
      'itemCategory': itemCategory,
      'ingredients': ingredients,
      'duration': duration,
      'notes': notes,
      'timeline': timeline,
      'journalquestion': journalquestion
    };
  }
}

class Journal{
  int rating;
  String recipeused;
  String date;
  List journalquestion;
  List journalanswer;
  String notes;

  Journal(this.rating, this.recipeused, this.date, this.journalquestion, this.journalanswer, this.notes);

  factory Journal.fromJson(Map<String, dynamic> json) => Journal(
    json['rating'] as int,
    json['recipeused'] as String,
    json['date'] as String,
    json['journalquestion'] as List ,
    json['journalanswer'] as List ,
    json['notes'] as String,
  );

  Map<String, dynamic> toJson(){
    return {
      'rating': rating,
      'recipeused': recipeused,
      'date': date,
      'journalquestion': journalquestion,
      'journalanswer': journalanswer,
      'notes': notes,
    };
  }
}


