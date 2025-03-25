import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'Home.dart';
import 'package:adobe_xd/page_link.dart';
import 'Ayuda.dart';
import 'PerfilPublico.dart';
import 'GoogleMaps.dart';
import 'dart:ui' as ui;
import 'PrimerosAuxilios.dart';
import 'ServiciodeAmbulancia.dart';
import 'AtencionenCasa.dart';
import 'Settings.dart';
import 'ListadeAnimales.dart';
import 'CompradeProductos.dart';
import 'CuidadosyRecomendaciones.dart';
import 'Comunidad.dart';
import 'Cearpublicaciones.dart';

class Emergencias extends StatelessWidget {
  const Emergencias({
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
            Pin(size: 178.0, start: 20.0),
            Pin(size: 163.0, middle: 0.5185),
            child: ClipRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => GoogleMaps(key: Key("GoogleMaps"),),
                    ),
                  ],
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0x5e4ec8dd),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                          width: 1.0, color: const Color(0xff707070)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x29000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 178.0, end: 16.0),
            Pin(size: 163.0, middle: 0.5185),
            child: ClipRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => PrimerosAuxilios(key: Key("PrimerosAuxilios"),),
                    ),
                  ],
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0x5e4ec8dd),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                          width: 1.0, color: const Color(0xff707070)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x29000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 178.0, start: 20.0),
            Pin(size: 163.0, middle: 0.797),
            child: ClipRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => ServiciodeAmbulancia(key: Key("ServiciodeAmbulancia"),),
                    ),
                  ],
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0x5e4ec8dd),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                          width: 1.0, color: const Color(0xff707070)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x29000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 178.0, end: 16.0),
            Pin(size: 163.0, middle: 0.797),
            child: ClipRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: PageLink(
                  links: [
                    PageLinkInfo(
                      transition: LinkTransition.Fade,
                      ease: Curves.easeOut,
                      duration: 0.3,
                      pageBuilder: () => AtencionenCasa(key: Key("AtencionenCasa"),),
                    ),
                  ],
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0x5e4ec8dd),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                          width: 1.0, color: const Color(0xff707070)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x29000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 158.0, start: 30.5),
            Pin(size: 21.0, middle: 0.5792),
            child: Text(
              'Veterinarias cercanas',
              style: TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 15,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w700,
                height: 1,
              ),
              textHeightBehavior:
                  TextHeightBehavior(applyHeightToFirstAscent: false),
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ),
          Pinned.fromPins(
            Pin(size: 124.0, end: 43.0),
            Pin(size: 21.0, middle: 0.5798),
            child: Text(
              'Primeros Auxilios',
              style: TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 15,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w700,
                height: 1,
              ),
              textHeightBehavior:
                  TextHeightBehavior(applyHeightToFirstAscent: false),
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ),
          Pinned.fromPins(
            Pin(size: 168.0, start: 25.0),
            Pin(size: 21.0, middle: 0.8129),
            child: Text(
              'Servicio de Ambulancia',
              style: TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 15,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w700,
                height: 1,
              ),
              textHeightBehavior:
                  TextHeightBehavior(applyHeightToFirstAscent: false),
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ),
          Pinned.fromPins(
            Pin(size: 124.0, end: 41.0),
            Pin(size: 21.0, middle: 0.8129),
            child: Text(
              'Atención en Casa',
              style: TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 15,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w700,
                height: 1,
              ),
              textHeightBehavior:
                  TextHeightBehavior(applyHeightToFirstAscent: false),
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ),
          Pinned.fromPins(
            Pin(start: 66.0, end: 66.0),
            Pin(size: 36.0, middle: 0.3657),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xe3a0f4fe),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(width: 1.0, color: const Color(0xe3000000)),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 82.0, end: 82.0),
            Pin(size: 33.0, middle: 0.3667),
            child: Text(
              'Servicios de Emergencias',
              style: TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 20,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w700,
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
            Pin(size: 116.0, end: 47.0),
            Pin(size: 120.0, middle: 0.5),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => PrimerosAuxilios(key: Key("PrimerosAuxilios"),),
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
            Pin(size: 103.4, start: 57.8),
            Pin(size: 120.0, middle: 0.5),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => GoogleMaps(key: Key("GoogleMaps"),),
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
                  pageBuilder: () => Home(key: Key("Home"),),
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
            child: Container(
              width: 65.0,
              height: 60.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(''),
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
          Pinned.fromPins(
            Pin(size: 125.5, end: 42.3),
            Pin(size: 120.0, middle: 0.763),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => AtencionenCasa(key: Key("AtencionenCasa"),),
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
            Pin(size: 135.2, start: 41.4),
            Pin(size: 120.0, middle: 0.763),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => ServiciodeAmbulancia(key: Key("ServiciodeAmbulancia"),),
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
