
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          margin: EdgeInsets.all(10),
          width: double.infinity,
          height: 300,
          color: Colors.black,
          child: Text(
            "Streaming 1",
            style: TextStyle(color: Colors.white, fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          width: double.infinity,
          height: 300,
          color: Colors.amber,
          child: Text(
            "Streaming 2",
            style: TextStyle(color: Colors.white, fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          width: double.infinity,
          height: 300,
          color: Colors.black,
          child: Text(
            "Streaming 3",
            style: TextStyle(color: Colors.white, fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
      ]),
    );
  }
}
