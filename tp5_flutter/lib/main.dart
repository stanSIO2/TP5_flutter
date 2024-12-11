import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OMDb API Demo',
      home: MovieListScreen(),
    );
  }
}

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Movies> _movies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OMDb Movie Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Search Movies'),
              onSubmitted: (value) {
                _searchMovies(value);
              },
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_movies[index].title),
                    subtitle: Text(_movies[index].annee),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchMovies(String query) async {
    const apiKey = 'a1a7e3e1';
    final apiUrl = 'http://www.omdbapi.com/?apikey=$apiKey&s=$query';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      print(data);
      final List<dynamic> movies = data['Search'];


      print("rhefjcbherfnhelz");
      print(movies);
      print("rhefjcbherfnhelz");

      setState(() {
        _movies = movies.map((movie) => Movies.fromJson(movie)).toList();
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }
}

class Movies {
  String title ="";
  String annee;

  Movies({required this.title, required this.annee});

  factory Movies.fromJson(Map<String, dynamic> json) {
    return Movies(
      title: json['Title'],
      annee: json['Year'],
    );
  }
}

/*class MovieDetailScreen extends StatefulWidget {
  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Detail> _movies = [];
  
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.Movies.title ?? 'Details du film'),
        ),
        body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _MovieDetailScreen == null
            ? Center(child: Text('Erreur de chargement'))
            : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Titre: ${_MovieDetailScreen!['Title']}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold)
                  ),
                  SizedBox(height: 10),
                  Text('Année: ${_MovieDetailScreen!['Year']}'
                  ),
                ],
              ),
            ),
          );
        }

    Future<void> _searchMovies(String query) async {
    const apiKey = 'a1a7e3e1';
    final apiUrl = 'http://www.omdbapi.com/?apikey=$apiKey&s=$query';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      print(data);
      final List<dynamic> movies = data['Search'];


      print("rhefjcbherfnhelz");
      print(movies);
      print("rhefjcbherfnhelz");

      setState(() {
        _movies = movies.map((movie) => Movies.fromJson(movie)).toList();
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }
}

  class Detail {
    String title ="";
    late String annee;
    String poster;
}

Movies({required this.title, required this.annee, , required this.description});

  factory Movies.fromJson(Map<String, dynamic> json) {
    return Movies(
      title: json['Title'],
      annee: json['Year'],
      affiche: json['poster']
    );
  }
}*/