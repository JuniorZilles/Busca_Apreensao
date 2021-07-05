import 'package:flutter/material.dart';

class ImageDefinition {
  Image obterIcon() {
    return Image(
      image: AssetImage('assets/icone2.png'),
      height: 150,
      width: 150,
      alignment: Alignment.center,
      fit: BoxFit.contain,
    );
  }

  Image obterIcon2() {
    return Image(
      image: AssetImage('assets/icone.png'),
      height: 150,
      width: 150,
      alignment: Alignment.center,
      fit: BoxFit.contain,
    );
  }
  
  ImageProvider obterIconAsImageProvider() {
    return AssetImage('assets/icone2.png');
  }
}
