import 'package:animal_health/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './Carritodecompras.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Pedidos extends StatelessWidget {
  const Pedidos({
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
            Pin(size: 412.0, middle: 0.5),
            Pin(size: 615.0, end: 38.0),
            child: SingleChildScrollView(
              primary: false,
              child: SizedBox(
                width: 412.0,
                height: 1020.0,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: SingleChildScrollView(
                        primary: false,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 20,
                          runSpacing: 101,
                          children: [{}].map((itemData) {
                            return SizedBox(
                              width: 412.0,
                              height: 921.0,
                              child: Stack(
                                children: <Widget>[
                                  Pinned.fromPins(
                                    Pin(start: 0.0, end: 0.0),
                                    Pin(size: 305.0, start: 0.0),
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
                                          Pin(size: 100.0, start: 26.0),
                                          Pin(size: 100.0, start: 12.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/shampoo.jpg'),
                                                fit: BoxFit.fill,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 185.0, middle: 0.5022),
                                          Pin(size: 36.0, end: 10.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(11.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff707070)),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 172.0, middle: 0.5),
                                          Pin(size: 28.0, end: 15.0),
                                          child: Text(
                                            'Total  \$ 500.000',
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
                                          Pin(size: 100.0, middle: 0.5),
                                          Pin(size: 100.0, start: 12.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/fancy.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 100.0, end: 26.0),
                                          Pin(size: 100.0, start: 12.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/probioticos.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 100.0, start: 26.0),
                                          Pin(size: 100.0, middle: 0.6927),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/camagato.png'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 100.0, end: 26.0),
                                          Pin(size: 100.0, middle: 0.6927),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/jabon.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(0.0, 0.385),
                                          child: Container(
                                            width: 100.0,
                                            height: 100.0,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/shampoo2.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 0.0, end: 0.0),
                                    Pin(size: 305.0, middle: 0.5),
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
                                          Pin(size: 100.0, start: 26.0),
                                          Pin(size: 100.0, start: 12.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/fancy.jpg'),
                                                fit: BoxFit.fill,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 185.0, middle: 0.5022),
                                          Pin(size: 36.0, end: 10.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(11.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff707070)),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 172.0, middle: 0.5),
                                          Pin(size: 28.0, end: 15.0),
                                          child: Text(
                                            'Total  \$ 500.000',
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
                                          Pin(size: 100.0, middle: 0.5),
                                          Pin(size: 100.0, start: 12.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/fancy.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 100.0, end: 26.0),
                                          Pin(size: 100.0, start: 12.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/camagato.png'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 100.0, start: 26.0),
                                          Pin(size: 100.0, middle: 0.6927),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/shampoo.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 100.0, end: 26.0),
                                          Pin(size: 100.0, middle: 0.6927),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/shampoo4.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(0.0, 0.385),
                                          child: Container(
                                            width: 100.0,
                                            height: 100.0,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/jabon.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 0.0, end: 0.0),
                                    Pin(size: 305.0, end: 0.0),
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
                                          Pin(size: 100.0, start: 26.0),
                                          Pin(size: 100.0, start: 12.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/jabon.jpg'),
                                                fit: BoxFit.fill,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 185.0, middle: 0.5022),
                                          Pin(size: 36.0, end: 10.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(11.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff707070)),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 172.0, middle: 0.5),
                                          Pin(size: 28.0, end: 15.0),
                                          child: Text(
                                            'Total  \$ 500.000',
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
                                          Pin(size: 100.0, middle: 0.5),
                                          Pin(size: 100.0, start: 12.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/jabon.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 100.0, end: 26.0),
                                          Pin(size: 100.0, start: 12.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/camagato.png'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 100.0, start: 26.0),
                                          Pin(size: 100.0, middle: 0.6927),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/camagato.png'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 100.0, end: 26.0),
                                          Pin(size: 100.0, middle: 0.6927),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/camagato.png'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(0.0, 0.385),
                                          child: Container(
                                            width: 100.0,
                                            height: 100.0,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/camagato.png'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
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
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 76.7, end: 76.7),
            Pin(size: 35.0, middle: 0.2252),
            child: SvgPicture.string(
              _svg_uw9156,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment(0.045, -0.544),
            child: SizedBox(
              width: 190.0,
              height: 28.0,
              child: Text(
                'Ordenes de Compra',
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
          Pinned.fromPins(
            Pin(size: 47.2, middle: 0.6987),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Carritodecompras(key: Key('Carritodecompras'),),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/carrito.png'),
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

const String _svg_i3j02g =
    '<svg viewBox="-7.5 128.0 50.0 1.0" ><path transform="translate(-55.49, 74.01)" d="M 48.65689086914062 53.9924201965332 C 48.2294921875 53.9924201965332 47.98928833007812 53.9924201965332 47.98928833007812 53.9924201965332 C 47.98928833007812 53.9924201965332 48.2294921875 53.9924201965332 48.65689086914062 53.9924201965332 L 62.29214477539062 53.99241638183594 C 63.1807861328125 53.99241638183594 64.62149047851562 53.99241638183594 65.51007080078125 53.99241638183594 C 66.39871215820312 53.99241638183594 66.39871215820312 53.99241638183594 65.51007080078125 53.99241638183594 L 55.75177001953125 53.9924201965332 L 95.71670532226562 53.9924201965332 C 96.97183227539062 53.9924201965332 97.98928833007812 53.9924201965332 97.98928833007812 53.9924201965332 C 97.98928833007812 53.9924201965332 96.97183227539062 53.9924201965332 95.71670532226562 53.9924201965332 L 55.75177001953125 53.9924201965332 L 65.51007080078125 53.99242401123047 C 66.39871215820312 53.99242401123047 66.39871215820312 53.99242401123047 65.51007080078125 53.99242401123047 C 64.62149047851562 53.99242401123047 63.1807861328125 53.99242401123047 62.29220581054688 53.99242401123047 L 48.65689086914062 53.9924201965332 Z" fill="#fafafa" stroke="none" stroke-width="12" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_uw9156 =
    '<svg viewBox="76.7 193.0 258.6 35.0" ><path transform="translate(76.72, 193.0)" d="M 11.29102420806885 0 L 247.2734222412109 0 C 253.50927734375 0 258.564453125 4.477152347564697 258.564453125 10 L 258.564453125 25 C 258.564453125 30.52284812927246 253.50927734375 35 247.2734222412109 35 L 11.29102420806885 35 C 5.055163383483887 35 0 30.52284812927246 0 25 L 0 10 C 0 4.477152347564697 5.055163383483887 0 11.29102420806885 0 Z" fill="#a0f4fe" fill-opacity="0.89" stroke="#000000" stroke-width="1" stroke-opacity="0.89" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
