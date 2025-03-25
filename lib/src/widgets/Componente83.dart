import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';

class Componente83 extends StatelessWidget {
  const Componente83({
    required Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffc2bbbb),
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(width: 1.0, color: const Color(0xff707070)),
          ),
        ),
        Pinned.fromPins(
          Pin(size: 26.0, start: 2.0),
          Pin(start: 2.0, end: 2.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
              border: Border.all(width: 1.0, color: const Color(0xff707070)),
            ),
          ),
        ),
      ],
    );
  }
}
