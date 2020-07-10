import 'dart:io';

import 'package:chatup/widgets/widget.dart';
import "package:flutter/material.dart";

class ImageDisplay extends StatelessWidget {
  final File imageFile;
  ImageDisplay(this.imageFile);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Center(
        child: Container(
          child: Image.file(imageFile, width: 400, height: 400),
        ),
      )
    );
  }
}
