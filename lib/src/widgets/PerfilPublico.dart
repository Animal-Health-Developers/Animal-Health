import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './Crearpublicaciondesdeperfil.dart';
import './DetallesdeFotooVideo.dart';
import './CompartirPublicacion.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PerfilPublico extends StatelessWidget {
  PerfilPublico({
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
          Pinned.fromPins(
            Pin(size: 47.2, end: 7.6),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Configuraciones(key: Key('Settings'),),
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
            Pin(size: 412.0, middle: 0.5),
            Pin(start: 180.0, end: 0.0),
            child: SingleChildScrollView(
              primary: false,
              child: SizedBox(
                width: 412.0,
                height: 2383.0,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: SingleChildScrollView(
                        primary: false,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 20,
                          runSpacing: 20,
                          children: [{}].map((itemData) {
                            return SizedBox(
                              width: 412.0,
                              height: 2383.0,
                              child: Stack(
                                children: <Widget>[
                                  Pinned.fromPins(
                                    Pin(start: 1.0, end: 0.0),
                                    Pin(size: 65.0, start: 266.0),
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xe3a0f4fe),
                                            borderRadius:
                                                BorderRadius.circular(9.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xe3000000)),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 135.8, start: 11.9),
                                          Pin(size: 30.0, middle: 0.5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xff54d1e0),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      const Color(0xff080808),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 115.0, start: 21.6),
                                          Pin(size: 28.0, middle: 0.473),
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
                                          alignment: Alignment(0.084, 0.0),
                                          child: SizedBox(
                                            width: 100.0,
                                            height: 30.0,
                                            child: SvgPicture.string(
                                              _svg_ymtv88,
                                              allowDrawingOutsideViewBox: true,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(0.084, -0.054),
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
                                          Pin(size: 112.0, end: 11.9),
                                          Pin(size: 30.0, middle: 0.5),
                                          child: SvgPicture.string(
                                            _svg_wctb2,
                                            allowDrawingOutsideViewBox: true,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 100.0, end: 16.9),
                                          Pin(size: 28.0, middle: 0.473),
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
                                      ],
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 12.0, end: 10.0),
                                    Pin(size: 253.0, start: 0.0),
                                    child: Stack(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: PageLink(
                                            links: [
                                              PageLinkInfo(
                                                transition: LinkTransition.Fade,
                                                ease: Curves.easeOut,
                                                duration: 0.3,
                                                pageBuilder: () =>
                                                    Crearpublicaciondesdeperfil(key: Key('Crearpublicaciondesdeperfil'),),
                                              ),
                                            ],
                                            child: Container(
                                              width: 179.0,
                                              height: 40.0,
                                              decoration: BoxDecoration(
                                                color: const Color(0xff54d1e0),
                                                borderRadius:
                                                    BorderRadius.circular(7.0),
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: const Color(
                                                        0xff000000)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        const Color(0xff080808),
                                                    offset: Offset(0, 3),
                                                    blurRadius: 6,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 165.0, start: 7.0),
                                          Pin(size: 28.0, end: 6.0),
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
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            width: 179.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff54d1e0),
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      const Color(0xff080808),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 121.0, end: 27.0),
                                          Pin(size: 28.0, end: 6.0),
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
                                                image: const AssetImage('assets/images/perfilusuario.jpeg'),
                                                fit: BoxFit.fill,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(start: 65.7, end: 65.7),
                                          Pin(size: 35.0, middle: 0.7523),
                                          child: SvgPicture.string(
                                            _svg_z0u8a,
                                            allowDrawingOutsideViewBox: true,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(0.034, 0.493),
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
                                      ],
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 0.0, end: 0.0),
                                    Pin(size: 237.0, start: 336.0),
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xe3a0f4fe),
                                            borderRadius:
                                                BorderRadius.circular(9.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xe3000000)),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 129.0, middle: 0.2647),
                                          Pin(size: 24.0, start: 13.0),
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
                                            textHeightBehavior:
                                                TextHeightBehavior(
                                                    applyHeightToFirstAscent:
                                                        false),
                                            softWrap: false,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(-0.529, -0.441),
                                          child: SizedBox(
                                            width: 94.0,
                                            height: 24.0,
                                            child: Text.rich(
                                              TextSpan(
                                                style: TextStyle(
                                                  fontFamily: 'Comic Sans MS',
                                                  fontSize: 17,
                                                  color:
                                                      const Color(0xff000000),
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: 'De ',
                                                  ),
                                                  TextSpan(
                                                    text: 'Medellín',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
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
                                          alignment: Alignment(-0.435, -0.005),
                                          child: SizedBox(
                                            width: 147.0,
                                            height: 24.0,
                                            child: Text.rich(
                                              TextSpan(
                                                style: TextStyle(
                                                  fontFamily: 'Comic Sans MS',
                                                  fontSize: 17,
                                                  color:
                                                      const Color(0xff000000),
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: 'Prefencias: ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: 'Todos',
                                                  ),
                                                ],
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
                                          alignment: Alignment(-0.447, 0.432),
                                          child: SizedBox(
                                            width: 141.0,
                                            height: 24.0,
                                            child: Text.rich(
                                              TextSpan(
                                                style: TextStyle(
                                                  fontFamily: 'Comic Sans MS',
                                                  fontSize: 17,
                                                  color:
                                                      const Color(0xff000000),
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: 'Género ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: 'Masculino',
                                                  ),
                                                ],
                                              ),
                                              textHeightBehavior:
                                                  TextHeightBehavior(
                                                      applyHeightToFirstAscent:
                                                          false),
                                              softWrap: false,
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 112.0, middle: 0.2497),
                                          Pin(size: 24.0, end: 14.0),
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
                                            textHeightBehavior:
                                                TextHeightBehavior(
                                                    applyHeightToFirstAscent:
                                                        false),
                                            softWrap: false,
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 37.9, start: 20.6),
                                          Pin(size: 40.0, middle: 0.2614),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/de.png'),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 45.5, start: 17.4),
                                          Pin(size: 40.0, start: 5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/viveen.png'),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 45.6, start: 17.2),
                                          Pin(size: 40.0, middle: 0.4975),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/preferencias.png'),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 35.8, start: 21.7),
                                          Pin(size: 40.0, middle: 0.7411),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/genero.png'),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 41.2, start: 19.6),
                                          Pin(size: 40.0, end: 6.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/edadusuario.png'),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0.0, 582.0, 0.0, 0.0),
                                    child: SingleChildScrollView(
                                      primary: false,
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 20,
                                        runSpacing: 10,
                                        children: [{}, {}, {}].map((itemData) {
                                          return SizedBox(
                                            width: 412.0,
                                            height: 588.0,
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xe3a0f4fe),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9.0),
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: const Color(
                                                            0xe3000000)),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(start: 5.7, end: 5.7),
                                                  Pin(size: 40.5, end: 6.0),
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Pinned.fromPins(
                                                        Pin(
                                                            size: 37.0,
                                                            start: 40.1),
                                                        Pin(
                                                            size: 28.0,
                                                            end: 6.0),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            SizedBox.expand(
                                                                child: Text(
                                                              '777',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Comic Sans MS',
                                                                fontSize: 20,
                                                                color: const Color(
                                                                    0xff000000),
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
                                                        Pin(
                                                            size: 54.0,
                                                            end: 45.4),
                                                        Pin(
                                                            size: 28.0,
                                                            end: 6.0),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            SizedBox.expand(
                                                                child: Text(
                                                              'SAVE',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Comic Sans MS',
                                                                fontSize: 20,
                                                                color: const Color(
                                                                    0xff000000),
                                                                height: 1.2,
                                                              ),
                                                              textHeightBehavior:
                                                                  TextHeightBehavior(
                                                                      applyHeightToFirstAscent:
                                                                          false),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              softWrap: false,
                                                            )),
                                                          ],
                                                        ),
                                                      ),
                                                      Pinned.fromPins(
                                                        Pin(
                                                            size: 21.0,
                                                            middle: 0.3455),
                                                        Pin(
                                                            size: 28.0,
                                                            end: 6.0),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            SizedBox.expand(
                                                                child: Text(
                                                              '13',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Comic Sans MS',
                                                                fontSize: 20,
                                                                color: const Color(
                                                                    0xff000000),
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
                                                        Pin(
                                                            size: 36.1,
                                                            start: 0.0),
                                                        Pin(
                                                            start: 0.0,
                                                            end: 0.5),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  const AssetImage(
                                                                      'assets/images/like.png'),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Pinned.fromPins(
                                                        Pin(
                                                            size: 37.8,
                                                            middle: 0.2513),
                                                        Pin(
                                                            start: 0.5,
                                                            end: 0.0),
                                                        child: PageLink(
                                                          links: [
                                                            PageLinkInfo(
                                                              transition:
                                                                  LinkTransition
                                                                      .Fade,
                                                              ease: Curves
                                                                  .easeOut,
                                                              duration: 0.3,
                                                              pageBuilder: () =>
                                                                  DetallesdeFotooVideo(key: Key('DetallesdeFotooVideo'),),
                                                            ),
                                                          ],
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    const AssetImage(
                                                                        'assets/images/comments.png'),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Pinned.fromPins(
                                                        Pin(
                                                            size: 40.4,
                                                            end: 0.0),
                                                        Pin(
                                                            start: 0.5,
                                                            end: 0.0),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  const AssetImage(
                                                                      'assets/images/save.png'),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Pinned.fromPins(
                                                        Pin(
                                                            size: 35.0,
                                                            middle: 0.7171),
                                                        Pin(
                                                            start: 0.5,
                                                            end: 0.0),
                                                        child: PageLink(
                                                          links: [
                                                            PageLinkInfo(
                                                              transition:
                                                                  LinkTransition
                                                                      .Fade,
                                                              ease: Curves
                                                                  .easeOut,
                                                              duration: 0.3,
                                                              pageBuilder: () =>
                                                                  CompartirPublicacion(key: Key('CompartirPublicacion'),),
                                                            ),
                                                          ],
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    const AssetImage(
                                                                        'assets/images/share.png'),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Pinned.fromPins(
                                                        Pin(
                                                            size: 69.0,
                                                            middle: 0.5735),
                                                        Pin(
                                                            size: 28.0,
                                                            end: 6.0),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            SizedBox.expand(
                                                                child: Text(
                                                              'SHARE',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Comic Sans MS',
                                                                fontSize: 20,
                                                                color: const Color(
                                                                    0xff000000),
                                                                height: 1.2,
                                                              ),
                                                              textHeightBehavior:
                                                                  TextHeightBehavior(
                                                                      applyHeightToFirstAscent:
                                                                          false),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              softWrap: false,
                                                            )),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(start: 36.0, end: 36.0),
                                                  Pin(size: 439.0, end: 50.0),
                                                  child: PageLink(
                                                    links: [
                                                      PageLinkInfo(
                                                        transition:
                                                            LinkTransition.Fade,
                                                        ease: Curves.easeOut,
                                                        duration: 0.3,
                                                        pageBuilder: () =>
                                                            DetallesdeFotooVideo(key: Key('DetallesdeFotooVideo'),),
                                                      ),
                                                    ],
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image:
                                                              const AssetImage(
                                                                  'assets/images/imagenpublicacion.jpg'),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Pinned.fromPins(
                                                  Pin(start: 7.0, end: 0.0),
                                                  Pin(size: 87.0, start: 6.0),
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Pinned.fromPins(
                                                        Pin(
                                                            size: 187.0,
                                                            start: 47.0),
                                                        Pin(
                                                            size: 28.0,
                                                            start: 3.0),
                                                        child: Text(
                                                          'Nombre de Usuario',
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
                                                        Pin(
                                                            start: 13.0,
                                                            end: 0.0),
                                                        Pin(
                                                            size: 42.0,
                                                            end: 0.0),
                                                        child: Text(
                                                          'Kitty estrenando sus nuevas orejeras que compramos \n#Amazon',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Comic Sans MS',
                                                            fontSize: 15,
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
                                                            Alignment.topLeft,
                                                        child: Container(
                                                          width: 40.0,
                                                          height: 40.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  const AssetImage(
                                                                      'assets/images/perfilusuario.jpeg'),
                                                              fit: BoxFit.fill,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                        ),
                                                      ),
                                                      Pinned.fromPins(
                                                        Pin(
                                                            size: 33.6,
                                                            middle: 0.6641),
                                                        Pin(
                                                            size: 30.0,
                                                            start: 2.0),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  const AssetImage(
                                                                      'assets/images/comunidad.png'),
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
                                        }).toList(),
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
    );
  }
}

const String _svg_ymtv88 =
    '<svg viewBox="168.6 463.5 100.0 30.0" ><path transform="translate(168.6, 463.5)" d="M 8 0 L 92 0 C 96.41828155517578 0 100 3.581721782684326 100 8 L 100 22 C 100 26.41827774047852 96.41828155517578 30 92 30 L 8 30 C 3.581721782684326 30 0 26.41827774047852 0 22 L 0 8 C 0 3.581721782684326 3.581721782684326 0 8 0 Z" fill="#54d1e0" stroke="#000000" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_wctb2 =
    '<svg viewBox="287.1 463.5 112.0 30.0" ><path transform="translate(287.14, 463.5)" d="M 8 0 L 104 0 C 108.4182815551758 0 112 3.581721782684326 112 8 L 112 22 C 112 26.41827774047852 108.4182815551758 30 104 30 L 8 30 C 3.581721782684326 30 0 26.41827774047852 0 22 L 0 8 C 0 3.581721782684326 3.581721782684326 0 8 0 Z" fill="#947b93" stroke="#000000" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_z0u8a =
    '<svg viewBox="76.7 344.0 258.6 35.0" ><path transform="translate(76.72, 344.0)" d="M 11.29102420806885 0 L 247.2734222412109 0 C 253.50927734375 0 258.564453125 4.477152347564697 258.564453125 10 L 258.564453125 25 C 258.564453125 30.52284812927246 253.50927734375 35 247.2734222412109 35 L 11.29102420806885 35 C 5.055163383483887 35 0 30.52284812927246 0 25 L 0 10 C 0 4.477152347564697 5.055163383483887 0 11.29102420806885 0 Z" fill="#a0f4fe" fill-opacity="0.89" stroke="#000000" stroke-width="1" stroke-opacity="0.89" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
