import 'package:flutter/material.dart';

Widget imageDownloadDialog(String res) {
  return Card(
    color: Colors.transparent,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const CircularProgressIndicator(),
        const SizedBox(height: 20.0),
        Text(
          "Downloading File : $res",
          style: const TextStyle(color: Colors.white),
        )
      ],
    ),
  );
}