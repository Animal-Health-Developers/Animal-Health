import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import '../services/auth_service.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './CompradeProductos.dart';
import './CuidadosyRecomendaciones.dart';
import './Emergencias.dart';
import './Comunidad.dart';
import './Crearpublicaciones.dart';
import './Atragantamiento.dart';
import './Fracturas.dart';
import './GolpedeCalor.dart';
import './Heridas.dart';
import './Intoxicacion.dart';
import './Picaduras.dart';
import './Alergias.dart';
import './ViasRespiratorias.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrimerosAuxilios extends StatelessWidget {
  const PrimerosAuxilios({
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
                  pageBuilder: () => CompradeProductos(key: Key('CompradeProductos'),),// ruta a el widget de Tienda
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
                  pageBuilder: () => Home(key: Key('Home'),),//Home de noticias
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
          Pinned.fromPins(
            Pin(start: 47.0, end: 47.0),
            Pin(size: 580.0, end: 0.0),
            child: Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(start: 67.5, end: 67.5),
                  Pin(size: 34.0, start: 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xe3a0f4fe),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          width: 1.0, color: const Color(0xe3000000)),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 150.0, middle: 0.5),
                  Pin(size: 28.0, start: 3.0),
                  child: Text(
                    'EMERGENCIAS',
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
                  Pin(size: 318.0, middle: 0.5),
                  Pin(start: 42.0, end: 0.0),
                  child: SingleChildScrollView(
                    primary: false,
                    child: SizedBox(
                      width: 318.0,
                      height: 529.0,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 9.0),
                            child: SingleChildScrollView(
                              primary: false,
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 20,
                                runSpacing: 20,
                                children: [{}].map((itemData) {
                                  return SizedBox(
                                    width: 318.0,
                                    height: 511.0,
                                    child: Stack(
                                      children: <Widget>[
                                        Stack(
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                Pinned.fromPins(
                                                  Pin(start: 0.0, end: 0.0),
                                                  Pin(size: 45.0, start: 64.0),
                                                  child: PageLink(
                                                    links: [
                                                      PageLinkInfo(
                                                        transition:
                                                            LinkTransition.Fade,
                                                        ease: Curves.easeOut,
                                                        duration: 0.3,
                                                        pageBuilder: () =>
                                                            Atragantamiento(key: Key('Atragantamiento'),),
                                                      ),
                                                    ],
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: const Color(
                                                                0xff000000)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(start: 0.0, end: 0.0),
                                                  Pin(
                                                      size: 45.0,
                                                      middle: 0.279),
                                                  child: PageLink(
                                                    links: [
                                                      PageLinkInfo(
                                                        transition:
                                                            LinkTransition.Fade,
                                                        ease: Curves.easeOut,
                                                        duration: 0.3,
                                                        pageBuilder: () =>
                                                            Fracturas(key: Key('Fracturas'),),
                                                      ),
                                                    ],
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: const Color(
                                                                0xff000000)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(start: 0.0, end: 0.0),
                                                  Pin(
                                                      size: 45.0,
                                                      middle: 0.4206),
                                                  child: PageLink(
                                                    links: [
                                                      PageLinkInfo(
                                                        transition:
                                                            LinkTransition.Fade,
                                                        ease: Curves.easeOut,
                                                        duration: 0.3,
                                                        pageBuilder: () =>
                                                            GolpedeCalor(key: Key('GolpedeCalor'),),
                                                      ),
                                                    ],
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: const Color(
                                                                0xff000000)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(start: 0.0, end: 0.0),
                                                  Pin(
                                                      size: 45.0,
                                                      middle: 0.5622),
                                                  child: PageLink(
                                                    links: [
                                                      PageLinkInfo(
                                                        transition:
                                                            LinkTransition.Fade,
                                                        ease: Curves.easeOut,
                                                        duration: 0.3,
                                                        pageBuilder: () =>
                                                            Heridas(key: Key('Heridas'),),
                                                      ),
                                                    ],
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: const Color(
                                                                0xff000000)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(start: 0.0, end: 0.0),
                                                  Pin(
                                                      size: 45.0,
                                                      middle: 0.7082),
                                                  child: PageLink(
                                                    links: [
                                                      PageLinkInfo(
                                                        transition:
                                                            LinkTransition.Fade,
                                                        ease: Curves.easeOut,
                                                        duration: 0.3,
                                                        pageBuilder: () =>
                                                            Intoxicacion(key: Key('Intoxicacion'),),
                                                      ),
                                                    ],
                                                    child: SvgPicture.string(
                                                      _svg_adrya2,
                                                      allowDrawingOutsideViewBox:
                                                          true,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(start: 0.0, end: 0.0),
                                                  Pin(size: 45.0, end: 68.0),
                                                  child: PageLink(
                                                    links: [
                                                      PageLinkInfo(
                                                        transition:
                                                            LinkTransition.Fade,
                                                        ease: Curves.easeOut,
                                                        duration: 0.3,
                                                        pageBuilder: () =>
                                                            Picaduras(key: Key('Picaduras'),),
                                                      ),
                                                    ],
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: const Color(
                                                                0xff000000)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(start: 0.0, end: 0.0),
                                                  Pin(size: 45.0, start: 0.0),
                                                  child: PageLink(
                                                    links: [
                                                      PageLinkInfo(
                                                        transition:
                                                            LinkTransition.Fade,
                                                        ease: Curves.easeOut,
                                                        duration: 0.3,
                                                        pageBuilder: () =>
                                                            Alergias(key: Key('Alergias'),),
                                                      ),
                                                    ],
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: const Color(
                                                                0xff000000)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(start: 0.0, end: 0.0),
                                                  Pin(size: 45.0, end: 0.0),
                                                  child: PageLink(
                                                    links: [
                                                      PageLinkInfo(
                                                        transition:
                                                            LinkTransition.Fade,
                                                        ease: Curves.easeOut,
                                                        duration: 0.3,
                                                        pageBuilder: () =>
                                                            ViasRespiratorias(key: Key('ViasRespiratorias'),),
                                                      ),
                                                    ],
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: const Color(
                                                                0xff000000)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(size: 232.0, end: 24.0),
                                                  Pin(size: 28.0, end: 9.0),
                                                  child: Text(
                                                    'VIAS RESPIRATORIAS',
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
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment(0.0, -0.151),
                                                  child: SizedBox(
                                                    width: 174.0,
                                                    height: 28.0,
                                                    child: Text(
                                                      'GOLPE DE CALOR',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Comic Sans MS',
                                                        fontSize: 20,
                                                        color: const Color(
                                                            0xff000000),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                      softWrap: false,
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment(0.111, 0.408),
                                                  child: SizedBox(
                                                    width: 165.0,
                                                    height: 28.0,
                                                    child: Text(
                                                      'INTOXICACIÓN',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Comic Sans MS',
                                                        fontSize: 20,
                                                        color: const Color(
                                                            0xff000000),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                      softWrap: false,
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment(0.075, 0.673),
                                                  child: SizedBox(
                                                    width: 119.0,
                                                    height: 28.0,
                                                    child: Text(
                                                      'PICADURAS',
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
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(
                                                      size: 104.0,
                                                      middle: 0.5421),
                                                  Pin(size: 28.0, start: 9.0),
                                                  child: Text(
                                                    'ALERGIAS',
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
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(size: 216.0, end: 41.0),
                                                  Pin(size: 28.0, start: 72.0),
                                                  child: Text(
                                                    'ATRAGANTAMIENTO',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Comic Sans MS',
                                                      fontSize: 20,
                                                      color: const Color(
                                                          0xff000000),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    softWrap: false,
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment(0.082, -0.429),
                                                  child: SizedBox(
                                                    width: 122.0,
                                                    height: 28.0,
                                                    child: Text(
                                                      'FRACTURAS',
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
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment(0.076, 0.122),
                                                  child: SizedBox(
                                                    width: 95.0,
                                                    height: 28.0,
                                                    child: Text(
                                                      'HERIDAS',
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
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(size: 33.6, start: 6.6),
                                                  Pin(size: 40.0, start: 3.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: const AssetImage(
                                                            'assets/images/alergias.png'),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(size: 39.8, start: 4.0),
                                                  Pin(
                                                      size: 40.0,
                                                      middle: 0.4214),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: const AssetImage(
                                                            'assets/images/golpecalor.png'),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(size: 40.5, start: 4.0),
                                                  Pin(size: 40.0, end: 2.5),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: const AssetImage(
                                                            'assets/images/vias respiratorias.png'),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(size: 27.2, start: 10.7),
                                                  Pin(
                                                      size: 40.0,
                                                      middle: 0.7091),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: const AssetImage(
                                                            'assets/images/intoxicacion.png'),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Pinned.fromPins(
                                              Pin(size: 39.5, start: 4.4),
                                              Pin(size: 40.0, start: 67.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: const AssetImage('assets/images/atragantamiento.png'),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Pinned.fromPins(
                                              Pin(size: 36.0, start: 6.2),
                                              Pin(size: 40.0, middle: 0.2824),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: const AssetImage('assets/images/fracturas.png'),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Pinned.fromPins(
                                              Pin(size: 39.3, start: 5.0),
                                              Pin(size: 40.0, middle: 0.5626),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: const AssetImage('assets/images/heridas.png'),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 45.0, start: 3.0),
                                          Pin(size: 40.0, end: 71.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/picadura.png'),
                                                fit: BoxFit.fill,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_adrya2 =
    '<svg viewBox="47.0 396.0 318.0 45.0" ><path transform="translate(47.0, 396.0)" d="M 12 0 L 306 0 C 312.6274108886719 0 318 5.37258243560791 318 12 L 318 33 C 318 39.62741851806641 312.6274108886719 45 306 45 L 12 45 C 5.37258243560791 45 0 39.62741851806641 0 33 L 0 12 C 0 5.37258243560791 5.37258243560791 0 12 0 Z" fill="#ffffff" stroke="#000000" stroke-width="1" stroke-miterlimit="4" stroke-linecap="round" /></svg>';
