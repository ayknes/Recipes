import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipes/api/recipe_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipesDetail {
  final int id;
  final String title;
  final String description;
  final String image;
  final String ingredients;

  RecipesDetail({
    required this.title,
    required this.description,
    required this.image,
    required this.ingredients,
    required this.id,
  });
  toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'ingredients': ingredients,
    };
  }
}

class DetailScreen extends StatelessWidget {
  final RecipesDetail recipesDetail;
  final RecipeApi recipeApi = RecipeApi();

  DetailScreen({Key? key, required this.recipesDetail, required recipeId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipesDetail.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(recipesDetail.image),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                recipesDetail.title,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                recipesDetail.description,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                recipesDetail.ingredients,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Ingredients:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<String>>(
                future: recipeApi.fetchIngredients(
                    recipesDetail.id, RecipeApi.apiKey),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: snapshot.data!
                            .map((ingredient) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    ingredient,
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ))
                            .toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<String>>(
                future: recipeApi.fetchAnalyzedInstructions(
                    recipesDetail.id, RecipeApi.apiKey),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: snapshot.data!
                            .map((step) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    step,
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ))
                            .toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            FirebaseFirestore.instance
                .collection('users/${user.uid}/savedRecipes')
                .add(recipesDetail.toJson())
                .catchError((e) {
              print(e);
            });
          } else {
            print("User is not signed in.");
          }
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
