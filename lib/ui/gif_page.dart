import 'package:flutter/material.dart';
//import 'package:share_plus/share_plus.dart';

class GifPage extends StatelessWidget {
  const GifPage({super.key, required this.gifData});

  final Map gifData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //actions: [
        //IconButton(
        //   onPressed: () {
        //  Share.share(gifData["images"]["fixed_height"]["url"]);
        //   },
        //icon: const Icon(Icons.share))
        //],
        foregroundColor: Colors.white,
        title: Text(
          gifData["title"],
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
