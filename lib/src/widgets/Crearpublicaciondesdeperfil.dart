import 'package:animal_health/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import 'dart:ui' as ui;
import './PerfilPublico.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Crearpublicaciondesdeperfil extends StatelessWidget {
  const Crearpublicaciondesdeperfil({
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
            Pin(size: 52.9, start: 9.1),
            Pin(size: 50.0, start: 49.0),
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
          Align(
            alignment: Alignment(-0.267, -0.494),
            child: SizedBox(
              width: 1.0,
              height: 1.0,
              child: SvgPicture.string(
                _svg_a7p9a8,
                allowDrawingOutsideViewBox: true,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.0, -0.515),
            child: Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/perfilusuario.jpeg'),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(25.0),
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
                  pageBuilder: () => Configuraciones(key: Key('Settings'), authService: AuthService(),),
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
                    image: const AssetImage('assets/images/listaanimales.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 16.0, end: 15.0),
            Pin(size: 524.0, end: 24.0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment(-0.008, -1.0),
                  child: SizedBox(
                    width: 259.0,
                    height: 35.0,
                    child: SvgPicture.string(
                      _svg_z0u8a,
                      allowDrawingOutsideViewBox: true,
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 187.0, middle: 0.5155),
                  Pin(size: 28.0, start: 4.0),
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
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 41.0, 0.0, 0.0),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: SizedBox.expand(
                            child: SvgPicture.string(
                          _svg_cepmj,
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        )),
                      ),
                      Pinned.fromPins(
                        Pin(size: 187.0, middle: 0.4278),
                        Pin(size: 28.0, start: 24.0),
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
                        Pin(size: 45.0, middle: 0.372),
                        Pin(size: 19.0, start: 61.0),
                        child: Text(
                          'Público',
                          style: TextStyle(
                            fontFamily: 'Comic Sans MS',
                            fontSize: 14,
                            color: const Color(0xff000000),
                            height: 1.7142857142857142,
                          ),
                          textHeightBehavior: TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          softWrap: false,
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 176.0, start: 15.0),
                        Pin(size: 24.0, middle: 0.2157),
                        child: Text(
                          '¿Qué estás pensando?',
                          style: TextStyle(
                            fontFamily: 'Comic Sans MS',
                            fontSize: 17,
                            color: const Color(0xff000000),
                          ),
                          softWrap: false,
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(start: 15.0, end: 14.0),
                        Pin(size: 190.0, middle: 0.4915),
                        child: ClipRect(
                          child: BackdropFilter(
                            filter:
                                ui.ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                    width: 1.0, color: const Color(0xff707070)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(start: 21.0, end: 22.0),
                        Pin(size: 177.0, middle: 0.4902),
                        child: ClipRect(
                          child: BackdropFilter(
                            filter:
                                ui.ImageFilter.blur(sigmaX: 22.0, sigmaY: 22.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                    width: 1.0, color: const Color(0xff707070)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.0, 0.233),
                        child: SizedBox(
                          width: 171.0,
                          height: 24.0,
                          child: Text(
                            'Agregar fotos/videos',
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 17,
                              color: const Color(0xff000000),
                            ),
                            softWrap: false,
                          ),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(start: 4.0, end: 4.0),
                        Pin(size: 63.0, middle: 0.8024),
                        child: ClipRect(
                          child: BackdropFilter(
                            filter:
                                ui.ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                    width: 1.0, color: const Color(0xff707070)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(start: 7.0, end: 7.0),
                        Pin(size: 56.0, middle: 0.7963),
                        child: ClipRect(
                          child: BackdropFilter(
                            filter:
                                ui.ImageFilter.blur(sigmaX: 22.0, sigmaY: 22.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                    width: 1.0, color: const Color(0xff707070)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(start: 2.0, end: 2.0),
                        Pin(size: 56.0, end: 0.0),
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
                              color: const Color(0xff4ec8dd),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                  width: 1.0, color: const Color(0xff000000)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xff000000),
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 75.0, middle: 0.5163),
                        Pin(size: 28.0, end: 15.0),
                        child: Text(
                          'publicar',
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
                        Pin(size: 60.0, start: 15.0),
                        Pin(size: 60.0, start: 27.0),
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
                      Pinned.fromPins(
                        Pin(size: 192.0, start: 15.0),
                        Pin(size: 24.0, middle: 0.7756),
                        child: Text(
                          'Agregar a tu Publicación',
                          style: TextStyle(
                            fontFamily: 'Comic Sans MS',
                            fontSize: 17,
                            color: const Color(0xff000000),
                          ),
                          softWrap: false,
                        ),
                      ),
                      Align(
                        alignment: Alignment(-0.004, -0.102),
                        child: Container(
                          width: 127.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: const AssetImage('assets/images/subirfotovideo.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 33.9, middle: 0.2391),
                        Pin(size: 40.0, start: 52.0),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: const AssetImage('assets/images/publico.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment(0.244, 0.62),
                  child: Container(
                    width: 47.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/ubicacion.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0.54, 0.62),
                  child: Container(
                    width: 45.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/gif.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 52.5, end: 20.6),
                  Pin(size: 50.0, middle: 0.8101),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/etiqueta.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_a7p9a8 =
    '<svg viewBox="150.6 225.5 1.0 1.0" ><path transform="translate(0.0, -105.0)" d="M 150.5888214111328 330.5046081542969" fill="none" stroke="#4ec8dd" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_z0u8a =
    '<svg viewBox="76.7 344.0 258.6 35.0" ><path transform="translate(76.72, 344.0)" d="M 11.29102420806885 0 L 247.2734222412109 0 C 253.50927734375 0 258.564453125 4.477152347564697 258.564453125 10 L 258.564453125 25 C 258.564453125 30.52284812927246 253.50927734375 35 247.2734222412109 35 L 11.29102420806885 35 C 5.055163383483887 35 0 30.52284812927246 0 25 L 0 10 C 0 4.477152347564697 5.055163383483887 0 11.29102420806885 0 Z" fill="#a0f4fe" fill-opacity="0.89" stroke="#000000" stroke-width="1" stroke-opacity="0.89" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_cepmj =
    '<svg viewBox="0.2 0.0 381.0 410.0" ><path transform="translate(0.2, 0.0)" d="M 20 0 L 361 0 C 372.0456848144531 0 381 8.954304695129395 381 20 L 381 390 C 381 401.0456848144531 372.0456848144531 410 361 410 L 20 410 C 8.954304695129395 410 0 401.0456848144531 0 390 L 0 20 C 0 8.954304695129395 8.954304695129395 0 20 0 Z" fill="#a0f4fe" fill-opacity="0.89" stroke="#000000" stroke-width="1" stroke-opacity="0.89" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
