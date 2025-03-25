import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'Home.dart';
import 'package:adobe_xd/page_link.dart';
import 'Ayuda.dart';
import 'PerfilPublico.dart';
import 'Settings.dart';
import 'ListadeAnimales.dart';
import 'CompradeProductos.dart';
import 'CuidadosyRecomendaciones.dart';
import 'Emergencias.dart';
import 'Comunidad.dart';
import 'Cearpublicaciones.dart';

class ServiciodeAmbulancia extends StatelessWidget {
  const ServiciodeAmbulancia({
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
            Pin(size: 33.9, start: 10.0),
            Pin(size: 32.0, middle: 0.3605),
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
            alignment: Alignment(-0.055, 1.0),
            child: SizedBox(
              width: 319.0,
              height: 526.0,
              child: SingleChildScrollView(
                primary: false,
                child: SizedBox(
                  width: 319.0,
                  height: 974.0,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, -448.0),
                        child: SingleChildScrollView(
                          primary: false,
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 20,
                            runSpacing: 20,
                            children: [{}].map((itemData) {
                              return SizedBox(
                                width: 319.0,
                                height: 955.0,
                                child: Stack(
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        Pinned.fromPins(
                                          Pin(start: 0.0, end: 1.0),
                                          Pin(size: 45.0, start: 64.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 48.0, middle: 0.4908),
                                          Pin(size: 28.0, start: 72.0),
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
                                        Pinned.fromPins(
                                          Pin(start: 0.0, end: 1.0),
                                          Pin(size: 45.0, start: 130.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 71.0, middle: 0.5),
                                          Pin(size: 28.0, start: 138.0),
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
                                        Pinned.fromPins(
                                          Pin(start: 0.0, end: 1.0),
                                          Pin(size: 45.0, middle: 0.2154),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(0.011, -0.56),
                                          child: SizedBox(
                                            width: 46.0,
                                            height: 28.0,
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
                                        ),
                                        Pinned.fromPins(
                                          Pin(start: 0.0, end: 1.0),
                                          Pin(size: 45.0, middle: 0.2879),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(start: 0.0, end: 1.0),
                                          Pin(size: 45.0, middle: 0.3626),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(-0.004, -0.413),
                                          child: SizedBox(
                                            width: 42.0,
                                            height: 28.0,
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
                                        ),
                                        Align(
                                          alignment: Alignment(0.19, -0.266),
                                          child: SizedBox(
                                            width: 166.0,
                                            height: 28.0,
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
                                        ),
                                        Pinned.fromPins(
                                          Pin(start: 0.0, end: 1.0),
                                          Pin(size: 45.0, middle: 0.4374),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(0.152, -0.122),
                                          child: SizedBox(
                                            width: 161.0,
                                            height: 28.0,
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
                                        ),
                                        Pinned.fromPins(
                                          Pin(start: 0.0, end: 1.0),
                                          Pin(size: 45.0, start: 0.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 75.0, middle: 0.502),
                                          Pin(size: 28.0, start: 9.0),
                                          child: Text(
                                            'Nombre',
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
                                          Pin(start: 0.0, end: 1.0),
                                          Pin(size: 45.0, middle: 0.5121),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(start: 0.0, end: 1.0),
                                          Pin(size: 45.0, middle: 0.5846),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(0.021, 0.025),
                                          child: SizedBox(
                                            width: 86.0,
                                            height: 28.0,
                                            child: Text(
                                              'Problema',
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
                                          alignment: Alignment(0.013, 0.167),
                                          child: SizedBox(
                                            width: 90.0,
                                            height: 28.0,
                                            child: Text(
                                              'Ubicacion',
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
                                          Pin(start: 0.0, end: 0.0),
                                          Pin(size: 45.0, middle: 0.6571),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 222.0, end: 39.0),
                                          Pin(size: 29.0, middle: 0.6544),
                                          child: SingleChildScrollView(
                                            primary: false,
                                            child: Wrap(
                                              alignment: WrapAlignment.center,
                                              spacing: 2,
                                              runSpacing: 21,
                                              children: [{}].map((itemData) {
                                                return SizedBox(
                                                  width: 240.0,
                                                  height: 28.0,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      SizedBox.expand(
                                                          child: Text(
                                                        'Informacion de Contacto',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Comic Sans MS',
                                                          fontSize: 20,
                                                          color: const Color(
                                                              0xff000000),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        softWrap: false,
                                                      )),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(0.041, 1.0),
                                          child: SizedBox(
                                            width: 196.0,
                                            height: 28.0,
                                            child: Text(
                                              'Solicitar Ambulancia',
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
                                        Pinned.fromPins(
                                          Pin(size: 35.2, start: 5.8),
                                          Pin(size: 40.0, start: 66.5),
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
                                          Pin(size: 40.3, start: 4.3),
                                          Pin(size: 40.0, start: 133.0),
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
                                          Pin(size: 40.4, start: 4.5),
                                          Pin(size: 40.0, middle: 0.2169),
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
                                          Pin(size: 40.7, start: 4.0),
                                          Pin(size: 40.0, middle: 0.2902),
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
                                          Pin(size: 35.8, start: 6.8),
                                          Pin(size: 40.0, middle: 0.3628),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage(''),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 35.8, start: 6.8),
                                          Pin(size: 40.0, middle: 0.4377),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage(''),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 37.4, start: 5.8),
                                          Pin(size: 40.0, start: 2.5),
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
                                          Pin(size: 39.3, start: 3.6),
                                          Pin(size: 40.0, middle: 0.6563),
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
                                          Pin(size: 39.3, start: 5.1),
                                          Pin(size: 40.0, middle: 0.512),
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
                                          Pin(size: 32.8, start: 6.8),
                                          Pin(size: 40.0, middle: 0.5842),
                                          child: Container(
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
                                        Align(
                                          alignment: Alignment(-0.005, 0.557),
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
                                          Pin(start: 42.0, end: 37.0),
                                          Pin(size: 28.0, end: 163.0),
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
                                      ],
                                    ),
                                    Pinned.fromPins(
                                      Pin(size: 140.1, middle: 0.5),
                                      Pin(size: 120.0, end: 27.0),
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
          ),
          Pinned.fromPins(
            Pin(start: 85.0, end: 85.0),
            Pin(size: 34.0, middle: 0.3625),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xe3a0f4fe),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(width: 1.0, color: const Color(0xe3000000)),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.0, -0.273),
            child: SizedBox(
              width: 223.0,
              height: 28.0,
              child: Text(
                'Servicio de Ambulancia',
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
            Pin(size: 33.9, start: 10.0),
            Pin(size: 32.0, middle: 0.3605),
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
    );
  }
}
