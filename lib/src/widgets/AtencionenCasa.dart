import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'Emergencias.dart';
import 'Home.dart';
import 'Ayuda.dart';
import 'Settings.dart';
import 'ListadeAnimales.dart';
import 'CompradeProductos.dart';
import 'CuidadosyRecomendaciones.dart';
import 'Comunidad.dart';
import 'Cearpublicaciones.dart';

class AtencionenCasa extends StatelessWidget {
  const AtencionenCasa({
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
            Pin(start: 10.0, end: 0.0),
            Pin(size: 416.0, middle: 0.6513),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: 0.0,
                    height: 0.0,
                    child: Text(
                      '',
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
                  alignment: Alignment.topLeft,
                  child: PageLink(
                    links: [
                      PageLinkInfo(),
                    ],
                    child: Container(
                      width: 34.0,
                      height: 32.0,
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
          ),
          Pinned.fromPins(
            Pin(size: 319.0, middle: 0.5054),
            Pin(size: 536.5, end: 0.5),
            child: SingleChildScrollView(
              primary: false,
              child: SizedBox(
                width: 319.0,
                height: 983.0,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, -446.0),
                      child: SingleChildScrollView(
                        primary: false,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 20,
                          runSpacing: 20,
                          children: [{}].map((itemData) {
                            return SizedBox(
                              width: 319.0,
                              height: 963.0,
                              child: Stack(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Transform.translate(
                                        offset: Offset(0.0, 64.0),
                                        child: Container(
                                          width: 318.0,
                                          height: 45.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xff000000)),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(66.5, 72.0),
                                        child: SizedBox(
                                          width: 181.0,
                                          child: Text(
                                            'Edad',
                                            style: TextStyle(
                                              fontFamily: 'Comic Sans MS',
                                              fontSize: 20,
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.center,
                                            softWrap: false,
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(0.0, 130.0),
                                        child: Container(
                                          width: 318.0,
                                          height: 45.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xff000000)),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(124.0, 138.0),
                                        child: Text(
                                          'Especie',
                                          style: TextStyle(
                                            fontFamily: 'Comic Sans MS',
                                            fontSize: 20,
                                            color: const Color(0xff000000),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          softWrap: false,
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(0.0, 196.0),
                                        child: Container(
                                          width: 318.0,
                                          height: 45.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xff000000)),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(138.0, 204.0),
                                        child: Text(
                                          'Raza',
                                          style: TextStyle(
                                            fontFamily: 'Comic Sans MS',
                                            fontSize: 20,
                                            color: const Color(0xff000000),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          softWrap: false,
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(0.0, 262.0),
                                        child: Container(
                                          width: 318.0,
                                          height: 45.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xff000000)),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(0.0, 330.0),
                                        child: Container(
                                          width: 318.0,
                                          height: 45.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xff000000)),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(138.0, 272.0),
                                        child: Text(
                                          'Peso',
                                          style: TextStyle(
                                            fontFamily: 'Comic Sans MS',
                                            fontSize: 20,
                                            color: const Color(0xff000000),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          softWrap: false,
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(91.0, 340.0),
                                        child: Text(
                                          'Ancho del Animal',
                                          style: TextStyle(
                                            fontFamily: 'Comic Sans MS',
                                            fontSize: 20,
                                            color: const Color(0xff000000),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          softWrap: false,
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(0.0, 398.0),
                                        child: Container(
                                          width: 318.0,
                                          height: 45.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xff000000)),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(91.0, 407.0),
                                        child: Text(
                                          'Largo del Animal',
                                          style: TextStyle(
                                            fontFamily: 'Comic Sans MS',
                                            fontSize: 20,
                                            color: const Color(0xff000000),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          softWrap: false,
                                        ),
                                      ),
                                      Container(
                                        width: 318.0,
                                        height: 45.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffffffff),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                              width: 1.0,
                                              color: const Color(0xff000000)),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(61.0, 9.0),
                                        child: SizedBox(
                                          width: 196.0,
                                          child: Text(
                                            'Nombre',
                                            style: TextStyle(
                                              fontFamily: 'Comic Sans MS',
                                              fontSize: 20,
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.center,
                                            softWrap: false,
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(0.0, 466.0),
                                        child: Container(
                                          width: 318.0,
                                          height: 45.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xff000000)),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(0.0, 532.0),
                                        child: Container(
                                          width: 318.0,
                                          height: 45.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xff000000)),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(83.0, 475.0),
                                        child: Text(
                                          'Motivo de Consulta',
                                          style: TextStyle(
                                            fontFamily: 'Comic Sans MS',
                                            fontSize: 20,
                                            color: const Color(0xff000000),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          softWrap: false,
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(116.0, 541.0),
                                        child: Text(
                                          'Ubicación',
                                          style: TextStyle(
                                            fontFamily: 'Comic Sans MS',
                                            fontSize: 20,
                                            color: const Color(0xff000000),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          softWrap: false,
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(0.0, 598.0),
                                        child: Container(
                                          width: 319.0,
                                          height: 45.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xff000000)),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(59.0, 607.0),
                                        child: Text(
                                          'Información de Contacto',
                                          style: TextStyle(
                                            fontFamily: 'Comic Sans MS',
                                            fontSize: 20,
                                            color: const Color(0xff000000),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          softWrap: false,
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(5.8, 66.5),
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
                                      Transform.translate(
                                        offset: Offset(4.3, 133.0),
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
                                      Transform.translate(
                                        offset: Offset(4.5, 198.5),
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
                                      Transform.translate(
                                        offset: Offset(4.0, 265.5),
                                        child: Container(
                                          width: 41.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: const AssetImage(''),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(6.8, 332.0),
                                        child: Container(
                                          width: 36.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: const AssetImage(''),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(6.8, 400.5),
                                        child: Container(
                                          width: 36.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: const AssetImage(''),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(5.8, 2.5),
                                        child: Container(
                                          width: 37.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: const AssetImage(''),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(3.6, 600.5),
                                        child: Container(
                                          width: 39.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: const AssetImage(''),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(5.1, 468.5),
                                        child: Container(
                                          width: 39.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: const AssetImage(''),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(6.8, 534.5),
                                        child: Container(
                                          width: 33.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: const AssetImage(''),
                                              fit: BoxFit.fill,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(15.5, 934.5),
                                        child: SizedBox(
                                          width: 287.0,
                                          child: Text(
                                            'Solicitar Atención en Casa',
                                            style: TextStyle(
                                              fontFamily: 'Comic Sans MS',
                                              fontSize: 20,
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.center,
                                            softWrap: false,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment(-0.034, 0.569),
                                    child: Container(
                                      width: 110.0,
                                      height: 120.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: const AssetImage(''),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 39.0, end: 40.0),
                                    Pin(size: 28.0, end: 159.5),
                                    child: Text(
                                      'Adjuntar Historia Clínica',
                                      style: TextStyle(
                                        fontFamily: 'Comic Sans MS',
                                        fontSize: 20,
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                      softWrap: false,
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 122.1, middle: 0.4975),
                                    Pin(size: 120.0, end: 26.5),
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
          Align(
            alignment: Alignment(0.0, -0.272),
            child: Container(
              width: 183.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: const Color(0xe3a0f4fe),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(width: 1.0, color: const Color(0xe3000000)),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.004, -0.267),
            child: SizedBox(
              width: 141.0,
              height: 24.0,
              child: Text(
                'Atención en Casa',
                style: TextStyle(
                  fontFamily: 'Comic Sans MS',
                  fontSize: 17,
                  color: const Color(0xff000000),
                  fontWeight: FontWeight.w700,
                ),
                softWrap: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
