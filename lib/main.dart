
import 'package:anonymouschat/BottomNavBar.dart';
import 'package:anonymouschat/LoginSignUpAdmin.dart';
import 'package:anonymouschat/TextFieldCustom.dart';

import 'package:anonymouschat/flags.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_information/device_information.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'AllChats.dart';
import 'SelectedGroupChat.dart';
import 'VideoClass.dart';
import 'delItLater.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values,);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
    systemStatusBarContrastEnforced: false,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
  ),);



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anonymous Chat',
      theme: ThemeData(

      ),
      home:  const SplashScreen()
        //change to splashscreen
    );
  }
}


// temp class



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String ?_platformVersion ='hello';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
     }


  Future<void> initPlatformState() async {
    String platformVersion='';
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    platformVersion = androidInfo.id;
      // Fluttertoast.showToast(msg: platformVersion!,toastLength: Toast.LENGTH_LONG);
   await   platformVersion.replaceAll(".", "");
    } catch(e){
      // print(e);
    }
    if (!mounted) return;
    setState(() {

      _platformVersion = platformVersion;
      // Fluttertoast.showToast(msg: _platformVersion!,toastLength: Toast.LENGTH_LONG);
    });
  }

  checkIfItIsAdmin()async {

    try{
      User?user =FirebaseAuth.instance.currentUser;

      var snapshot = await FirebaseFirestore.instance.collection('Admin').get();
      final docs = snapshot.docs;
      final data = docs[0].data();

      if(data.isNotEmpty){
     try{
       if(user!.uid==data['uid']){
         // Fluttertoast.showToast(msg: 'Admin Already exists');
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavBar()));
       }
       else if(user!.uid!=null){
         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>BottomNavBar()));
       }
     }
     catch(e){
        await initPlatformState();
        try {
          // Fluttertoast.showToast(msg: _platformVersion.toString()!,toastLength: Toast.LENGTH_LONG);
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _platformVersion! + "1@gmail.com",
              password: _platformVersion!).then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => BottomNavBar()));
          });
        }
        catch (e) {
          // Fluttertoast.showToast(
          //     msg: e.toString(), toastLength: Toast.LENGTH_LONG);
          try {
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: _platformVersion! + "1@gmail.com",
                password: _platformVersion!).then((value) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => BottomNavBar()));
            });
          }
          catch (e) {
            // // Fluttertoast.showToast(
            //     msg: e.toString(), toastLength: Toast.LENGTH_LONG);
          }

         
        }
      }
     }


      else{
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginSignUpAdmin()));
      }

    }
    catch(e){
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginSignUpAdmin()));
      // Fluttertoast.showToast(msg: e.toString());
    }


  }
   initialize()async{

    try{
      await Firebase.initializeApp();

      await checkIfItIsAdmin();

      // Navigator.push(context,MaterialPageRoute(builder: (context)=>CustomTextField()));
    }
    catch(e){
      // Fluttertoast.showToast(msg: e.toString(),toastLength: Toast.LENGTH_LONG);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Container(alignment: Alignment.center,width: MediaQuery.of(context).size.width*0.4,height:  MediaQuery.of(context).size.width*0.4,child: Image.asset('lib/meetme.png')),),
    );
  }
}
