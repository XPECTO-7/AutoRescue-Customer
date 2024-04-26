import 'package:flutter/material.dart';

class SimpleTextArea extends StatelessWidget {
  final String title,content;
  const SimpleTextArea({super.key,required this.content,required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.black,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(title,),
                const SizedBox(width: 5,),
                 Text(content,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
