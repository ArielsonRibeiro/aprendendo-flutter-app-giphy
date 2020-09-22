import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:visualizador_gifs/pages/details.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controller = TextEditingController();
  String _search;
  int offset = 0;

  Future<List> _getData() async {
    String url;
    if (_search == null || _search.isEmpty) {
      url =
          "https://api.giphy.com/v1/gifs/trending?api_key=Il7nt2aWkKCaXtLpFeo56HkuPyXAk4mz&limit=20&rating=pg-13";
    } else {
      url =
          "https://api.giphy.com/v1/gifs/search?api_key=Il7nt2aWkKCaXtLpFeo56HkuPyXAk4mz&q=$_search&limit=19&offset=$offset&rating=pg-13&lang=pt";
    }
    print(url);
    http.Response response = await http.get(url);
    return json.decode(response.body)["data"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("img/header-logo.gif"),
      ),
      backgroundColor: Colors.grey[900],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: _controller,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  offset = 0;
                });
              },
              style: TextStyle(fontSize: 30.0),
              decoration: InputDecoration(
                hintText: "Search",
                contentPadding: const EdgeInsets.all(15),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35.0),
                    borderSide: BorderSide(color: Colors.purple, width: 2.0)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35.0)),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List>(
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Ouve Algum Problema na Comunicação.\n Tente Mais Tarde",
                          style: TextStyle(color: Colors.white, fontSize: 25.0),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0),
                      itemCount: _search == null || _search.isEmpty
                          ? snapshot.data.length
                          : 20,
                      itemBuilder: (context, index) {
                        if (snapshot.data.length == index) {
                          return GestureDetector(
                            key: Key(DateTime.now()
                                .millisecondsSinceEpoch
                                .toString()),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 100,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Carregar Mais",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25.0),
                                )
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                offset += 20;
                              });
                            },
                          );
                        }
                        return GestureDetector(
                          key: Key(
                              DateTime.now().millisecondsSinceEpoch.toString()),
                          child: FadeInImage.memoryNetwork(
                            image: snapshot.data[index]["images"]
                                ["fixed_height"]["url"],
                            placeholder: kTransparentImage,
                          ),
                          onLongPress: (){Share.share(snapshot.data[index]["images"]["original"]
                                      ["url"], subject: snapshot.data[index]["title"]);},
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detail(
                                  snapshot.data[index]["images"]["original"]
                                      ["url"],
                                  snapshot.data[index]["title"],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                }
              },
              future: _getData(),
            ),
          ),
        ],
      ),
    );
  }
}
