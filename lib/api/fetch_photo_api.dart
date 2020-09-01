import 'dart:convert';
import 'package:images/models/photo.dart';
import 'package:http/http.dart' as http;

//API Photo base URL
const apiPhotoPexels = "https://api.pexels.com/v1/search?query=people";

//Your API Key
const apiKey = "563492ad6f91700001000001f665b79ee4eb49aaa75e1db515ac2dc2";

Future<void> getPhotoFromPexels(
    {Function(List<Photos>) onSuccess, Function(String) onError}) async {

      //Create list for Photos
      List<Photos> photos = List();

      //Use plugin Http fetch data from API
      http.Response response = await http.get(apiPhotoPexels, headers: {"Authorization": apiKey});

      //Check statusCode. 200 is success
      if(response.statusCode == 200){
        try{
        
        //Parce
        dynamic parceJSON = json.decode(response.body);

        //Create list for JSON soon parce
        List<dynamic> data = parceJSON["resuls"];

        data.forEach((element) {
          photos.add(Photos.fromJSON(element));
        });
        } catch(e) {
          onError("Something wrong!!!");
        }
      } else {
        onError("Something get wrong! Status code ${response.statusCode}");
      }

      return photos;
    }
