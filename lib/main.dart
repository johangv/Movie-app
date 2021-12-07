import 'package:cartelera/src/pages/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:cartelera/src/pages/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cartelera de películas',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'detail': (BuildContext context) => const MovieDetail(),
      },
    );
  }
}
