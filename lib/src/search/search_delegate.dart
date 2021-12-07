import 'package:cartelera/src/models/movie_model.dart';
import 'package:cartelera/src/providers/movies_provider.dart';
import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate {
  String selection = '';

  final movieProvider = MovieProvider();

  final movies = [
    'Spiderman',
    'Aquaman',
    'Los Vengadores',
    'Shazam',
    'Doctor Strange',
    'Ironman',
  ];

  final recentMovies = ['Spiderman', 'Capitán América'];

  @override
  String get searchFieldLabel => 'Buscar...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    // Son las acciones que va a tener el appbar en el modo de búsqueda
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: query != '' ? const Icon(Icons.clear) : Container())
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // Icono a la izquierda del appbar
    return IconButton(
      onPressed: () {
        // Método integrado en el search para cerrarlo
        close(context, null);
      },
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // La instrucción que crea los resultados que se van a mostrar
    return const Center();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: movieProvider.searchMovie(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          final movies = snapshot.data;

          return ListView(
            children: movies!.map((movie) {
              return ListTile(
                leading: FadeInImage(
                  placeholder: const AssetImage('assets/img/no-image.jpg'),
                  image: NetworkImage(movie.getPosterImg()),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(movie.title!),
                subtitle: Text(movie.releaseDate!),
                onTap: () {
                  // Cerramos la búsqueda
                  close(context, null);
                  movie.uniqueId = '${movie.id} search';
                  Navigator.pushNamed(context, 'detail', arguments: movie);
                },
              );
            }).toList(),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Son las sugerencias que aparecen mientras la persona escribe

  //   final suggestedList = (query.isEmpty)
  //       ? recentMovies
  //       // Retornar las películas que cumplen con la condición de lo que la
  //       // persona escribió en el buscador
  //       : movies
  //           .where(
  //               (movie) => movie.toLowerCase().startsWith(query.toLowerCase()))
  //           .toList();

  //   return ListView.builder(
  //     itemCount: suggestedList.length,
  //     itemBuilder: (context, index) {
  //       return ListTile(
  //         leading: const Icon(Icons.movie),
  //         title: Text(suggestedList[index]),
  //         onTap: () {
  //           selection = suggestedList[index];
  //           // Construye los resultados del item seleccionado
  //           showResults(context);
  //         },
  //       );
  //     },
  //   );
  // }
}
