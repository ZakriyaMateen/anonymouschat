import 'dart:io';

import 'package:flutter/material.dart';

    class Zoomedimage extends StatefulWidget {
      final String image;
      const Zoomedimage({Key? key, required this.image}) : super(key: key);

      @override
      State<Zoomedimage> createState() => _ZoomedimageState();
    }

    class _ZoomedimageState extends State<Zoomedimage> {
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(backgroundColor: Colors.teal,

elevation: 0.0,
            title: Text(""),
          ),
          body:
            Container(
              decoration: BoxDecoration(
                  image:DecorationImage(image:
                  NetworkImage(widget.image!),fit: BoxFit.fitWidth)

            ),
          ),
        );
      }
    }
