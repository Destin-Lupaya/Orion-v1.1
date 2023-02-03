import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/Components/applogo.dart';
import 'package:universal_html/html.dart';

class CustomNetworkImage extends StatefulWidget {
  const CustomNetworkImage({required this.src, required this.size});

  final String src;
  final Size size;

  @override
  _CustomNetworkImageState createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CustomNetworkImage> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    // print(widget.src);
    // await http
    //     .get(
    //   Uri.parse(widget.src),
    // )
    //     .then((response) {
    //   print(response.body);
    //   _bytes = response.bodyBytes;
    // }).catchError((error) {
    //   print(error.toString());
    //   print("unable to load image");
    // });
    // _bytes = await http.get(Uri.parse(widget.src))..th.bodyBytes;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: undefined_prefixed_name
    // ui.platformViewRegistry.registerViewFactory(
    //     widget.src, (int _) => ImageElement()..src = widget.src);
    // return _bytes != null
    //     ? Image.memory(_bytes!,
    //         width: widget.size.width, height: widget.size.height)
    return Container(
        width: widget.size.width,
        height: widget.size.height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage.assetNetwork(
              // width: 50,
              // height: 50,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stacktrace) {
                return const AppLogo(size: Size(50, 50));
              },
              placeholder: "Assets/Images/Orion/hopital.jpg",
              image: widget.src.toString().trim().contains("clientfiles")
                  ? widget.src.toString().trim()
                  : "Assets/Images/logo.jpg"),
          // HtmlElementView(viewType: widget.src)
        ));
    // : Container(
    //     width: widget.size.width,
    //     height: widget.size.height,
    //     decoration: BoxDecoration(
    //         color: Colors.grey[200]!,
    //         borderRadius: BorderRadius.circular(10)),
    //     child: Icon(Icons.image_outlined,
    //         color: Colors.grey[400]!, size: widget.size.width));
  }
}
