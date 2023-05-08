import 'dart:async';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';


class VideosPrivateChat extends StatefulWidget {
  final String isAdmin;
  final String groupName;
  final String uid;
  final String recieverUid;
  final String docId;
  const VideosPrivateChat({Key? key, required this.groupName, required this.uid, required this.isAdmin, required this.docId, required this.recieverUid}) : super(key: key);

  @override
  State<VideosPrivateChat> createState() => _VideosPrivateChatState();
}

class _VideosPrivateChatState extends State<VideosPrivateChat> {
  bool isPostEnabled=true;
  File ?_videoFile;
  bool _isUploading = false;

  late VideoPlayerController _videoPlayerController;
  Color postColor=Colors.white;

  Future<void> _chooseVideo() async {
    final pickedFile = await ImagePicker().getVideo(source: ImageSource.gallery);
    setState(() {
      _videoFile = File(pickedFile!.path);
      _videoPlayerController = VideoPlayerController.file(_videoFile!);
      _videoPlayerController.initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
    });
  }

  Future<void> _uploadVideo() async {
    String videoId = DateTime.now().millisecondsSinceEpoch.toString();

    try{
      setState(() {
        _isUploading = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("يرجى الانتظار حتى يتم تحميل الفيديو")));
      Reference storageRef = FirebaseStorage.instance.ref().child('videos/$videoId.mp4');
      await storageRef.putFile(_videoFile!);

      String videoUrl = await storageRef.getDownloadURL();
      DateTime now = DateTime.now();

      String currentTime = DateFormat.jm().format(now);
      await FirebaseFirestore.instance.collection("Chats").doc(widget.docId).collection('messages').add(
          {
            'message':"في انتظار موافقة الفيديو",
            'uid':widget.uid,
            'time':FieldValue.serverTimestamp(),
            'currentTime':currentTime,
            'isImage':"false",
            'hasConsent':widget.isAdmin=="true"?"true":"false",
            'imageUrl':"",
            'videoUrl':videoUrl,
            'isVideo':"true",
            'docId':widget.docId
          }
      ).then((value) async{
        // await FirebaseFirestore.instance.collection('ChatIds').add({
        //   'recieverUid':widget.recieverUid,
        //   'myUid':widget.uid
        // });

        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم الرفع بنجاح!")));
        Navigator.pop(context);
      });
    }
    catch(e){
      setState((){
        isPostEnabled=true;
        _isUploading=false;
      });
      Fluttertoast.showToast(msg: e.toString(),toastLength: Toast.LENGTH_LONG);
    }

    setState(() {
      _videoFile = null;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        if(!_isUploading){
          Navigator.pop(context);
        }
        else{

        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('رفع فيديو'),
          elevation: 0.05,
          actions: [
            _isUploading?
            Padding(
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator(color: Colors.teal[200],),
            )
                :
            TextButton(
              onPressed: ()async{
                if(_videoFile != null)  {await _uploadVideo();}

                else{ Fluttertoast.showToast(msg: 'لا يوجد ملف ، لاغية');}
              },
              child: Text('Post',style: TextStyle(color: postColor),),
            )
          ],
        ),
        body: Center(
          child: _isUploading?Padding(
            padding:  EdgeInsets.symmetric(horizontal:20),
            child: LinearProgressIndicator(color: Colors.teal,semanticsLabel: "تحميل",),
          ): Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_videoFile != null)
                AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoPlayer(_videoPlayerController),
                      VideoProgressIndicator(
                        _videoPlayerController,
                        allowScrubbing: true,
                        padding: EdgeInsets.only(bottom: 10),
                      ),
                    ],
                  ),
                ),
              OutlinedButton(
                onPressed: ()async{await _chooseVideo();},
                child: Text('اختر من معرض الهاتف',style: TextStyle(color: Colors.teal),),
              ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}
