import 'package:flutter/material.dart';

// space
class Space extends StatelessWidget {
  double? height;
  double? width;
  Space({ this.width,  this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 0.0,
      width: width ?? 0.0,
    );
  }
}

//