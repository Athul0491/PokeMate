import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemate/models/pokemon_pvp.dart';
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

  PokemonType(String name)
      : color = colorMap[name.capitalize()] ?? Colors.red,
        name = name.capitalize();

  const PokemonType.empty() : this._('empty', Colors.red);

  @override
  String toString() {
    return name;
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

  PokemonJSON(String dataStr) : data = jsonDecode(dataStr);

  int getID(String name) {
    print(name);
    return data[name.toLowerCase()]['id'] as int;
  }

  List<PokemonType> getTypes(String name) {
    return [
      for (String type in data[name.toLowerCase()]['types']) PokemonType(type)
    ];
  }

  String getImage(String name) {
    return data[name.toLowerCase()]['image'] as String;
  }
}

class PVPMovesJSON {
  final Map<String, dynamic> data;

  PVPMovesJSON(String dataStr) : data = jsonDecode(dataStr);

  PVPMove getMoveSet(String id) {
    return PVPMove(
      name: data[id]['name'],
      type: PokemonType(data[id]['type']),
      archetype: data[id]['archetype'],
    );
  }
}

enum InputType { gallery, manual }

class PokemonTypeList extends StatelessWidget {
  final List<PokemonType> types;

  const PokemonTypeList({
    Key? key, required this.types,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.w,
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: types.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          PokemonType type = types[index];
          return Container(
            height: 20.w,
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 2.w),
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color: type.color,
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: Text(
              type.name,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }
}
