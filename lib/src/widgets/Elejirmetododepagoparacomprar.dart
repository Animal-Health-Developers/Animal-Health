import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './Settings.dart';
import './ListadeAnimales.dart';
import './Carritodecompras.dart';

class Elejirmetododepagoparacomprar extends StatelessWidget {
  const Elejirmetododepagoparacomprar({
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
            alignment: Alignment(-0.248, -0.57),
            child: SizedBox(
              width: 1.0,
              height: 1.0,
              child: SvgPicture.string(
                _svg_grwtv,
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
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 390.0,
              height: 706.0,
              child: SingleChildScrollView(
                primary: false,
                child: SizedBox(
                  width: 390.0,
                  height: 1125.0,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: SingleChildScrollView(
                          primary: false,
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 20,
                            runSpacing: 109,
                            children: [{}].map((itemData) {
                              return SizedBox(
                                width: 390.0,
                                height: 1016.0,
                                child: Stack(
                                  children: <Widget>[
                                    Pinned.fromPins(
                                      Pin(start: 0.0, end: 0.0),
                                      Pin(size: 476.0, start: 49.5),
                                      child: Stack(
                                        children: <Widget>[
                                          Pinned.fromPins(
                                            Pin(start: 0.0, end: 0.0),
                                            Pin(size: 110.0, start: 0.0),
                                            child: PageLink(
                                              links: [
                                                PageLinkInfo(),
                                              ],
                                              child: Container(
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
                                            ),
                                          ),
                                          Pinned.fromPins(
                                            Pin(size: 202.0, middle: 0.5),
                                            Pin(size: 84.0, start: 15.0),
                                            child: Text(
                                              'Tarjeda de credito\n**** **** **** 3090\nMasterCard',
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
                                            Pin(start: 0.0, end: 0.0),
                                            Pin(size: 110.0, middle: 0.3333),
                                            child: PageLink(
                                              links: [
                                                PageLinkInfo(),
                                              ],
                                              child: SvgPicture.string(
                                                _svg_x4ym1q,
                                                allowDrawingOutsideViewBox:
                                                    true,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment(0.0, -0.301),
                                            child: SizedBox(
                                              width: 202.0,
                                              height: 84.0,
                                              child: Text(
                                                'Tarjeda Debito\n**** **** **** 1317\nVisa',
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
                                          ),
                                          Pinned.fromPins(
                                            Pin(start: 0.0, end: 0.0),
                                            Pin(size: 110.0, middle: 0.6667),
                                            child: PageLink(
                                              links: [
                                                PageLinkInfo(),
                                              ],
                                              child: SvgPicture.string(
                                                _svg_dsf2,
                                                allowDrawingOutsideViewBox:
                                                    true,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Pinned.fromPins(
                                            Pin(start: 0.0, end: 0.0),
                                            Pin(size: 110.0, end: 0.0),
                                            child: PageLink(
                                              links: [
                                                PageLinkInfo(),
                                              ],
                                              child: SvgPicture.string(
                                                _svg_r2cav6,
                                                allowDrawingOutsideViewBox:
                                                    true,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment(0.0, 0.321),
                                            child: SizedBox(
                                              width: 202.0,
                                              height: 84.0,
                                              child: Text(
                                                'Tarjeda Debito\n**** **** **** 4057\nVisa',
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
                                          ),
                                          Pinned.fromPins(
                                            Pin(size: 202.0, middle: 0.5),
                                            Pin(size: 84.0, end: 11.0),
                                            child: Text(
                                              'Tarjeda de credito\n**** **** **** 5713\nVisa',
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
                                    Pinned.fromPins(
                                      Pin(start: 0.0, end: 0.0),
                                      Pin(size: 476.0, end: 0.0),
                                      child: Stack(
                                        children: <Widget>[
                                          Pinned.fromPins(
                                            Pin(start: 0.0, end: 0.0),
                                            Pin(size: 110.0, start: 0.0),
                                            child: PageLink(
                                              links: [
                                                PageLinkInfo(),
                                              ],
                                              child: Container(
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
                                            ),
                                          ),
                                          Pinned.fromPins(
                                            Pin(size: 202.0, middle: 0.5),
                                            Pin(size: 84.0, start: 15.0),
                                            child: Text(
                                              'Tarjeda de credito\n**** **** **** 3090\nMasterCard',
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
                                            Pin(start: 0.0, end: 0.0),
                                            Pin(size: 110.0, middle: 0.3333),
                                            child: PageLink(
                                              links: [
                                                PageLinkInfo(),
                                              ],
                                              child: SvgPicture.string(
                                                _svg_x4ym1q,
                                                allowDrawingOutsideViewBox:
                                                    true,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment(0.0, -0.301),
                                            child: SizedBox(
                                              width: 202.0,
                                              height: 84.0,
                                              child: Text(
                                                'Tarjeda Debito\n**** **** **** 1317\nVisa',
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
                                          ),
                                          Pinned.fromPins(
                                            Pin(start: 0.0, end: 0.0),
                                            Pin(size: 110.0, middle: 0.6667),
                                            child: PageLink(
                                              links: [
                                                PageLinkInfo(),
                                              ],
                                              child: SvgPicture.string(
                                                _svg_dsf2,
                                                allowDrawingOutsideViewBox:
                                                    true,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Pinned.fromPins(
                                            Pin(start: 0.0, end: 0.0),
                                            Pin(size: 110.0, end: 0.0),
                                            child: PageLink(
                                              links: [
                                                PageLinkInfo(),
                                              ],
                                              child: SvgPicture.string(
                                                _svg_r2cav6,
                                                allowDrawingOutsideViewBox:
                                                    true,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment(0.0, 0.321),
                                            child: SizedBox(
                                              width: 202.0,
                                              height: 84.0,
                                              child: Text(
                                                'Tarjeda Debito\n**** **** **** 4057\nVisa',
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
                                          ),
                                          Pinned.fromPins(
                                            Pin(size: 202.0, middle: 0.5),
                                            Pin(size: 84.0, end: 11.0),
                                            child: Text(
                                              'Tarjeda de credito\n**** **** **** 5713\nVisa',
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
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        width: 183.0,
                                        height: 35.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xe3a0f4fe),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                              width: 1.0,
                                              color: const Color(0xe3000000)),
                                        ),
                                      ),
                                    ),
                                    Pinned.fromPins(
                                      Pin(size: 164.0, middle: 0.5),
                                      Pin(size: 28.0, start: 3.5),
                                      child: Text(
                                        'Métodos de pago',
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

const String _svg_x4ym1q =
    '<svg viewBox="11.0 385.0 390.0 110.0" ><path transform="translate(11.0, 385.0)" d="M 15 0 L 375 0 C 383.2842712402344 0 390 6.715728759765625 390 15 L 390 95 C 390 103.2842712402344 383.2842712402344 110 375 110 L 15 110 C 6.715728759765625 110 0 103.2842712402344 0 95 L 0 15 C 0 6.715728759765625 6.715728759765625 0 15 0 Z" fill="#a0f4fe" fill-opacity="0.89" stroke="#000000" stroke-width="1" stroke-opacity="0.89" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_dsf2 =
    '<svg viewBox="11.0 507.0 390.0 110.0" ><path transform="translate(11.0, 507.0)" d="M 15 0 L 375 0 C 383.2842712402344 0 390 6.715728759765625 390 15 L 390 95 C 390 103.2842712402344 383.2842712402344 110 375 110 L 15 110 C 6.715728759765625 110 0 103.2842712402344 0 95 L 0 15 C 0 6.715728759765625 6.715728759765625 0 15 0 Z" fill="#a0f4fe" fill-opacity="0.89" stroke="#000000" stroke-width="1" stroke-opacity="0.89" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_r2cav6 =
    '<svg viewBox="11.0 629.0 390.0 110.0" ><path transform="translate(11.0, 629.0)" d="M 15 0 C 15 0 217.0964660644531 0 307.0964660644531 0 C 397.0964660644531 0 375 0 375 0 C 383.2842712402344 0 390 6.715728759765625 390 15 L 390 95 C 390 103.2842712402344 383.2842712402344 110 375 110 L 15 110 C 6.715728759765625 110 0 103.2842712402344 0 95 L 0 15 C 0 6.715728759765625 6.715728759765625 0 15 0 Z" fill="#a0f4fe" fill-opacity="0.89" stroke="#000000" stroke-width="1" stroke-opacity="0.89" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_grwtv =
    '<svg viewBox="154.6 191.5 1.0 1.0" ><path transform="translate(4.0, -139.0)" d="M 150.5888214111328 330.5046081542969" fill="none" stroke="#4ec8dd" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
