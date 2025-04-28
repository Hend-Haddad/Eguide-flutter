import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisabledButton extends StatefulWidget {
  final bool isDisabled;
  final Function onClick;
  const DisabledButton({super.key, required this.isDisabled, required this.onClick});

  @override
  State<DisabledButton> createState() => _DisabledButtonState();
}

class _DisabledButtonState extends State<DisabledButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
              children: [
                Expanded(
                  child:CupertinoButton(
                    borderRadius:BorderRadius.circular(12) ,
                    color:  widget.isDisabled?Colors.grey.shade200 : const Color.fromARGB(230, 94, 142, 206) ,
                    child: Text('Publish' ,style: TextStyle(fontWeight: FontWeight.bold,color: widget.isDisabled?Colors.grey : Colors.white),),
                    onPressed: (){
                     widget.isDisabled? null:widget.onClick();
                    },
                  ) 
                )
              ],
            );
  }
}