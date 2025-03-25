import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'Home.dart';
import 'package:adobe_xd/page_link.dart';
import 'Ayuda.dart';
import 'PerfilPublico.dart';
import 'Settings.dart';
import 'ListadeAnimales.dart';
import 'dart:ui' as ui;
import 'CompartirPublicacion.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetallesdeFotooVideo extends StatelessWidget {
  const DetallesdeFotooVideo({
    required Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000000),
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
            Pin(size: 60.0, start: 13.0),
            Pin(size: 60.0, start: 115.0),
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
                  borderRadius: BorderRadius.circular(10.0),
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
                  pageBuilder: () => ListadeAnimales(key: Key('ListadeAnimales'),),
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
            Pin(size: 414.0, middle: 0.5),
            Pin(start: 192.0, end: 0.0),
            child: SingleChildScrollView(
              primary: false,
              child: SizedBox(
                width: 414.0,
                height: 1268.0,
                child: Stack(
                  children: <Widget>[
                    Pinned.fromPins(
                      Pin(size: 1.0, middle: 0.367),
                      Pin(size: 1.0, start: 33.5),
                      child: SvgPicture.string(
                        _svg_vlnkoj,
                        allowDrawingOutsideViewBox: true,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(start: 0.0, end: 0.0),
                      Pin(size: 45.0, end: 22.0),
                      child: SvgPicture.string(
                        _svg_sa9bsn,
                        allowDrawingOutsideViewBox: true,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 37.0, start: 48.0),
                      Pin(size: 28.0, end: 30.3),
                      child: Stack(
                        children: <Widget>[
                          SizedBox.expand(
                              child: Text(
                            '777',
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 20,
                              color: const Color(0xff000000),
                              height: 1.2,
                            ),
                            textHeightBehavior: TextHeightBehavior(
                                applyHeightToFirstAscent: false),
                            softWrap: false,
                          )),
                        ],
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 36.1, start: 7.9),
                      Pin(size: 40.0, end: 24.8),
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
                      Pin(size: 37.8, middle: 0.2631),
                      Pin(size: 40.0, end: 24.3),
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
                      Pin(size: 40.4, end: 9.6),
                      Pin(size: 40.0, end: 24.3),
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
                      Pin(size: 54.0, end: 53.0),
                      Pin(size: 28.0, end: 30.0),
                      child: Stack(
                        children: <Widget>[
                          SizedBox.expand(
                              child: Text(
                            'SAVE',
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 20,
                              color: const Color(0xff000000),
                              height: 1.2,
                            ),
                            textHeightBehavior: TextHeightBehavior(
                                applyHeightToFirstAscent: false),
                            textAlign: TextAlign.right,
                            softWrap: false,
                          )),
                        ],
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 21.0, middle: 0.3486),
                      Pin(size: 28.0, end: 30.0),
                      child: Stack(
                        children: <Widget>[
                          SizedBox.expand(
                              child: Text(
                            '13',
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 20,
                              color: const Color(0xff000000),
                              height: 1.2,
                            ),
                            textHeightBehavior: TextHeightBehavior(
                                applyHeightToFirstAscent: false),
                            softWrap: false,
                          )),
                        ],
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(start: 1.0, end: 1.0),
                      Pin(size: 100.0, start: 0.0),
                      child: ClipRect(
                        child: BackdropFilter(
                          filter:
                              ui.ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xba54d1e0),
                              border: Border.all(
                                  width: 1.0, color: const Color(0xba000000)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 187.0, start: 52.0),
                      Pin(size: 28.0, start: 8.0),
                      child: Text(
                        'Nombre de Usuario',
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
                      Pin(start: 18.0, end: 4.0),
                      Pin(size: 42.0, start: 50.0),
                      child: Text(
                        'Kitty estrenando sus nuevas orejeras que compramos \n#Amazon',
                        style: TextStyle(
                          fontFamily: 'Comic Sans MS',
                          fontSize: 15,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700,
                        ),
                        softWrap: false,
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 40.0, start: 5.0),
                      Pin(size: 40.0, start: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: const AssetImage(''),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage(''),
                          fit: BoxFit.fill,
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(1.0, 100.0, 1.0, 67.0),
                    ),
                    Pinned.fromPins(
                      Pin(size: 33.6, middle: 0.6615),
                      Pin(size: 30.0, start: 7.0),
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
                      Pin(size: 35.0, middle: 0.6965),
                      Pin(size: 40.0, end: 24.0),
                      child: PageLink(
                        links: [
                          PageLinkInfo(
                            transition: LinkTransition.Fade,
                            ease: Curves.easeOut,
                            duration: 0.3,
                            pageBuilder: () => CompartirPublicacion(key: Key('CompartirPublicacion'),),
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
                      Pin(size: 69.0, middle: 0.5565),
                      Pin(size: 28.0, end: 30.0),
                      child: Stack(
                        children: <Widget>[
                          SizedBox.expand(
                              child: Text(
                            'SHARE',
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 20,
                              color: const Color(0xff000000),
                              height: 1.2,
                            ),
                            textHeightBehavior: TextHeightBehavior(
                                applyHeightToFirstAscent: false),
                            textAlign: TextAlign.right,
                            softWrap: false,
                          )),
                        ],
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(start: 1.0, end: 1.0),
                      Pin(size: 588.0, end: -568.0),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xe3a0f4fe),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  width: 1.0, color: const Color(0xe3000000)),
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 50.0, start: 7.0),
                            Pin(size: 50.0, start: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: const AssetImage(''),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 157.0, start: 60.0),
                            Pin(size: 28.0, start: 21.0),
                            child: Text(
                              'Anderson Florez',
                              style: TextStyle(
                                fontFamily: 'Comic Sans MS',
                                fontSize: 20,
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                              textHeightBehavior: TextHeightBehavior(
                                  applyHeightToFirstAscent: false),
                              textAlign: TextAlign.right,
                              softWrap: false,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 206.0, start: 7.0),
                            Pin(size: 28.0, start: 65.0),
                            child: Text(
                              'Quedó hermosa Kitty',
                              style: TextStyle(
                                fontFamily: 'Comic Sans MS',
                                fontSize: 20,
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                              textHeightBehavior: TextHeightBehavior(
                                  applyHeightToFirstAscent: false),
                              textAlign: TextAlign.right,
                              softWrap: false,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 157.0, start: 60.0),
                            Pin(size: 28.0, middle: 0.2143),
                            child: Text(
                              'Anderson Florez',
                              style: TextStyle(
                                fontFamily: 'Comic Sans MS',
                                fontSize: 20,
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                              textHeightBehavior: TextHeightBehavior(
                                  applyHeightToFirstAscent: false),
                              textAlign: TextAlign.right,
                              softWrap: false,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 50.0, start: 7.0),
                            Pin(size: 50.0, middle: 0.2026),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: const AssetImage(''),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 206.0, start: 7.0),
                            Pin(size: 28.0, middle: 0.2929),
                            child: Text(
                              'Quedó hermosa Kitty',
                              style: TextStyle(
                                fontFamily: 'Comic Sans MS',
                                fontSize: 20,
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                              textHeightBehavior: TextHeightBehavior(
                                  applyHeightToFirstAscent: false),
                              textAlign: TextAlign.right,
                              softWrap: false,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 157.0, start: 60.0),
                            Pin(size: 28.0, middle: 0.3982),
                            child: Text(
                              'Anderson Florez',
                              style: TextStyle(
                                fontFamily: 'Comic Sans MS',
                                fontSize: 20,
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                              textHeightBehavior: TextHeightBehavior(
                                  applyHeightToFirstAscent: false),
                              textAlign: TextAlign.right,
                              softWrap: false,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 50.0, start: 7.0),
                            Pin(size: 50.0, middle: 0.3941),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: const AssetImage(''),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 206.0, start: 7.0),
                            Pin(size: 28.0, middle: 0.4839),
                            child: Text(
                              'Quedó hermosa Kitty',
                              style: TextStyle(
                                fontFamily: 'Comic Sans MS',
                                fontSize: 20,
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                              textHeightBehavior: TextHeightBehavior(
                                  applyHeightToFirstAscent: false),
                              textAlign: TextAlign.right,
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_vlnkoj =
    '<svg viewBox="151.6 33.5 1.0 1.0" ><path transform="translate(1.0, -297.0)" d="M 150.5888214111328 330.5046081542969" fill="none" stroke="#4ec8dd" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_sa9bsn =
    '<svg viewBox="0.0 633.0 414.0 45.0" ><path transform="translate(0.0, 633.0)" d="M 0 0 L 414.0000305175781 0 L 414.0000305175781 45 L 0 45 L 0 0 Z" fill="#54d1e0" fill-opacity="0.53" stroke="#000000" stroke-width="1" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
