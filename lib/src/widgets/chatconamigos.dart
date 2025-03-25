import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'Home.dart';
import 'package:adobe_xd/page_link.dart';
import 'Ayuda.dart';
import 'PerfilPublico.dart';
import 'dart:ui' as ui;
import 'package:flutter_svg/flutter_svg.dart';
import 'Settings.dart';
import 'ListadeAnimales.dart';

class chatconamigos extends StatelessWidget {
  const chatconamigos({
    required Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/BackGround.png'),
                fit: BoxFit.cover,
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: -58.0, vertical: 0.0),
          ),
          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5),
            Pin(size: 73.0, start: 42.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Home(key: Key('Home'),),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage(''),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                  border:
                      Border.all(width: 1.0, color: const Color(0xff000000)),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 52.9, start: 9.1),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage(''),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 40.5, middle: 0.8328),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Ayuda(key: Key('Ayuda'),),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage(''),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 4.0, end: 4.0),
            Pin(size: 600.0, end: 107.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0x8754d1e0),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(width: 1.0, color: const Color(0x87000000)),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 4.0, end: 4.0),
            Pin(size: 1.0, middle: 0.298),
            child: SvgPicture.string(
              _svg_uzpewl,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment(-0.478, -0.522),
            child: SizedBox(
              width: 71.0,
              height: 42.0,
              child: Text(
                'Kitty',
                style: TextStyle(
                  fontFamily: 'Comic Sans MS',
                  fontSize: 30,
                  color: const Color(0xff000000),
                ),
                softWrap: false,
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 64.0, start: 20.0),
            Pin(size: 64.0, middle: 0.2321),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => PerfilPublico(key: Key('PerfilPublico'),),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage(''),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.464, -0.521),
            child: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 63.0, middle: 0.5),
            Pin(size: 63.0, end: 44.0),
            child: Stack(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.9, vertical: 5.3),
                  child: Stack(
                    children: <Widget>[
                      SizedBox.expand(
                          child: SvgPicture.string(
                        _svg_fb3q1,
                        allowDrawingOutsideViewBox: true,
                        fit: BoxFit.fill,
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Pinned.fromPins(
            Pin(start: 4.0, end: 4.0),
            Pin(size: 63.0, end: 44.0),
            child: ClipRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                    border:
                        Border.all(width: 1.0, color: const Color(0xff000000)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xf2000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 190.0, end: 56.0),
            Pin(size: 56.0, end: 48.0),
            child: ClipRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 22.0, sigmaY: 22.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                    border:
                        Border.all(width: 1.0, color: const Color(0xff707070)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xf2000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 43.5, middle: 0.8276),
            Pin(size: 40.0, end: 55.5),
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
            Pin(size: 13.2, end: 19.7),
            Pin(size: 32.8, middle: 0.2419),
            child: Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(size: 7.0, middle: 0.5192),
                  Pin(start: 4.0, end: 3.8),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Pinned.fromPins(
                          Pin(start: 0.0, end: 1.2),
                          Pin(size: 24.0, end: 0.0),
                          child: SvgPicture.string(
                            _svg_xrr992,
                            allowDrawingOutsideViewBox: true,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 6.0,
                            height: 6.0,
                            decoration: BoxDecoration(
                              color: const Color(0xff000000),
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(9999.0, 9999.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Pinned.fromPins(
            Pin(size: 48.0, end: 15.0),
            Pin(size: 48.0, middle: 0.2322),
            child: Stack(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Pinned.fromPins(
            Pin(size: 88.0, middle: 0.5401),
            Pin(size: 28.0, end: 65.0),
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  fontFamily: 'Comic Sans MS',
                  fontSize: 20,
                  color: const Color(0xff000000),
                ),
                children: [
                  TextSpan(
                    text: 'Mensaje',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: '...',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              textHeightBehavior:
                  TextHeightBehavior(applyHeightToFirstAscent: false),
              softWrap: false,
            ),
          ),
          Pinned.fromPins(
            Pin(size: 40.1, middle: 0.2347),
            Pin(size: 40.0, end: 55.5),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 38.8, start: 44.8),
            Pin(size: 40.0, end: 55.5),
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
            Pin(size: 50.9, end: 39.0),
            Pin(size: 40.0, middle: 0.2397),
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
            Pin(size: 33.6, end: 15.3),
            Pin(size: 40.0, end: 56.0),
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
            Pin(size: 34.7, middle: 0.3474),
            Pin(size: 40.0, end: 54.0),
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
            Pin(size: 30.2, start: 11.0),
            Pin(size: 40.0, end: 55.5),
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
            Pin(size: 383.4, middle: 0.6989),
            Pin(size: 515.0, end: 111.1),
            child: SingleChildScrollView(
              primary: false,
              child: SizedBox(
                width: 383.0,
                height: 1134.0,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, -619.0),
                      child: SingleChildScrollView(
                        primary: false,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 20,
                          runSpacing: 20,
                          children: [{}, {}, {}].map((itemData) {
                            return SizedBox(
                              width: 383.0,
                              height: 501.0,
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment(1.0, -0.196),
                                    child: SizedBox(
                                      width: 261.0,
                                      height: 70.0,
                                      child: SvgPicture.string(
                                        _svg_x2icxv,
                                        allowDrawingOutsideViewBox: true,
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 27.0, start: 0.0),
                                    Pin(size: 27.0, start: 6.9),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: const AssetImage(''),
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(-1.0, 0.125),
                                    child: Container(
                                      width: 27.0,
                                      height: 27.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: const AssetImage(''),
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 27.0, start: 0.0),
                                    Pin(size: 27.0, end: 41.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: const AssetImage(''),
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 28.8, end: 40.2),
                                    Pin(size: 69.7, start: 0.0),
                                    child: SvgPicture.string(
                                      _svg_icj4fl,
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(1.0, -0.6),
                                    child: SizedBox(
                                      width: 314.0,
                                      height: 70.0,
                                      child: SvgPicture.string(
                                        _svg_dtu8fg,
                                        allowDrawingOutsideViewBox: true,
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 28.8, end: 40.2),
                                    Pin(size: 69.7, middle: 0.6018),
                                    child: SvgPicture.string(
                                      _svg_fj61hq,
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(1.0, 0.6),
                                    child: SizedBox(
                                      width: 314.0,
                                      height: 70.0,
                                      child: SvgPicture.string(
                                        _svg_fozgq4,
                                        allowDrawingOutsideViewBox: true,
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 28.8, end: 40.2),
                                    Pin(size: 68.0, end: 0.0),
                                    child: SvgPicture.string(
                                      _svg_f79p5o,
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 189.0, start: 47.0),
                                    Pin(size: 28.0, start: 18.9),
                                    child: Text(
                                      '¿Hola, como estás?',
                                      style: TextStyle(
                                        fontFamily: 'Comic Sans MS',
                                        fontSize: 20,
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      softWrap: false,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(-0.189, -0.542),
                                    child: SizedBox(
                                      width: 168.0,
                                      height: 28.0,
                                      child: Text(
                                        '¡Muy Bien! ¿y tú?',
                                        style: TextStyle(
                                          fontFamily: 'Comic Sans MS',
                                          fontSize: 20,
                                          color: const Color(0xff000000),
                                          fontWeight: FontWeight.w700,
                                        ),
                                        softWrap: false,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(-0.219, -0.209),
                                    child: SizedBox(
                                      width: 26.0,
                                      height: 28.0,
                                      child: Text(
                                        '...',
                                        style: TextStyle(
                                          fontFamily: 'Comic Sans MS',
                                          fontSize: 20,
                                          color: const Color(0xff000000),
                                          fontWeight: FontWeight.w700,
                                        ),
                                        softWrap: false,
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 26.0, start: 44.2),
                                    Pin(size: 28.0, middle: 0.5741),
                                    child: Text(
                                      '...',
                                      style: TextStyle(
                                        fontFamily: 'Comic Sans MS',
                                        fontSize: 20,
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      softWrap: false,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(-0.553, 0.515),
                                    child: SizedBox(
                                      width: 26.0,
                                      height: 28.0,
                                      child: Text(
                                        '...',
                                        style: TextStyle(
                                          fontFamily: 'Comic Sans MS',
                                          fontSize: 20,
                                          color: const Color(0xff000000),
                                          fontWeight: FontWeight.w700,
                                        ),
                                        softWrap: false,
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 26.0, start: 39.5),
                                    Pin(size: 28.0, end: 26.5),
                                    child: Text(
                                      '...',
                                      style: TextStyle(
                                        fontFamily: 'Comic Sans MS',
                                        fontSize: 20,
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      softWrap: false,
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 32.0, end: 8.4),
                                    Pin(size: 18.0, middle: 0.3212),
                                    child: Text(
                                      'Leído',
                                      style: TextStyle(
                                        fontFamily: 'Comic Sans MS',
                                        fontSize: 13,
                                        color: const Color(0xff000000),
                                      ),
                                      textAlign: TextAlign.center,
                                      softWrap: false,
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 32.0, end: 8.4),
                                    Pin(size: 18.0, middle: 0.4993),
                                    child: Text(
                                      'Leído',
                                      style: TextStyle(
                                        fontFamily: 'Comic Sans MS',
                                        fontSize: 13,
                                        color: const Color(0xff000000),
                                      ),
                                      textAlign: TextAlign.center,
                                      softWrap: false,
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 32.0, end: 8.4),
                                    Pin(size: 18.0, middle: 0.4993),
                                    child: Text(
                                      'Leído',
                                      style: TextStyle(
                                        fontFamily: 'Comic Sans MS',
                                        fontSize: 13,
                                        color: const Color(0xff000000),
                                      ),
                                      textAlign: TextAlign.center,
                                      softWrap: false,
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 32.0, end: 8.4),
                                    Pin(size: 18.0, end: 67.9),
                                    child: Text(
                                      'Leído',
                                      style: TextStyle(
                                        fontFamily: 'Comic Sans MS',
                                        fontSize: 13,
                                        color: const Color(0xff000000),
                                      ),
                                      textAlign: TextAlign.center,
                                      softWrap: false,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 47.2, end: 7.6),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Settings(key: Key('Settings'),),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage(''),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.1, end: 7.6),
            Pin(size: 60.0, start: 110.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => ListadeAnimales(key: Key("ListadeAnimales"),),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage(''),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_x2icxv =
    '<svg viewBox="142.4 439.2 261.0 69.7" ><path transform="translate(142.39, 439.21)" d="M 5.701456546783447 0 L 255.2985534667969 0 C 258.4473876953125 0 261 2.864627599716187 261 6.398325443267822 L 261 63.2723274230957 C 261 66.8060302734375 258.4473876953125 69.670654296875 255.2985534667969 69.670654296875 L 5.701456546783447 69.670654296875 C 2.552628993988037 69.670654296875 0 66.8060302734375 0 63.2723274230957 L 0 6.398325443267822 C 0 2.864627599716187 2.552628993988037 0 5.701456546783447 0 Z" fill="#ffffff" fill-opacity="0.53" stroke="#54d1e0" stroke-width="7" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_icj4fl =
    '<svg viewBox="48.8 265.9 314.3 69.7" ><path transform="translate(48.83, 265.85)" d="M 6.866647243499756 0 L 307.4732055664062 0 C 311.2655639648438 0 314.33984375 2.864627599716187 314.33984375 6.398325443267822 L 314.33984375 63.2723274230957 C 314.33984375 66.8060302734375 311.2655639648438 69.670654296875 307.4732055664062 69.670654296875 L 6.866647243499756 69.670654296875 C 3.074302673339844 69.670654296875 0 66.8060302734375 0 63.2723274230957 L 0 6.398325443267822 C 0 2.864627599716187 3.074302673339844 0 6.866647243499756 0 Z" fill="#ffffff" fill-opacity="0.53" stroke="#54d1e0" stroke-width="7" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_dtu8fg =
    '<svg viewBox="89.0 352.1 314.3 69.7" ><path transform="translate(89.05, 352.08)" d="M 6.866647243499756 0 L 307.4732055664062 0 C 311.2655639648438 0 314.33984375 2.864627599716187 314.33984375 6.398325443267822 L 314.33984375 63.2723274230957 C 314.33984375 66.8060302734375 311.2655639648438 69.670654296875 307.4732055664062 69.670654296875 L 6.866647243499756 69.670654296875 C 3.074302673339844 69.670654296875 0 66.8060302734375 0 63.2723274230957 L 0 6.398325443267822 C 0 2.864627599716187 3.074302673339844 0 6.866647243499756 0 Z" fill="#ffffff" fill-opacity="0.53" stroke="#54d1e0" stroke-width="7" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_fj61hq =
    '<svg viewBox="48.8 525.4 314.3 69.7" ><path transform="translate(48.83, 525.45)" d="M 6.866647243499756 0 L 307.4732055664062 0 C 311.2655639648438 0 314.33984375 2.864627599716187 314.33984375 6.398325443267822 L 314.33984375 63.2723274230957 C 314.33984375 66.8060302734375 311.2655639648438 69.670654296875 307.4732055664062 69.670654296875 L 6.866647243499756 69.670654296875 C 3.074302673339844 69.670654296875 0 66.8060302734375 0 63.2723274230957 L 0 6.398325443267822 C 0 2.864627599716187 3.074302673339844 0 6.866647243499756 0 Z" fill="#ffffff" fill-opacity="0.53" stroke="#54d1e0" stroke-width="7" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_fozgq4 =
    '<svg viewBox="89.0 610.9 314.3 69.7" ><path transform="translate(89.05, 610.88)" d="M 6.866647243499756 0 L 307.4732055664062 0 C 311.2655639648438 0 314.33984375 2.864627599716187 314.33984375 6.398325443267822 L 314.33984375 63.2723274230957 C 314.33984375 66.8060302734375 311.2655639648438 69.670654296875 307.4732055664062 69.670654296875 L 6.866647243499756 69.670654296875 C 3.074302673339844 69.670654296875 0 66.8060302734375 0 63.2723274230957 L 0 6.398325443267822 C 0 2.864627599716187 3.074302673339844 0 6.866647243499756 0 Z" fill="#ffffff" fill-opacity="0.53" stroke="#54d1e0" stroke-width="7" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_f79p5o =
    '<svg viewBox="48.8 698.9 314.3 68.0" ><path transform="translate(48.83, 698.88)" d="M 6.866647243499756 0 L 307.4732055664062 0 C 311.2655639648438 0 314.33984375 2.795644760131836 314.33984375 6.244247913360596 L 314.33984375 61.74867248535156 C 314.33984375 65.19728088378906 311.2655639648438 67.992919921875 307.4732055664062 67.992919921875 L 6.866647243499756 67.992919921875 C 3.074302673339844 67.992919921875 0 65.19728088378906 0 61.74867248535156 L 0 6.244247913360596 C 0 2.795644760131836 3.074302673339844 0 6.866647243499756 0 Z" fill="#ffffff" fill-opacity="0.53" stroke="#54d1e0" stroke-width="7" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_uzpewl =
    '<svg viewBox="4.0 265.5 404.0 1.0" ><path transform="translate(4.0, 265.5)" d="M 0 0 L 404 0" fill="none" stroke="#000000" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_fb3q1 =
    '<svg viewBox="0.0 0.0 55.1 52.5" ><path transform="translate(-3.94, -5.25)" d="M 49.875 22.3125 L 40.6875 22.3125 L 41.21249771118164 17.98124885559082 C 42 11.55000019073486 40.6875 6.431250095367432 36.48749923706055 5.25 L 36.09375 5.25 C 35.21182632446289 5.404857635498047 34.46967315673828 5.998579978942871 34.125 6.824999809265137 C 34.125 6.824999809265137 24.9375 26.25 21 26.25 L 6.5625 26.25 C 5.112752437591553 26.25 3.937499761581421 27.42525482177734 3.9375 28.875 L 3.9375 49.875 C 3.9375 51.32474517822266 5.112752437591553 52.5 6.5625 52.5 L 24.01874923706055 52.5 C 24.59357643127441 52.45124053955078 25.16314697265625 52.64109802246094 25.59375 53.02500152587891 C 27.43124961853027 54.33750152587891 33.60000228881836 57.75 36.75 57.75 L 43.3125 57.75 C 51.05625152587891 57.75 57.75 52.5 58.40625 42.13124847412109 L 58.40625 42.13124847412109 L 59.0625 31.5 C 59.17580032348633 29.03033256530762 58.24427032470703 26.62705230712891 56.49610900878906 24.8788948059082 C 54.74795913696289 23.13073921203613 52.34467315673828 22.1992073059082 49.87500381469727 22.31250190734863 Z M 9.1875 31.5 L 17.0625 31.5 L 17.0625 47.25 L 9.1875 47.25 L 9.1875 31.5 Z M 53.15625 41.73749923706055 L 53.15625 41.73749923706055 C 52.63124847412109 48.5625 48.95624923706055 52.5 43.3125 52.5 L 36.75 52.5 C 35.17499923706055 52.36875152587891 30.45000076293945 50.00624847412109 28.74374961853027 48.82500076293945 C 27.38990592956543 47.78504180908203 25.72579574584961 47.23033905029297 24.01874923706055 47.25 L 22.3125 47.25 L 22.3125 31.5 C 24.80624961853027 30.97500038146973 28.875 28.61249923706055 36.09375 14.69999980926514 C 36.10972595214844 15.62062168121338 36.06588363647461 16.54130935668945 35.96249771118164 17.45624923706055 L 35.4375 21.78750038146973 L 34.78125 27.5625 L 49.875 27.5625 C 50.92844772338867 27.44122505187988 51.98085021972656 27.79808044433594 52.74327087402344 28.53508567810059 C 53.50568771362305 29.27209281921387 53.89800262451172 30.31179618835449 53.81249618530273 31.36874961853027 L 53.15625 41.73749923706055 Z" fill="#000000" stroke="none" stroke-width="1.3125" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_xrr992 =
    '<svg viewBox="0.0 8.5 12.0 24.0" ><path transform="translate(-15.98, -8.0)" d="M 27.20000076293945 34.79999923706055 L 22.70000076293945 35.20000076293945 C 22.70000076293945 35.20000076293945 24.90000152587891 27.30000114440918 26.5 22 C 26.94443130493164 20.78423309326172 26.78862190246582 19.42998886108398 26.07970428466797 18.34692001342773 C 25.37078475952148 17.26384925842285 24.1920280456543 16.57917213439941 22.89999961853027 16.49999809265137 C 21.86975288391113 16.49522590637207 20.88682746887207 16.93208122253418 20.20000076293945 17.70000076293945 L 16.19999885559082 21 C 15.97420883178711 21.2117805480957 15.91434097290039 21.54672050476074 16.05278396606445 21.82360649108887 C 16.19122695922852 22.10049247741699 16.4951000213623 22.25356292724609 16.79999923706055 22.19999885559082 L 21.29999923706055 21.80000114440918 L 17.5 35 C 17.05556869506836 36.21576690673828 17.21137809753418 37.57001113891602 17.92029762268066 38.65307998657227 C 18.62921524047852 39.73614883422852 19.8079719543457 40.42082595825195 21.10000038146973 40.5 C 22.1302490234375 40.50477600097656 23.11317443847656 40.06792068481445 23.80000114440918 39.29999923706055 L 27.80000114440918 36 C 28.02578735351562 35.78821563720703 28.08565521240234 35.45327758789062 27.94721221923828 35.1763916015625 C 27.80877113342285 34.89950561523438 27.50489807128906 34.74643707275391 27.20000076293945 34.79999923706055 Z" fill="#000000" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
