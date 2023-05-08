import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ZoomableImage extends StatefulWidget {
  final String imageUrl;
  const ZoomableImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  late ImageProvider imageProvider;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    imageProvider = NetworkImage(widget.imageUrl);
    precacheImage(imageProvider, context).then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading:InkWell(
        onTap:(){
          Navigator.of(context).pop();
        },child: Icon(Icons.arrow_back_ios_new_rounded,color:Colors.black87)),
        title: Text('Zoomable Network Image'),
      ),
      body: InteractiveViewer(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height*0.7,
          child: FancyShimmerImage(
            imageUrl: widget.imageUrl,
            errorWidget: Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
