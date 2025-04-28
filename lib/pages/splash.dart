
import 'package:eguideapp/pages/onbording/onbording_screen.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState(){
    super.initState();
    _navigate();
  }
  _navigate()async{
    await Future.delayed(const Duration(milliseconds: 1500),(){});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnbordingScreen(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: 
      Image.asset('assets/images/logo.png',width: 200, height:60,),),
    );
  }
}