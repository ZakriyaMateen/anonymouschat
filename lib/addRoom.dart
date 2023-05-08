import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:image_picker/image_picker.dart';

import 'package:intl/date_symbol_data_local.dart';

import 'AllChats.dart';


class addRoom extends StatefulWidget {
  const addRoom({Key? key}) : super(key: key);

  @override
  State<addRoom> createState() => _addRoomState();
}

class _addRoomState extends State<addRoom> {
  final _formKey=GlobalKey<FormState>();

  File? _imageFile;
  String? _downloadUrl="https://firebasestorage.googleapis.com/v0/b/testforchattingapp.appspot.com/o/appDefault.jpg?alt=media&token=a9d77aed-ef16-474d-88e0-b3268b430a34";

  // Function to pick image from the gallery
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  // Function to upload image to Firebase Storage
  Future<void> _uploadImageToFirebaseStorage() async {
    setState((){
      isAddingRoom=true;
    });
  try{
    if(_imageFile!=null){
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final firebase_storage.Reference reference =
    firebase_storage.FirebaseStorage.instance.ref().child(fileName);
    final uploadTask = reference.putFile(_imageFile!);

    final snapshot = await uploadTask.whenComplete(() {

    });

    final downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      _downloadUrl = downloadUrl;
    });}

  }
  catch(e){
      Fluttertoast.showToast(msg: e.toString());
  }

  }

  // Function to save download URL to Firestore

 bool isAddingRoom=false;
  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;

    TextEditingController _groupNameController= TextEditingController();

    return WillPopScope(
      onWillPop: () {
        if(!isAddingRoom){
            Navigator.pop(context);
      }
      else{

      }
        return Future.value(false);
    },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
          leading: InkWell(
          onTap: (){
        Navigator.of(context).pop();
      }
      ,child: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
      backgroundColor: Colors.teal,
      elevation: 0.3,
      title: styled(text: 'أضف مجموعة', color: Colors.white, weight: FontWeight.bold, size: h*0.02),
      ),
      body: isAddingRoom?Center(child: CircularProgressIndicator(),): Form(
            key: _formKey,
      child:
      Column(

        children: [
          SizedBox(height:h*0.14),
        Padding(
        padding: EdgeInsets.symmetric(horizontal: w*0.05),
        child: Row(

          children: [
            _imageFile==null? IconButton(tooltip: "إضافة الصورة",icon: Icon(Icons.camera_alt),onPressed: ()async{
                await _pickImage(ImageSource.gallery).then((value)async {
                });

            },):Container(
              width: w*0.12,
              height: w*0.12,
              margin: EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                image: DecorationImage(image:
                FileImage(_imageFile!),
                fit:BoxFit.fill
                )
              ),
            ),
            Expanded(
              child: TextFormField(
              controller: _groupNameController,
              validator: (value){
              if(value!.isEmpty){
              return 'الرجاء إدخال اسم المجموعة';
              }
              else{
              return null;
              }
              },
              decoration: InputDecoration(
              // label: styled(text: 'Group Name', color: Colors.black, weight: FontWeight.normal, size: 14),
              hintText: 'أسم المجموعة...',
              // hintStyle: style( Colors.black, weight: FontWeight.normal, size: 14),
              border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal,width: 1.5),
              ),
              focusedBorder:  OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal,width: 1.5),
              ),
              enabledBorder:  OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal,width: 1),
              ),
              ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: h*0.025,),
      OutlinedButton(
      style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.teal,width: 1),
      borderRadius: BorderRadius.circular(7)
      ),
      ),
      onPressed: ()async{
      if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();

       await _uploadImageToFirebaseStorage();
      await FirebaseFirestore.instance.collection("Rooms").doc(_groupNameController.text.toString()).set(
          {
            'groupName':_groupNameController.text.toString(),
            'groupImageUrl':_downloadUrl

          }).then((value)async{

        User?user =await FirebaseAuth.instance.currentUser;
        DateTime now = DateTime.now();
        String formattedTime = DateFormat.jm().format(now);

        await  FirebaseFirestore.instance.collection(_groupNameController.text.toString()).add(
            {'message': 'تم إنشاء المسؤول ' + _groupNameController.text.toString(),
              'uid':user!.uid,
              'time':FieldValue.serverTimestamp(),
              'currentTime': formattedTime,
              'isImage':"false",
              'hasConsent':"false",
              'imageUrl':_downloadUrl,
              'isVideo':"false",
              'videoUrl':'',

            }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم إنشاء المجموعة بنجاح!'),
            ),
          );
          Navigator.of(context).pop();
        });




      });

      }
      }, child:styled(text: 'إنشاء مجموعة', color: Colors.teal, weight: FontWeight.bold, size:h*0.02))
      ],
      ))),
    );
  }
}


