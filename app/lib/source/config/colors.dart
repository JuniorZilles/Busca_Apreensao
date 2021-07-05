import 'package:flutter/material.dart';

class ColorsDefinitions{

  static const MaterialColor orange = const MaterialColor(
    0xFFEF6C00,
    const <int, Color>{
      50:  const Color(0xFFEF6C00),
      100: const Color(0xFFEF6C00),
      200: const Color(0xFFEF6C00),
      300: const Color(0xFFEF6C00),
      400: const Color(0xFFEF6C00),
      500: const Color(0xFFEF6C00),
      600: const Color(0xFFEF6C00),
      700: const Color(0xFFEF6C00),
      800: const Color(0xFFEF6C00),
      900: const Color(0xFFEF6C00),
    },
  );
  
  Color obterAppTheme(){
    return orange;
  }

  Color obterThemeColor(){
    return Colors.orange[800];
  }

  Color obterThemeTextColor(){
    return Colors.white;
  }

  Color obterThemeSecundary(){
    return Colors.orange.shade800;
  }

   Color obterText(){
    return Colors.grey;
  }

  Color obterShadowText(){
    return Colors.black26;
  }
}