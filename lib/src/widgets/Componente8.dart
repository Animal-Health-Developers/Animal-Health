import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Componente8 extends StatelessWidget {
  const Componente8({
    required Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(1431.0, 1457.0, 0.0, 0.0),
          child: SizedBox.expand(
              child: SvgPicture.string(
            _svg_wxpd6m,
            allowDrawingOutsideViewBox: true,
            fit: BoxFit.fill,
          )),
        ),
        Pinned.fromPins(
          Pin(size: 30.0, start: 1464.0),
          Pin(start: 1460.0, end: 3.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
              border: Border.all(width: 1.0, color: const Color(0xff707070)),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffc2bbbb),
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(width: 1.0, color: const Color(0xff707070)),
          ),
          margin: EdgeInsets.fromLTRB(0.0, 0.0, 1431.0, 1457.0),
        ),
        Pinned.fromPins(
          Pin(size: 30.0, start: 3.0),
          Pin(start: 3.0, end: 1460.0),
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

const String _svg_wxpd6m =
    '<svg viewBox="1431.0 1457.0 66.0 36.0" ><path transform="translate(1431.0, 1457.0)" d="M 18 0 L 48 0 C 57.94112396240234 0 66 8.058874130249023 66 18 C 66 27.94112586975098 57.94112396240234 36 48 36 L 18 36 C 8.058874130249023 36 0 27.94112586975098 0 18 C 0 8.058874130249023 8.058874130249023 0 18 0 Z" fill="#2e92df" stroke="#707070" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
