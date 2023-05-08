import 'package:anonymouschat/SelectedGroupChat.dart';
import 'package:anonymouschat/zoomableImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'addRoom.dart';

    class AllChats extends StatefulWidget {
      const AllChats({Key? key}) : super(key: key);
      @override
      State<AllChats> createState() => _AllChatsState();
    }
    class _AllChatsState extends State<AllChats> {
     bool isAdmin=false;
     bool isLoaded=false;
      User? user=FirebaseAuth.instance.currentUser;
      String AdminUid='';
      checkIfItIsAdmin()async {
        user = await FirebaseAuth.instance.currentUser;
        var snapshot = await FirebaseFirestore.instance.collection('Admin').get();
        final docs = snapshot.docs;
        final data = docs[0].data();
        if(data['uid']==user?.uid){
          setState((){AdminUid=data['uid'];
            isAdmin=true;});}
        setState((){
          isLoaded=true;
        });
        
      }
      @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfItIsAdmin();
  }
      @override
      Widget build(BuildContext context) {
        double h=MediaQuery.of(context).size.height;
        double w=MediaQuery.of(context).size.width;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.teal,
            elevation: 0.3,
                  title: styledText(text: 'All Chats', color: Colors.white, weight: FontWeight.bold, size: h*0.02),
          ),
          body:isLoaded==false?Center(child: CircularProgressIndicator(color: Colors.teal,)):

          StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
            stream:  FirebaseFirestore.instance.collection('Rooms').snapshots(),
              builder: (context, snapshot) {
              if(snapshot.hasError){
              return Center(child: styled(text: "الرجاء إنشاء مجموعة!", color: Colors.black, weight:FontWeight.bold, size:h*0.02),);
              }

              if(snapshot.hasData){
              final docs=snapshot.data!.docs;
              return ListView.builder(scrollDirection: Axis.vertical,itemBuilder: (context,index) {
                final data = docs[index].data();
                String groupName=data['groupName'];
                String imageUrl=data['groupImageUrl'];
                return ChatList(index: index, h: h, w: w,groupName: groupName, image: imageUrl);
                  },itemCount: docs.length,);}
                  else{return Container();}}
          ),


          floatingActionButton: isAdmin?Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            height: h*0.06,
            width: w*0.3,
            child: FloatingActionButton(
              backgroundColor: Colors.teal,
              child: styled(text: 'أضف مجموعة', color: Colors.white, weight: FontWeight.bold, size: h*0.019),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>addRoom()));
              },
              tooltip: 'Add Room',
              shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
          ):null,
        );
      }


      Widget ChatList({required int index,required double h,required double w,required String groupName,required String image}){

     return   StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
            stream:  FirebaseFirestore.instance.collection(groupName+"Count").where("status",isEqualTo: "online").snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Center(child: styled(text: "الرجاء إنشاء مجموعة!", color: Colors.black, weight:FontWeight.bold, size:h*0.02),);
              }

              if(snapshot.hasData){
                final docs=snapshot.data!.docs;
                final  countOnline=docs.length;
                return   InkWell(
                  onTap: ()async{
                    String isAd='';
                    if(isAdmin){
                      isAd='true';
                    }
                    else{
                      isAd='false';
                    }
                    try{
                      await FirebaseFirestore.instance.collection(groupName+"Count").doc(user!.uid).set(
                          {"status":"online"});
                    }
                    catch(e){
                      Fluttertoast.showToast(msg: e.toString());
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(groupName: groupName, UidAdmin: AdminUid, isAdmin:isAd, imageUrl: image,)));
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
                          padding: EdgeInsets.all(7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: h*0.08,
                                        height: h*0.08,
                                        child: InkWell(
                                          onTap: (){
                                            Navigator.push(context,MaterialPageRoute(builder: (context)=>ZoomableImage(imageUrl:image)));
                                          },
                                          child: Material(

                                            borderRadius: BorderRadius.circular(100),
                                            elevation: 2,
                                            child: ClipRRect(
                                              borderRadius:BorderRadius.circular(100),
                                              child: FancyShimmerImage(
                                                shimmerBaseColor: Colors.grey,
                                                imageUrl: image,
                                                shimmerHighlightColor: Colors.black,
                                                shimmerBackColor: Colors.teal,
                                                height: h*0.08,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),SizedBox(width: w*0.03,)
                                  ,Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      styledText(text: groupName, color:Colors.grey[800]!, weight: FontWeight.bold, size: h*0.02),
                                      // styled(text: 'R', color: Colors.black, weight: FontWeight.bold, size:h*0.009)
                                    ],
                                  ),

                                ],

                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.message_outlined,color: Colors.grey[500],),
                                  styledText(text: countOnline.toString(), color: Colors.grey[800]!, weight: FontWeight.bold, size: h*0.018)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );}
              else{return Container();}}
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