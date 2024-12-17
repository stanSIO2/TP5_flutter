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
                    onTap: (){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MovieDetailScreen(movie:_movies[index]))
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

      print(movies);

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
  String imdbID;

  Movies({required this.title, required this.annee, required this.imdbID});

  factory Movies.fromJson(Map<String, dynamic> json) {
    return Movies(
      title: json['Title'],
      annee: json['Year'],
      imdbID: json['imdbID'],
    );
  }
}

class MovieDetailScreen extends StatefulWidget {
  final Movies movie;
  MovieDetailScreen({required this.movie});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

  class _MovieDetailScreenState extends State<MovieDetailScreen> {
    //TextEditingController _searchController = TextEditingController();
    late Map<String, dynamic> _MovieDetail;
    bool _isLoading = true;

@override
void initState(){
  super.initState();
  _getMovie('');
}
  
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.movie.title ?? 'Details du film'),
        ),
        body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _MovieDetail == null
            ? const Center(child: Text('Erreur de chargement'))
            : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network("${_MovieDetail!['Poster']}"),
                  Text('Titre: ${_MovieDetail!['Title']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 10),
                  Text('Année: ${_MovieDetail!['Year']}'),
                  Text('Genre: ${_MovieDetail!['Genre']}'),
                  Text('Réalisateur: ${_MovieDetail!['Director']}'),
                  Text('Description: ${_MovieDetail!['Plot']}'),
                ],
              ),
            ),
          );
        }

    Future<void> _getMovie(String query) async {
    const apiKey = 'a1a7e3e1';
    final apiUrl = 'http://www.omdbapi.com/?apikey=$apiKey&i=${widget.movie.imdbID}';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        _MovieDetail = json.decode(response.body);
        _isLoading = false;
      });
      final Map<String, dynamic> data = json.decode(response.body);
      //print(data);

      setState(() {
        _isLoading = false;
      });
    }else {
      throw Exception('False to load Movies');
    }
    }
  }

      /*setState(() {
        _movies = movies.map((movie) => Movies.fromJson(movie)).cast<Detail>().toList();
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }
}*/

class Detail {
    String title ="";
    late String annee;
    late String poster;
    late String imdbID;


Detail({required this.title, required this.annee, required this.imdbID, required this.poster});

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      title: json['Title'],
      annee: json['Year'],
      imdbID: json['imdbID'],
      poster: json['poster'],
    );
  }
}