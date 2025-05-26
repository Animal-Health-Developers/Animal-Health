import 'package:animal_health/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './EditarPerfildeAnimal.dart';
import './FuncionesdelaApp.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Tratamientomedico extends StatelessWidget {
  const Tratamientomedico({
    required Key key, required String animalId,
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
            Pin(size: 62.7, start: 6.7),
            Pin(size: 70.0, middle: 0.2324),
            child: PageLink(
              links: [
                PageLinkInfo(
                  duration: 0.3,
                  pageBuilder: () => FuncionesdelaApp(key: Key('FuncionesdelaApp'), animalId: '',),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 404.0,
              height: 601.0,
              child: SingleChildScrollView(
                primary: false,
                child: SizedBox(
                  width: 404.0,
                  height: 1483.0,
                  child: Stack(
                    children: <Widget>[
                      Pinned.fromPins(
                        Pin(start: 88.0, end: 87.0),
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
                        Pin(size: 194.0, middle: 0.4905),
                        Pin(size: 28.0, start: 4.0),
                        child: Text(
                          'Tratamiento Médico',
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
                        padding: EdgeInsets.fromLTRB(0.0, 63.0, 0.0, 0.0),
                        child: GridView.count(
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          crossAxisCount: 1,
                          childAspectRatio: 1.21,
                          children: [{}, {}, {}, {}].map((itemData) {
                            return Stack(
                              children: <Widget>[
                                Pinned.fromPins(
                                  Pin(size: 0.0, end: 7.0),
                                  Pin(size: 0.0, middle: 0.7821),
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 20,
                                      color: const Color(0xff000000),
                                    ),
                                    softWrap: false,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xe3a0f4fe),
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                        width: 1.0,
                                        color: const Color(0xe3000000)),
                                  ),
                                ),
                                Pinned.fromPins(
                                  Pin(size: 252.0, middle: 0.5),
                                  Pin(size: 28.0, start: 8.0),
                                  child: Text(
                                    'Medicamento: Cefalexina ',
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
                                  Pin(size: 262.0, middle: 0.5),
                                  Pin(size: 28.0, start: 46.0),
                                  child: Text(
                                    'Dósis: 30mL cada 8 horas ',
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
                                  Pin(start: 31.0, end: 31.0),
                                  Pin(size: 28.0, middle: 0.2736),
                                  child: Text(
                                    'tiempo de tratamiento: 1 semana  ',
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
                                Align(
                                  alignment: Alignment(0.0, -0.205),
                                  child: SizedBox(
                                    width: 252.0,
                                    height: 28.0,
                                    child: Text(
                                      'Medicamento: Cefalexina ',
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
                                  Pin(size: 120.5, start: 34.0),
                                  Pin(size: 120.0, middle: 0.7628),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: const AssetImage('assets/images/recordatorio.png'),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                Pinned.fromPins(
                                  Pin(size: 110.4, end: 45.0),
                                  Pin(size: 120.0, middle: 0.7628),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: const AssetImage('assets/images/suministrado.png'),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                Pinned.fromPins(
                                  Pin(size: 134.0, start: 27.0),
                                  Pin(size: 28.0, end: 13.0),
                                  child: Text(
                                    ' Redordatorio',
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
                                  Pin(size: 132.0, end: 34.0),
                                  Pin(size: 28.0, end: 13.0),
                                  child: Text(
                                    ' Suministrado',
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
                            );
                          }).toList(),
                        ),
                      ),
                    ],
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
