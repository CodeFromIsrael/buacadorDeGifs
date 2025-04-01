import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projeto3/ui/gif_page.dart';
//import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String search = "";
  int offset = 0;
  List gifs = [];

  final ScrollController scrollController = ScrollController();

  Future<void> getGifs() async {
    try {
      String url;
      if (search.isEmpty) {
        url =
            "https://api.giphy.com/v1/gifs/trending?api_key=HOSIJqEUyMHImYdbQgJMsNmz7wnr3w1u&limit=20&offset=$offset&rating=g&bundle=messaging_non_clips";
      } else {
        url =
            "https://api.giphy.com/v1/gifs/search?api_key=HOSIJqEUyMHImYdbQgJMsNmz7wnr3w1u&q=$search&limit=20&offset=$offset&rating=g&lang=en&bundle=messaging_non_clips";
      }
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      setState(() {
        if (offset == 0) {
          gifs = data["data"];
        } else {
          gifs.addAll(data["data"]);
        }
        offset += 20;
      });
    } catch (e) {
      log("Erro ao buscar GIFs: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getGifs();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        log("Passou aqui");
        getGifs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              labelText: "Pesquise Aqui",
              labelStyle: TextStyle(color: Colors.white),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 15),
            textAlign: TextAlign.center,
            onSubmitted: (text) {
              setState(() {
                search = text;
                offset = 0;
              });
              getGifs();
            },
          ),
        ),
        Expanded(
          child: gifs.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : createGifTable(),
        ),
      ]),
    );
  }

  Widget createGifTable() {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      controller: scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: gifs.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Image.network(
            gifs[index]["images"]["fixed_height"]["url"],
            height: 300,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GifPage(
                          gifData: gifs[index],
                        )));
          },
          // onLongPress: () {
          // Share.share(gifs[index]["images"]["fixed_height"]["url"]);
          // },
        );
      },
    );
  }
}
