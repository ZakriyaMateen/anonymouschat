import 'package:anonymouschat/AllChats.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({Key? key}) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CustomField(w:w,h:h),
      ),
    );
  }
}
bool isMe=true;
final radius=Radius.circular(12);
final String time="05:30";
final String message= "hey there how are you doing?";

Widget CustomField({required double w,required double h}){
  return
    Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Material(
            elevation: 3.6,
            borderRadius: BorderRadius.only(
              topLeft: radius,
              topRight: radius,
              bottomLeft: isMe ? radius : Radius.zero,
              bottomRight: isMe ? Radius.zero : radius,
            ),
            child: Container(
              constraints: BoxConstraints(minWidth: 20, maxWidth: w*0.6),
              padding:EdgeInsets.all(5),
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
        ),
      ],
    );
}