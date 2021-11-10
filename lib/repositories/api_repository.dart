import 'dart:convert';
import 'package:http/http.dart';
import 'package:pokemate/shared/shared_methods.dart';

class APIRepository {
  final Client _client = Client();
  String url = 'pokemate01.herokuapp.com';

  void getLeaguePVPInfo(String name, String league) async {
    Response response = await _client.get(
      Uri.https(
        url,
        "/api/$league-league",
        {
          'Pokemon': name.capitalize(),
        },
      ),
    );
    Map data = jsonDecode(response.body);
    print(data);
  }

  Future<Map<String, dynamic>?> getWildPokemonInfo(int id) async {
    Response response = await _client.get(Uri.https(
      url,
      '/api/wild',
      {'id': id.toString()},
    ));
    if(response.statusCode==200){
      var data = jsonDecode(response.body);
      print(data);
      return data;
    } else {
      return null;
    }
  }

  void getPVPInfo() {}

  String getPokemonImage(String name) {
    return '';
  }
}

// Client _client = Client();
// // webscraping
// Response response = await _client.get(
// Uri.http("athul0491.pythonanywhere.com","/api/$query")
// );

// Response response = await _client.get(
//   Uri.https('api.edamam.com', '/search',
//   {
//     'app_id': '09d2d618',
//     'app_key': '27642983d5b23a813598dfd96c727778',
//     'q': query
//   })
// );
//
// rapid api nutritionix
// Response response = await _client
//     .get(Uri.https("nutritionix-api.p.rapidapi.com", "/v1_1/search/$query",
//     {"fields": "item_name,item_id,brand_name,nf_calories,nf_total_fat,nf_total_carbohydrate,nf_protein",
//       "limit": "5"}),
//     headers: {
//       "x-rapidapi-key": apiKey,
//       "x-rapidapi-host": "nutritionix-api.p.rapidapi.com",
//     }
// );
// webscraping
// Response response = await _client.get(
//   Uri.http("athul0491.pythonanywhere.com","/$query")
// );
// Nutritionix
// Response response = await _client
//     .post(Uri.https("trackapi.nutritionix.com", "/v2/natural/nutrients",
//     {
//       "fields": "item_name,item_id,brand_name,nf_calories,nf_total_fat,nf_total_carbohydrate,nf_protein",
//       "limit": "5"
//     }),
//     body: {
//       "query" : query,
//     },
//     headers: {
//       "x-app-id": "df24937b",
//       "x-app-key": "cd83b97fdf4bd32131ddc36e97e0bf12",
//       "x-remote-user-id": "0",
//     }
// );
// Response response = await get("https://nutritionix-api.p.rapidapi.com/v1_1/search/$foodName?fields=item_name%2Citem_id%2Cbrand_name%2Cnf_calories%2Cnf_total_fat%2Cnf_total_carbohydrate%2Cnf_protein",
//     headers: {
//       "x-rapidapi-key": "9b837a32d8mshd72f108cc18a5ebp160760jsnc13d929cb7fd",
//       "x-rapidapi-host": "nutritionix-api.p.rapidapi.com"
//     }
// );
// Map data = jsonDecode(response.body);
