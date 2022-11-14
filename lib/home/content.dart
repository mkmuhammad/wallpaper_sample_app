import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wallpaper_sample_app/home/widget/wallpaper.dart';
import 'package:wallpaper_sample_app/models/photos_model.dart';
import 'package:wallpaper_sample_app/util/consts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int noOfImageToLoad = 80;
  int noOfPage = 1;
  List<PhotosModel> photos = [];

  @override
  void initState() {
    _fetchPhotos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: WallPaper(photos, context),
        ),
      ),
    );
  }

  _fetchPhotos() async {
    await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/curated?per_page=$noOfImageToLoad&page=$noOfPage"),
        headers: {"Authorization": API_KEY}).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      jsonData["photos"].forEach((element) {
        photos.add(PhotosModel.fromMap(element));
      });
      setState(() {});
    });
  }
}
