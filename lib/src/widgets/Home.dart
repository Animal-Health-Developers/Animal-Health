import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'Ayuda.dart';
import 'package:adobe_xd/page_link.dart';
import 'PerfilPublico.dart';
import 'DetallesdeFotooVideo.dart';
import 'dart:ui' as ui;
import 'CompartirPublicacion.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'Settings.dart';
import 'CompradeProductos.dart';
import 'ListadeAnimales.dart';
import 'CuidadosyRecomendaciones.dart';
import 'Emergencias.dart';
import 'Comunidad.dart';
import 'Cearpublicaciones.dart';

class Home extends StatelessWidget {
  const Home({
    required Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/BackGround.png'),
                fit: BoxFit.cover,
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 58.0, vertical: 0.0),
          ),
          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5),
            Pin(size: 73.0, start: 42.0),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(width: 1.0, color: const Color(0xff000000)),
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
                  pageBuilder: () => Ayuda(key: Key("Ayuda"),),
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
            Pin(size: 307.0, end: 33.0),
            Pin(size: 45.0, middle: 0.1995),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.255, -0.593),
            child: SizedBox(
              width: 216.0,
              height: 28.0,
              child: Text(
                '¿Qué estás buscando?',
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
            alignment: Alignment(-0.585, -0.591),
            child: Container(
              width: 31.0,
              height: 31.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.0, start: 6.0),
            Pin(size: 60.0, middle: 0.1947),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => PerfilPublico(key: Key("PerfilPublico"),),
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
            Pin(size: 430.0, middle: 0.5),
            Pin(start: 288.0, end: 0.0),
            child: SingleChildScrollView(
              primary: false,
              child: SizedBox(
                width: 430.0,
                height: 1952.0,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, -1348.0),
                      child: GridView.count(
                        mainAxisSpacing: 9,
                        crossAxisSpacing: 20,
                        crossAxisCount: 1,
                        childAspectRatio: 0.45,
                        children: [{}, {}].map((itemData) {
                          return Stack(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0.0, 0.0, 0.0, 29.0),
                                    child: Stack(
                                      children: <Widget>[
                                        Pinned.fromPins(
                                          Pin(size: 1.0, middle: 0.3662),
                                          Pin(size: 1.0, start: 34.5),
                                          child: SvgPicture.string(
                                            _svg_bzyupw,
                                            allowDrawingOutsideViewBox: true,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(start: 1.0, end: 2.0),
                                          Pin(size: 196.0, start: 50.0),
                                          child: PageLink(
                                            links: [
                                              PageLinkInfo(
                                                transition: LinkTransition.Fade,
                                                ease: Curves.easeOut,
                                                duration: 0.3,
                                                pageBuilder: () =>
                                                    DetallesdeFotooVideo(key: Key("DetallesdeFotooVideo"),),
                                              ),
                                            ],
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: const AssetImage(''),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(-0.263, -0.372),
                                          child: SizedBox(
                                            width: 1.0,
                                            height: 1.0,
                                            child: SvgPicture.string(
                                              _svg_guzxfw,
                                              allowDrawingOutsideViewBox: true,
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(start: 1.0, end: 1.0),
                                          Pin(size: 196.0, middle: 0.4722),
                                          child: PageLink(
                                            links: [
                                              PageLinkInfo(
                                                transition: LinkTransition.Fade,
                                                ease: Curves.easeOut,
                                                duration: 0.3,
                                                pageBuilder: () =>
                                                    DetallesdeFotooVideo(key: Key("DetallesdeFotooVideo"),),
                                              ),
                                            ],
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: const AssetImage(''),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(start: 0.0, end: 3.0),
                                          Pin(size: 1.0, middle: 0.3637),
                                          child: SvgPicture.string(
                                            _svg_u50o6d,
                                            allowDrawingOutsideViewBox: true,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(start: 0.0, end: 0.0),
                                          Pin(size: 1.0, start: 50.0),
                                          child: SvgPicture.string(
                                            _svg_ij4r4z,
                                            allowDrawingOutsideViewBox: true,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(start: 1.0, end: 2.0),
                                          Pin(size: 321.0, end: 16.0),
                                          child: Stack(
                                            children: <Widget>[
                                              PageLink(
                                                links: [
                                                  PageLinkInfo(
                                                    transition:
                                                        LinkTransition.Fade,
                                                    ease: Curves.easeOut,
                                                    duration: 0.3,
                                                    pageBuilder: () =>
                                                        DetallesdeFotooVideo(key: Key("DetallesdeFotooVideo"),),
                                                  ),
                                                ],
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image:
                                                          const AssetImage(''),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color(
                                                            0xff080808),
                                                        offset: Offset(0, 3),
                                                        blurRadius: 6,
                                                      ),
                                                    ],
                                                  ),
                                                  margin: EdgeInsets.fromLTRB(
                                                      0.0, 100.0, 0.0, 0.0),
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(start: 0.0, end: 0.0),
                                                Pin(size: 100.0, start: 0.0),
                                                child: ClipRect(
                                                  child: BackdropFilter(
                                                    filter: ui.ImageFilter.blur(
                                                        sigmaX: 50.0,
                                                        sigmaY: 50.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xba54d1e0),
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: const Color(
                                                                0xba000000)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 187.0, start: 54.0),
                                                Pin(size: 28.0, start: 9.0),
                                                child: Text(
                                                  'Nombre de Usuario',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(start: 7.0, end: 13.0),
                                                Pin(size: 42.0, middle: 0.1971),
                                                child: Text(
                                                  'Kitty estrenando sus nuevas orejeras que compramos \n#Amazon',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 15,
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 40.0, start: 7.0),
                                                Pin(size: 40.0, start: 6.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image:
                                                          const AssetImage(''),
                                                      fit: BoxFit.fill,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(start: 0.0, end: 1.0),
                                          Pin(size: 45.0, middle: 0.277),
                                          child: SvgPicture.string(
                                            _svg_g10ppz,
                                            allowDrawingOutsideViewBox: true,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 37.0, start: 47.0),
                                          Pin(size: 28.0, middle: 0.2818),
                                          child: Stack(
                                            children: <Widget>[
                                              SizedBox.expand(
                                                  child: Text(
                                                '777',
                                                style: TextStyle(
                                                  fontFamily: 'Comic Sans MS',
                                                  fontSize: 20,
                                                  color:
                                                      const Color(0xff000000),
                                                  height: 1.2,
                                                ),
                                                textHeightBehavior:
                                                    TextHeightBehavior(
                                                        applyHeightToFirstAscent:
                                                            false),
                                                softWrap: false,
                                              )),
                                            ],
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 54.0, end: 53.0),
                                          Pin(size: 28.0, middle: 0.2818),
                                          child: Stack(
                                            children: <Widget>[
                                              SizedBox.expand(
                                                  child: Text(
                                                'SAVE',
                                                style: TextStyle(
                                                  fontFamily: 'Comic Sans MS',
                                                  fontSize: 20,
                                                  color:
                                                      const Color(0xff000000),
                                                  height: 1.2,
                                                ),
                                                textHeightBehavior:
                                                    TextHeightBehavior(
                                                        applyHeightToFirstAscent:
                                                            false),
                                                textAlign: TextAlign.right,
                                                softWrap: false,
                                              )),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(-0.299, -0.436),
                                          child: SizedBox(
                                            width: 21.0,
                                            height: 28.0,
                                            child: Stack(
                                              children: <Widget>[
                                                SizedBox.expand(
                                                    child: Text(
                                                  '13',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff000000),
                                                    height: 1.2,
                                                  ),
                                                  textHeightBehavior:
                                                      TextHeightBehavior(
                                                          applyHeightToFirstAscent:
                                                              false),
                                                  softWrap: false,
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 1.0, start: 1.0),
                                          Pin(size: 1.0, end: -1.0),
                                          child: SvgPicture.string(
                                            _svg_ei6j4e,
                                            allowDrawingOutsideViewBox: true,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 36.1, start: 6.9),
                                          Pin(size: 40.0, middle: 0.2783),
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
                                          Pin(start: 1.0, end: 2.0),
                                          Pin(size: 50.0, start: 0.0),
                                          child: ClipRect(
                                            child: BackdropFilter(
                                              filter: ui.ImageFilter.blur(
                                                  sigmaX: 50.0, sigmaY: 50.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xba54d1e0),
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: const Color(
                                                          0xba000000)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 279.0, start: 50.0),
                                          Pin(size: 28.0, start: 11.0),
                                          child: Text(
                                            'Ministerio de Medioambiente',
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
                                          Pin(size: 40.0, start: 5.0),
                                          Pin(size: 40.0, start: 5.0),
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
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(-0.48, -0.46),
                                    child: Container(
                                      width: 38.0,
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
                                    Pin(size: 40.4, end: 7.6),
                                    Pin(size: 40.0, middle: 0.2701),
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
                                    Pin(start: 1.0, end: 0.0),
                                    Pin(size: 45.0, middle: 0.5921),
                                    child: Stack(
                                      children: <Widget>[
                                        SizedBox.expand(
                                            child: SvgPicture.string(
                                          _svg_p67ux,
                                          allowDrawingOutsideViewBox: true,
                                          fit: BoxFit.fill,
                                        )),
                                        Pinned.fromPins(
                                          Pin(size: 37.0, start: 47.0),
                                          Pin(size: 28.0, middle: 0.5294),
                                          child: Stack(
                                            children: <Widget>[
                                              SizedBox.expand(
                                                  child: Text(
                                                '777',
                                                style: TextStyle(
                                                  fontFamily: 'Comic Sans MS',
                                                  fontSize: 20,
                                                  color:
                                                      const Color(0xff000000),
                                                  height: 1.2,
                                                ),
                                                textHeightBehavior:
                                                    TextHeightBehavior(
                                                        applyHeightToFirstAscent:
                                                            false),
                                                softWrap: false,
                                              )),
                                            ],
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 54.0, end: 52.0),
                                          Pin(size: 28.0, middle: 0.5294),
                                          child: Stack(
                                            children: <Widget>[
                                              SizedBox.expand(
                                                  child: Text(
                                                'SAVE',
                                                style: TextStyle(
                                                  fontFamily: 'Comic Sans MS',
                                                  fontSize: 20,
                                                  color:
                                                      const Color(0xff000000),
                                                  height: 1.2,
                                                ),
                                                textHeightBehavior:
                                                    TextHeightBehavior(
                                                        applyHeightToFirstAscent:
                                                            false),
                                                textAlign: TextAlign.right,
                                                softWrap: false,
                                              )),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(-0.298, 0.059),
                                          child: SizedBox(
                                            width: 21.0,
                                            height: 28.0,
                                            child: Stack(
                                              children: <Widget>[
                                                SizedBox.expand(
                                                    child: Text(
                                                  '13',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff000000),
                                                    height: 1.2,
                                                  ),
                                                  textHeightBehavior:
                                                      TextHeightBehavior(
                                                          applyHeightToFirstAscent:
                                                              false),
                                                  softWrap: false,
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 36.1, start: 6.9),
                                          Pin(start: 2.5, end: 2.5),
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
                                          Pin(size: 37.8, middle: 0.2605),
                                          Pin(start: 3.0, end: 2.0),
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
                                          Pin(size: 40.4, end: 6.6),
                                          Pin(start: 3.0, end: 2.0),
                                          child: Container(
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
                                  ),
                                  Align(
                                    alignment: Alignment(0.416, -0.46),
                                    child: PageLink(
                                      links: [
                                        PageLinkInfo(
                                          transition: LinkTransition.Fade,
                                          ease: Curves.easeOut,
                                          duration: 0.3,
                                          pageBuilder: () =>
                                              CompartirPublicacion(key: Key("CompartirPublicacion"),),
                                        ),
                                      ],
                                      child: Container(
                                        width: 35.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: const AssetImage(''),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0.139, -0.454),
                                    child: SizedBox(
                                      width: 69.0,
                                      height: 28.0,
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
                                            textHeightBehavior:
                                                TextHeightBehavior(
                                                    applyHeightToFirstAscent:
                                                        false),
                                            textAlign: TextAlign.right,
                                            softWrap: false,
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0.416, 0.182),
                                    child: PageLink(
                                      links: [
                                        PageLinkInfo(
                                          transition: LinkTransition.Fade,
                                          ease: Curves.easeOut,
                                          duration: 0.3,
                                          pageBuilder: () =>
                                              CompartirPublicacion(key: Key("CompartirPublicacion"),),
                                        ),
                                      ],
                                      child: Container(
                                        width: 35.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: const AssetImage(''),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0.139, 0.18),
                                    child: SizedBox(
                                      width: 69.0,
                                      height: 28.0,
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
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 1.0, end: 0.0),
                                    Pin(size: 45.0, end: 0.0),
                                    child: SvgPicture.string(
                                      _svg_xb0n,
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 37.0, start: 49.0),
                                    Pin(size: 28.0, end: 8.3),
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
                                          textHeightBehavior:
                                              TextHeightBehavior(
                                                  applyHeightToFirstAscent:
                                                      false),
                                          softWrap: false,
                                        )),
                                      ],
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 36.1, start: 8.9),
                                    Pin(size: 40.0, end: 2.8),
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
                                    Pin(size: 37.8, middle: 0.2651),
                                    Pin(size: 40.0, end: 2.3),
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
                                    Pin(size: 40.0, end: 2.3),
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
                                    Pin(size: 28.0, end: 8.0),
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
                                          textHeightBehavior:
                                              TextHeightBehavior(
                                                  applyHeightToFirstAscent:
                                                      false),
                                          textAlign: TextAlign.right,
                                          softWrap: false,
                                        )),
                                      ],
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 21.0, middle: 0.3503),
                                    Pin(size: 28.0, end: 8.0),
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
                                          textHeightBehavior:
                                              TextHeightBehavior(
                                                  applyHeightToFirstAscent:
                                                      false),
                                          softWrap: false,
                                        )),
                                      ],
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 35.0, middle: 0.6973),
                                    Pin(size: 40.0, end: 2.0),
                                    child: PageLink(
                                      links: [
                                        PageLinkInfo(
                                          transition: LinkTransition.Fade,
                                          ease: Curves.easeOut,
                                          duration: 0.3,
                                          pageBuilder: () =>
                                              CompartirPublicacion(key: Key("CompartirPublicacion"),),
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
                                    Pin(size: 69.0, middle: 0.5578),
                                    Pin(size: 28.0, end: 8.0),
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
                                          textHeightBehavior:
                                              TextHeightBehavior(
                                                  applyHeightToFirstAscent:
                                                      false),
                                          textAlign: TextAlign.right,
                                          softWrap: false,
                                        )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Pinned.fromPins(
                                Pin(start: 1.0, end: 2.0),
                                Pin(size: 50.0, middle: 0.3268),
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ui.ImageFilter.blur(
                                        sigmaX: 50.0, sigmaY: 50.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xba54d1e0),
                                        border: Border.all(
                                            width: 1.0,
                                            color: const Color(0xba000000)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Pinned.fromPins(
                                Pin(start: 59.0, end: 2.0),
                                Pin(size: 28.0, middle: 0.3319),
                                child: Text(
                                  'La Perla Centro de Bienestar Animal',
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
                                Pin(size: 40.0, start: 7.0),
                                Pin(size: 40.0, middle: 0.3297),
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
                              Align(
                                alignment: Alignment(0.316, 0.296),
                                child: Container(
                                  width: 34.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: const AssetImage(''),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
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
                  pageBuilder: () => Settings(key: Key("Settings"),),
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
            Pin(size: 58.5, end: 2.0),
            Pin(size: 60.0, start: 105.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => CompradeProductos(key: Key("CompradeProductos"),),
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
            Pin(size: 60.1, start: 6.0),
            Pin(size: 60.0, start: 44.0),
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
          Pinned.fromPins(
            Pin(size: 54.3, start: 24.0),
            Pin(size: 60.0, middle: 0.2712),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.fill,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff9ff1fb),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.459, -0.458),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => CuidadosyRecomendaciones(key: Key("CuidadosyRecomendaciones"),),
                ),
              ],
              child: Container(
                width: 63.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage(''),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.0, -0.458),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Emergencias(key: Key("Emergencias"),),
                ),
              ],
              child: Container(
                width: 65.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage(''),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.477, -0.458),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Comunidad(key: Key("Comunidad"),),
                ),
              ],
              child: Container(
                width: 67.0,
                height: 60.0,
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
            Pin(size: 53.6, end: 20.3),
            Pin(size: 60.0, middle: 0.2712),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Cearpublicaciones(key: Key("Cearpublicaciones"),),
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

const String _svg_bzyupw =
    '<svg viewBox="150.6 314.5 1.0 1.0" ><path transform="translate(0.0, -16.0)" d="M 150.5888214111328 330.5046081542969" fill="none" stroke="#4ec8dd" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_guzxfw =
    '<svg viewBox="151.6 572.5 1.0 1.0" ><path transform="translate(1.0, 242.0)" d="M 150.5888214111328 330.5046081542969" fill="none" stroke="#4ec8dd" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_u50o6d =
    '<svg viewBox="-1.0 619.0 412.0 1.0" ><path transform="translate(-1.0, 578.0)" d="M 412 41 L 0 41 L 412 41 Z" fill="#ffffff" fill-opacity="0.4" stroke="none" stroke-width="1" stroke-opacity="0.65" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_ij4r4z =
    '<svg viewBox="-1.0 330.0 415.0 1.0" ><path transform="translate(-1.0, 292.0)" d="M 415 38 L 0 38 L 415 38 Z" fill="#ffffff" fill-opacity="0.4" stroke="none" stroke-width="1" stroke-opacity="0.65" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_g10ppz =
    '<svg viewBox="-1.0 526.0 414.0 45.0" ><path transform="translate(-1.0, 526.0)" d="M 0 0 L 413.9999694824219 0 L 413.9999694824219 45 L 0 45 L 0 0 Z" fill="#54d1e0" fill-opacity="0.53" stroke="#000000" stroke-width="1" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_ei6j4e =
    '<svg viewBox="0.0 1213.0 1.0 1.0" ><path transform="translate(0.0, 1186.0)" d="M 0 27 L 0 27 Z" fill="#54d1e0" fill-opacity="0.53" stroke="#000000" stroke-width="1" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_p67ux =
    '<svg viewBox="-1.0 713.0 414.0 45.0" ><path transform="translate(-1.0, 713.0)" d="M 0 0 L 413.9999694824219 0 L 413.9999694824219 45 L 0 45 L 0 0 Z" fill="#54d1e0" fill-opacity="0.53" stroke="#000000" stroke-width="1" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_xb0n =
    '<svg viewBox="0.0 1205.0 414.0 45.0" ><path transform="translate(0.0, 1205.0)" d="M 0 0 L 414.0000305175781 0 L 414.0000305175781 45 L 0 45 L 0 0 Z" fill="#54d1e0" fill-opacity="0.53" stroke="#000000" stroke-width="1" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
