import 'package:cartelera/src/models/movie_model.dart';
import 'package:cartelera/src/providers/movies_provider.dart';
import 'package:cartelera/src/search/search_delegate.dart';
import 'package:cartelera/src/widgets/card_swiper_widget.dart';
import 'package:cartelera/src/widgets/movie_horizontal.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final movieProvider = MovieProvider();

  @override
  Widget build(BuildContext context) {
    // Esto me retorna el listado del future, a su vez también ejecuta el
    // sink
    movieProvider.getPopular();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas en cartelera'),
        backgroundColor: Color(0xff0ac9e8),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
              );
              // Este texto es el que queremos que esté pregargado
              // en el buscador
              //query: 'Hola');
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[_swiperTarjetas(), _footer(context)],
      ),
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: movieProvider.getInCinemas(),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(movies: snapshot.data!);
        } else {
          return const SizedBox(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Populares',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          const SizedBox(height: 10.0),
          // El streambuilder se va a ejecutar cada vez que se emita un valor en
          // el stream
          StreamBuilder(
            stream: movieProvider.popularStream,
            builder:
                (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  movies: snapshot.data!,
                  nextPage: movieProvider.getPopular,
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
