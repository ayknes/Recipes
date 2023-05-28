import 'package:flutter/material.dart';
import 'package:recipes/api/recipe_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeDetail {
  final int id;
  final String title;
  final String description;
  final String image;
  final String ingredients;

  RecipeDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.ingredients,
  });

  Map<String, dynamic> toJson() {
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
  final RecipeDetail recipeDetail;
  final RecipeApi recipeApi = RecipeApi();

  DetailScreen({Key? key, required this.recipeDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeDetail.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              recipeDetail.image,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                recipeDetail.title,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                recipeDetail.description,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Ingredients:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8.0),
            FutureBuilder<List<String>>(
              future: recipeApi.fetchIngredients(
                recipeDetail.id,
                RecipeApi.apiKey,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: snapshot.data!
                          .map((ingredient) => Padding(
                                padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  '• $ingredient',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ))
                          .toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Instructions:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8.0),
            FutureBuilder<List<String>>(
              future: recipeApi.fetchAnalyzedInstructions(
                recipeDetail.id,
                RecipeApi.apiKey,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: snapshot.data!
                          .map((step) => Padding(
                                padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  '• $step',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ))
                          .toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
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
                .add(recipeDetail.toJson())
                .then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Recipe saved successfully!')),
              );
            }).catchError((e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error saving recipe.')),
              );
              print(e);
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please sign in to save recipes.')),
            );
            print("User is not signed in.");
          }
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
