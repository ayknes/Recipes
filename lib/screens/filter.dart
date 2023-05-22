import 'package:flutter/material.dart';

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
            title: Text('Aggregate Likes'),
            trailing: Text(_aggregateLikes.toString()),
            onTap: () {
              // Add your logic to filter by Aggregate Likes here.
            },
          ),
          ListTile(
            title: Text('Health Score'),
            trailing: Text(_healthScore.toString()),
            onTap: () {
              // Add your logic to filter by Health Score here.
            },
          ),
          ListTile(
            title: Text('Spoonacular Score'),
            trailing: Text(_spoonacularScore.toString()),
            onTap: () {
              // Add your logic to filter by Spoonacular Score here.
            },
          ),
          ListTile(
            title: Text('Ready In Minutes'),
            trailing: Text(_readyInMinutes.toString()),
            onTap: () {
              // Add your logic to filter by Ready In Minutes here.
            },
          ),
          ListTile(
            title: Text('Price Per Serving'),
            trailing: Text(_pricePerServing.toString()),
            onTap: () {
              // Add your logic to filter by Price Per Serving here.
            },
          ),
        ],
      ),
    );
  }
}
