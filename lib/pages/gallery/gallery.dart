import 'package:flutter/material.dart';

class Gallery extends StatefulWidget {

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {

  bool shouldBack = false;

  @override
  void initState() {
    super.initState();
    print('gallery 初始化');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: Center(
        child: Text('Gallery'),
      ),
    );
  }
}