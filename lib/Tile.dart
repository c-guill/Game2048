import 'dart:ui';
import 'package:flutter/material.dart';

import 'TileStyle.dart';

class Tile extends StatelessWidget {
  final int value;

  const Tile({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = _tileStyle(value);
    final txt = value == 0 ? '' : '$value';
    final txtStyle = value <= 4
        ? TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)
        : TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white);
    return AnimatedContainer(
      duration: Duration(milliseconds: 120),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (style.imagePath != null)
            Padding(
              padding: EdgeInsets.all(6),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset(style.imagePath!),
              ),
            ),
        ],
      ),
    );
  }

  TileStyle _tileStyle(int v) {
    switch (v) {
      case 2:
        return TileStyle(
          Color(0xffeee4da),
          Color(0xff776e65),
          28,
          imagePath: "media/spermatozoid.jpg",
        );
      case 4:
        return TileStyle(
          Color(0xffede0c8),
          Color(0xff776e65),
          28,
          imagePath: "media/foetus_simpson.png",
        );
      case 8:
        return TileStyle(
          Color(0xfff2b179),
          Colors.white,
          28,
          imagePath: "media/bebe.png",
        );
      case 16:
        return TileStyle(
          Color(0xfff59563),
          Colors.white,
          26,
          imagePath: "media/enfant.png",
        );
      case 32:
        return TileStyle(
          Color(0xfff67c5f),
          Colors.white,
          26,
          imagePath: "media/bart.png",
        );
      case 64:
        return TileStyle(
          Color(0xfff65e3b),
          Colors.white,
          26,
          imagePath: "media/ado.png",
        );
      case 128:
        return TileStyle(
          Color(0xffedcf72),
          Colors.white,
          22,
          imagePath: "media/Homer_young.webp",
        );
      case 256:
        return TileStyle(
          Color(0xffedcc61),
          Colors.white,
          22,
          imagePath: "media/Homer.webp",
        );
      case 512:
        return TileStyle(
          Color(0xffedc850),
          Colors.white,
          20,
          imagePath: "media/200px-Evil_Burns.png",
        );
      case 1024:
        return TileStyle(
          Color(0xffedc53f),
          Colors.white,
          18,
          imagePath: "media/vieux.png",
        );
      case 2048:
        return TileStyle(
          Color(0xffedc22e),
          Colors.white,
          18,
          imagePath: "media/2048.png",
        );
      case 1:
        return TileStyle(
          Color(0xff80f557),
          Colors.white,
          18,
          imagePath: "media/Taverne_de_Moe.webp",
        );
      case 3:
        return TileStyle(
          Color(0xffD10000),
          Colors.white,
          18,
          imagePath: "media/tombe.webp",
        );
      default:
        return TileStyle(Colors.transparent.withOpacity(0.15), Colors.white, 16);
    }
  }
}