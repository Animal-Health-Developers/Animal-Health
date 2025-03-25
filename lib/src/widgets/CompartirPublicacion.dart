import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'Home.dart';
import 'package:adobe_xd/page_link.dart';
import 'Ayuda.dart';
import 'PerfilPublico.dart';
import 'Settings.dart';
import 'ListadeAnimales.dart';
import 'dart:ui' as ui;

class CompartirPublicacion extends StatelessWidget {
  const CompartirPublicacion({
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
            Pin(start: 14.0, end: 14.0),
            Pin(size: 661.0, end: 52.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0x8754d1e0),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(width: 1.0, color: const Color(0x87000000)),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 231.0, start: 41.0),
            Pin(size: 660.0, end: 52.1),
            child: SingleChildScrollView(
              primary: false,
              child: SizedBox(
                width: 231.0,
                height: 1074.0,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, -414.0),
                      child: SingleChildScrollView(
                        primary: false,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 20,
                          runSpacing: 20,
                          children: [{}, {}, {}, {}].map((itemData) {
                            return SizedBox(
                              width: 231.0,
                              height: 302.0,
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment(1.0, -0.574),
                                    child: ClipRect(
                                      child: BackdropFilter(
                                        filter: ui.ImageFilter.blur(
                                            sigmaX: 36.0, sigmaY: 36.0),
                                        child: Container(
                                          width: 129.0,
                                          height: 25.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0x7a54d1e0),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xff707070)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 71.0, end: 30.5),
                                    Pin(size: 21.0, middle: 0.21),
                                    child: Text(
                                      'Compartir',
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
                                    Pin(size: 36.0, middle: 0.5333),
                                    Pin(size: 21.0, start: 16.0),
                                    child: Text(
                                      'Kitty',
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
                                    Pin(size: 38.0, middle: 0.5389),
                                    Pin(size: 14.0, start: 41.0),
                                    child: Text(
                                      'En linea',
                                      style: TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontSize: 10,
                                        color: const Color(0xff050505),
                                        fontWeight: FontWeight.w600,
                                        height: 1.2,
                                      ),
                                      textHeightBehavior: TextHeightBehavior(
                                          applyHeightToFirstAscent: false),
                                      softWrap: false,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0.095, -0.11),
                                    child: SizedBox(
                                      width: 41.0,
                                      height: 21.0,
                                      child: Text(
                                        'Donut',
                                        style: TextStyle(
                                          fontFamily: 'Comic Sans MS',
                                          fontSize: 15,
                                          color: const Color(0xff000000),
                                          fontWeight: FontWeight.w700,
                                        ),
                                        softWrap: false,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0.095, 0.042),
                                    child: SizedBox(
                                      width: 41.0,
                                      height: 14.0,
                                      child: Text(
                                        'En Linea',
                                        style: TextStyle(
                                          fontFamily: 'Open Sans',
                                          fontSize: 10,
                                          color: const Color(0xff050505),
                                          fontWeight: FontWeight.w600,
                                          height: 1.2,
                                        ),
                                        textHeightBehavior: TextHeightBehavior(
                                            applyHeightToFirstAscent: false),
                                        softWrap: false,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0.138, 0.665),
                                    child: SizedBox(
                                      width: 50.0,
                                      height: 21.0,
                                      child: Text(
                                        'Winter',
                                        style: TextStyle(
                                          fontFamily: 'Comic Sans MS',
                                          fontSize: 15,
                                          color: const Color(0xff000000),
                                          fontWeight: FontWeight.w700,
                                        ),
                                        softWrap: false,
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 38.0, middle: 0.5337),
                                    Pin(size: 14.0, end: 29.0),
                                    child: Text(
                                      'En linea',
                                      style: TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontSize: 10,
                                        color: const Color(0xff050505),
                                        fontWeight: FontWeight.w600,
                                        height: 1.2,
                                      ),
                                      textHeightBehavior: TextHeightBehavior(
                                          applyHeightToFirstAscent: false),
                                      softWrap: false,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: 84.0,
                                      height: 84.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: const AssetImage(''),
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      width: 84.0,
                                      height: 84.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: const AssetImage(''),
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 84.0, start: 2.0),
                                    Pin(size: 84.0, end: 0.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: const AssetImage(''),
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(42.0),
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 84.0, start: 2.0),
                                    Pin(size: 84.0, end: 0.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: const AssetImage(''),
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(42.0),
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 84.0, start: 2.0),
                                    Pin(size: 84.0, end: 0.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: const AssetImage(''),
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(42.0),
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 84.0, start: 2.0),
                                    Pin(size: 84.0, end: 0.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: const AssetImage(''),
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(1.0, 0.235),
                                    child: ClipRect(
                                      child: BackdropFilter(
                                        filter: ui.ImageFilter.blur(
                                            sigmaX: 36.0, sigmaY: 36.0),
                                        child: Container(
                                          width: 129.0,
                                          height: 25.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0x7a54d1e0),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xff707070)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 71.0, end: 30.5),
                                    Pin(size: 21.0, middle: 0.6157),
                                    child: Text(
                                      'Compartir',
                                      style: TextStyle(
                                        fontFamily: 'Comic Sans MS',
                                        fontSize: 15,
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      softWrap: false,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: ClipRect(
                                      child: BackdropFilter(
                                        filter: ui.ImageFilter.blur(
                                            sigmaX: 36.0, sigmaY: 36.0),
                                        child: Container(
                                          width: 129.0,
                                          height: 25.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0x7a54d1e0),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xff707070)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 71.0, end: 30.5),
                                    Pin(size: 21.0, end: 1.0),
                                    child: Text(
                                      'Compartir',
                                      style: TextStyle(
                                        fontFamily: 'Comic Sans MS',
                                        fontSize: 15,
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w700,
                                      ),
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
        ],
      ),
    );
  }
}
