import 'package:flutter/material.dart';
import 'package:recipes/api/recipe_api.dart';
import 'package:recipes/components/recipe_card.dart';
import 'package:recipes/screens/detail.dart';
import 'package:recipes/screens/filter.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _recipeApi = RecipeApi();
  List<dynamic> _recipes = [];

  void _searchRecipes() async {
    String query = _searchController.text;
    List<dynamic> recipes = await _recipeApi.searchRecipes(query);
    setState(() {
      _recipes = recipes;
    });
  }

  void _searchRecipesWithFilters({
    String? query,
    String? cuisine,
    String? excludeCuisine,
    String? diet,
    String? intolerances,
    String? equipment,
    String? includeIngredients,
    String? excludeIngredients,
    String? type,
    bool? instructionsRequired,
    // Add other parameters as needed
    int? offset,
    int? number,
    required vegetarian,
    required vegan,
    required pricePerServing,
    required healthScore,
    required aggregateLikes,
    required spoonacularScore,
    required readyInMinutes,
  }) async {
    List<dynamic> recipes = await _recipeApi.searchRecipes(
      query!,
      cuisine: cuisine,
      excludeCuisine: excludeCuisine,
      diet: diet,
      intolerances: intolerances,
      equipment: equipment,
      includeIngredients: includeIngredients,
      excludeIngredients: excludeIngredients,
      type: type,
      instructionsRequired: instructionsRequired,
      // Add other parameters as needed
      offset: offset,
      number: number,
    );
    setState(() {
      _recipes = recipes;
    });
  }

  void _openFilterPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => FilterPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(-1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );

    if (result != null) {
      // The result is the filters map you passed to Navigator.pop in FilterPage.
      Map<String, dynamic> filters = result;
      _searchRecipesWithFilters(
        query: _searchController.text,
        vegetarian: filters['vegetarian'],
        vegan: filters['vegan'],
        aggregateLikes: filters['aggregateLikes'],
        healthScore: filters['healthScore'],
        spoonacularScore: filters['spoonacularScore'],
        readyInMinutes: filters['readyInMinutes'],
        pricePerServing: filters['pricePerServing'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Search'),
        actions: [
          IconButton(
            onPressed: () => _openFilterPage(context),
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search recipes',
              ),
            ),
            TextButton(
              onPressed: _searchRecipes,
              child: Text('Search'),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: _recipes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return RecipeCard(
                    title: _recipes[index]['title'],
                    imageUrl: _recipes[index]['image'],
                    onTap: () async {
                      int recipeId = _recipes[index]['id'];
                      List<String> instructions =
                          await _recipeApi.fetchAnalyzedInstructions(
                              recipeId, RecipeApi.apiKey);
                      String steps = instructions.join('\n');

                      RecipeDetail recipeDetail = RecipeDetail(
                        id: _recipes[index]['id'] ?? 0,
                        title: _recipes[index]['title'] ?? '',
                        description: _recipes[index]['description'] ?? '',
                        image: _recipes[index]['image'] ?? '',
                        ingredients: _recipes[index]['ingredients'] ?? '',
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            recipeDetail: recipeDetail,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
