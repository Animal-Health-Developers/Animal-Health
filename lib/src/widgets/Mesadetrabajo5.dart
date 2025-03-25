import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:adobe_xd/pinned.dart';

class Mesadetrabajo5 extends StatelessWidget {
  const Mesadetrabajo5({
    required Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ClipRect(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x3bffffff),
                  border:
                      Border.all(width: 1.0, color: const Color(0xff707070)),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(end: 0.0, startFraction: 0.0),
            Pin(size: 412.0, middle: 0.5),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
