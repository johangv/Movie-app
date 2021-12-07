import 'dart:async';
import 'dart:convert';

import 'package:cartelera/src/models/actors.dart';
import 'package:cartelera/src/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MovieProvider {
  final _apikey = '9e7da4d1b8740638cd7de07430468f2c';
  final _url = 'api.themoviedb.org';
  final _language = 'es-ES';

  // Creamos un stream para hacer el cambio de páginas en la petición http y
  // conseguir que el scroll de películas populares sea infinito

  // Página inicial de la consulta
  int _popularPage = 0;
  // Este bool va a servir para bloquear el scroll horizontal cuando se
  // empiecen hacer peticiones http para que no se hagan múltiples
  // peticiones
  bool _charging = false;

  List<Movie> _popular = [];

  // Agregamos el broadcast porque queremos que el stream tenga varios listener
  final _popularStreamController = StreamController<List<Movie>>.broadcast();

  // Proceso para introducir películas
  Function(List<Movie>) get popularSink => _popularStreamController.sink.add;

  // Proceso para escuchar u obtener películas
  Stream<List<Movie>> get popularStream => _popularStreamController.stream;

  void disposeStreams() {
    _popularStreamController.close();
  }

  // Método para obtener los datos de la api
  Future<List<Movie>> _processResponse(Uri url) async {
    // Usamos el paquete http para recibir la respuesta
    final response = await http.get(url);
    // Decodificamos le json de la respuesta para convertirlo en String
    final decodedData = json.decode(response.body);

    // El método fromJsonList se va a encargar de barrer cada uno de los objetos
    // que se encuentra en la lista y generar los objetos de tipo Movie con
    // cada uno de sus atributos
    final movies = Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }

  Future<List<Movie>> getInCinemas() async {
    // Objeto de dart para construir la url de mi petición
    final url = Uri.https(_url, '3/movie/now_playing',
        // En esta parte se pueden agregar parámetros adicionales a la url
        {
          'api_key': _apikey,
          'languaje': _language,
        });

    return await _processResponse(url);
  }

  Future<List<Movie>> getPopular() async {
    if (_charging) return [];

    _charging = true;

    _popularPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularPage.toString(),
    });

    final resp = await _processResponse(url);

    // Agrego todo lo obtenido de la consulta http y lo almaceno en mi lista
    // vacía
    _popular.addAll(resp);

    // Uso mi sink para colocar las películas en mi Stream
    popularSink(_popular);

    _charging = false;
    // Todo queda igual a excepción de que ahora se le añadió información al
    // stream por medio de su sink
    return resp;
  }

  // Es un future y no un stream porque los actores son finitos
  Future<List<Actor>> getCast(String movieId) async {
    final url = Uri.https(_url, '3/movie/$movieId/credits', {
      'api_key': _apikey,
      'language': _language,
    });

    final response = await http.get(url);

    // Tomar el body y transformarlo en un mapa
    final decodedData = json.decode(response.body);

    final cast = Cast.fromJsonList(decodedData['cast']);

    return cast.actors;
  }

  // Método para buscar películas por medio del buscador
  Future<List<Movie>> searchMovie(String query) async {
    // Objeto de dart para construir la url de mi petición
    final url = Uri.https(_url, '3/search/movie',
        // En esta parte se pueden agregar parámetros adicionales a la url
        {
          'api_key': _apikey,
          'languaje': _language,
          'query': query,
        });

    return await _processResponse(url);
  }
}
