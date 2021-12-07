import 'package:cartelera/src/models/movie_model.dart';
import 'package:flutter/material.dart';

class MovieHorizontal extends StatelessWidget {
  MovieHorizontal({Key? key, required this.movies, required this.nextPage})
      : super(key: key);

  final List<Movie> movies;
  final Function nextPage;
  final _pageController = PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return SizedBox(
      // Obtenemos el 20% del tamaño total de la pantalla
      height: _screenSize.height * 0.2,
      // Este widget sirve para deslizar como páginas o portadas, es un
      // tipo de carrusel, el .builder sirve para que renderize solo los
      // elementos necesarios
      child: PageView.builder(
        // Creamos el controlador del pageView para definir una página
        // inicial y la cantidad de imágenes que se van a mostrar en
        // la pantalla al mismo tiempo
        controller: _pageController,
        // Al poner en falso esta propiedad el movimiento es más fluido
        pageSnapping: false,
        itemCount: movies.length,
        itemBuilder: (context, i) {
          return _card(context, movies[i]);
        },
      ),
    );
  }

  Widget _card(BuildContext context, Movie movie) {
    // Este código se implementa para evitar que ayan dos
    // ids iguales y el Hero animation no de errores al aplicar
    // la animación
    movie.uniqueId = '${movie.id}-cardPopular';

    final movieCard = Container(
      margin: const EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: const AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(movie.getPosterImg()),
                fit: BoxFit.cover,
                height: 130.0,
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            movie.title!,
            textAlign: TextAlign.center,
            // Para que se agreguen 3 puntos suspensivos cuando el texto se
            // desborde
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: movie);
      },
      child: movieCard,
    );
  }
}
