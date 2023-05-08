import 'package:anonymouschat/PrivateChatScreen.dart';
import 'package:anonymouschat/SelectedGroupChat.dart';
import 'package:anonymouschat/selectedGroupChat.dart';
import 'package:anonymouschat/zoomableImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

import 'addRoom.dart';


class AllPrivateChats extends StatefulWidget {
  const AllPrivateChats({Key? key}) : super(key: key);

  @override
  State<AllPrivateChats> createState() => _AllPrivateChatsState();
}

class _AllPrivateChatsState extends State<AllPrivateChats> {
  bool isAdmin=false;
  bool isLoaded=true;
  // User? user=FirebaseAuth.instance.currentUser;

  String AdminUid='';



  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    User?user =FirebaseAuth.instance.currentUser;
    // Fluttertoast.showToast(msg: user!.uid,toastLength: Toast.LENGTH_LONG);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0.3,
        title: styledText(text: 'All Chats', color: Colors.white, weight: FontWeight.bold, size: h*0.02),
      ),
      body:isLoaded==false?Center(child: CircularProgressIndicator(color: Colors.teal,)):
      //
      StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
          stream:  FirebaseFirestore.instance.collection('Chats').where('ids',arrayContains: user!.uid).snapshots(),


          builder: (context, snapshot) {
            if(snapshot.hasError){
              return Center(child: styled(text: "No Chats", color: Colors.black, weight:FontWeight.bold, size:h*0.02),);
            }


            if(snapshot.hasData){
              final docs=snapshot.data!.docs;
              return ListView.builder(scrollDirection: Axis.vertical,itemBuilder: (context,index) {
                final data = docs[index].data();
             
              String imageUrl='';


                var arrayIds= data['ids'];
                String docId=data['docId'];
                List<String> listIds=List<String>.from(arrayIds);
                String recieverUid=listIds[1];
                List<String> sortedIds = [user.uid,recieverUid]..sort();
                String chatId = "${sortedIds[0]}_${sortedIds[1]}";
                //
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(recieverUid),duration: Duration(seconds: 3),));
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(chatId),duration: Duration(seconds: 3),));
                return ChatList(index: index, h: h, w: w,groupName: "زائر", image: imageUrl, docId: docId, recieverUid: recieverUid);
              },itemCount: docs.length,);}
            else{
              return Container();
            }
          }),

    );
  }
  Widget ChatList({required int index,required double h,required double w,required String groupName,required String image,required String docId,required String recieverUid}){
    return
      InkWell(
        onTap: (){
          String isAd='';
          if(isAdmin){
            isAd='true';
          }
          else{
            isAd='false';
          }
          Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivateChatScreen(docId: docId, recieverUid: recieverUid,)));
        },
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 5,vertical: 8),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 4,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
              ),

              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                       SizedBox(width: w*0.03,)
                        ,styledText(text: groupName, color:Colors.grey[800]!, weight: FontWeight.bold, size: h*0.0217),

                      ],

                    ),
                    Icon(Icons.message_outlined,color: Colors.grey[500],),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  }}

Text styledForThisPage(  Color? color,{required String text,required FontWeight weight,required double size}){
  return Text(text,  style: GoogleFonts.alike(
      textStyle: TextStyle(fontWeight: weight,fontSize: size,color: color)
  ),);
}
TextStyle style(Color? color,{required FontWeight weight,required double size}){
  return TextStyle(color: color, fontSize: size,fontWeight: weight);
}

Text styledText({required String text, required Color color,required FontWeight weight,required double size}){
  return Text(text,  style: GoogleFonts.concertOne(
      textStyle: TextStyle(fontWeight: weight,fontSize: size,color: color)
  ),);
}

Text styled({required String text, required Color color,required FontWeight weight,required double size}){
  return Text(text,  style: GoogleFonts.alike(
      textStyle: TextStyle(fontWeight: weight,fontSize: size,color: color)
  ),);
}