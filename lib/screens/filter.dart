import 'package:flutter/material.dart';
import 'package:recipes/api/recipe_api.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  bool _vegetarian = false;
  bool _vegan = false;
  double _aggregateLikes = 0;
  double _healthScore = 0;
  double _spoonacularScore = 0;
  double _readyInMinutes = 0;
  double _pricePerServing = 0;

  void _searchRecipes() async {
    RecipeApi api = RecipeApi();

    var recipes = await api.searchRecipes('',
        vegetarian: _vegetarian,
        vegan: _vegan,
        aggregateLikes: _aggregateLikes.round(),
        healthScore: _healthScore.round(),
        spoonacularScore: _spoonacularScore.round(),
        readyInMinutes: _readyInMinutes.round(),
        pricePerServing: _pricePerServing.round());

    print(
        recipes); // Just for debugging, do whatever you want with the recipes.
  }

  void _applyFilters() {
    setState(() {
      _vegetarian = _vegetarian;
      _vegan = _vegan;
      _aggregateLikes = _aggregateLikes;
      _healthScore = _healthScore;
      _spoonacularScore = _spoonacularScore;
      _readyInMinutes = _readyInMinutes;
      _pricePerServing = _pricePerServing;
    });
    print('vegetarian: $_vegetarian');
    print('vegan: $_vegan');
    print('healthScore: $_healthScore');

    _searchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Filter')),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text('Vegetarian'),
            value: _vegetarian,
            onChanged: (bool value) {
              setState(() {
                _vegetarian = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Vegan'),
            value: _vegan,
            onChanged: (bool value) {
              setState(() {
                _vegan = value;
              });
            },
          ),
          ListTile(
            title: Text('Aggregate Likes: ${_aggregateLikes.round()}'),
            trailing: Container(
              width: 200, // You can adjust the width as needed
              child: Slider(
                min: 0,
                max: 100,
                value: _aggregateLikes,
                onChanged: (double value) {
                  setState(() {
                    _aggregateLikes = value;
                  });
                },
              ),
            ),
          ),
          ListTile(
            title: Text('Health Score: ${_healthScore.round()}'),
            trailing: Container(
              width: 200, // You can adjust the width as needed
              child: Slider(
                min: 0,
                max: 100,
                value: _healthScore,
                onChanged: (double value) {
                  setState(() {
                    _healthScore = value;
                  });
                },
              ),
            ),
          ),
          ListTile(
            title: Text('Spoonacular Score: ${_spoonacularScore.round()}'),
            trailing: Container(
              width: 200, // You can adjust the width as needed
              child: Slider(
                min: 0,
                max: 100,
                value: _spoonacularScore,
                onChanged: (double value) {
                  setState(() {
                    _spoonacularScore = value;
                  });
                },
              ),
            ),
          ),
          ListTile(
            title: Text('Ready In Minutes: ${_readyInMinutes.round()}'),
            trailing: Container(
              width: 200, // You can adjust the width as needed
              child: Slider(
                min: 0,
                max: 120,
                value: _readyInMinutes,
                onChanged: (double value) {
                  setState(() {
                    _readyInMinutes = value;
                  });
                },
              ),
            ),
          ),
          ListTile(
            title: Text('Price Per Serving: ${_pricePerServing.round()}'),
            trailing: Container(
              width: 200, // You can adjust the width as needed
              child: Slider(
                min: 0,
                max: 100,
                value: _pricePerServing,
                onChanged: (double value) {
                  setState(() {
                    _pricePerServing = value;
                  });
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _applyFilters,
            child: Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
