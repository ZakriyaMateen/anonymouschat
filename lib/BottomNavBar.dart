import 'package:anonymouschat/AllChats.dart';
import 'package:anonymouschat/delItLater.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  final Screens=[
    AllChats(),
    AllPrivateChats()
  ];
  int _currentIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screens[_currentIndex],


       bottomNavigationBar: BottomNavigationBar(

         elevation: 0.0,

         onTap: (index){
           setState((){
             _currentIndex=index;
           });

         },
          currentIndex: _currentIndex,
         selectedItemColor: Colors.teal,
         selectedIconTheme: IconThemeData(color: Colors.teal),
         unselectedItemColor: Colors.grey,
         unselectedIconTheme: IconThemeData(color: Colors.grey),
         backgroundColor: Colors.white, items: [
           BottomNavigationBarItem(icon: Icon(Icons.people_rounded),label: "كل المجموعات"),
         BottomNavigationBarItem(icon: Icon(Icons.chat),label: "الدردشات الخاصة"),
       ],

       ),
    );
  }
}
