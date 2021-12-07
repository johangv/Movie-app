// Información relacionada a todos los objetos de tipo película.

// La respuesta envía una lista de películas, lo que hace necesario tener una
// clase películas que contenga todas esas películas
class Movies {
  List<Movie> items = [];

  Movies();

  // Cuando se lee un json es mejor usar datos de tipo dynamic para evitar
  // errores
  Movies.fromJsonList(List<dynamic> jsonList) {
    // Recorremos la lista dinámica de peliculas usando un ciclo for
    for (var item in jsonList) {
      // Decimos que cada item de esta lista es una pelicula
      final movie = Movie.fromJsonMap(item);
      // Agregamos la película a la lista items que se definió en la clase
      items.add(movie);
    }
  }
}

class Movie {
  String? uniqueId;

  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  int? id;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  bool? video;
  double? voteAverage;
  int? voteCount;

  Movie({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  Movie.fromJsonMap(Map<String, dynamic> json) {
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    // A este se le tiene que hacer un cast a int
    genreIds = json['genre_ids'].cast<int>();
    id = json['id'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity'] / 1;
    posterPath = json['poster_path'];
    releaseDate = json['release_date'];
    title = json['title'];
    video = json['video'];
    // Aveces en la respuesta se envía un entero, entonces lo dividimos entre 1
    // para que siempre sea un double
    voteAverage = json['vote_average'] / 1;
    voteCount = json['vote_count'];
  }

  getPosterImg() {
    if (posterPath == null) {
      return 'https://lasd.lv/public/assets/no-image.png';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
    }
  }

  getBackgroundImg() {
    if (backdropPath == null) {
      return 'https://lasd.lv/public/assets/no-image.png';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$backdropPath';
    }
  }
}
