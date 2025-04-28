import 'package:flutter/material.dart';

import '../../utils/dims.dart';
class FirstOnbordingPage extends StatefulWidget {
  const FirstOnbordingPage({super.key});

  @override
  State<FirstOnbordingPage> createState() => _FirstOnbordingPageState();
}

class _FirstOnbordingPageState extends State<FirstOnbordingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
        margin: AppDims.globalMargin,
        child:Column(
          
          children: [
          Image.asset('assets/images/travel.jpg'),
           
            const SizedBox(height: 8,),
            const Text('know the country ', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                    color:Color.fromARGB(230, 94, 142, 206)  ),),
                    const SizedBox(height: 28,),
                    const Text(' Learn how to live as a native',style: TextStyle(fontSize: 18,color: Colors.black54,),),
                     const SizedBox(height: 8,),
                    const Text('E-guide make living in a foreign country',style: TextStyle(fontSize: 18,color: Colors.black54,)),
                     const SizedBox(height: 8,),
                    const Text('  easier and more interresting  ',style: TextStyle(fontSize: 18,color: Colors.black54,)),
            
             
            
             
          ],
        )
      )),
    );
    
  }
}