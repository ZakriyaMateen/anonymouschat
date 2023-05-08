import 'dart:io';
import 'package:anonymouschat/VideoClass.dart';
import 'package:anonymouschat/zoomableImage.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'AllChats.dart';
import 'PlayVideo.dart';
import 'PrivateChatScreen.dart';
import 'TemporaryShowingImage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatScreen extends StatefulWidget {
  final String UidAdmin;
  final String groupName;
  final String isAdmin;
  final String imageUrl;
  const ChatScreen({super.key, required this.groupName, required this.UidAdmin, required this.isAdmin, required this.imageUrl});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = ScrollController();

  File? _imageFile;
  String? _downloadUrl="https://firebasestorage.googleapis.com/v0/b/testforchattingapp.appspot.com/o/appDefault.jpg?alt=media&token=f3b19424-03a9-44b4-8696-347faf7de9c2";

  // Function to pick image from the gallery
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  // Function to upload image to Firebase Storage
  Future<void> _uploadImageToFirebaseStorage() async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final firebase_storage.Reference reference =
    firebase_storage.FirebaseStorage.instance.ref().child(fileName);
    final uploadTask = reference.putFile(_imageFile!);

    final snapshot = await uploadTask.whenComplete(() {

    });

    final downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      _downloadUrl = downloadUrl;
    });
  }

  bool changingStatus=false;
  bool showEmoji=false;
  User? user=FirebaseAuth.instance.currentUser;
  FocusNode focusNode=FocusNode();
  bool isCreatingPrivateChat=false;
  @override
  void initState() {
    super.initState();
focusNode.addListener(() { 
  if(focusNode.hasFocus){
    setState((){
      showEmoji=false;
    });
  }
});
  }


  Widget WelcomeMessage({required double w,required double h}){
    return Container(
      margin: EdgeInsets.only(left: 20,right: 20,top: 20),
      width: w*0.65,
      height: h*0.44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.teal,width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Flexible(
            child: styledText(text: "اهلا و سهلا", color: Colors.black87, weight:FontWeight.bold, size: h*0.018)
        ),],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [Icon(Icons.favorite,color:Colors.red[800],size: h*0.02,
        ),],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [Icon(FontAwesomeIcons.star,color:Colors.grey[800],size: h*0.02,
        ),],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [Icon(Icons.favorite,color:Colors.red[800],size: h*0.02,
        ),],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [Flexible(
            child: styledText(text: "البنات فقط", color: Colors.black87, weight:FontWeight.bold, size: h*0.018)
        ),],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [Icon(Icons.favorite,color:Colors.red[800],size: h*0.02,
        ),],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [Icon(FontAwesomeIcons.star,color:Colors.grey[800],size: h*0.02,
        ),],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [Icon(Icons.favorite,color:Colors.red[800],size: h*0.02,
        ),],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [Flexible(
            child: styledText(text: "الصداقة شىء جميل لكن تحتاج الى اشخاس", color: Colors.black87, weight:FontWeight.bold, size: h*0.016)
        ),],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [Flexible(
            child: styledText(text: "تعرف معنا الوفاء وليس المصلحتة الروم الجميل", color: Colors.black87, weight:FontWeight.bold, size: h*0.016)
        ),],
      ),
    ],
    ));
  }

  TextEditingController messageController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async{

        try{
          await FirebaseFirestore.instance.collection(widget.groupName+"Count").doc(user!.uid).set(
              {"status":"offline"}).then((value){
            Navigator.pop(context);
          });
        }
        catch(e){
          Fluttertoast.showToast(msg: e.toString());
        }
        // if(!changingStatus){
        //   Navigator.pop(context);
        // }
        // else{
        //
        // }
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                  onTap: ()async{
                    try{
                      await FirebaseFirestore.instance.collection(widget.groupName+"Count").doc(user!.uid).set(
                          {"status":"offline"}).then((value){
                        Navigator.pop(context);
                      });
                    }
                    catch(e){
                      Fluttertoast.showToast(msg: e.toString());
                    }

                  },
                  child: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
              SizedBox(width: w*0.05,),
              InkWell(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>ZoomableImage(imageUrl:widget.imageUrl)));
                },
                child: Container(
                  width: w*0.08,
                  height: w*0.08,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.teal[200]!,width: 0.1)
                  ),
                  child: ClipRRect(borderRadius:BorderRadius.circular(100),child: FancyShimmerImage(imageUrl: widget.imageUrl,shimmerBackColor: Colors.teal,alignment: Alignment.center,))
                ),
              ),
              SizedBox(width: w*0.038,),
              Text(widget.groupName,style: GoogleFonts.concertOne(),)
            ],
          ),
          centerTitle: false,
          backgroundColor: Colors.teal,
          elevation: 0.4,
        ),
        // wrap the column with single child scroll view try it/
        body: isCreatingPrivateChat?Center(child:CircularProgressIndicator()):WillPopScope(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
                  stream:  FirebaseFirestore.instance.collection(widget.groupName).orderBy('time',descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasError){
                      return Center(child: styled(text: "لا رسائل", color: Colors.black, weight:FontWeight.bold, size:h*0.02),);
                    }
                    if(snapshot.hasData){

                      final docs=snapshot.data!.docs;
                      return Flexible(
                        child: ListView.builder(
                          reverse: true,
                          controller: _controller,
                          scrollDirection: Axis.vertical,itemBuilder: (context,index) {
                          final data = docs[index].data();
                            String messagee=data['message'];
                          String currentTime=data['currentTime'];
                          String hasConsent=data['hasConsent'];
                          String isImage=data['isImage'];
                          String imageUrl=data['imageUrl'];
                          String isV=data['isVideo'];
                          String videoU=data['videoUrl'];
                          // _controller.animateTo(
                          //   _controller.position.maxScrollExtent,
                          //   duration: Duration(milliseconds: 300),
                          //   curve: Curves.easeInOut,
                          // );

                          return  index ==docs.length-1? WelcomeMessage(w: w, h: h):ChatBubble(
                            isAdmin:widget.isAdmin,
                            isImage:isImage,
                            hasConsent: hasConsent,
                            message: messagee,
                            time: currentTime,
                            isMe:user!.uid==data['uid'], imageUrl: imageUrl, groupName: widget.groupName, isVideo: isV, videoUrl: videoU, otherUid: data['uid'], myUid: user!.uid,
                          );
                        },itemCount: docs.length,),
                      );}
                    else{
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: CircularProgressIndicator(),),
                        ],
                      );
                    }
                  }),

      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Container(
      //               height: 60,
      //               width: double.infinity,
      //               child: Padding(
      //                 padding: EdgeInsets.only(left: 20,right: 2),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Row(
      //                       children: [
      //                         Container(
      //                         width: w/1.42,
      //                           height: 40,
      //                           decoration: BoxDecoration(
      //                             color: Colors.grey.shade200,
      //                             borderRadius: BorderRadius.only(
      //                               topLeft: Radius.circular(20),
      //                               bottomLeft: Radius.circular(20)
      //                             ),
      //                           ),
      //                           child: Padding(
      //                             padding: const EdgeInsets.only(left: 9),
      //                             child: TextField(
      // onSubmitted:  (val)async{
      //                 try{
      //                   DateTime now = DateTime.now();
      //                   String currentTime = DateFormat.jm().format(now);
      //                   if (messageController.text.trim().isNotEmpty) {
      //                     await FirebaseFirestore.instance.collection(widget.groupName).add({
      //                       'message':messageController.text,
      //                       'uid':user!.uid,
      //                       'time':FieldValue.serverTimestamp(),
      //                       'currentTime':currentTime,
      //                       'isImage':"false",
      //                       'hasConsent':"false",
      //                       'imageUrl':'',
      //                       'isVideo':"false",
      //                       'videoUrl':'',
      //                     }).then((value) {
      //                       messageController.clear();
      //                     });
      //                   }
      //
      //                 }
      //                 catch(e){
      //                   Fluttertoast.showToast(msg:e.toString(),toastLength:Toast.LENGTH_LONG);
      //                 }
      //               },
      //                               focusNode: focusNode,
      //                               cursorColor: Colors.black,
      //                               controller: messageController,
      //                               decoration: InputDecoration(
      //                                 border: InputBorder.none,
      //                                 hintText: 'اكتب رسالتك...',
      //                                 prefixIcon: IconButton(
      //                                     onPressed: (){
      //                                       focusNode.unfocus();
      //                                       focusNode.canRequestFocus=false;
      //
      //                                       setState((){
      //                                          showEmoji=!showEmoji;
      //
      //                                       });
      //                                     },
      //                                     icon:Icon(FontAwesomeIcons.smileWink,color: Colors.grey,size:20)),
      //                                 suffixIcon:    IconButton(icon:Icon(Icons.video_camera_back_outlined,color: Colors.grey,),onPressed: ()async{
      //              Navigator.push(context, (MaterialPageRoute(builder: (context)=>Videos(groupName: widget.groupName, uid:user!.uid, isAdmin: widget.isAdmin,))));
      //        },),
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                         Container(
      //                           padding:EdgeInsets.only(right: 10),
      //                           height: 40,
      //                           decoration: BoxDecoration(
      //                             color: Colors.grey.shade200,
      //                             borderRadius: BorderRadius.only(
      //                               bottomRight: Radius.circular(20),
      //                               topRight: Radius.circular(20),
      //                             )
      //                           ),
      //                           child: IconButton(icon:Icon(FontAwesomeIcons.photoFilm,color: Colors.grey,),onPressed:()async{
      //                         await _pickImage(ImageSource.gallery).then((value)async {
      //                         }).then((value) {
      //                         Navigator.push(context, MaterialPageRoute(builder: (context)=>TemporaryShowingImage(image: _imageFile, uid: user!.uid, groupName: widget.groupName, isAdmin: widget.isAdmin,)));
      //                         });
      //                         }),
      //                         ),
      //                         SizedBox(
      //                           width: 7,
      //                         ),
      //                         Container(
      //                           padding:EdgeInsets.only(right: 5),
      //                           height:40,
      //                           width:40,
      //                           decoration: BoxDecoration(
      //                             shape:BoxShape.circle,
      //                             color:Colors.teal[800]
      //                           ),
      //                           child:IconButton(icon:Icon(FontAwesomeIcons.solidPaperPlane,color: Colors.white,size: 20,),onPressed: () async{
      //
      //
      //                                                             }),
      //
      //
      //                         )
      //
      //                       ],
      //                     )
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
              _buildInputArea(),
              showEmoji? showEmojiPicker():Container()


              //5:08 PM


            ],
          ),
          onWillPop: (){
            if(showEmoji){
              setState((){
                showEmoji=false;
              });
            }
            else{
              Navigator.pop(context);
            }
            return Future.value(false);
          },
        ),


      ),
    );
  }
  bool _isComposingMessage = false;
  bool _showEmojiPicker = false;
  Widget _buildInputArea() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.025),
            child: Row(
              children: <Widget>[
                _buildIconButton(
                  Icons.emoji_emotions,
                        (){
                      focusNode.unfocus();
                      focusNode.canRequestFocus=false;

                      setState((){
                        showEmoji=!showEmoji;

                      });
                    },
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                _buildIconButton(
                  Icons.photo_library,
                        ()async{
                      await _pickImage(ImageSource.gallery).then((value)async {
                      }).then((value) {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>TemporaryShowingImage(image: _imageFile, uid: user!.uid, groupName: widget.groupName, isAdmin: widget.isAdmin,)));
                      });
                    }
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                _buildIconButton(
                  Icons.videocam,
                      ()async{
                    Navigator.push(context, (MaterialPageRoute(builder: (context)=>Videos(groupName: widget.groupName, uid:user!.uid, isAdmin: widget.isAdmin,))));
                  },
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.025),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode:focusNode,


                    controller: messageController,
                    onChanged: (String text) {
                      setState(() {
                        _isComposingMessage = text.isNotEmpty;
                      });
                    },
                    onSubmitted:    (val)async{

    try{
    DateTime now = DateTime.now();
    String currentTime = DateFormat.jm().format(now);
    if (messageController.text.trim().isNotEmpty) {
    await FirebaseFirestore.instance.collection(widget.groupName).add({
    'message':messageController.text,
    'uid':user!.uid,
    'time':FieldValue.serverTimestamp(),
    'currentTime':currentTime,
    'isImage':"false",
    'hasConsent':"false",
    'imageUrl':'',
    'isVideo':"false",
    'videoUrl':'',
    }).then((value) {
    // messageController.clear();
      messageController.clear();
    });
    }

    }
    catch(e){
    Fluttertoast.showToast(msg:e.toString(),toastLength:Toast.LENGTH_LONG);
    }
    },
                    decoration: InputDecoration.collapsed(
                                                      hintText: 'اكتب رسالتك...',
                    ),

                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                _isComposingMessage ? _buildIconButton(Icons.send, () async{
                  try{

                    DateTime now = DateTime.now();
                    String currentTime = DateFormat.jm().format(now);
                    if (messageController.text.trim().isNotEmpty) {
                      await FirebaseFirestore.instance.collection(widget.groupName).add({
                        'message':messageController.text,
                        'uid':user!.uid,
                        'time':FieldValue.serverTimestamp(),
                        'currentTime':currentTime,
                        'isImage':"false",
                        'hasConsent':"false",
                        'imageUrl':'',
                        'isVideo':"false",
                        'videoUrl':'',
                      }).then((value) {
                        messageController.clear();
                      });}}
                  catch(e){
                    Fluttertoast.showToast(msg:e.toString(),toastLength:Toast.LENGTH_LONG);
                  }
                },
                ) : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Function()? onPressed) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.1,
      width: MediaQuery.of(context).size.width * 0.1,
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }

  Widget showEmojiPicker(){
    return  Offstage(
        offstage: !showEmoji,
        child: SizedBox(
        height: 250,
        child: EmojiPicker(
        textEditingController: messageController,
        config: Config(
        columns: 7,
        // Issue: https://github.com/flutter/flutter/issues/28894
        emojiSizeMax: 32 *
        (foundation.defaultTargetPlatform ==
        TargetPlatform.iOS
        ? 1.30
        : 1.0),
    verticalSpacing: 0,horizontalSpacing: 0,gridPadding: EdgeInsets.zero,initCategory: Category.RECENT,bgColor: const Color(0xFFF2F2F2),indicatorColor: Colors.blue,iconColor: Colors.grey,iconColorSelected: Colors.blue,backspaceColor: Colors.blue,skinToneDialogBgColor: Colors.white,skinToneIndicatorColor: Colors.grey,
    enableSkinTones: true,showRecentsTab: true,
    recentsLimit: 28,
    replaceEmojiOnLimitExceed: false,
    noRecents: const Text(
    'No Recents',
    style: TextStyle(fontSize: 20, color: Colors.black26),
    textAlign: TextAlign.center,
    ),
    loadingIndicator: const SizedBox.shrink(),
    tabIndicatorAnimDuration: kTabScrollDuration,
    categoryIcons: const CategoryIcons(),
    buttonMode: ButtonMode.MATERIAL,
    checkPlatformCompatibility: true,
    ),
    )),
    );
    }
}
class ChatBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;
  final String hasConsent;
  final String isImage;
  final String isAdmin;
  final String imageUrl;
  final String groupName;
  final String videoUrl;
  final String isVideo;
  final String myUid;
  final String otherUid;
  const ChatBubble({Key? key, required this.message, required this.time, required this.isMe, required this.hasConsent, required this.isImage, required this.isAdmin, required this.imageUrl, required this.groupName, required this.videoUrl, required this.isVideo, required this.myUid, required this.otherUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      final radius = Radius.circular(18);

    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end :MainAxisAlignment.start,
        // (isMe=='me') ? MainAxisAlignment.end : (isMe=='someone')? MainAxisAlignment.start:MainAxisAlignment.center
      children: <Widget>[
        Padding(
          padding:  EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              (isAdmin=="false"&& hasConsent=="true" && isImage=="true")?
                InkWell(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>ZoomableImage(imageUrl:imageUrl)));
                    },
                  child: Column(
                    children: [
                      Container(
                        alignment: isMe? Alignment.centerLeft:Alignment.centerRight,
                        child: styledText(text: !isMe? "زائر":"", color:Colors.grey[800]!, weight: FontWeight.bold, size: h*0.017)
                      ),
                      Container(
                        width: w*0.65,
                        height: h*0.45,
                          margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover
                          ),
                          borderRadius:BorderRadius.circular(10),
                          border: Border.all(color: Colors.black,width: 1.5,style: BorderStyle.solid)
                        ),

                      ),
                    ],
                  ),
                )
              :  (isAdmin=="true" && isImage=="true")?
              Padding(
                padding:  EdgeInsets.all(5),
                child: Column(
                  children: [
                    Container(
                        alignment: isMe? Alignment.centerLeft:Alignment.centerRight,
                        child: styledText(text: "المشرف", color:Colors.grey[800]!, weight: FontWeight.bold, size: h*0.017)
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>ZoomableImage(imageUrl:imageUrl)));
                      },
                      child: Container(

                        width: w*0.65,
                        height: h*0.45,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover
                            ),
                            borderRadius:BorderRadius.circular(10),
                            border: Border.all(color: Colors.black,width: 1.5,style: BorderStyle.solid)
                        ),

                      ),
                    ),
     hasConsent=="false"?  TextButton(onPressed: ()async{
                      CollectionReference users = FirebaseFirestore.instance.collection(groupName);

                      QuerySnapshot querySnapshot = await users.where('imageUrl', isEqualTo: imageUrl).get();
                      String docId=querySnapshot.docs[0].id;
                      await users.doc(docId).update({
                        'hasConsent':"true"
                      });
                      }
                    , child: Text("تسمح له")):Container()
                  ],
                ),
              ):

              (isAdmin=="false"&& hasConsent=="true" && isVideo=="true")?

                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoPlayerScreen(videoUrl:videoUrl)));
                  },
                  child: Column(
                    children: [
                      Container(
                          alignment: isMe? Alignment.centerLeft:Alignment.centerRight,
                          child: styledText(text: !isMe? "زائر":"", color:Colors.grey[800]!, weight: FontWeight.bold, size: h*0.017)
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 5,vertical: 7),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          width: w*0.4,
                          height: h*0.07,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [ Colors.teal[300]!,Colors.teal[400]!,Colors.teal[500]!,Colors.teal[600]!,Colors.teal[700]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight
                            ),
                            border: Border.all(color: Colors.grey[800]!,width: 1.2),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: isMe ? Radius.circular(12) : Radius.zero,
                              bottomRight: isMe ? Radius.zero : Radius.circular(12),
                            ),
                          ),
                          child:  Row(

                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.video_camera_back_outlined,color: Colors.teal[900],),
                              SizedBox(width: 3,),
                              styledText(text: "شغل الفيديو", color: Colors.grey[800]!, weight: FontWeight.normal, size: 18),
                              SizedBox(width: 3,),
                              Icon(Icons.play_circle_filled_outlined,color: Colors.teal[900],),
                              SizedBox(width: 3,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ):
              (isAdmin=="true"&& isVideo=="true")?

                  Column(
                    children: [
                      Container(
                          alignment: isMe? Alignment.centerLeft:Alignment.centerRight,
                          child: styledText(text: !isMe? "زائر":"", color:Colors.grey[800]!, weight: FontWeight.bold, size: h*0.017)
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoPlayerScreen(videoUrl: videoUrl,)));
                        },
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 5,vertical: 7),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            width: w*0.4,
                            height: h*0.07,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [ Colors.teal[300]!,Colors.teal[400]!,Colors.teal[500]!,Colors.teal[600]!,Colors.teal[700]!],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight
                              ),
                              border: Border.all(color: Colors.grey[800]!,width: 1.2),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: isMe ? Radius.circular(12) : Radius.zero,
                                bottomRight: isMe ? Radius.zero : Radius.circular(12),
                              ),
                            ),
                            child:   Row(

                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.video_camera_back_outlined,color: Colors.teal[900],),
                                SizedBox(width: 3,),
                                styledText(text: "شغل الفيديو", color: Colors.grey[800]!, weight: FontWeight.normal, size: 18),
                                SizedBox(width: 3,),
                                Icon(Icons.play_circle_filled_outlined,color: Colors.teal[900],),
                                SizedBox(width: 3,),

                              ],
                            ),
                          ),
                        ),
                      ),
                      hasConsent=="false"?  TextButton(onPressed: ()async{
                        CollectionReference users = FirebaseFirestore.instance.collection(groupName);

                        QuerySnapshot querySnapshot = await users.where('videoUrl', isEqualTo: videoUrl).get();
                        String docId=querySnapshot.docs[0].id;
                        await users.doc(docId).update({
                          'hasConsent':"true"
                        });
                      }
                          , child: Text("Allow")):Container()
                    ],
                  ):


              InkWell(
                onTap: ()async{

                    List<String> sortedIds = [myUid, otherUid]..sort();
                    String chatId = "${sortedIds[0]}_${sortedIds[1]}";
                    String docId=chatId;
                    try{
                      User? user= FirebaseAuth.instance.currentUser;
                      List<String> idsList=[];
                      idsList.add(user!.uid);
                      idsList.add(otherUid);
                      await FirebaseFirestore.instance.collection('Chats').doc(docId).set({
                        'ids':FieldValue.arrayUnion(idsList),
                        'docId':docId
                      }).then((value) {
                        // Fluttertoast.showToast(msg: "جار تهيئة");
                      });
                    }
                    catch(e){
                      Fluttertoast.showToast(msg: e.toString()+"In the initialization");
                    }
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivateChatScreen( docId: docId,recieverUid:otherUid)));
                },
                child: Column(
                  children: [
                    Container(
                        alignment: isMe? Alignment.centerLeft:Alignment.centerRight,
                        child: styledText(text: isAdmin=="true"? "المشرف":(isMe == true && isAdmin=="false")?"":"زائر", color:Colors.grey[800]!, weight: FontWeight.bold, size: h*0.017)

                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        constraints: BoxConstraints(minWidth: 20, maxWidth: w*0.7),
                        padding: EdgeInsets.symmetric(horizontal: 7.5,vertical: 5),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.teal[900] : Colors.blueGrey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: radius,
                            topRight: radius,
                            bottomLeft: isMe ? radius : Radius.zero,
                            bottomRight: isMe ? Radius.zero : radius,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment:
                        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              //remove this flexible if needed
                              child: Text(
                                message,
                                style: GoogleFonts.concertOne(textStyle: TextStyle(
                                  color:isMe ? Colors.white : Colors.grey[800],
                                  fontSize: 16,
                                ),)
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              time,
                              style: GoogleFonts.prompt(textStyle: TextStyle(
                                color:isMe ? Colors.white : Colors.grey[800],
                                fontSize: 11,
                              ),)

                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
