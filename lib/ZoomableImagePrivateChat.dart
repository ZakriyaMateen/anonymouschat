import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class TemporaryShowingImagePrivateChat extends StatefulWidget {
  final File?image;
  final String uid;
  final String groupName;
  final String isAdmin;
  final String recieverUid;
  final String docId;
  const TemporaryShowingImagePrivateChat({Key? key, this.image, required this.uid, required this.groupName, required this.isAdmin, required this.docId, required this.recieverUid}) : super(key: key);

  @override
  State<TemporaryShowingImagePrivateChat> createState() => _TemporaryShowingImagePrivateChatState();
}

class _TemporaryShowingImagePrivateChatState extends State<TemporaryShowingImagePrivateChat> {
  String? _downloadUrl="https://firebasestorage.googleapis.com/v0/b/testforchattingapp.appspot.com/o/appDefault.jpg?alt=media&token=f3b19424-03a9-44b4-8696-347faf7de9c2";
  bool _isUploading=false;
  Future<void> _uploadImageToFirebaseStorage() async {

    setState((){
      _isUploading=true;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("يرجى الانتظار حتى يتم تحميل الصورة!")));
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final firebase_storage.Reference reference =
    firebase_storage.FirebaseStorage.instance.ref().child(fileName);
    final uploadTask = reference.putFile(widget.image!);

    final snapshot = await uploadTask.whenComplete(() {

    });

    final downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      _downloadUrl = downloadUrl;
    });
  }
  bool enabled=true;
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
        backgroundColor: Colors.black,
        appBar: AppBar(leading:   InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.teal,actions: [
            if (_isUploading)
              Padding(
                padding: EdgeInsets.all(9.0),
                child: CircularProgressIndicator(color: Colors.teal[200],),
              )
            else TextButton(

                onPressed: ()async{

                  await _uploadImageToFirebaseStorage().then((value)async{
                    DateTime now = DateTime.now();

                    String currentTime = DateFormat.jm().format(now);

                    await FirebaseFirestore.instance.collection("Chats").doc(widget.docId).collection('messages').add(
                        {
                          'message':"في انتظار موافقة الصورة",
                          'uid':widget.uid,
                          'docId':widget.docId,
                          'time':FieldValue.serverTimestamp(),
                          'currentTime':currentTime,
                          'isImage':"true",
                          'hasConsent':widget.isAdmin=="true"?"true":"false",
                          'imageUrl':_downloadUrl,
                          'videoUrl':'',
                          'isVideo':"false"
//isAdmin consent:true
                        }
                    ).then((value)async{

                       await FirebaseFirestore.instance.collection('ChatIds').add({
                         'recieverUid':widget.recieverUid,
                         'myUid':widget.uid
                       });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("في انتظار موافقة الصورة")));
                      setState((){
                        _isUploading=false;
                      });
                      Navigator.pop(context);
                    });
                  }).onError((error, stackTrace){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()+" Occurred! ")));
                    setState((){
                      enabled=true;
                    });

                  });
                }, child:

            Text("نشر",style: TextStyle(color:Colors.white),))
          ],),
        body: Container(
          decoration: BoxDecoration(
              image:DecorationImage(image:
              FileImage(widget.image!),fit: BoxFit.fitWidth)
          ),
        ),

      ),
    );
  }
}
