import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'Home.dart';
import 'package:adobe_xd/page_link.dart';
import 'Ayuda.dart';
import 'PerfilPublico.dart';
import 'chatconamigos.dart';
import 'dart:ui' as ui;
import 'Comunidad.dart';
import 'Contactos.dart';
import 'Settings.dart';
import 'ListadeAnimales.dart';
import 'CompradeProductos.dart';
import 'CuidadosyRecomendaciones.dart';
import 'Emergencias.dart';
import 'Cearpublicaciones.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AmigosenLInea extends StatelessWidget {
  const AmigosenLInea({
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
                  pageBuilder: () => Home(key: Key("Home"),),
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
            Pin(size: 40.5, middle: 0.8328),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Ayuda(key: Key("Ayuda")),
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
            Pin(start: 0.0, end: 14.0),
            Pin(size: 530.9, end: 51.1),
            child: Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(start: 14.0, end: 0.0),
                  Pin(size: 346.0, end: 41.8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xe3a0f4fe),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                          width: 1.0, color: const Color(0xe3000000)),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    width: 1.0,
                    height: 3.0,
                    child: SvgPicture.string(
                      _svg_jr8ex,
                      allowDrawingOutsideViewBox: true,
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 330.0, middle: 0.6029),
                  Pin(size: 340.0, end: 46.9),
                  child: SingleChildScrollView(
                    primary: false,
                    child: SizedBox(
                      width: 330.0,
                      height: 644.0,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, -304.0),
                            child: SingleChildScrollView(
                              primary: false,
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 117,
                                runSpacing: 20,
                                children: [
                                  {
                                    'text': 'En Linea',
                                  },
                                  {
                                    'text': 'En linea',
                                  }
                                ].map((itemData) {
                                  final text = itemData['text'];
                                  return SizedBox(
                                    width: 233.0,
                                    height: 302.0,
                                    child: Stack(
                                      children: <Widget>[
                                        Pinned.fromPins(
                                          Pin(size: 129.0, end: 2.0),
                                          Pin(size: 25.0, middle: 0.213),
                                          child: ClipRect(
                                            child: BackdropFilter(
                                              filter: ui.ImageFilter.blur(
                                                  sigmaX: 36.0, sigmaY: 36.0),
                                              child: PageLink(
                                                links: [
                                                  PageLinkInfo(
                                                    transition:
                                                        LinkTransition.Fade,
                                                    ease: Curves.easeOut,
                                                    duration: 0.3,
                                                    pageBuilder: () =>
                                                        chatconamigos(key: Key('chatconamigos'),),
                                                  ),
                                                ],
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0x7a54d1e0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: const Color(
                                                            0xff707070)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 110.0, end: 11.0),
                                          Pin(size: 21.0, middle: 0.2135),
                                          child: Text(
                                            'Enviar Mensaje',
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
                                          Pin(size: 36.0, middle: 0.5279),
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
                                          Pin(size: 38.0, middle: 0.5333),
                                          Pin(size: 14.0, start: 41.0),
                                          child: Text(
                                            'En linea',
                                            style: TextStyle(
                                              fontFamily: 'Open Sans',
                                              fontSize: 10,
                                              color: const Color(0xff131313),
                                              fontWeight: FontWeight.w600,
                                              height: 1.2,
                                            ),
                                            textHeightBehavior:
                                                TextHeightBehavior(
                                                    applyHeightToFirstAscent:
                                                        false),
                                            softWrap: false,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(0.083, -0.11),
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
                                          alignment: Alignment(0.083, 0.042),
                                          child: SizedBox(
                                            width: 41.0,
                                            height: 14.0,
                                            child: Text(
                                              text!,
                                              style: TextStyle(
                                                fontFamily: 'Open Sans',
                                                fontSize: 10,
                                                color: const Color(0xff000000),
                                                fontWeight: FontWeight.w600,
                                                height: 1.2,
                                              ),
                                              textHeightBehavior:
                                                  TextHeightBehavior(
                                                      applyHeightToFirstAscent:
                                                          false),
                                              softWrap: false,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(0.126, 0.665),
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
                                          Pin(size: 38.0, middle: 0.5282),
                                          Pin(size: 14.0, end: 29.0),
                                          child: Text(
                                            'En linea',
                                            style: TextStyle(
                                              fontFamily: 'Open Sans',
                                              fontSize: 10,
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w600,
                                              height: 1.2,
                                            ),
                                            textHeightBehavior:
                                                TextHeightBehavior(
                                                    applyHeightToFirstAscent:
                                                        false),
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
                                                  BorderRadius.circular(42.0),
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
                                        Align(
                                          alignment: Alignment(1.0, 0.213),
                                          child: ClipRect(
                                            child: BackdropFilter(
                                              filter: ui.ImageFilter.blur(
                                                  sigmaX: 36.0, sigmaY: 36.0),
                                              child: PageLink(
                                                links: [
                                                  PageLinkInfo(
                                                    transition:
                                                        LinkTransition.Fade,
                                                    ease: Curves.easeOut,
                                                    duration: 0.3,
                                                    pageBuilder: () =>
                                                        chatconamigos(key: Key('chatconamigos'),),
                                                  ),
                                                ],
                                                child: Container(
                                                  width: 129.0,
                                                  height: 25.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0x7a54d1e0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: const Color(
                                                            0xff707070)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 110.0, end: 8.0),
                                          Pin(size: 21.0, middle: 0.6085),
                                          child: Text(
                                            'Enviar Mensaje',
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
                                          Pin(size: 129.0, end: 2.0),
                                          Pin(size: 25.0, end: 0.0),
                                          child: ClipRect(
                                            child: BackdropFilter(
                                              filter: ui.ImageFilter.blur(
                                                  sigmaX: 36.0, sigmaY: 36.0),
                                              child: PageLink(
                                                links: [
                                                  PageLinkInfo(
                                                    transition:
                                                        LinkTransition.Fade,
                                                    ease: Curves.easeOut,
                                                    duration: 0.3,
                                                    pageBuilder: () =>
                                                        chatconamigos(key: Key('chatconamigos'),),
                                                  ),
                                                ],
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0x7a54d1e0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: const Color(
                                                            0xff707070)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 110.0, end: 8.0),
                                          Pin(size: 21.0, end: 2.0),
                                          child: Text(
                                            'Enviar Mensaje',
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
                Pinned.fromPins(
                  Pin(size: 33.9, start: 10.0),
                  Pin(size: 32.0, start: 0.0),
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
                  Pin(size: 1.0, middle: 0.4181),
                  Pin(size: 1.0, start: 29.6),
                  child: SvgPicture.string(
                    _svg_fejle,
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.fill,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 143.0, middle: 0.543),
                  Pin(size: 30.0, start: 1.0),
                  child: PageLink(
                    links: [
                      PageLinkInfo(
                        transition: LinkTransition.Fade,
                        ease: Curves.easeOut,
                        duration: 0.3,
                        pageBuilder: () => Comunidad(key: Key('Comunidad'),),
                      ),
                    ],
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xe3a0f4fe),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            width: 1.0, color: const Color(0xe3000000)),
                      ),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 129.0, start: 37.0),
                  Pin(size: 30.0, start: 48.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xe3a0f4fe),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          width: 1.0, color: const Color(0xe3000000)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xe31b0ed9),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 129.0, end: 15.0),
                  Pin(size: 30.0, start: 48.0),
                  child: PageLink(
                    links: [
                      PageLinkInfo(
                        transition: LinkTransition.Fade,
                        ease: Curves.easeOut,
                        duration: 0.3,
                        pageBuilder: () => Contactos(key: Key('Contactos'),),
                      ),
                    ],
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xe3a0f4fe),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            width: 1.0, color: const Color(0xe3000000)),
                      ),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 57.0, middle: 0.2228),
                  Pin(size: 21.0, start: 52.0),
                  child: Text(
                    'En linea',
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
                  Pin(size: 101.0, end: 29.0),
                  Pin(size: 21.0, start: 53.0),
                  child: Text(
                    'Tus contactos',
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
                  Pin(size: 78.0, middle: 0.5452),
                  Pin(size: 21.0, start: 5.0),
                  child: Text(
                    'Solicitudes',
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
            Pin(size: 60.1, start: 6.0),
            Pin(size: 60.0, start: 44.0),
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
            Pin(size: 58.5, end: 2.0),
            Pin(size: 60.0, start: 105.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => CompradeProductos(key: Key('CompradeProductos'),),
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
                    fit: BoxFit.fill,
                  ),
                ),
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
                  pageBuilder: () => CuidadosyRecomendaciones(key: Key('CuidadosyRecomendaciones'),),
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
                  pageBuilder: () => Emergencias(key: Key('Emergencias'),),
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
                  pageBuilder: () => Comunidad(key: Key('Comunidad'),),
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
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff9dedf9),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
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
                  pageBuilder: () => Cearpublicaciones(key: Key('Cearpublicaciones'),),
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

const String _svg_jr8ex =
    '<svg viewBox="0.0 529.6 1.0 3.3" ><path transform="translate(0.0, 516.09)" d="M 0 13.5 C 0 13.5 0 20.95584487915039 0 13.5 Z" fill="#000000" fill-opacity="0.65" stroke="#000000" stroke-width="1" stroke-opacity="0.65" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_fejle =
    '<svg viewBox="166.0 31.6 1.0 1.0" ><path transform="translate(15.41, -298.91)" d="M 150.5888214111328 330.5046081542969" fill="#000000" stroke="#000000" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
