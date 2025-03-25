import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'Home.dart';
import 'package:adobe_xd/page_link.dart';
import 'Ayuda.dart';
import 'Crearpublicaciondesdeperfil.dart';
import 'dart:ui' as ui;
import 'CompartirPublicacion.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'Settings.dart';
import 'ListadeAnimales.dart';

class PerfilPublico extends StatelessWidget {
  const PerfilPublico({
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
            Pin(size: 430.0, middle: 0.5),
            Pin(start: 180.0, end: 0.0),
            child: SingleChildScrollView(
              primary: false,
              child: SizedBox(
                width: 430.0,
                height: 1686.0,
                child: Stack(
                  children: <Widget>[
                    Pinned.fromPins(
                      Pin(start: 9.0, end: 9.0),
                      Pin(size: 237.0, middle: 0.7053),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0x8754d1e0),
                          border: Border.all(
                              width: 1.0, color: const Color(0x87000000)),
                        ),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 179.0, start: 20.0),
                      Pin(size: 40.0, middle: 0.317),
                      child: PageLink(
                        links: [
                          PageLinkInfo(
                            transition: LinkTransition.Fade,
                            ease: Curves.easeOut,
                            duration: 0.3,
                            pageBuilder: () => Crearpublicaciondesdeperfil(key: Key('Crearpublicaciondesdeperfil'),),
                          ),
                        ],
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff54d1e0),
                            borderRadius: BorderRadius.circular(7.0),
                            border: Border.all(
                                width: 1.0, color: const Color(0xff000000)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xff080808),
                                offset: Offset(0, 3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 165.0, start: 27.0),
                      Pin(size: 28.0, middle: 0.3202),
                      child: Text(
                        'Crear Publicación',
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
                      Pin(size: 179.0, end: 20.0),
                      Pin(size: 40.0, middle: 0.317),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff54d1e0),
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(
                              width: 1.0, color: const Color(0xff000000)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff080808),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 121.0, end: 47.0),
                      Pin(size: 28.0, middle: 0.3202),
                      child: Text(
                        'Editar Perfil',
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
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: const AssetImage(''),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(start: 0.0, end: 0.0),
                      Pin(size: 1111.0, end: -974.0),
                      child: SingleChildScrollView(
                        primary: false,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 20,
                          runSpacing: 5,
                          children: [{}, {}, {}].map((itemData) {
                            return SizedBox(
                              width: 414.0,
                              height: 362.0,
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0.0, 0.0, 2.0, 45.0),
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: const AssetImage(''),
                                              fit: BoxFit.cover,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xff080808),
                                                offset: Offset(0, 3),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                          margin: EdgeInsets.fromLTRB(
                                              0.0, 100.0, 0.0, 0.0),
                                        ),
                                        Pinned.fromPins(
                                          Pin(start: 0.0, end: 0.0),
                                          Pin(size: 100.0, start: 0.0),
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
                                          Pin(start: 17.0, end: 3.0),
                                          Pin(size: 42.0, middle: 0.1818),
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
                                          Pin(size: 40.0, start: 4.0),
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
                                        Pinned.fromPins(
                                          Pin(size: 187.0, start: 53.0),
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
                                          Pin(size: 33.6, middle: 0.6676),
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
                                      ],
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 0.0, end: 0.0),
                                    Pin(size: 45.0, end: 0.0),
                                    child: SvgPicture.string(
                                      _svg_taae19,
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 37.0, start: 47.0),
                                    Pin(size: 28.0, end: 8.0),
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
                                    Pin(size: 54.0, end: 52.0),
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
                                    Pin(size: 21.0, middle: 0.3511),
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
                                    Pin(size: 36.1, start: 6.9),
                                    Pin(size: 40.0, end: 2.5),
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
                                    Pin(size: 40.0, end: 2.0),
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
                                    Pin(size: 40.0, end: 2.0),
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
                                    Pin(size: 35.0, middle: 0.7071),
                                    Pin(size: 40.0, end: 2.0),
                                    child: PageLink(
                                      links: [
                                        PageLinkInfo(
                                          transition: LinkTransition.Fade,
                                          ease: Curves.easeOut,
                                          duration: 0.3,
                                          pageBuilder: () =>
                                              CompartirPublicacion(key: Key('CompartirPublicacion'),),
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
                                    Pin(size: 69.0, middle: 0.5682),
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
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-0.442, 0.012),
                      child: SizedBox(
                        width: 129.0,
                        height: 24.0,
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 17,
                              color: const Color(0xff000000),
                            ),
                            children: [
                              TextSpan(
                                text: 'Vive en ',
                              ),
                              TextSpan(
                                text: 'Medellín',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          textHeightBehavior: TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          softWrap: false,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-0.501, 0.147),
                      child: SizedBox(
                        width: 94.0,
                        height: 24.0,
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 17,
                              color: const Color(0xff000000),
                            ),
                            children: [
                              TextSpan(
                                text: 'De ',
                              ),
                              TextSpan(
                                text: 'Medellín',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          textHeightBehavior: TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          softWrap: false,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-0.407, 0.282),
                      child: SizedBox(
                        width: 147.0,
                        height: 24.0,
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 17,
                              color: const Color(0xff000000),
                            ),
                            children: [
                              TextSpan(
                                text: 'Prefencias: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: 'Todos',
                              ),
                            ],
                          ),
                          textHeightBehavior: TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          softWrap: false,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-0.419, 0.417),
                      child: SizedBox(
                        width: 141.0,
                        height: 24.0,
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 17,
                              color: const Color(0xff000000),
                            ),
                            children: [
                              TextSpan(
                                text: 'Género ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: 'Masculino',
                              ),
                            ],
                          ),
                          textHeightBehavior: TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          softWrap: false,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-0.472, 0.552),
                      child: SizedBox(
                        width: 112.0,
                        height: 24.0,
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 17,
                              color: const Color(0xff000000),
                            ),
                            children: [
                              TextSpan(
                                text: 'Edad ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: '33 Años',
                              ),
                            ],
                          ),
                          textHeightBehavior: TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          softWrap: false,
                        ),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(start: 9.0, end: 9.0),
                      Pin(size: 65.0, middle: 0.4111),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0x8754d1e0),
                          border: Border.all(
                              width: 1.0, color: const Color(0x87000000)),
                        ),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 135.8, start: 20.9),
                      Pin(size: 30.0, middle: 0.4157),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff54d1e0),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              width: 1.0, color: const Color(0xff000000)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff080808),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 115.0, start: 30.6),
                      Pin(size: 28.0, middle: 0.4145),
                      child: Text(
                        'Información',
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
                      alignment: Alignment(0.08, -0.169),
                      child: SizedBox(
                        width: 100.0,
                        height: 30.0,
                        child: SvgPicture.string(
                          _svg_yjko0q,
                          allowDrawingOutsideViewBox: true,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0.08, -0.171),
                      child: SizedBox(
                        width: 87.0,
                        height: 28.0,
                        child: Text(
                          'Historias',
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
                      Pin(size: 112.0, end: 20.9),
                      Pin(size: 30.0, middle: 0.4157),
                      child: SvgPicture.string(
                        _svg_dghm4,
                        allowDrawingOutsideViewBox: true,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 100.0, end: 25.9),
                      Pin(size: 28.0, middle: 0.4145),
                      child: Text(
                        'Comunidad',
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
                      Pin(start: 85.7, end: 85.7),
                      Pin(size: 35.0, middle: 0.2422),
                      child: SvgPicture.string(
                        _svg_t9va16,
                        allowDrawingOutsideViewBox: true,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Align(
                      alignment: Alignment(0.029, -0.509),
                      child: SizedBox(
                        width: 187.0,
                        height: 28.0,
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
                    ),
                    Pinned.fromPins(
                      Pin(size: 37.9, start: 29.6),
                      Pin(size: 40.0, middle: 0.5751),
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
                      Pin(size: 45.5, start: 26.4),
                      Pin(size: 40.0, middle: 0.506),
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
                      Pin(size: 45.6, start: 26.2),
                      Pin(size: 40.0, middle: 0.6443),
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
                      Pin(size: 35.8, start: 30.7),
                      Pin(size: 40.0, middle: 0.7158),
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
                      Pin(size: 41.2, start: 28.6),
                      Pin(size: 40.0, middle: 0.7827),
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
        ],
      ),
    );
  }
}

const String _svg_taae19 =
    '<svg viewBox="0.0 1072.0 414.0 45.0" ><path transform="translate(0.0, 1072.0)" d="M 0 0 L 413.9999694824219 0 L 413.9999694824219 45 L 0 45 L 0 0 Z" fill="#54d1e0" fill-opacity="0.53" stroke="#000000" stroke-width="1" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_yjko0q =
    '<svg viewBox="178.1 283.5 100.0 30.0" ><path transform="translate(178.14, 283.5)" d="M 8 0 L 92 0 C 96.41828155517578 0 100 3.581721782684326 100 8 L 100 22 C 100 26.41827774047852 96.41828155517578 30 92 30 L 8 30 C 3.581721782684326 30 0 26.41827774047852 0 22 L 0 8 C 0 3.581721782684326 3.581721782684326 0 8 0 Z" fill="#54d1e0" stroke="#000000" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_dghm4 =
    '<svg viewBox="297.1 283.5 112.0 30.0" ><path transform="translate(297.14, 283.5)" d="M 8 0 L 104 0 C 108.4182815551758 0 112 3.581721782684326 112 8 L 112 22 C 112 26.41827774047852 108.4182815551758 30 104 30 L 8 30 C 3.581721782684326 30 0 26.41827774047852 0 22 L 0 8 C 0 3.581721782684326 3.581721782684326 0 8 0 Z" fill="#947b93" stroke="#000000" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_t9va16 =
    '<svg viewBox="85.7 164.0 258.6 35.0" ><path transform="translate(85.72, 164.0)" d="M 11.29102420806885 0 L 247.2734222412109 0 C 253.50927734375 0 258.564453125 4.477152347564697 258.564453125 10 L 258.564453125 25 C 258.564453125 30.52284812927246 253.50927734375 35 247.2734222412109 35 L 11.29102420806885 35 C 5.055163383483887 35 0 30.52284812927246 0 25 L 0 10 C 0 4.477152347564697 5.055163383483887 0 11.29102420806885 0 Z" fill="#a0f4fe" fill-opacity="0.89" stroke="#000000" stroke-width="1" stroke-opacity="0.89" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
