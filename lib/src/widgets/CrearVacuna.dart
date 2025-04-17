import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './PerfilPublico.dart';
import './Ayuda.dart';
import './Settings.dart';
import './ListadeAnimales.dart';
import './CarnetdeVacunacin.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './EditarPerfildeAnimalesdeCompaia.dart';
import './FuncionesdelaApp.dart';

class CrearVacuna extends StatelessWidget {
  CrearVacuna({
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
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 392.0,
              height: 611.0,
              child: SingleChildScrollView(
                primary: false,
                child: SizedBox(
                  width: 392.0,
                  height: 711.0,
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
                                width: 392.0,
                                height: 691.0,
                                child: Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 0.0, 0.0, 173.0),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0x8754d1e0),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0x87000000)),
                                            ),
                                            margin: EdgeInsets.fromLTRB(
                                                0.0, 57.0, 0.0, 0.0),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0x8754d1e0),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0x87000000)),
                                            ),
                                            margin: EdgeInsets.fromLTRB(
                                                3.0, 61.0, 4.0, 5.0),
                                          ),
                                          Pinned.fromPins(
                                            Pin(start: 39.0, end: 38.0),
                                            Pin(size: 45.0, middle: 0.203),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xffffffff),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: const Color(
                                                        0xff000000)),
                                              ),
                                            ),
                                          ),
                                          Pinned.fromPins(
                                            Pin(size: 75.0, start: 44.0),
                                            Pin(size: 28.0, start: 68.0),
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
                                            Pin(start: 81.5, end: 81.5),
                                            Pin(size: 35.0, start: 0.0),
                                            child: SvgPicture.string(
                                              _svg_eq66i,
                                              allowDrawingOutsideViewBox: true,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Pinned.fromPins(
                                            Pin(size: 152.0, middle: 0.5),
                                            Pin(size: 28.0, start: 3.5),
                                            child: Text(
                                              'Agregar Vacuna',
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
                                            Pin(start: 39.0, end: 38.0),
                                            Pin(size: 45.0, middle: 0.3573),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xffffffff),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: const Color(
                                                        0xff000000)),
                                              ),
                                            ),
                                          ),
                                          Pinned.fromPins(
                                            Pin(size: 169.0, start: 44.0),
                                            Pin(size: 28.0, middle: 0.2878),
                                            child: Text(
                                              'Fecha Vacunación',
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
                                            Pin(start: 39.0, end: 38.0),
                                            Pin(size: 45.0, middle: 0.5116),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xffffffff),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: const Color(
                                                        0xff000000)),
                                              ),
                                            ),
                                          ),
                                          Pinned.fromPins(
                                            Pin(size: 134.0, start: 44.0),
                                            Pin(size: 28.0, middle: 0.4367),
                                            child: Text(
                                              'Proxima Dósis',
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
                                            Pin(start: 39.0, end: 38.0),
                                            Pin(size: 45.0, middle: 0.666),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xffffffff),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: const Color(
                                                        0xff000000)),
                                              ),
                                            ),
                                          ),
                                          Pinned.fromPins(
                                            Pin(size: 42.0, start: 44.0),
                                            Pin(size: 28.0, middle: 0.5857),
                                            child: Text(
                                              'Lote',
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
                                            Pin(start: 39.0, end: 38.0),
                                            Pin(size: 45.0, middle: 0.8203),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xffffffff),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: const Color(
                                                        0xff000000)),
                                              ),
                                            ),
                                          ),
                                          Pinned.fromPins(
                                            Pin(size: 164.0, start: 44.0),
                                            Pin(size: 28.0, middle: 0.7347),
                                            child: Text(
                                              'Número de Dósis',
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
                                            Pin(start: 39.0, end: 38.0),
                                            Pin(size: 45.0, end: 13.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xffffffff),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: const Color(
                                                        0xff000000)),
                                              ),
                                            ),
                                          ),
                                          Pinned.fromPins(
                                            Pin(size: 108.0, start: 44.0),
                                            Pin(size: 28.0, end: 58.0),
                                            child: Text(
                                              'Veterinario',
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
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: SizedBox(
                                        width: 152.0,
                                        height: 149.0,
                                        child: Stack(
                                          children: <Widget>[
                                            Pinned.fromPins(
                                              Pin(start: 12.6, end: 12.6),
                                              Pin(size: 120.0, start: 0.0),
                                              child: PageLink(
                                                links: [
                                                  PageLinkInfo(
                                                    transition:
                                                        LinkTransition.Fade,
                                                    ease: Curves.easeOut,
                                                    duration: 0.3,
                                                    pageBuilder: () =>
                                                        CarnetdeVacunacin(key: Key('CarnetdeVacunacin'),),//ICONO AGREGAR VACUNA
                                                  ),
                                                ],
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image:
                                                          const AssetImage('assets/images/agregarvacuna.png'),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Pinned.fromPins(
                                              Pin(start: 0.0, end: 0.0),
                                              Pin(size: 28.0, end: 0.0),
                                              child: Text(
                                                'Agregar Vacuna',
                                                style: TextStyle(
                                                  fontFamily: 'Comic Sans MS',
                                                  fontSize: 20,
                                                  color:
                                                      const Color(0xff000000),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.center,
                                                softWrap: false,
                                              ),
                                            ),
                                          ],
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
            alignment: Alignment(0.0, -0.549),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => EditarPerfildeAnimalesdeCompaia(key: Key('EditarPerfildeAnimalesdeCompaia'),),//FOTO DE PERFIL DE ANIMALES
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
                  border:
                      Border.all(width: 1.0, color: const Color(0xff000000)),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 62.7, start: 6.7),
            Pin(size: 70.0, middle: 0.2324),
            child: PageLink(
              links: [
                PageLinkInfo(
                  duration: 0.3,
                  pageBuilder: () => FuncionesdelaApp(key: Key('FuncionesdelaApp'),),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/funciones.png'),
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

const String _svg_eq66i =
    '<svg viewBox="91.5 281.0 229.0 35.0" ><path transform="translate(91.5, 281.0)" d="M 10 0 L 219 0 C 224.5228424072266 0 229 4.477152347564697 229 10 L 229 25 C 229 30.52284812927246 224.5228424072266 35 219 35 L 10 35 C 4.477152347564697 35 0 30.52284812927246 0 25 L 0 10 C 0 4.477152347564697 4.477152347564697 0 10 0 Z" fill="#a0f4fe" fill-opacity="0.89" stroke="#000000" stroke-width="1" stroke-opacity="0.89" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
