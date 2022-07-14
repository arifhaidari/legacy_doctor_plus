

import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String url;

  const FullScreenImage({Key key, this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Image.network(
        url,
        width: size.width,
        height: size.height,
        semanticLabel: "Image",
        fit: BoxFit.contain,
      ),
    );
  }
}
