
import 'package:eguideapp/pages/core/edit_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextEditingController _bioController= TextEditingController();
class Bio extends StatefulWidget {
  
  const Bio({super.key, });

  @override
  State<Bio> createState() => _BioState();
}

class _BioState extends State<Bio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: (){
                          Navigator.pop(context, CupertinoPageRoute(builder: (context) => const EditProfile()));
                        }, icon: const Icon(CupertinoIcons.xmark,size: 26,)),
                       
                      const  Text('Bio',style: TextStyle(fontSize: 24)),
                      IconButton(onPressed: (){
                        Navigator.pop(context,CupertinoPageRoute(builder: (context) => const EditProfile()));
                      }, icon:const Icon(CupertinoIcons.check_mark,color: Colors.blue,))
                  ],
          ),
         Padding(
           padding:  const EdgeInsets.all(8.0),
           child:  TextField(
           controller:_bioController,
            minLines: 1,
            maxLines: 12,
              cursorColor: Colors.teal,
              cursorHeight: 22,
                     
                   
           ),
         )
        ],
      )),
    );
  }
}