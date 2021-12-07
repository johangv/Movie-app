import 'package:card_swiper/card_swiper.dart';
import 'package:cartelera/src/models/movie_model.dart';
import 'package:flutter/material.dart';

class CardSwiper extends StatelessWidget {
  const CardSwiper({Key? key, required this.movies}) : super(key: key);

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    // Usamos el mediaQuery para controlar los tamaños dependiendo del tamaño
    // de pantalla de mi dispositivo
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: Swiper(
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        layout: SwiperLayout.STACK,
        itemBuilder: (BuildContext context, int index) {
          // Este código se implementa para evitar que ayan dos
          // ids iguales y el Hero animation no de errores al aplicar
          // la animación
          movies[index].uniqueId = '${movies[index].id}-cardSwiper';
          return GestureDetector(
            child: Hero(
              tag: movies[index].uniqueId!,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'detail',
                        arguments: movies[index]),
                    child: FadeInImage(
                      placeholder: const AssetImage('assets/img/no-image.jpg'),
                      image: NetworkImage(movies[index].getPosterImg()),
                      fit: BoxFit.cover,
                    ),
                  )),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
