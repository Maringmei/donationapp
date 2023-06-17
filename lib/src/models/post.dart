import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {


  final String id;
  final String name;
  // final String address;
  // final dynamic mobile;


  PostItem(this.id, this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: 200,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.amber
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(id,
              style: const TextStyle(
                  color: Colors.purple,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),),
            const SizedBox(height: 10,),
            Text(name,
              style: const TextStyle(
                  fontSize: 15
              ),)
          ],
        ),
      ),
    );
  }
}