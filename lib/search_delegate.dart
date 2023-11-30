import 'package:flutter/material.dart';
import 'package:movie_flix_app/custom_classes.dart';

class MovieSearchDelegate extends SearchDelegate<String> {

  final List movies;

  MovieSearchDelegate({required this.movies});

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for the search bar (e.g., clear text)
    return [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the search bar (e.g., back button)
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show the results based on the query
    return buildSearchResults(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions that appear while typing
    return buildSearchResults(query);
  }

  Widget buildSearchResults(String query) {
    // Build the results based on the query
    final List filteredMovies = movies
        .where((movie) =>
    movie.title.toLowerCase().contains(query.toLowerCase()) ||
        movie.subTitle.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      color: Colors.orange,
      child: ListView.builder(
        itemCount: filteredMovies.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(filteredMovies[index].title),
            subtitle: Text(filteredMovies[index].subTitle),
            leading: Image.network('https://image.tmdb.org/t/p/w200${filteredMovies[index].imageUrl}'),
            onTap: () {
              // Handle the tapped item (optional)
              close(context, filteredMovies[index].title);
            },
          );
        },
      ),
    );
  }
}