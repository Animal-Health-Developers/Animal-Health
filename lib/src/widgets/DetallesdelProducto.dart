import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './Carritodecompras.dart';
import './ComprarAhora.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './Settings.dart';
import './ListadeAnimales.dart';

class DetallesdelProducto extends StatelessWidget {
  const DetallesdelProducto({
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
          Pinned.fromPins(
            Pin(start: 53.0, end: 52.0),
            Pin(size: 45.0, middle: 0.2149),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(5.0),
                    border:
                        Border.all(width: 1.0, color: const Color(0xff707070)),
                  ),
                ),
                Pinned.fromPins(
                  Pin(start: 44.0, end: 37.0),
                  Pin(size: 28.0, middle: 0.4118),
                  child: Text(
                    '¿Qué Producto Buscas?',
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
                  Pin(size: 31.0, start: 5.0),
                  Pin(start: 7.0, end: 7.0),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage(''),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
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
                    image: const AssetImage(''),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 415.0, middle: 0.0),
            Pin(start: 234.0, end: -0.3),
            child: SingleChildScrollView(
              primary: false,
              child: SizedBox(
                width: 415.0,
                height: 889.0,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, -231.0),
                      child: SingleChildScrollView(
                        primary: false,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 5,
                          runSpacing: 20,
                          children: [{}].map((itemData) {
                            return SizedBox(
                              width: 429.0,
                              height: 869.0,
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment(-0.107, -0.298),
                                    child: Container(
                                      width: 270.0,
                                      height: 134.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xe3ffffff),
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        border: Border.all(
                                            width: 1.0,
                                            color: const Color(0xe3707070)),
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 0.0, end: 17.0),
                                    Pin(size: 250.0, start: 0.0),
                                    child: SingleChildScrollView(
                                      primary: false,
                                      scrollDirection: Axis.horizontal,
                                      child: SizedBox(
                                        width: 1332.0,
                                        height: 250.0,
                                        child: Stack(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0.0, 0.0, -920.0, 0.0),
                                              child: SingleChildScrollView(
                                                primary: false,
                                                child: Wrap(
                                                  alignment:
                                                      WrapAlignment.center,
                                                  spacing: 84,
                                                  runSpacing: 20,
                                                  children: [{}, {}, {}, {}]
                                                      .map((itemData) {
                                                    return SizedBox(
                                                      width: 250.0,
                                                      height: 250.0,
                                                      child: Stack(
                                                        children: <Widget>[
                                                          Pinned.fromPins(
                                                            Pin(
                                                                end: 0.0,
                                                                startFraction:
                                                                    0.0),
                                                            Pin(
                                                                size: 250.0,
                                                                middle: 0.5),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      const AssetImage(
                                                                          ''),
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16.0),
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
                                  Pinned.fromPins(
                                    Pin(size: 0.0, end: 31.0),
                                    Pin(size: 0.0, start: 155.0),
                                    child: Text(
                                      '',
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
                                    Pin(start: 0.0, end: 17.0),
                                    Pin(size: 98.0, middle: 0.5121),
                                    child: SvgPicture.string(
                                      _svg_ufi7jy,
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 170.0, start: 9.0),
                                    Pin(size: 19.0, middle: 0.4786),
                                    child: Text(
                                      'Información del Producto:',
                                      style: TextStyle(
                                        fontFamily: 'Comic Sans MS',
                                        fontSize: 14,
                                        color: const Color(0xff000000),
                                      ),
                                      textAlign: TextAlign.center,
                                      softWrap: false,
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 8.0, end: 31.0),
                                    Pin(size: 38.0, middle: 0.5124),
                                    child: Text(
                                      'Shampoo para perros y gatos marca Petys, anti fúngico y anti bacterial, con un olor agradable a arbol de Té verde',
                                      style: TextStyle(
                                        fontFamily: 'Comic Sans MS',
                                        fontSize: 14,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 0.0, end: 17.0),
                                    Pin(size: 67.0, middle: 0.6257),
                                    child: SvgPicture.string(
                                      _svg_kxoidv,
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 126.0, start: 7.0),
                                    Pin(size: 28.0, middle: 0.6193),
                                    child: Text(
                                      ' Calificación ',
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
                                    alignment: Alignment(-0.309, 0.24),
                                    child: SizedBox(
                                      width: 30.0,
                                      height: 30.0,
                                      child: SvgPicture.string(
                                        _svg_g0shyf,
                                        allowDrawingOutsideViewBox: true,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(-0.049, 0.24),
                                    child: SizedBox(
                                      width: 30.0,
                                      height: 30.0,
                                      child: SvgPicture.string(
                                        _svg_ep59o,
                                        allowDrawingOutsideViewBox: true,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0.211, 0.24),
                                    child: SizedBox(
                                      width: 30.0,
                                      height: 30.0,
                                      child: SvgPicture.string(
                                        _svg_xxeqcl,
                                        allowDrawingOutsideViewBox: true,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0.471, 0.24),
                                    child: SizedBox(
                                      width: 30.0,
                                      height: 30.0,
                                      child: SvgPicture.string(
                                        _svg_tyr51w,
                                        allowDrawingOutsideViewBox: true,
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 30.0, end: 53.8),
                                    Pin(size: 30.0, middle: 0.6202),
                                    child: SvgPicture.string(
                                      _svg_a3rdgm,
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(-0.52, -0.149),
                                    child: SizedBox(
                                      width: 0.0,
                                      height: 0.0,
                                      child: Text(
                                        '',
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
                                    Pin(start: 3.0, end: 14.0),
                                    Pin(size: 249.3, end: 0.0),
                                    child: SvgPicture.string(
                                      _svg_rb06jz,
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 12.0, end: 41.0),
                                    Pin(size: 56.0, middle: 0.7746),
                                    child: Text(
                                      'Andrés Mendoza: Excelente producto,\ncuida la salud de la piel de mi perrita ',
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
                                    Pin(size: 125.0, start: 5.0),
                                    Pin(size: 35.0, middle: 0.694),
                                    child: Container(
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
                                    Pin(size: 90.0, start: 23.0),
                                    Pin(size: 28.0, middle: 0.693),
                                    child: Text(
                                      'Opiniones',
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
                                    Pin(start: 11.0, end: 0.0),
                                    Pin(size: 84.0, end: 83.3),
                                    child: Text(
                                      'Anderson Florez: Tiene un olor delicioso y \nduradero, además protege la piel de mi \nperrita kitty de hongos y bacterias.',
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
                                    alignment: Alignment(-0.075, -0.168),
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
                                        width: 215.0,
                                        height: 38.0,
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
                                  Align(
                                    alignment: Alignment(0.058, -0.166),
                                    child: SizedBox(
                                      width: 178.0,
                                      height: 28.0,
                                      child: Text(
                                        'Agregar al carrito',
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
                                  Align(
                                    alignment: Alignment(-0.075, -0.271),
                                    child: PageLink(
                                      links: [
                                        PageLinkInfo(
                                          transition: LinkTransition.Fade,
                                          ease: Curves.easeOut,
                                          duration: 0.3,
                                          pageBuilder: () => ComprarAhora(key: Key('ComprarAhora'),),
                                        ),
                                      ],
                                      child: Container(
                                        width: 215.0,
                                        height: 38.0,
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
                                  Align(
                                    alignment: Alignment(-0.081, -0.268),
                                    child: SizedBox(
                                      width: 146.0,
                                      height: 28.0,
                                      child: Text(
                                        'Comprar Ahora',
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
                                  Align(
                                    alignment: Alignment(-0.066, -0.369),
                                    child: Container(
                                      width: 185.0,
                                      height: 36.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffffffff),
                                        borderRadius:
                                            BorderRadius.circular(11.0),
                                        border: Border.all(
                                            width: 1.0,
                                            color: const Color(0xff707070)),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(-0.065, -0.368),
                                    child: SizedBox(
                                      width: 168.0,
                                      height: 28.0,
                                      child: Text(
                                        'Precio  \$ 17.761',
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
                                  Align(
                                    alignment: Alignment(-0.476, -0.167),
                                    child: Container(
                                      width: 33.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: const AssetImage(''),
                                          fit: BoxFit.fill,
                                        ),
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

const String _svg_ufi7jy =
    '<svg viewBox="0.0 629.0 412.0 98.0" ><path transform="translate(0.0, 629.0)" d="M 9 0 L 403 0 C 407.9705505371094 0 412 4.029437065124512 412 9 L 412 89 C 412 93.97056579589844 407.9705505371094 98 403 98 L 9 98 C 4.029437065124512 98 0 93.97056579589844 0 89 L 0 9 C 0 4.029437065124512 4.029437065124512 0 9 0 Z" fill="#ffffff" fill-opacity="0.83" stroke="#54d1e0" stroke-width="7" stroke-opacity="0.83" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_kxoidv =
    '<svg viewBox="0.0 736.0 412.0 67.0" ><path transform="translate(0.0, 736.0)" d="M 11 0 L 401 0 C 407.0751342773438 0 412 4.924867630004883 412 11 L 412 56 C 412 62.07513427734375 407.0751342773438 67 401 67 L 11 67 C 4.924867630004883 67 0 62.07513427734375 0 56 L 0 11 C 0 4.924867630004883 4.924867630004883 0 11 0 Z" fill="#ffffff" fill-opacity="0.83" stroke="#54d1e0" stroke-width="7" stroke-opacity="0.83" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_g0shyf =
    '<svg viewBox="137.8 754.5 30.0 30.0" ><path transform="translate(134.85, 751.5)" d="M 16.61100006103516 3.94950008392334 C 17.09099960327148 2.683500051498413 18.90749931335449 2.683500051498413 19.38899993896484 3.94950008392334 L 22.49399948120117 12.55049991607666 C 22.71574592590332 13.12406158447266 23.26806449890137 13.50161933898926 23.88299751281738 13.50000095367432 L 31.51350021362305 13.5 C 32.92350006103516 13.5 33.53850173950195 15.25500011444092 32.43000030517578 16.11450004577637 L 27 21 C 26.50099945068359 21.38360595703125 26.30596542358398 22.04502487182617 26.51700019836426 22.63800048828125 L 28.5 31.04249954223633 C 28.98299980163574 32.39249801635742 27.42000007629395 33.55199813842773 26.23799896240234 32.72100067138672 L 18.86249923706055 28.04100036621094 C 18.34500885009766 27.67730712890625 17.65498924255371 27.67730712890625 17.13749885559082 28.04100036621094 L 9.761999130249023 32.72100067138672 C 8.581499099731445 33.552001953125 7.016999244689941 32.39099884033203 7.499999046325684 31.04250144958496 L 9.482998847961426 22.63800048828125 C 9.694033622741699 22.04502487182617 9.499000549316406 21.38360595703125 9 21 L 3.570000171661377 16.11450004577637 C 2.460000038146973 15.25500011444092 3.078000068664551 13.5 4.485000133514404 13.5 L 12.11549949645996 13.5 C 12.73056507110596 13.50204849243164 13.28310298919678 13.12434196472168 13.50450038909912 12.55050086975098 L 16.60949897766113 3.94950008392334 Z" fill="none" stroke="#000000" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /></svg>';
const String _svg_ep59o =
    '<svg viewBox="189.7 754.5 30.0 30.0" ><path transform="translate(186.69, 751.5)" d="M 16.61100006103516 3.94950008392334 C 17.09099960327148 2.683500051498413 18.90749931335449 2.683500051498413 19.38899993896484 3.94950008392334 L 22.49399948120117 12.55049991607666 C 22.71574592590332 13.12406158447266 23.26806449890137 13.50161933898926 23.88299751281738 13.50000095367432 L 31.51350021362305 13.5 C 32.92350006103516 13.5 33.53850173950195 15.25500011444092 32.43000030517578 16.11450004577637 L 27 21 C 26.50099945068359 21.38360595703125 26.30596542358398 22.04502487182617 26.51700019836426 22.63800048828125 L 28.5 31.04249954223633 C 28.98299980163574 32.39249801635742 27.42000007629395 33.55199813842773 26.23799896240234 32.72100067138672 L 18.86249923706055 28.04100036621094 C 18.34500885009766 27.67730712890625 17.65498924255371 27.67730712890625 17.13749885559082 28.04100036621094 L 9.761999130249023 32.72100067138672 C 8.581499099731445 33.552001953125 7.016999244689941 32.39099884033203 7.499999046325684 31.04250144958496 L 9.482998847961426 22.63800048828125 C 9.694033622741699 22.04502487182617 9.499000549316406 21.38360595703125 9 21 L 3.570000171661377 16.11450004577637 C 2.460000038146973 15.25500011444092 3.078000068664551 13.5 4.485000133514404 13.5 L 12.11549949645996 13.5 C 12.73056507110596 13.50204849243164 13.28310298919678 13.12434196472168 13.50450038909912 12.55050086975098 L 16.60949897766113 3.94950008392334 Z" fill="none" stroke="#000000" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /></svg>';
const String _svg_xxeqcl =
    '<svg viewBox="241.5 754.5 30.0 30.0" ><path transform="translate(238.54, 751.5)" d="M 16.61100006103516 3.94950008392334 C 17.09099960327148 2.683500051498413 18.90749931335449 2.683500051498413 19.38899993896484 3.94950008392334 L 22.49399948120117 12.55049991607666 C 22.71574592590332 13.12406158447266 23.26806449890137 13.50161933898926 23.88299751281738 13.50000095367432 L 31.51350021362305 13.5 C 32.92350006103516 13.5 33.53850173950195 15.25500011444092 32.43000030517578 16.11450004577637 L 27 21 C 26.50099945068359 21.38360595703125 26.30596542358398 22.04502487182617 26.51700019836426 22.63800048828125 L 28.5 31.04249954223633 C 28.98299980163574 32.39249801635742 27.42000007629395 33.55199813842773 26.23799896240234 32.72100067138672 L 18.86249923706055 28.04100036621094 C 18.34500885009766 27.67730712890625 17.65498924255371 27.67730712890625 17.13749885559082 28.04100036621094 L 9.761999130249023 32.72100067138672 C 8.581499099731445 33.552001953125 7.016999244689941 32.39099884033203 7.499999046325684 31.04250144958496 L 9.482998847961426 22.63800048828125 C 9.694033622741699 22.04502487182617 9.499000549316406 21.38360595703125 9 21 L 3.570000171661377 16.11450004577637 C 2.460000038146973 15.25500011444092 3.078000068664551 13.5 4.485000133514404 13.5 L 12.11549949645996 13.5 C 12.73056507110596 13.50204849243164 13.28310298919678 13.12434196472168 13.50450038909912 12.55050086975098 L 16.60949897766113 3.94950008392334 Z" fill="none" stroke="#000000" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /></svg>';
const String _svg_tyr51w =
    '<svg viewBox="293.4 754.5 30.0 30.0" ><path transform="translate(290.39, 751.5)" d="M 16.61100006103516 3.94950008392334 C 17.09099960327148 2.683500051498413 18.90749931335449 2.683500051498413 19.38899993896484 3.94950008392334 L 22.49399948120117 12.55049991607666 C 22.71574592590332 13.12406158447266 23.26806449890137 13.50161933898926 23.88299751281738 13.50000095367432 L 31.51350021362305 13.5 C 32.92350006103516 13.5 33.53850173950195 15.25500011444092 32.43000030517578 16.11450004577637 L 27 21 C 26.50099945068359 21.38360595703125 26.30596542358398 22.04502487182617 26.51700019836426 22.63800048828125 L 28.5 31.04249954223633 C 28.98299980163574 32.39249801635742 27.42000007629395 33.55199813842773 26.23799896240234 32.72100067138672 L 18.86249923706055 28.04100036621094 C 18.34500885009766 27.67730712890625 17.65498924255371 27.67730712890625 17.13749885559082 28.04100036621094 L 9.761999130249023 32.72100067138672 C 8.581499099731445 33.552001953125 7.016999244689941 32.39099884033203 7.499999046325684 31.04250144958496 L 9.482998847961426 22.63800048828125 C 9.694033622741699 22.04502487182617 9.499000549316406 21.38360595703125 9 21 L 3.570000171661377 16.11450004577637 C 2.460000038146973 15.25500011444092 3.078000068664551 13.5 4.485000133514404 13.5 L 12.11549949645996 13.5 C 12.73056507110596 13.50204849243164 13.28310298919678 13.12434196472168 13.50450038909912 12.55050086975098 L 16.60949897766113 3.94950008392334 Z" fill="none" stroke="#000000" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /></svg>';
const String _svg_a3rdgm =
    '<svg viewBox="345.2 754.5 30.0 30.0" ><path transform="translate(342.24, 751.5)" d="M 16.61100006103516 3.94950008392334 C 17.09099960327148 2.683500051498413 18.90749931335449 2.683500051498413 19.38899993896484 3.94950008392334 L 22.49399948120117 12.55049991607666 C 22.71574592590332 13.12406158447266 23.26806449890137 13.50161933898926 23.88299751281738 13.50000095367432 L 31.51350021362305 13.5 C 32.92350006103516 13.5 33.53850173950195 15.25500011444092 32.43000030517578 16.11450004577637 L 27 21 C 26.50099945068359 21.38360595703125 26.30596542358398 22.04502487182617 26.51700019836426 22.63800048828125 L 28.5 31.04249954223633 C 28.98299980163574 32.39249801635742 27.42000007629395 33.55199813842773 26.23799896240234 32.72100067138672 L 18.86249923706055 28.04100036621094 C 18.34500885009766 27.67730712890625 17.65498924255371 27.67730712890625 17.13749885559082 28.04100036621094 L 9.761999130249023 32.72100067138672 C 8.581499099731445 33.552001953125 7.016999244689941 32.39099884033203 7.499999046325684 31.04250144958496 L 9.482998847961426 22.63800048828125 C 9.694033622741699 22.04502487182617 9.499000549316406 21.38360595703125 9 21 L 3.570000171661377 16.11450004577637 C 2.460000038146973 15.25500011444092 3.078000068664551 13.5 4.485000133514404 13.5 L 12.11549949645996 13.5 C 12.73056507110596 13.50204849243164 13.28310298919678 13.12434196472168 13.50450038909912 12.55050086975098 L 16.60949897766113 3.94950008392334 Z" fill="none" stroke="#000000" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /></svg>';
const String _svg_rb06jz =
    '<svg viewBox="3.0 854.0 412.0 249.3" ><path transform="translate(3.0, 854.0)" d="M 9 0 L 403 0 C 407.9705505371094 0 412 10.25078964233398 412 22.89578056335449 L 412 226.4138336181641 C 412 239.0588226318359 407.9705505371094 249.3096008300781 403 249.3096008300781 L 9 249.3096008300781 C 4.029437065124512 249.3096008300781 0 239.0588226318359 0 226.4138336181641 L 0 22.89578056335449 C 0 10.25078964233398 4.029437065124512 0 9 0 Z" fill="#ffffff" fill-opacity="0.83" stroke="#54d1e0" stroke-width="7" stroke-opacity="0.83" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
