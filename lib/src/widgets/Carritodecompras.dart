import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './Settings.dart';
import './DetallesdelProducto.dart';
import './Elejirmetododepagoparacomprar.dart';
import './DirecciondeEnvio.dart';
import './Pedidos.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Carritodecompras extends StatelessWidget {
  Carritodecompras({
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
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 400.0,
              height: 743.0,
              child: SingleChildScrollView(
                primary: false,
                child: SizedBox(
                  width: 400.0,
                  height: 1324.0,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 52.0, 0.0, 0.0),
                        child: SingleChildScrollView(
                          primary: false,
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 20,
                            runSpacing: 20,
                            children: [{}].map((itemData) {
                              return SizedBox(
                                width: 400.0,
                                height: 1242.0,
                                child: Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 0.0, 0.0, 234.0),
                                      child: SingleChildScrollView(
                                        primary: false,
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          spacing: 20,
                                          runSpacing: 20,
                                          children: [{}, {}, {}, {}, {}]
                                              .map((itemData) {
                                            return SizedBox(
                                              width: 400.0,
                                              height: 182.0,
                                              child: Stack(
                                                children: <Widget>[
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xe3a0f4fe),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              9.0),
                                                      border: Border.all(
                                                          width: 1.0,
                                                          color: const Color(
                                                              0xe3000000)),
                                                    ),
                                                  ),
                                                  Transform.translate(
                                                    offset: Offset(191.0, 54.0),
                                                    child: SizedBox(
                                                      width: 382.0,
                                                      child: Text(
                                                        '',
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
                                                  Transform.translate(
                                                    offset: Offset(7.0, 20.0),
                                                    child: PageLink(
                                                      links: [
                                                        PageLinkInfo(
                                                          transition:
                                                              LinkTransition
                                                                  .Fade,
                                                          ease: Curves.easeOut,
                                                          duration: 0.3,
                                                          pageBuilder: () =>
                                                              DetallesdelProducto(key: Key('DetallesdelProducto'),),
                                                        ),
                                                      ],
                                                      child: Container(
                                                        width: 141.0,
                                                        height: 141.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                const AssetImage(
                                                                    'assets/images/shampoo.jpg'),
                                                            fit: BoxFit.fill,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      39.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Transform.translate(
                                                    offset: Offset(137.0, 73.0),
                                                    child: SizedBox(
                                                      width: 274.0,
                                                      child: Text(
                                                        '',
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
                                                  Transform.translate(
                                                    offset: Offset(191.0, 54.0),
                                                    child: SizedBox(
                                                      width: 382.0,
                                                      child: Text(
                                                        '',
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
                                                  Transform.translate(
                                                    offset:
                                                        Offset(162.5, 134.0),
                                                    child: SizedBox(
                                                      width: 325.0,
                                                      child: Text(
                                                        '',
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
                                                  Transform.translate(
                                                    offset:
                                                        Offset(213.0, 119.0),
                                                    child: Container(
                                                      width: 147.0,
                                                      height: 34.0,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xff4ec8dd),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: const Color(
                                                                0xff000000)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: const Color(
                                                                0xff080808),
                                                            offset:
                                                                Offset(0, 3),
                                                            blurRadius: 6,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Transform.translate(
                                                    offset:
                                                        Offset(124.5, 122.0),
                                                    child: SizedBox(
                                                      width: 325.0,
                                                      child: Text(
                                                        'Eliminar',
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
                                                  Transform.translate(
                                                    offset: Offset(194.0, 74.0),
                                                    child: Container(
                                                      width: 185.0,
                                                      height: 32.0,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: const Color(
                                                                0xff707070)),
                                                      ),
                                                    ),
                                                  ),
                                                  Transform.translate(
                                                    offset: Offset(101.5, 76.0),
                                                    child: SizedBox(
                                                      width: 371.0,
                                                      child: Text(
                                                        'Precio  \$ 17.761',
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
                                                  Transform.translate(
                                                    offset: Offset(194.0, 28.0),
                                                    child: Container(
                                                      width: 185.0,
                                                      height: 32.0,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: const Color(
                                                                0xff707070)),
                                                      ),
                                                    ),
                                                  ),
                                                  Transform.translate(
                                                    offset: Offset(100.0, 29.0),
                                                    child: SizedBox(
                                                      width: 284.0,
                                                      child: Text(
                                                        'Cantidad',
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
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    Pinned.fromPins(
                                      Pin(start: 42.0, end: 43.0),
                                      Pin(size: 50.0, end: 158.0),
                                      child: PageLink(
                                        links: [
                                          PageLinkInfo(
                                            transition: LinkTransition.Fade,
                                            ease: Curves.easeOut,
                                            duration: 0.3,
                                            pageBuilder: () =>
                                                Elejirmetododepagoparacomprar(key: Key('Elejirmetododepagoparacomprar'),),
                                          ),
                                        ],
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xff707070)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xff51b5e0),
                                                offset: Offset(0, 3),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Pinned.fromPins(
                                      Pin(size: 218.0, middle: 0.5),
                                      Pin(size: 28.0, end: 169.0),
                                      child: Text(
                                        'Elegir Método de Pago',
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
                                      Pin(start: 42.0, end: 43.0),
                                      Pin(size: 50.0, end: 79.0),
                                      child: PageLink(
                                        links: [
                                          PageLinkInfo(
                                            transition: LinkTransition.Fade,
                                            ease: Curves.easeOut,
                                            duration: 0.3,
                                            pageBuilder: () =>
                                                DirecciondeEnvio(key: Key('DirecciondeEnvio'),),
                                          ),
                                        ],
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xff707070)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xff51b5e0),
                                                offset: Offset(0, 3),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Pinned.fromPins(
                                      Pin(size: 178.0, middle: 0.491),
                                      Pin(size: 28.0, end: 90.0),
                                      child: Text(
                                        'Dirección de Envío',
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
                                      Pin(start: 43.0, end: 42.0),
                                      Pin(size: 50.0, end: 0.0),
                                      child: PageLink(
                                        links: [
                                          PageLinkInfo(
                                            transition: LinkTransition.Fade,
                                            ease: Curves.easeOut,
                                            duration: 0.3,
                                            pageBuilder: () => Pedidos(key: Key('Pedidos'),),
                                          ),
                                        ],
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xff707070)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xff51b5e0),
                                                offset: Offset(0, 3),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Pinned.fromPins(
                                      Pin(size: 80.0, middle: 0.5031),
                                      Pin(size: 28.0, end: 11.0),
                                      child: Text(
                                        'Comprar',
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
                      Pinned.fromPins(
                        Pin(start: 70.7, end: 70.7),
                        Pin(size: 35.0, start: 0.0),
                        child: SvgPicture.string(
                          _svg_ur00ga,
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 188.0, middle: 0.5189),
                        Pin(size: 28.0, start: 4.0),
                        child: Text(
                          'Carrito de Compras',
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_ur00ga =
    '<svg viewBox="70.7 0.0 258.6 35.0" ><path transform="translate(70.72, 0.0)" d="M 11.29102420806885 0 L 247.2734222412109 0 C 253.50927734375 0 258.564453125 4.477152347564697 258.564453125 10 L 258.564453125 25 C 258.564453125 30.52284812927246 253.50927734375 35 247.2734222412109 35 L 11.29102420806885 35 C 5.055163383483887 35 0 30.52284812927246 0 25 L 0 10 C 0 4.477152347564697 5.055163383483887 0 11.29102420806885 0 Z" fill="#a0f4fe" fill-opacity="0.89" stroke="#000000" stroke-width="1" stroke-opacity="0.89" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
