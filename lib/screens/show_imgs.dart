import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:images/api/fetch_photo_api.dart';
import 'package:images/models/global.dart';
import 'package:images/models/photo.dart';

class ShowWallpapers extends StatefulWidget {
  @override
  _ShowWallpapersState createState() => _ShowWallpapersState();
}

class _ShowWallpapersState extends State<ShowWallpapers> {

  //Create list with ag Photo
  List<Photos> photos = List();

  Future<void> getWallpapers() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await getPhotoFromPexels(onSuccess: (value){
        setState(() {
          photos = value;
        });
      }, onError: (msg) {
        print(msg);
      },);
    });
  }

  getWallpaper() async {
    await http.get("https://api.pexels.com/v1/search", headers: {
      "Authorization":
          "563492ad6f91700001000001f665b79ee4eb49aaa75e1db515ac2dc2"
    }).then((res) {
      // print(res.body);
      var parsedJson = jsonDecode(res.body);
      Global.photos = (parsedJson["photos"] as List)
          .map((data) => Photos.fromJSON(data))
          .toList();
    });
    setState(() {});
  }

  void initState(){
    super.initState();
    getWallpaper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Wallpapers'),
        elevation: 5.0,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).pushNamed('SearchBar');
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: GridView.builder(
          itemCount: Global.photos.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 0.8),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Global.index = index;
                Navigator.of(context).pushNamed('FullImage');
              },
              child: Hero(
                tag: '$index',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      image: NetworkImage(
                        Global.photos[index].src.tiny,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}