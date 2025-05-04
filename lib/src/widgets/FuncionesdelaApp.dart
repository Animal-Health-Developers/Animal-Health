import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import '../services/auth_service.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './EditarPerfildeAnimal.dart';
import './VisitasalVeterinario.dart';
import 'dart:ui' as ui;
import './CarnetdeVacunacin.dart';
import './Tratamientomedico.dart';
import './HistoriaClnica.dart';
import './IndicedeMasaCoporal.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FuncionesdelaApp extends StatelessWidget {
  const FuncionesdelaApp({
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
            Pin(size: 50.0, start: -7.5),
            Pin(size: 1.0, start: 128.0),
            child: SvgPicture.string(
              _svg_i3j02g,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
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
            alignment: Alignment(0.0, -0.621),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => EditarPerfildeAnimal(key: Key('EditarPerfildeAnimalesdeCompaia'), animalId: '',),
                ),
              ],
              child: Container(
                width: 90.0,
                height: 90.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/kitty.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 15.0, end: 19.0),
            Pin(size: 585.0, end: 49.0),
            child: Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(size: 178.0, start: 0.0),
                  Pin(size: 163.0, start: 52.0),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: PageLink(
                        links: [
                          PageLinkInfo(
                            transition: LinkTransition.Fade,
                            ease: Curves.easeOut,
                            duration: 0.3,
                            pageBuilder: () => VisitasalVeterinario(key: Key('VisitasalVeterinario'),),
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
                  Pin(size: 178.0, end: 0.0),
                  Pin(size: 163.0, start: 52.0),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: PageLink(
                        links: [
                          PageLinkInfo(
                            transition: LinkTransition.Fade,
                            ease: Curves.easeOut,
                            duration: 0.3,
                            pageBuilder: () => CarnetdeVacunacin(key: Key('CarnetdeVacunacin'),),
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
                Align(
                  alignment: Alignment(-1.0, 0.118),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: PageLink(
                        links: [
                          PageLinkInfo(
                            transition: LinkTransition.Fade,
                            ease: Curves.easeOut,
                            duration: 0.3,
                            pageBuilder: () => Tratamientomedico(key: Key('Tratamientomedico'),),
                          ),
                        ],
                        child: Container(
                          width: 178.0,
                          height: 163.0,
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
                Align(
                  alignment: Alignment(1.0, 0.118),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: PageLink(
                        links: [
                          PageLinkInfo(
                            transition: LinkTransition.Fade,
                            ease: Curves.easeOut,
                            duration: 0.3,
                            pageBuilder: () => HistoriaClnica(key: Key('HistoriaClnica'),),
                          ),
                        ],
                        child: Container(
                          width: 178.0,
                          height: 163.0,
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
                  Pin(size: 154.0, start: 14.5),
                  Pin(size: 21.0, middle: 0.3245),
                  child: Text(
                    'Visitas al Veterinario',
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
                  Pin(size: 156.0, end: 9.0),
                  Pin(size: 21.0, middle: 0.3245),
                  child: Text(
                    'Carnet de Vacunación',
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
                  Pin(size: 100.0, start: 39.0),
                  Pin(size: 21.0, middle: 0.6543),
                  child: Text(
                    'Medicamentos',
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
                  Pin(size: 110.0, end: 34.0),
                  Pin(size: 21.0, middle: 0.6543),
                  child: Text(
                    'Historia Clínica',
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
                  Pin(size: 121.7, start: 28.6),
                  Pin(size: 120.0, start: 61.0),
                  child: PageLink(
                    links: [
                      PageLinkInfo(
                        transition: LinkTransition.Fade,
                        ease: Curves.easeOut,
                        duration: 0.3,
                        pageBuilder: () => VisitasalVeterinario(key: Key('VisitasalVeterinario'),),
                      ),
                    ],
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage('assets/images/visitasveterinario.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: PageLink(
                        links: [
                          PageLinkInfo(
                            transition: LinkTransition.Fade,
                            ease: Curves.easeOut,
                            duration: 0.3,
                            pageBuilder: () => IndicedeMasaCoporal(key: Key('IndicedeMasaCoporal'),),
                          ),
                        ],
                        child: Container(
                          width: 178.0,
                          height: 163.0,
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
                  Pin(size: 112.0, start: 33.0),
                  Pin(size: 21.0, end: 10.0),
                  child: Text(
                    'Indice de Masa',
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
                  Pin(size: 122.5, start: 30.2),
                  Pin(size: 120.0, end: 34.0),
                  child: PageLink(
                    links: [
                      PageLinkInfo(
                        transition: LinkTransition.Fade,
                        ease: Curves.easeOut,
                        duration: 0.3,
                        pageBuilder: () => IndicedeMasaCoporal(key: Key('IndicedeMasaCoporal'),),
                      ),
                    ],
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage('assets/images/indicedemasa.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 118.9, start: 31.6),
                  Pin(size: 120.0, middle: 0.5355),
                  child: PageLink(
                    links: [
                      PageLinkInfo(
                        transition: LinkTransition.Fade,
                        ease: Curves.easeOut,
                        duration: 0.3,
                        pageBuilder: () => Tratamientomedico(key: Key('Tratamientomedico'),),
                      ),
                    ],
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage('assets/images/medicamentos.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 100.1, end: 41.0),
                  Pin(size: 120.0, middle: 0.5355),
                  child: PageLink(
                    links: [
                      PageLinkInfo(
                        transition: LinkTransition.Fade,
                        ease: Curves.easeOut,
                        duration: 0.3,
                        pageBuilder: () => HistoriaClnica(key: Key('HistoriaClnica'),),
                      ),
                    ],
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage('assets/images/historiaclinica.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(start: 43.0, end: 39.0),
                  Pin(size: 35.0, start: 0.0),
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
                  Pin(size: 266.0, end: 50.0),
                  Pin(size: 28.0, start: 4.0),
                  child: Text(
                    'Funciones de Animal Health',
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
                  Pin(size: 113.1, end: 32.4),
                  Pin(size: 120.0, start: 63.0),
                  child: PageLink(
                    links: [
                      PageLinkInfo(
                        transition: LinkTransition.Fade,
                        ease: Curves.easeOut,
                        duration: 0.3,
                        pageBuilder: () => CarnetdeVacunacin(key: Key('CarnetdeVacunacin'),),
                      ),
                    ],
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage('assets/images/carnetvacunacion.png'),
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
        ],
      ),
    );
  }
}

const String _svg_a7p9a8 =
    '<svg viewBox="150.6 225.5 1.0 1.0" ><path transform="translate(0.0, -105.0)" d="M 150.5888214111328 330.5046081542969" fill="none" stroke="#4ec8dd" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_i3j02g =
    '<svg viewBox="-7.5 128.0 50.0 1.0" ><path transform="translate(-55.49, 74.01)" d="M 48.65689086914062 53.9924201965332 C 48.2294921875 53.9924201965332 47.98928833007812 53.9924201965332 47.98928833007812 53.9924201965332 C 47.98928833007812 53.9924201965332 48.2294921875 53.9924201965332 48.65689086914062 53.9924201965332 L 62.29214477539062 53.99241638183594 C 63.1807861328125 53.99241638183594 64.62149047851562 53.99241638183594 65.51007080078125 53.99241638183594 C 66.39871215820312 53.99241638183594 66.39871215820312 53.99241638183594 65.51007080078125 53.99241638183594 L 55.75177001953125 53.9924201965332 L 95.71670532226562 53.9924201965332 C 96.97183227539062 53.9924201965332 97.98928833007812 53.9924201965332 97.98928833007812 53.9924201965332 C 97.98928833007812 53.9924201965332 96.97183227539062 53.9924201965332 95.71670532226562 53.9924201965332 L 55.75177001953125 53.9924201965332 L 65.51007080078125 53.99242401123047 C 66.39871215820312 53.99242401123047 66.39871215820312 53.99242401123047 65.51007080078125 53.99242401123047 C 64.62149047851562 53.99242401123047 63.1807861328125 53.99242401123047 62.29220581054688 53.99242401123047 L 48.65689086914062 53.9924201965332 Z" fill="#fafafa" stroke="none" stroke-width="12" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
