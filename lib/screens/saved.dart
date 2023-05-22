import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:recipes/components/saved_recipe_card.dart';

class SavedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference recipes =
        FirebaseFirestore.instance.collection('recipes');

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: recipes.snapshots(),
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
                  // Handle tap event
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
