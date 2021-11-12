import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/shared/shared_methods.dart';

class WildPokemon {
  final String name;
  final int cp;
  late List<PokemonType> types;
  late List<TypeEffect> weakness;
  late List<TypeEffect> resistance;
  late String imageUrl;
  late double captureRate;
  late double fleeRate;
  late String estimatedLevel;
  late List<dynamic> rawTable;
  late List<List<double>> parsedTable;

  WildPokemon({
    this.name = '',
    this.cp = 0,
  });

  WildPokemon.fromAPI({
    required this.name,
    required this.cp,
    required Map<String, dynamic> data,
    required PokemonJSON pokemonJSON,
  }) {
    types = [];
    for (int i = 0; i < (data['Types'] as List).length; i++) {
      types.add(PokemonType(data['Types'][i]['$i']));
    }
    weakness = [];
    for (var type in data['Vulnerable']) {
      String multiplier = type['multiplier'] ?? '0%';
      String name = type['name'] ?? 'Normal';
      multiplier = multiplier.substring(0, multiplier.length - 1);
      weakness.add(TypeEffect(
        type: PokemonType(name.capitalize()),
        multiplier: double.tryParse(multiplier)!,
      ));
    }
    resistance = [];
    for (var type in data['Resistant']) {
      String multiplier = type['multiplier'] ?? '0%';
      String name = type['name'] ?? 'Normal';
      multiplier = multiplier.substring(0, multiplier.length - 1);
      resistance.add(TypeEffect(
        type: PokemonType(name.capitalize()),
        multiplier: double.tryParse(multiplier)!,
      ));
    }
    imageUrl = pokemonJSON.getImage(name);
    String capRate = data['rates']['capture rate'];
    captureRate =
        double.tryParse(capRate.substring(0, capRate.length - 2)) ?? 0;
    String fRate = data['rates']['flee rate'];
    fleeRate = double.tryParse(fRate.substring(0, fRate.length - 2)) ?? 0;
    rawTable = data['table'];
    parsedTable = [];
    for (int i = 1; i < rawTable.length; i++) {
      var e = rawTable[i];
      parsedTable.add([
        double.tryParse(e[0]) ?? 0,
        double.tryParse(e[1]) ?? 0,
        double.tryParse(e[2]) ?? 0
      ]);
    }
    estimatedLevel = getEstimatedLevel()[0] + ' - ' + getEstimatedLevel()[1];
  }

  @override
  String toString() {
    return '$name - CP$cp, Type: $types, Weakness: $weakness, Resistance: $resistance, Flee rate: $fleeRate, captureRate: $captureRate, estLvl: $estimatedLevel';
  }

  double getClosest(double val1, double val2, double target) {
    if (target - val1 >= val2 - target) {
      return val2;
    } else {
      return val1;
    }
  }

  double closest(double target, List<double> arr) {
    int n = arr.length;
    // Corner cases
    if (target <= arr[0]) {
      return arr[0];
    }
    if (target >= arr[n - 1]) {
      return arr[n - 1];
    }
    // Doing binary search
    int i = 0;
    int j = n, mid = 0;
    while (i < j) {
      mid = (i + j) ~/ 2;
      if (arr[mid] == target) {
        return arr[mid];
      }
      if (target < arr[mid]) {
        if (mid > 0 && target > arr[mid - 1]) {
          return getClosest(arr[mid - 1], arr[mid], target);
        }
        j = mid;
      } else {
        if (mid < n - 1 && target < arr[mid + 1]) {
          return getClosest(arr[mid], arr[mid + 1], target);
        }
        i = mid + 1;
      }
    }
    return arr[mid];
  }

  int binarySearch(arr, val) {
    int start = 0;
    int end = arr.length - 1;
    while (start <= end) {
      int mid = (start + end) ~/ 2;
      if (arr[mid] == val) {
        return mid;
      }
      if (val < arr[mid]) {
        end = mid - 1;
      } else {
        start = mid + 1;
      }
    }
    return -1;
  }

  List<String> getEstimatedLevel() {
    List<double> left = [];
    List<double> right = [];
    List<double> level = [];
    double a = 0, b = 0;
    int c = 0, d = 0;
    for (int i = 0; i < parsedTable.length; i++) {
      left.add(parsedTable[i][1]);
      right.add(parsedTable[i][2]);
      level.add(parsedTable[i][0]);
      a = closest(cp.floorToDouble(), left);
      b = closest(cp.floorToDouble(), right);
      c = binarySearch(left, a);
      d = binarySearch(right, b);
    }
    return [level[c].toString(), level[d].toString()];
  }
}

