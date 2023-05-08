import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'AllChats.dart';

class selectedGroupChat extends StatefulWidget {
  final String groupName;
  const selectedGroupChat({Key? key, required this.groupName}) : super(key: key);

  @override
  State<selectedGroupChat> createState() => _selectedGroupChatState();
}

class _selectedGroupChatState extends State<selectedGroupChat> {


  List<Map<String,String>> mapList=[
    {
      "Message":"testing 123 testing ?",
      'SentBy':"id123",
      'Time':"22:20:23"
    },
    {
      "Message":"testing 123 testing ?",
      'SentBy':"id122",
      'Time':"22:20:23"
    },{
      "Message":"testing 123 testing ?",
      'SentBy':"id123",
      'Time':"22:20:23"
    },{
      "Message":"testing 123 testing ?",
      'SentBy':"id123",
      'Time':"22:20:23"
    },{
      "Message":"testing 123 testing ?",
      'SentBy':"id122",
      'Time':"22:20:23"
    },{
      "Message":"testing 123 testing ?",
      'SentBy':"id122",
      'Time':"22:20:23"
    },{
      "Message":"testing 123 testing ?",
      'SentBy':"id123",
      'Time':"22:20:23"
    },{
      "Message":"testing 123 testing ?",
      'SentBy':"id123",
      'Time':"22:20:23"
    },{
      "Message":"testing 123 testing ?",
      'SentBy':"id123",
      'Time':"22:20:23"
    },{
      "Message":"testing 123 testing ?",
      'SentBy':"id123",
      'Time':"22:20:23"
    },{
      "Message":"testing 123 testing ?",
      'SentBy':"id123",
      'Time':"22:20:23"
    },{
      "Message":"testing 123 testing ?",
      'SentBy':"id123",
      'Time':"22:20:23"
    },{
      "Message":"testing 123 testing ?",
      'SentBy':"id123",
      'Time':"22:20:23"
    },{
      "Message":"testing 123 testing ?",
      'SentBy':"id123",
      'Time':"22:20:23"
    },{
      "Message":"testing 123 testing ?",
      'SentBy':"id123",
      'Time':"22:20:23"
    },{
      "Message":"testing 123 testing ?",
      'SentBy':"id122",
      'Time':"22:20:23"
    },{
      "Message":"testing 123 testing ?",
      'SentBy':"id123",
      'Time':"22:20:23"
    },{
      "Message":"testing 123 testing ?",
      'SentBy':"id122",
      'Time':"22:20:23"
    },
  ];
  //
  // User?user;
  // void getUid()async{
  //   user=FirebaseAuth.instance.currentUser;
  // }
  //
  TextEditingController messageController=TextEditingController();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getUid();
  // }
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
              Navigator.of(context).pop();
            }
            ,child: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
        backgroundColor: Colors.teal,
        elevation: 0.3,
        title: styled(text: widget.groupName, color: Colors.white, weight: FontWeight.bold, size: h*0.02),
      ),

      body: Column(
        children: [
          Container(
            height: (h*0.93)-100,
            width: w,

            // child:  ListView.builder(itemBuilder: (context,index){
            //   bool isMine=false;
            //   if(mapList[index]['SentBy'] != null && mapList[index]['SentBy'] == 'id122' ){
            //     isMine=true;
            //   }
            //   return messageTileBuilder(message: mapList[index]['Message']!, w: w, h: h,Mine:isMine, time: mapList[index]['Time']!);
            // },itemCount: mapList.length,))
          )
          ,


          Container(
            width: w,
            height: h*0.06,
            alignment: Alignment.center,
            child: Row(
              children: [
                Container(width: w*0.02,),

                Expanded(
                  child: TextFormField(
                    controller: messageController,

                    decoration: InputDecoration(
                      hintStyle: style(Colors.grey[600], weight: FontWeight.normal, size: h*0.018),
                      hintText:'Message...',
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.teal,width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.teal,width: 1.7),
                      ),
                      focusedBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.teal,width: 1.7),
                      ),
                      enabledBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.teal,width: 1),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: ()async{




                        try{
                      User?user=FirebaseAuth.instance.currentUser;
                      String text = messageController.text;
                      if (text.trim().isNotEmpty) {
                        await FirebaseFirestore.instance.collection(widget.groupName).add({
                          'message': text,
                          'uid': user!.uid,
                          'time': DateTime.now().millisecondsSinceEpoch,
                          'currentTime':FieldValue.serverTimestamp()
                        });
                        messageController.clear();
                      }

                    }
                    catch(e){
                      Fluttertoast.showToast(msg: e.toString(),toastLength:Toast.LENGTH_LONG);

                    }

                  },
                  child: Container(
                      width: w*0.1,child: Icon(Icons.send,color: Colors.teal[800],size: h*0.02,)),
                ),
              ],
            ),
          ),
          Container(
            height: h*0.01,
          )
        ],
      ),
    );
  }

  messageTileBuilder({required String message,required double w,required double h,required bool Mine,required String time}){
    return Align(
      alignment: Mine?Alignment.centerRight:Alignment.centerLeft,

      child: Container(
        constraints: BoxConstraints(minWidth: 20, maxWidth: w*0.6),
        margin: EdgeInsets.symmetric(vertical: h*0.005,horizontal: w*0.02),
        // alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: w*0.015,vertical: h*0.009),
        decoration: BoxDecoration(
            color: Colors.teal[900],
            borderRadius: BorderRadius.circular(10)
        ),
        child:
        Flexible(child: styled(text: message, color: Colors.white, weight: FontWeight.normal, size: h*0.017)),
      ),
    );
  }
}


