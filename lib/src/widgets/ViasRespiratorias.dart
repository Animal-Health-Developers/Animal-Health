import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import 'dart:ui' as ui;
import './SolucionAEMERGENCIAS.dart';
import './Settings.dart';
import './ListadeAnimales.dart';
import './CompradeProductos.dart';
import './CuidadosyRecomendaciones.dart';
import './Emergencias.dart';
import './Comunidad.dart';
import './Crearpublicaciones.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ViasRespiratorias extends StatelessWidget {
  const ViasRespiratorias({
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
                image: const AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                fit: BoxFit.cover,
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
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
                    image: const AssetImage('assets/images/logo.png'),
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
                  pageBuilder: () => Ayuda(key: Key('Ayuda'),),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/help.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 307.0, end: 33.0),
            Pin(size: 45.0, middle: 0.1995),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(5.0),
                    border:
                        Border.all(width: 1.0, color: const Color(0xff707070)),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 216.0, end: 40.0),
                  Pin(size: 28.0, middle: 0.4118),
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
                Pinned.fromPins(
                  Pin(size: 31.0, start: 7.0),
                  Pin(start: 7.0, end: 7.0),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/busqueda1.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
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
                  pageBuilder: () => PerfilPublico(key: Key('PerfilPublico'),),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/perfilusuario.jpeg'),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 15.5, end: 15.5),
            Pin(size: 476.0, end: 63.0),
            child: Stack(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0x8754d1e0),
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                            width: 1.0, color: const Color(0x87000000)),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 274.0, end: 12.5),
                      Pin(size: 28.0, start: 21.0),
                      child: Text(
                        'PROBLEMA RESPIRATORIO',
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
                      Pin(size: 57.0, middle: 0.2917),
                      Pin(size: 19.0, start: 51.0),
                      child: Text(
                        'síntomas',
                        style: TextStyle(
                          fontFamily: 'Comic Sans MS',
                          fontSize: 14,
                          color: const Color(0xff000000),
                          height: 1.7142857142857142,
                        ),
                        textHeightBehavior:
                            TextHeightBehavior(applyHeightToFirstAscent: false),
                        softWrap: false,
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(start: 9.0, end: 10.0),
                      Pin(size: 194.0, middle: 0.4504),
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(
                              sigmaX: 22.0, sigmaY: 22.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xe3a0f4fe),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                  width: 1.0,
                                  color: const Color(0xff707070)),
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
                      Pin(size: 100.0, start: 20.0),
                      Pin(size: 24.0, middle: 0.2235),
                      child: Text(
                        'Descripción:',
                        style: TextStyle(
                          fontFamily: 'Comic Sans MS',
                          fontSize: 17,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700,
                        ),
                        softWrap: false,
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 70.8, start: 14.5),
                      Pin(size: 70.0, start: 13.0),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: const AssetImage('assets/images/vias respiratorias.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Pinned.fromPins(
                  Pin(size: 147.0, end: 21.0),
                  Pin(size: 34.0, middle: 0.7511),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 147.0,
                        height: 34.0,
                        decoration: BoxDecoration(
                          color: const Color(0xff4ec8dd),
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
                      Pinned.fromPins(
                        Pin(size: 64.0, middle: 0.5301),
                        Pin(start: 5.0, end: 5.0),
                        child: Text(
                          'Guardar',
                          style: TextStyle(
                            fontFamily: 'Comic Sans MS',
                            fontSize: 17,
                            color: const Color(0xff000000),
                          ),
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 147.0, start: 21.0),
                  Pin(size: 34.0, middle: 0.7511),
                  child: Stack(
                    children: <Widget>[
                      SizedBox(
                        width: 147.0,
                        height: 34.0,
                        child: PageLink(
                          links: [
                            PageLinkInfo(
                              transition: LinkTransition.Fade,
                              ease: Curves.easeOut,
                              duration: 0.3,
                              pageBuilder: () => SolucionAEMERGENCIAS(key: Key('SolucionAEMERGENCIAS'),),
                            ),
                          ],
                          child: SvgPicture.string(
                            _svg_kpwrxw,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 49.0, middle: 0.5204),
                        Pin(start: 5.0, end: 5.0),
                        child: Text(
                          'Envíar',
                          style: TextStyle(
                            fontFamily: 'Comic Sans MS',
                            fontSize: 17,
                            color: const Color(0xff000000),
                          ),
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Pinned.fromPins(
            Pin(size: 33.9, start: 10.0),
            Pin(size: 32.0, middle: 0.3605),
            child: PageLink(
              links: [
                PageLinkInfo(),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/back.png'),
                    fit: BoxFit.fill,
                  ),
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
                    image: const AssetImage('assets/images/settingsbutton.png'),
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
                    image: const AssetImage('assets/images/listaanimales.png'),
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
                    image: const AssetImage('assets/images/store.png'),
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
                    image: const AssetImage('assets/images/noticias.png'),
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
                    image: const AssetImage('assets/images/cuidadosrecomendaciones.png'),
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
                    image: const AssetImage('assets/images/emergencias.png'),
                    fit: BoxFit.fill,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffa3f0fb),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
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
                    image: const AssetImage('assets/images/comunidad.png'),
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
                  pageBuilder: () => Crearpublicaciones(key: Key('Crearpublicaciones'),),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/crearpublicacion.png'),
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

const String _svg_kpwrxw =
    '<svg viewBox="36.5 685.0 147.0 34.0" ><path transform="translate(36.5, 685.0)" d="M 8 0 L 139 0 C 143.4182739257812 0 147 3.581721782684326 147 8 L 147 26 C 147 30.41827774047852 143.4182739257812 34 139 34 L 8 34 C 3.581721782684326 34 0 30.41827774047852 0 26 L 0 8 C 0 3.581721782684326 3.581721782684326 0 8 0 Z" fill="#4ec8dd" stroke="#000000" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
