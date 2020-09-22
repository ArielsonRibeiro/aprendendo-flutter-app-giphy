import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:share/share.dart';

class Detail extends StatelessWidget {
  final String _url, _title;
  Detail(this._url, this._title) : super();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(this._title,
            style: TextStyle(color: Colors.white, fontSize: 25.0)),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
            onPressed: () {
              Share.share(this._url, subject: this._title);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Text(this._title,
              style: TextStyle(color: Colors.white, fontSize: 25.0,),textAlign: TextAlign.center,),
          Divider(),
          FadeInImage.memoryNetwork(
              placeholder: kTransparentImage, image: this._url)
        ],
      ),
    );
  }
}
