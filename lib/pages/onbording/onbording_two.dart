// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../utils/dims.dart';
class SecondOnbordingPage extends StatefulWidget {
  const SecondOnbordingPage({super.key});

  @override
  State<SecondOnbordingPage> createState() => _SecondOnbordingPageState();
}

class _SecondOnbordingPageState extends State<SecondOnbordingPage> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
     
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: AppDims.globalMargin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             
             Image.asset('assets/images/question.jpg'),
              const SizedBox(height: 18,),
              const Text('Get Answers  ', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                      color:Color.fromARGB(230, 94, 142, 206)  ),),
                      const SizedBox(height: 28,),
                       Text(' If you want to know anything about the',style: TextStyle(fontSize: 18,color: Colors.black54,),),
                       const SizedBox(height: 8,),
                       Text('country you\'re living in all you have to do ',style: TextStyle(fontSize: 18,color: Colors.black54,)),
                       const SizedBox(height: 8,),
                       Text('  is to ask the question and get the answer  ',style: TextStyle(fontSize: 18,color: Colors.black54,)),
                       const SizedBox(height: 8,),
                       Text('   easy and simple    ',style: TextStyle(fontSize: 18,color: Colors.black54,)),
               
               
            ],
          ),
        )),
    );
  }
}