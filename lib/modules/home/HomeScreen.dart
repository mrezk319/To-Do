import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        leading: Icon(
          Icons.menu,
        ),
        title: Text('First App'),
        actions: [
          IconButton(
              icon: Icon(Icons.notification_important_outlined),
              onPressed: () {
                print("Hello");
              }),
          IconButton(icon: Icon(Icons.home), onPressed: () {}),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(50),bottomEnd: Radius.circular(50))
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Image(
                      image: NetworkImage(
                          'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/close-up-of-cat-wearing-sunglasses-while-sitting-royalty-free-image-1571755145.jpg'),
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.7),
                      child: Text(
                        "I'm A CAT",
                        style: TextStyle(
                            color: Colors.white70,fontSize: 25),
                        textAlign:TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
