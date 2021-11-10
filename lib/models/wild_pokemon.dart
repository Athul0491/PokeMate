import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/shared/shared_methods.dart';

class WildPokemon {
  String name;
  int cp;
  late PokemonType type1;
  late PokemonType type2;
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
    this.type1 = const PokemonType.empty(),
    this.type2 = const PokemonType.empty(),
    this.weakness = const [],
    this.resistance = const [],
    this.imageUrl = '',
    this.captureRate = 0,
    this.fleeRate = 0,
    this.estimatedLevel = '',
    this.rawTable = const [],
    this.parsedTable = const [],
  });

  WildPokemon.fromAPI({
    required this.name,
    required this.cp,
    required Map<String, dynamic> data,
  }) {
    type1 = PokemonType(data['Types'][0]['0']);
    if ({data['Types'] as List}.length > 1) {
      type2 = PokemonType(data['Types'][1]['1']);
    } else {
      type2 = const PokemonType.empty();
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
    imageUrl = data['img'];
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
    estimatedLevel = getEstimatedLevel()[0]+' - '+getEstimatedLevel()[1];
  }

  @override
  String toString() {
    return '$name - CP$cp, Type: $type1-$type2, Weakness: $weakness, Resistance: $resistance, Flee rate: $fleeRate, captureRate: $captureRate, estLvl: $estimatedLevel';
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
    // Only single element left after search
    return arr[mid];
  }

  List<String> getEstimatedLevel() {
    List<double> left = [];
    List<double> right = [];
    double a = 0, b = 0;
    for (int i = 0; i < parsedTable.length; i++) {
      left.add(parsedTable[i][1]);
      right.add(parsedTable[i][2]);
      a = closest(cp.floorToDouble(), left);
      b = closest(cp.floorToDouble(), right);
    }
    return [a.toString(), b.toString()];
  }
}

var res = {
  "Resistant": [
    {"multiplier": "39.1%", "name": "bug"},
    {"multiplier": "62.5%", "name": "fairy"},
    {"multiplier": "62.5%", "name": "fighting"},
    {"multiplier": "62.5%", "name": "fire"},
    {"multiplier": "39.1%", "name": "grass"},
    {"multiplier": "62.5%", "name": "ground"},
    {"multiplier": "62.5%", "name": "steel"}
  ],
  "Types": [
    {"0": "Fire"},
    {"1": "Flying"}
  ],
  "Vulnerable": [
    {"multiplier": "160%", "name": "electric"},
    {"multiplier": "256%", "name": "rock"},
    {"multiplier": "160%", "name": "water"}
  ],
  "img":
      "https://gamepress.gg//pokemongo/sites/pokemongo/files/styles/240w/public/2018-01/pokemon_icon_006_00.png?itok=cPIsdKn6",
  "rates": {"capture rate": "5.0 %", "flee rate": "5.0 %"},
  "table": [
    ["Level", "Min CP", "Max CP"],
    ["1", "35", "40"],
    ["1.5", "73", "84"],
    ["2", "110", "128"],
    ["2.5", "148", "171"],
    ["3", "186", "215"],
    ["3.5", "223", "258"],
    ["4", "261", "302"],
    ["4.5", "299", "346"],
    ["5", "336", "389"],
    ["5.5", "374", "433"],
    ["6", "412", "476"],
    ["6.5", "450", "520"],
    ["7", "487", "564"],
    ["7.5", "525", "607"],
    ["8", "563", "651"],
    ["8.5", "600", "695"],
    ["9", "638", "738"],
    ["9.5", "676", "782"],
    ["10", "714", "825"],
  ]
};
