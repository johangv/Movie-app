import 'package:cartelera/src/models/actors.dart';
import 'package:cartelera/src/models/movie_model.dart';
import 'package:cartelera/src/providers/movies_provider.dart';
import 'package:flutter/material.dart';

class MovieDetail extends StatelessWidget {
  const MovieDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // La notación para recibir argumentos usando el pushNamed para la
    // navegación es esta
    final movie = ModalRoute.of(context)!.settings.arguments as Movie;
    print(movie.posterPath);
    return Scaffold(
      body: CustomScrollView(
        // Widgets que interactuan con el scroll
        slivers: <Widget>[
          _createAppBar(movie),
          // Esto es como un ListView que pertenece a un Sliver
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(height: 10.0),
            _posterTitle(movie, context),
            _description(movie),
            _description(movie),
            _description(movie),
            _createCasting(movie),
          ])),
        ],
      ),
    );
  }

  Widget _createAppBar(Movie movie) {
    // Appbar que interactua con el scroll
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Color(0xff0ac9e8),
      // Que tan ancho se quiere que sea
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      // Widget que se adapta en el appbar
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          movie.title!,
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/img/loading.gif'),
          image: NetworkImage(movie.getBackgroundImg()),
          fadeInDuration: const Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  _posterTitle(Movie movie, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            // Se usa el uniqueId para que tome el id que se está
            // enviando para cada animación
            tag: movie.uniqueId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(movie.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                movie.title!,
                style: Theme.of(context).textTheme.headline6,
                overflow: TextOverflow.ellipsis,
              ),
              Text(movie.originalTitle!,
                  style: Theme.of(context).textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis),
              Row(
                children: <Widget>[
                  const Icon(Icons.star_border),
                  Text(movie.voteAverage.toString(),
                      style: Theme.of(context).textTheme.subtitle1)
                ],
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _description(Movie movie) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        movie.overview!,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _createCasting(Movie movie) {
    final movieProvider = MovieProvider();

    return FutureBuilder(
      future: movieProvider.getCast(movie.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _createActorsView(snapshot.data!);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createActorsView(List actors) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
          pageSnapping: false,
          controller: PageController(viewportFraction: 0.3, initialPage: 1),
          itemCount: actors.length,
          itemBuilder: (context, i) => _actorCard(actors[i])),
    );
  }

  Widget _actorCard(Actor actor) {
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
            placeholder: const AssetImage('assets/img/no-image.jpg'),
            image: NetworkImage(actor.getPhoto()),
            height: 150.0,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          actor.name!,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
