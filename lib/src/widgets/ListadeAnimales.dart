import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './Settings.dart';
import './CrearPerfildeAnimalesdeCompaia.dart';
import './EditarPerfildeAnimalesdeCompaia.dart';
import 'dart:ui' as ui;
import 'package:flutter_svg/flutter_svg.dart';

class ListadeAnimales extends StatelessWidget {
  ListadeAnimales({
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
            Pin(size: 60.0, start: 13.0),
            Pin(size: 60.0, start: 115.0),
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
            Pin(start: 30.0, end: 29.0),
            Pin(size: 714.0, end: 27.0),
            child: Stack(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Pinned.fromPins(
                      Pin(size: 110.7, middle: 0.4979),
                      Pin(size: 120.0, end: 35.0),
                      child: PageLink(
                        links: [
                          PageLinkInfo(
                            transition: LinkTransition.Fade,
                            ease: Curves.easeOut,
                            duration: 0.3,
                            pageBuilder: () => CrearPerfildeAnimalesdeCompaia(key: Key('CrearPerfildeAnimalesdeCompaia'),),
                          ),
                        ],
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: const AssetImage('assets/images/crearperfilanimal.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 135.0,
                        height: 35.0,
                        decoration: BoxDecoration(
                          color: const Color(0xe3a0f4fe),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                              width: 1.0, color: const Color(0xe3000000)),
                        ),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 98.0, middle: 0.498),
                      Pin(size: 24.0, end: 6.0),
                      child: Text(
                        'Crear Perfil',
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
                      Pin(start: 0.0, end: 0.0),
                      Pin(size: 489.0, start: 58.0),
                      child: Stack(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              SizedBox.expand(
                                  child: SvgPicture.string(
                                _svg_jvl87d,
                                allowDrawingOutsideViewBox: true,
                                fit: BoxFit.fill,
                              )),
                              Pinned.fromPins(
                                Pin(size: 245.5, middle: 0.4953),
                                Pin(start: 0.5, end: 1.5),
                                child: SingleChildScrollView(
                                  primary: false,
                                  child: SizedBox(
                                    width: 246.0,
                                    height: 858.0,
                                    child: Stack(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0.0, 0.0, 0.0, 0.0),
                                          child: SingleChildScrollView(
                                            primary: false,
                                            child: Wrap(
                                              alignment: WrapAlignment.center,
                                              spacing: 20,
                                              runSpacing: 20,
                                              children:
                                                  [{}, {}, {}].map((itemData) {
                                                return SizedBox(
                                                  width: 246.0,
                                                  height: 267.0,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Pinned.fromPins(
                                                        Pin(
                                                            size: 36.0,
                                                            middle: 0.7446),
                                                        Pin(
                                                            size: 21.0,
                                                            start: 10.5),
                                                        child: Text(
                                                          'Kitty',
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
                                                      Pinned.fromPins(
                                                        Pin(
                                                            size: 80.0,
                                                            start: 0.5),
                                                        Pin(
                                                            size: 80.0,
                                                            start: 0.0),
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
                                                                  EditarPerfildeAnimalesdeCompaia(key: Key('EditarPerfildeAnimalesdeCompaia'),),
                                                            ),
                                                          ],
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    const AssetImage(
                                                                        'assets/images/kitty.jpg'),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Pinned.fromPins(
                                                        Pin(
                                                            size: 143.0,
                                                            end: 0.0),
                                                        Pin(
                                                            size: 31.0,
                                                            start: 40.0),
                                                        child: ClipRect(
                                                          child: BackdropFilter(
                                                            filter: ui
                                                                    .ImageFilter
                                                                .blur(
                                                                    sigmaX:
                                                                        36.0,
                                                                    sigmaY:
                                                                        36.0),
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
                                                                      EditarPerfildeAnimalesdeCompaia(key: Key('EditarPerfildeAnimalesdeCompaia'),),
                                                                ),
                                                              ],
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0x7a54d1e0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  border: Border.all(
                                                                      width:
                                                                          1.0,
                                                                      color: const Color(
                                                                          0xff707070)),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment(
                                                            1.0, 0.136),
                                                        child: ClipRect(
                                                          child: BackdropFilter(
                                                            filter: ui
                                                                    .ImageFilter
                                                                .blur(
                                                                    sigmaX:
                                                                        36.0,
                                                                    sigmaY:
                                                                        36.0),
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
                                                                      EditarPerfildeAnimalesdeCompaia(key: Key('EditarPerfildeAnimalesdeCompaia'),),
                                                                ),
                                                              ],
                                                              child: Container(
                                                                width: 143.0,
                                                                height: 31.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0x7a54d1e0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  border: Border.all(
                                                                      width:
                                                                          1.0,
                                                                      color: const Color(
                                                                          0xff707070)),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Pinned.fromPins(
                                                        Pin(
                                                            size: 119.0,
                                                            end: 12.0),
                                                        Pin(
                                                            size: 21.0,
                                                            middle: 0.565),
                                                        child: Text(
                                                          'Ver Informacion',
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
                                                        alignment: Alignment(
                                                            -1.0, 0.005),
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
                                                                  EditarPerfildeAnimalesdeCompaia(key: Key('EditarPerfildeAnimalesdeCompaia'),),
                                                            ),
                                                          ],
                                                          child: Container(
                                                            width: 80.0,
                                                            height: 80.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    const AssetImage(
                                                                        'assets/images/winter.jpg'),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Pinned.fromPins(
                                                        Pin(
                                                            size: 80.0,
                                                            start: 0.5),
                                                        Pin(
                                                            size: 80.0,
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
                                                                  EditarPerfildeAnimalesdeCompaia(key: Key('EditarPerfildeAnimalesdeCompaia'),),
                                                            ),
                                                          ],
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    const AssetImage(
                                                                        'assets/images/donut.jpg'),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment(
                                                            0.487, 0.614),
                                                        child: SizedBox(
                                                          width: 41.0,
                                                          height: 21.0,
                                                          child: Text(
                                                            'Donut',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Comic Sans MS',
                                                              fontSize: 15,
                                                              color: const Color(
                                                                  0xff000000),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                            softWrap: false,
                                                          ),
                                                        ),
                                                      ),
                                                      Pinned.fromPins(
                                                        Pin(
                                                            size: 119.0,
                                                            end: 13.5),
                                                        Pin(
                                                            size: 21.0,
                                                            middle: 0.1829),
                                                        child: Text(
                                                          'Ver Informacion',
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
                                                      Pinned.fromPins(
                                                        Pin(
                                                            size: 143.0,
                                                            end: 0.0),
                                                        Pin(
                                                            size: 31.0,
                                                            end: 9.0),
                                                        child: ClipRect(
                                                          child: BackdropFilter(
                                                            filter: ui
                                                                    .ImageFilter
                                                                .blur(
                                                                    sigmaX:
                                                                        36.0,
                                                                    sigmaY:
                                                                        36.0),
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
                                                                      EditarPerfildeAnimalesdeCompaia(key: Key('EditarPerfildeAnimalesdeCompaia'),),
                                                                ),
                                                              ],
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0x7a54d1e0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  border: Border.all(
                                                                      width:
                                                                          1.0,
                                                                      color: const Color(
                                                                          0xff707070)),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Pinned.fromPins(
                                                        Pin(
                                                            size: 119.0,
                                                            end: 12.0),
                                                        Pin(
                                                            size: 21.0,
                                                            end: 14.0),
                                                        child: Text(
                                                          'Ver Informacion',
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
                                                        alignment: Alignment(
                                                            0.528, -0.15),
                                                        child: SizedBox(
                                                          width: 50.0,
                                                          height: 21.0,
                                                          child: Text(
                                                            'Winter',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Comic Sans MS',
                                                              fontSize: 15,
                                                              color: const Color(
                                                                  0xff000000),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                            softWrap: false,
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
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: 229.0,
                        height: 35.0,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xe3a0f4fe),
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    width: 1.0, color: const Color(0xe3000000)),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(30.0, 4.0, 29.0, 3.0),
                              child: SizedBox.expand(
                                  child: Text(
                                'Lista de Animales',
                                style: TextStyle(
                                  fontFamily: 'Comic Sans MS',
                                  fontSize: 20,
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                                softWrap: false,
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_jvl87d =
    '<svg viewBox="30.0 209.0 353.0 489.0" ><path transform="translate(30.0, 209.0)" d="M 20 0 L 333 0 C 344.0456848144531 0 353 8.954304695129395 353 20 L 353 469 C 353 480.0456848144531 344.0456848144531 489 333 489 L 20 489 C 8.954304695129395 489 0 480.0456848144531 0 469 L 0 20 C 0 8.954304695129395 8.954304695129395 0 20 0 Z" fill="#54d1e0" fill-opacity="0.53" stroke="#000000" stroke-width="1" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
