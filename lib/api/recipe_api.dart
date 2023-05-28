import 'dart:convert';
import 'package:http/http.dart' as http;

class RecipeApi {
  static const String _apiKey = '2eb2e0b9904a4cf49c40c840687010c0';
  static const String _baseURL = 'https://api.spoonacular.com/recipes';

  static String get apiKey => _apiKey;

  Future<List<dynamic>> searchRecipes(String query,
      {String? cuisine,
      String? excludeCuisine,
      String? diet,
      String? intolerances,
      String? equipment,
      String? includeIngredients,
      String? excludeIngredients,
      String? type,
      bool? instructionsRequired,
      int? offset,
      int? number,
      bool? vegetarian,
      bool? vegan,
      int? aggregateLikes,
      int? healthScore,
      int? spoonacularScore,
      int? readyInMinutes,
      int? pricePerServing}) async {
    String? adjustedDiet;

    if (vegetarian == true) {
      adjustedDiet = 'vegetarian';
    }

    if (vegan == true) {
      if (adjustedDiet != null) {
        adjustedDiet += ',vegan';
      } else {
        adjustedDiet = 'vegan';
      }
    }

    adjustedDiet = diet ?? adjustedDiet;

    print(
        'Sending API request to: $_baseURL/complexSearch?apiKey=$_apiKey&query=$query'
        '&cuisine=${cuisine ?? ""}'
        '&excludeCuisine=${excludeCuisine ?? ""}'
        '&diet=${adjustedDiet ?? ""}'
        '&intolerances=${intolerances ?? ""}'
        '&equipment=${equipment ?? ""}'
        '&includeIngredients=${includeIngredients ?? ""}'
        '&excludeIngredients=${excludeIngredients ?? ""}'
        '&type=${type ?? ""}'
        '&instructionsRequired=${instructionsRequired ?? ""}'
        '&offset=${offset ?? 0}'
        '&number=${number ?? 10}'
        '&minAggregateLikes=${aggregateLikes ?? 0}'
        '&minHealthScore=${healthScore ?? 0}'
        '&minSpoonacularScore=${spoonacularScore ?? 0}'
        '&maxReadyInMinutes=${readyInMinutes ?? 0}'
        '&maxPricePerServing=${pricePerServing ?? 0}');

    final response = await http
        .get(Uri.parse('$_baseURL/complexSearch?apiKey=$_apiKey&query=$query'
            '&cuisine=${cuisine ?? ""}'
            '&excludeCuisine=${excludeCuisine ?? ""}'
            '&diet=${adjustedDiet ?? ""}' // This line is edited
            '&intolerances=${intolerances ?? ""}'
            '&equipment=${equipment ?? ""}'
            '&includeIngredients=${includeIngredients ?? ""}'
            '&excludeIngredients=${excludeIngredients ?? ""}'
            '&type=${type ?? ""}'
            '&instructionsRequired=${instructionsRequired ?? ""}'
            '&offset=${offset ?? 0}'
            '&number=${number ?? 10}'
            '&minAggregateLikes=${aggregateLikes ?? 0}'
            '&minHealthScore=${healthScore ?? 0}'
            '&minSpoonacularScore=${spoonacularScore ?? 0}'
            '&maxReadyInMinutes=${readyInMinutes ?? 0}'
            '&maxPricePerServing=${pricePerServing ?? 0}'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse['results'] as List<dynamic>;
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<List<String>> fetchAnalyzedInstructions(
      int recipeId, String apiKey) async {
    final response = await http.get(
      Uri.parse(
          'https://api.spoonacular.com/recipes/$recipeId/analyzedInstructions?apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      if (jsonResponse.isEmpty) {
        return [];
      }
      List<String> instructions = [];
      for (var step in jsonResponse[0]['steps']) {
        instructions.add(step['step']);
      }
      return instructions;
    } else {
      throw Exception('Failed to load analyzed instructions');
    }
  }

  Future<List<String>> fetchIngredients(int recipeId, String apiKey) async {
    final response = await http.get(
      Uri.parse(
          'https://api.spoonacular.com/recipes/$recipeId/ingredientWidget.json?apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> ingredientsData = jsonResponse['ingredients'];
      List<String> ingredients = [];
      for (var ingredient in ingredientsData) {
        ingredients.add(ingredient['name']);
      }
      return ingredients;
    } else {
      throw Exception('Failed to load ingredients');
    }
  }
}
