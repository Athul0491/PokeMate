import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pokemate/shared/shared_methods.dart';

class PokemonType {
  final String name;
  final Color color;
  static const Map<String, Color> colorMap = {
    'Normal': Color(0xFFA8A878),
    'Fire': Color(0xFFF08030),
    'Water': Color(0xFF6890F0),
    'Grass': Color(0xFF78C850),
    'Electric': Color(0xFFF8D030),
    'Ice': Color(0xFF98D8D8),
    'Ground': Color(0xFFE0C068),
    'Flying': Color(0xFFA890F0),
    'Poison': Color(0xFFA040A0),
    'Fighting': Color(0xFFC03028),
    'Psychic': Color(0xFFF85888),
    'Dark': Color(0xFF705848),
    'Rock': Color(0xFFB8A038),
    'Bug': Color(0xFFA8B820),
    'Ghost': Color(0xFF705898),
    'Steel': Color(0xFFB8B8D0),
    'Dragon': Color(0xFF7038F8),
    'Fairy': Color(0xFFFFAEC9)
  };

  const PokemonType._(this.name, this.color);

  PokemonType(this.name) : color = colorMap[name] ?? Colors.red;

  const PokemonType.empty() : this._('empty', Colors.red);

  @override
  String toString() {
    return name.capitalize();
  }
}

class TypeEffect {
  final PokemonType type;
  final double multiplier;

  const TypeEffect({
    this.type = const PokemonType.empty(),
    this.multiplier = 1.0,
  });

  @override
  String toString() {
    return '$type(x$multiplier)';
  }
}

class PokemonJSON {
  final Map<String, dynamic> data;

  PokemonJSON(BuildContext context, String dataStr)
      : data = jsonDecode(dataStr);

  int getID(String name) {
    return data[name.toLowerCase()]['id'] as int;
  }
}

enum InputType { gallery, manual }
