import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipes/components/saved_recipe_card.dart';

class SavedScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  void saveRecipe(Map<String, dynamic> recipe) async {
    if (user != null) {
      CollectionReference savedRecipes = FirebaseFirestore.instance
          .collection('users/${user!.uid}/savedRecipes');

      // Add a new document and get its reference
      DocumentReference docRef = await savedRecipes.add(recipe);
      // Log the document ID
      print("Saved recipe with ID: ${docRef.id}");
    } else {
      // Handle the case where the user is not signed in
      print("User is not signed in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      // User is not signed in
      return Scaffold(
        appBar: AppBar(
          title: Text('Saved'),
        ),
        body: Center(
          child: Text('Please sign in to view saved recipes'),
        ),
      );
    }

    CollectionReference savedRecipes = FirebaseFirestore.instance
        .collection('users/${user!.uid}/savedRecipes');

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: savedRecipes.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return RecipeCard(
                title: data['title'],
                imageUrl: data['imageUrl'],
                onTap: () {
                  // Example usage of saveRecipe:
                  // When the card is tapped, save the same recipe again.
                  // In a real app, this would be replaced with the logic you need.
                  saveRecipe(data);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
