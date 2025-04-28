// ignore_for_file: prefer_const_constructors, prefer_final_fields


import 'package:eguideapp/pages/auth/login.dart';
import 'package:eguideapp/pages/onbording/onbording_one.dart';
import 'package:eguideapp/pages/onbording/onbording_two.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {
  PageController _controller =PageController();
  bool onLastPage = false ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            
            controller: _controller,
            onPageChanged: (index){
              setState(() {
                onLastPage = (index==1);
              });
            },
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              FirstOnbordingPage(),
              SecondOnbordingPage(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (() {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
                  }),
                  child: Text('skip',style: TextStyle(fontSize: 20,color: Color.fromARGB(230, 94, 142, 206) ,fontWeight: FontWeight.bold),)),
                SmoothPageIndicator(controller: _controller, count: 2,axisDirection: Axis.horizontal,),
                onLastPage?
                GestureDetector(
                  onTap: (() {
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
                  }),
                  child: Text('done',style: TextStyle(fontSize: 20,color: Color.fromARGB(230, 94, 142, 206) ,fontWeight: FontWeight.bold))):
                  GestureDetector(
                  onTap: (() {
                    _controller.nextPage(duration: Duration(microseconds: 500), curve: Curves.easeIn,);
                  }),
                  child: Text('next',style: TextStyle(fontSize: 20,color: Color.fromARGB(230, 94, 142, 206) ,fontWeight: FontWeight.bold)))

              ],
            )),
        ],),
    );
  }
}