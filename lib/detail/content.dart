import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:wallpaper_sample_app/detail/widget/downloading_dialog.dart';

class DetailScreen extends StatefulWidget {
  final String imgPath;
  final String downloadPath;
  final String photographer;

  DetailScreen(
      {required this.imgPath,
      required this.downloadPath,
      required this.photographer});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Stream<String> _progressString;
  late String _res;
  bool _downloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.imgPath,
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.network(widget.imgPath, fit: BoxFit.cover)),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _downloading
                    ? imageDownloadDialog(_res)
                    : InkWell(
                        onTap: () {
                          _setWallpaper(context);
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xff1C1B1B).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white24, width: 1),
                                    borderRadius: BorderRadius.circular(40),
                                    gradient: const LinearGradient(
                                        colors: [
                                          Color(0x36FFFFFF),
                                          Color(0x0FFFFFFF)
                                        ],
                                        begin: FractionalOffset.topLeft,
                                        end: FractionalOffset.bottomRight)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Text(
                                      "Set as Wallpaper",
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Text(
                                      "Image will be set as wallpaper",
                                      style: TextStyle(
                                          fontSize: 8, color: Colors.white70),
                                    ),
                                  ],
                                )),
                          ],
                        )),
                const SizedBox(height: 4),
                InkWell(
                    onTap: _downloading
                        ? null
                        : () {
                            _save();
                            Navigator.pop(context);
                          },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xff1C1B1B).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white24, width: 1),
                                borderRadius: BorderRadius.circular(40),
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0x36FFFFFF),
                                      Color(0x0FFFFFFF)
                                    ],
                                    begin: FractionalOffset.topLeft,
                                    end: FractionalOffset.bottomRight)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text(
                                  "Save Wallpaper",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  "Image will be saved in gallery",
                                  style: TextStyle(
                                      fontSize: 8, color: Colors.white70),
                                ),
                              ],
                            )),
                      ],
                    )),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    _downloading ? null : Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsetsDirectional.only(top: 60.0, end: 12.0),
            alignment: Alignment.topRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 3.5,
                      height: 41,
                      decoration: BoxDecoration(
                        color: const Color(0xff1C1B1B).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3.5,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white24, width: 1),
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                              colors: [Color(0x36FFFFFF), Color(0x0FFFFFFF)],
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Photographer:",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Text(
                            widget.photographer,
                            style: const TextStyle(
                                fontSize: 8, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _save() async {
    await _askPermission();
    var response = await Dio().get(
      widget.imgPath,
      options: Options(responseType: ResponseType.bytes),
    );
    var result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100);
  }

  _setWallpaper(BuildContext context) async {
    _downloading = true;
    _progressString = Wallpaper.imageDownloadProgress(widget.downloadPath);
    _progressString.listen((data) {
      setState(() {
        _res = data;
        _downloading = true;
      });
    }, onDone: () async {
      setState(() {
        _downloading = false;
        _setAsWallpaper();
        Navigator.pop(context);
      });
    }, onError: (error) {
      setState(() {
        _downloading = false;
      });
    });
  }

  _setAsWallpaper() async {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    await Wallpaper.homeScreen(
        options: RequestSizeOptions.RESIZE_FIT, width: width, height: height);
    setState(() {
      _downloading = false;
    });
  }

  _askPermission() async {
    if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted) {}
    } else {
      if (await Permission.storage.request().isGranted) {}
    }
  }
}
