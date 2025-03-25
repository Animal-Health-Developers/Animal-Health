import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Serviciosveterinarios extends StatelessWidget {
  const Serviciosveterinarios({
    required Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
              child: SvgPicture.string(
            _svg_ebb638,
            allowDrawingOutsideViewBox: true,
            fit: BoxFit.fill,
          )),
          Pinned.fromPins(
            Pin(start: 47.0, end: 47.0),
            Pin(size: 50.0, middle: 0.2292),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(7.0),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(114.0, 200.0),
            child: Text(
              'Consulta General',
              style: TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 25,
                color: const Color(0xff000000),
              ),
              softWrap: false,
            ),
          ),
          Transform.translate(
            offset: Offset(53.5, 195.0),
            child: Container(
              width: 42.0,
              height: 45.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 47.0, end: 47.0),
            Pin(size: 50.0, middle: 0.3052),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(7.0),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(52.1, 259.5),
            child: Container(
              width: 45.0,
              height: 45.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(142.5, 264.5),
            child: Text(
              'Vacunación',
              style: TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 25,
                color: const Color(0xff000000),
              ),
              softWrap: false,
            ),
          ),
          Pinned.fromPins(
            Pin(start: 47.0, end: 47.0),
            Pin(size: 50.0, middle: 0.3824),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(7.0),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(114.0, 329.0),
            child: Text(
              'Desparasitación',
              style: TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 25,
                color: const Color(0xff000000),
              ),
              softWrap: false,
            ),
          ),
          Transform.translate(
            offset: Offset(49.6, 324.0),
            child: Container(
              width: 48.0,
              height: 45.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 47.0, end: 47.0),
            Pin(size: 50.0, middle: 0.6152),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(7.0),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(148.5, 525.5),
            child: Text(
              'Fracturas',
              style: TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 25,
                color: const Color(0xff000000),
              ),
              softWrap: false,
            ),
          ),
          Pinned.fromPins(
            Pin(size: 44.5, start: 53.5),
            Pin(size: 45.0, middle: 0.6145),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 47.0, end: 47.0),
            Pin(size: 50.0, middle: 0.6936),
            child: SvgPicture.string(
              _svg_ly1t6,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Transform.translate(
            offset: Offset(127.0, 591.5),
            child: Text(
              'Esterilización',
              style: TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 25,
                color: const Color(0xff000000),
              ),
              softWrap: false,
            ),
          ),
          Pinned.fromPins(
            Pin(size: 44.2, start: 53.5),
            Pin(size: 45.0, middle: 0.6924),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 47.0, end: 47.0),
            Pin(size: 50.0, middle: 0.772),
            child: SvgPicture.string(
              _svg_vm1nme,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Transform.translate(
            offset: Offset(135.0, 654.5),
            child: Text(
              'Otros Casos',
              style: TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 25,
                color: const Color(0xff000000),
              ),
              softWrap: false,
            ),
          ),
          Pinned.fromPins(
            Pin(start: 47.0, end: 47.0),
            Pin(size: 50.0, middle: 0.4596),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(7.0),
                    border:
                        Border.all(width: 1.0, color: const Color(0xff707070)),
                  ),
                ),
                Transform.translate(
                  offset: Offset(5.0, 2.5),
                  child: Container(
                    width: 38.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage(''),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(96.5, 4.5),
                  child: Text(
                    'Curaciones',
                    style: TextStyle(
                      fontFamily: 'Comic Sans MS',
                      fontSize: 25,
                      color: const Color(0xff000000),
                    ),
                    softWrap: false,
                  ),
                ),
              ],
            ),
          ),
          Pinned.fromPins(
            Pin(start: 47.0, end: 47.0),
            Pin(size: 50.0, middle: 0.5368),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(7.0),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(113.5, 459.5),
            child: Text(
              'Desparasitación',
              style: TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 25,
                color: const Color(0xff000000),
              ),
              softWrap: false,
            ),
          ),
          Transform.translate(
            offset: Offset(53.5, 454.5),
            child: Container(
              width: 35.0,
              height: 45.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_ebb638 =
    '<svg viewBox="0.0 0.0 412.0 892.0" ><path  d="M 0 0 L 412 0 L 412 892 L 0 892 L 0 0 Z" fill="#ffffff" stroke="#707070" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_ly1t6 =
    '<svg viewBox="47.0 584.0 318.0 50.0" ><path transform="translate(47.0, 584.0)" d="M 7 0 L 311 0 C 314.8659973144531 0 318 3.561371088027954 318 7.954545497894287 L 318 42.04545593261719 C 318 46.43862915039062 314.8659973144531 50 311 50 L 7 50 C 3.134006500244141 50 0 46.43862915039062 0 42.04545593261719 L 0 7.954545497894287 C 0 3.561371088027954 3.134006500244141 0 7 0 Z" fill="#ffffff" stroke="#707070" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_vm1nme =
    '<svg viewBox="47.0 650.0 318.0 50.0" ><path transform="translate(47.0, 650.0)" d="M 7 0 L 311 0 C 314.8659973144531 0 318 3.561371088027954 318 7.954545497894287 L 318 42.04545593261719 C 318 46.43862915039062 314.8659973144531 50 311 50 L 7 50 C 3.134006500244141 50 0 46.43862915039062 0 42.04545593261719 L 0 7.954545497894287 C 0 3.561371088027954 3.134006500244141 0 7 0 Z" fill="#ffffff" stroke="#707070" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
