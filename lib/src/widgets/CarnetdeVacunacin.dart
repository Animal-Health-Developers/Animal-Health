import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './EditarPerfildeAnimalesdeCompaia.dart';
import './CrearVacuna.dart';
import './FuncionesdelaApp.dart';
import './Settings.dart';
import './ListadeAnimales.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CarnetdeVacunacin extends StatelessWidget {
  const CarnetdeVacunacin({
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
                image: const AssetImage('assets/BackGround.png'),
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
            Pin(start: 0.0, end: 0.5),
            Pin(size: 448.0, end: 118.0),
            child: SingleChildScrollView(
              primary: false,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 340.0,
                height: 448.0,
                child: Stack(
                  children: <Widget>[
                    Pinned.fromPins(
                      Pin(size: 42.0, end: -391.5),
                      Pin(size: 56.0, start: 0.0),
                      child: Text(
                        'Lote\n',
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
                      Pin(size: 63.0, end: -607.5),
                      Pin(size: 74.0, start: 27.0),
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
                      Pin(size: 63.0, end: -604.5),
                      Pin(size: 74.0, middle: 0.2567),
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
                      Pin(size: 63.0, end: -604.5),
                      Pin(size: 74.0, middle: 0.4251),
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
                      Pin(size: 63.0, end: -604.5),
                      Pin(size: 74.0, middle: 0.8021),
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
                      Pin(size: 63.0, end: -604.5),
                      Pin(size: 74.0, middle: 0.623),
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
                      Pin(size: 63.0, end: -604.5),
                      Pin(size: 74.0, end: 0.0),
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
                      Pin(size: 208.0, end: -689.5),
                      Pin(size: 28.0, start: 0.0),
                      child: Text(
                        'Firma del Veterinario',
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
                    image: const AssetImage(''),
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
                    image: const AssetImage(''),
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
                  pageBuilder: () => EditarPerfildeAnimalesdeCompaia(key: Key('EditarPerfildeAnimalesdeCompaia'),),
                ),
              ],
              child: Container(
                width: 90.0,
                height: 90.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage(''),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                  border:
                      Border.all(width: 1.0, color: const Color(0xff000000)),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 404.0,
              height: 611.0,
              child: SingleChildScrollView(
                primary: false,
                child: SizedBox(
                  width: 404.0,
                  height: 1955.0,
                  child: Stack(
                    children: <Widget>[
                      Pinned.fromPins(
                        Pin(start: 87.5, end: 87.5),
                        Pin(size: 35.0, start: 0.0),
                        child: SvgPicture.string(
                          _svg_e9s,
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 208.0, middle: 0.5),
                        Pin(size: 28.0, start: 3.5),
                        child: Text(
                          'Carnet de Vacunación',
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, -1344.0),
                        child: SingleChildScrollView(
                          primary: false,
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 20,
                            runSpacing: 20,
                            children: [{}].map((itemData) {
                              return SizedBox(
                                width: 404.0,
                                height: 1889.0,
                                child: Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 0.0, 0.0, 164.0),
                                      child: GridView.count(
                                        mainAxisSpacing: 20,
                                        crossAxisSpacing: 20,
                                        crossAxisCount: 1,
                                        childAspectRatio: 0.98,
                                        children:
                                            [{}, {}, {}, {}].map((itemData) {
                                          return Stack(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xe3a0f4fe),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: const Color(
                                                          0xe3000000)),
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(
                                                    size: 168.0,
                                                    middle: 0.5021),
                                                Pin(size: 28.0, start: 14.0),
                                                child: Text(
                                                  'Vacuna: Moquillo ',
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
                                              Pinned.fromPins(
                                                Pin(start: 19.0, end: 41.0),
                                                Pin(size: 28.0, start: 52.0),
                                                child: Text(
                                                  'Fecha de Vacunación: 05/03/2025 ',
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
                                              Pinned.fromPins(
                                                Pin(size: 278.0, end: 51.0),
                                                Pin(size: 28.0, middle: 0.2344),
                                                child: Text(
                                                  'Proxima Dósis: 05/06/2025 ',
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
                                              Pinned.fromPins(
                                                Pin(start: 31.0, end: 53.0),
                                                Pin(size: 28.0, middle: 0.3333),
                                                child: Text(
                                                  'Lote: 19271315XE 01/02/2025 ',
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
                                              Align(
                                                alignment:
                                                    Alignment(0.0, -0.135),
                                                child: SizedBox(
                                                  width: 194.0,
                                                  height: 28.0,
                                                  child: Text(
                                                    'Número de Dósis: 3',
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
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment(0.0, 0.063),
                                                child: SizedBox(
                                                  width: 282.0,
                                                  height: 28.0,
                                                  child: Text(
                                                    'Veterinario: Anderson Florez',
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
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 110.6, middle: 0.5),
                                                Pin(size: 120.0, end: 50.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image:
                                                          const AssetImage(''),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 80.0, middle: 0.5),
                                                Pin(size: 28.0, end: 17.0),
                                                child: Text(
                                                  'Aplicada',
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
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: SizedBox(
                                        width: 152.0,
                                        height: 149.0,
                                        child: Stack(
                                          children: <Widget>[
                                            Stack(
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
                                                            CrearVacuna(key: Key('CrearVacuna'),),
                                                      ),
                                                    ],
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image:
                                                              const AssetImage(
                                                                  ''),
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
                                              ],
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
                    image: const AssetImage('assets/settings.png'),
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

const String _svg_e9s =
    '<svg viewBox="87.5 0.0 229.0 35.0" ><path transform="translate(87.5, 0.0)" d="M 10 0 L 219 0 C 224.5228424072266 0 229 4.477152347564697 229 10 L 229 25 C 229 30.52284812927246 224.5228424072266 35 219 35 L 10 35 C 4.477152347564697 35 0 30.52284812927246 0 25 L 0 10 C 0 4.477152347564697 4.477152347564697 0 10 0 Z" fill="#a0f4fe" fill-opacity="0.89" stroke="#000000" stroke-width="1" stroke-opacity="0.89" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
