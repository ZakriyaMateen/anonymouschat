import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    // Initialize the video player controller with the video URL
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);

    // Initialize the chewie controller with the video player controller
    _chewieController = ChewieController(
      maxScale: 2,

      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      allowFullScreen: true,
      allowPlaybackSpeedChanging: true,
      allowMuting: true,
      showControls: true,
      showOptions: true,
      showControlsOnInitialize: true,
      fullScreenByDefault: false,

      looping: true,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      placeholder: Container(
        color: Colors.black,
      ),
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.teal[600]!,
        handleColor: Colors.teal[900]!,
        backgroundColor: Colors.grey[200]!,
        bufferedColor: Colors.grey[700]!,
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the chewie and video player controllers when the screen is disposed
    _chewieController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0.05,
        automaticallyImplyLeading: false,
        leading: InkWell(onTap: (){Navigator.pop(context);},child: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
        backgroundColor: Colors.white,
        title: Text('Video Player'),
      ),
      body: Center(
        child: Chewie(

          controller: _chewieController,
        ),
      ),
    );
  }
}
