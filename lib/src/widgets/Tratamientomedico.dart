import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'Home.dart';
import 'package:adobe_xd/page_link.dart';
import 'Ayuda.dart';
import 'EditarPerfildeAnimalesdeCompaia.dart';
import 'FuncionesdelaApp.dart';
import 'Settings.dart';
import 'ListadeAnimales.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Tratamientomedico extends StatelessWidget {
  const Tratamientomedico({
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
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(44.0),
                border: Border.all(width: 1.0, color: const Color(0xff070707)),
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
                  duration: 1,
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
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 404.0,
              height: 601.0,
              child: SingleChildScrollView(
                primary: false,
                child: SizedBox(
                  width: 404.0,
                  height: 1126.0,
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
                        padding: EdgeInsets.fromLTRB(0.0, 63.0, 0.0, -525.0),
                        child: SingleChildScrollView(
                          primary: false,
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 20,
                            runSpacing: 20,
                            children: [{}, {}, {}].map((itemData) {
                              return SizedBox(
                                width: 404.0,
                                height: 335.0,
                                child: Stack(
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
                                        borderRadius:
                                            BorderRadius.circular(20.0),
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
                                            image: const AssetImage(''),
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
                                            image: const AssetImage(''),
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

const String _svg_a7p9a8 =
    '<svg viewBox="150.6 225.5 1.0 1.0" ><path transform="translate(0.0, -105.0)" d="M 150.5888214111328 330.5046081542969" fill="none" stroke="#4ec8dd" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_i3j02g =
    '<svg viewBox="-7.5 128.0 50.0 1.0" ><path transform="translate(-55.49, 74.01)" d="M 48.65689086914062 53.9924201965332 C 48.2294921875 53.9924201965332 47.98928833007812 53.9924201965332 47.98928833007812 53.9924201965332 C 47.98928833007812 53.9924201965332 48.2294921875 53.9924201965332 48.65689086914062 53.9924201965332 L 62.29214477539062 53.99241638183594 C 63.1807861328125 53.99241638183594 64.62149047851562 53.99241638183594 65.51007080078125 53.99241638183594 C 66.39871215820312 53.99241638183594 66.39871215820312 53.99241638183594 65.51007080078125 53.99241638183594 L 55.75177001953125 53.9924201965332 L 95.71670532226562 53.9924201965332 C 96.97183227539062 53.9924201965332 97.98928833007812 53.9924201965332 97.98928833007812 53.9924201965332 C 97.98928833007812 53.9924201965332 96.97183227539062 53.9924201965332 95.71670532226562 53.9924201965332 L 55.75177001953125 53.9924201965332 L 65.51007080078125 53.99242401123047 C 66.39871215820312 53.99242401123047 66.39871215820312 53.99242401123047 65.51007080078125 53.99242401123047 C 64.62149047851562 53.99242401123047 63.1807861328125 53.99242401123047 62.29220581054688 53.99242401123047 L 48.65689086914062 53.9924201965332 Z" fill="#fafafa" stroke="none" stroke-width="12" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
