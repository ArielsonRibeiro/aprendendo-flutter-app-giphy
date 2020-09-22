import 'package:flutter/material.dart';
import 'package:visualizador_gifs/pages/home.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        primaryColor: Colors.black,
        backgroundColor: Colors.black,
        accentColor: Colors.purple),

  ));
}
