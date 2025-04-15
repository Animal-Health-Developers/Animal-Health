import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './Settings.dart';
import './ListadeAnimales.dart';
import './Carritodecompras.dart';
import './ComprarAhora.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetallesdelProducto extends StatelessWidget {
  DetallesdelProducto({
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
          Pinned.fromPins(
            Pin(size: 412.0, middle: 0.5),
            Pin(start: 234.0, end: 0.0),
            child: SingleChildScrollView(
              primary: false,
              child: SizedBox(
                width: 412.0,
                height: 949.0,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0),
                      child: Stack(
                        children: <Widget>[
                          Pinned.fromPins(
                            Pin(start: 0.0, end: 0.0),
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
                                          0.0, 0.0, 0.0, 0.0),
                                      child: SingleChildScrollView(
                                        primary: false,
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          spacing: 84,
                                          runSpacing: 20,
                                          children:
                                              [{}, {}, {}, {}].map((itemData) {
                                            return SizedBox(
                                              width: 250.0,
                                              height: 250.0,
                                              child: Stack(
                                                children: <Widget>[
                                                  Pinned.fromPins(
                                                    Pin(
                                                        end: 0.0,
                                                        startFraction: 0.0),
                                                    Pin(
                                                        size: 250.0,
                                                        middle: 0.5),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image:
                                                              const AssetImage(
                                                                  'assets/images/shampoo.jpg'),
                                                          fit: BoxFit.fill,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.0),
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
                            Pin(size: 0.0, end: 14.0),
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
                            Pin(start: 0.0, end: 0.0),
                            Pin(size: 98.0, middle: 0.4734),
                            child: SvgPicture.string(
                              _svg_q5ebjj,
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 170.0, start: 9.0),
                            Pin(size: 19.0, middle: 0.4461),
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
                            Pin(start: 8.0, end: 8.0),
                            Pin(size: 38.0, middle: 0.4762),
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
                            Pin(start: 0.0, end: 0.0),
                            Pin(size: 67.0, middle: 0.5781),
                            child: SvgPicture.string(
                              _svg_ygkusi,
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 126.0, start: 7.0),
                            Pin(size: 28.0, middle: 0.5742),
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
                            alignment: Alignment(-0.278, 0.15),
                            child: SizedBox(
                              width: 30.0,
                              height: 30.0,
                              child: SvgPicture.string(
                                _svg_xc86eb,
                                allowDrawingOutsideViewBox: true,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment(-0.007, 0.15),
                            child: SizedBox(
                              width: 30.0,
                              height: 30.0,
                              child: SvgPicture.string(
                                _svg_jfqa,
                                allowDrawingOutsideViewBox: true,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment(0.265, 0.15),
                            child: SizedBox(
                              width: 30.0,
                              height: 30.0,
                              child: SvgPicture.string(
                                _svg_hgbz8v,
                                allowDrawingOutsideViewBox: true,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment(0.536, 0.15),
                            child: SizedBox(
                              width: 30.0,
                              height: 30.0,
                              child: SvgPicture.string(
                                _svg_xgg0y,
                                allowDrawingOutsideViewBox: true,
                              ),
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 30.0, end: 36.8),
                            Pin(size: 30.0, middle: 0.5749),
                            child: SvgPicture.string(
                              _svg_ww309w,
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 125.0, start: 5.0),
                            Pin(size: 35.0, middle: 0.6421),
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
                            Pin(size: 90.0, start: 23.0),
                            Pin(size: 28.0, middle: 0.6415),
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
                          Align(
                            alignment: Alignment(0.0, -0.367),
                            child: SizedBox(
                              width: 270.0,
                              height: 134.0,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xe3ffffff),
                                      borderRadius: BorderRadius.circular(30.0),
                                      border: Border.all(
                                          width: 1.0,
                                          color: const Color(0xe3707070)),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(size: 0.0, start: 32.0),
                                    Pin(size: 0.0, end: 22.0),
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
                                    Pin(start: 28.0, end: 27.0),
                                    Pin(size: 38.0, end: 8.0),
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
                                    Pin(size: 178.0, end: 30.2),
                                    Pin(size: 28.0, end: 13.0),
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
                                  Pinned.fromPins(
                                    Pin(start: 28.0, end: 27.0),
                                    Pin(size: 38.0, middle: 0.4688),
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
                                    alignment: Alignment(-0.048, -0.057),
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
                                  Pinned.fromPins(
                                    Pin(start: 43.0, end: 42.0),
                                    Pin(size: 36.0, start: 5.0),
                                    child: Container(
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
                                  Pinned.fromPins(
                                    Pin(size: 168.0, middle: 0.5),
                                    Pin(size: 28.0, start: 8.0),
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
                                  Pinned.fromPins(
                                    Pin(size: 33.0, start: 32.8),
                                    Pin(size: 35.0, end: 9.5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: const AssetImage('assets/images/carrito.png'),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(start: 0.0, end: 0.0),
                            Pin(size: 321.0, end: 0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xd4ffffff),
                                borderRadius: BorderRadius.circular(21.0),
                                border: Border.all(
                                    width: 7.0, color: const Color(0xd454d1e0)),
                              ),
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(start: 12.0, end: 11.0),
                            Pin(size: 56.0, middle: 0.7167),
                            child: Text(
                              'Andrés Mendoza: Excelente producto,\ncuida la salud de la piel de mi perrita ',
                              style: TextStyle(
                                fontFamily: 'Comic Sans MS',
                                fontSize: 20,
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(start: 11.0, end: 11.0),
                            Pin(size: 84.0, middle: 0.8162),
                            child: Text(
                                'Anderson Florez: Tiene un olor delicioso y duradero, además protege la piel de mi perrita kitty de hongos y bacterias.',
                                style: TextStyle(
                                  fontFamily: 'Comic Sans MS',
                                  fontSize: 20,
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 53.0, end: 52.0),
            Pin(size: 45.0, middle: 0.2137),
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
                  Pin(size: 28.0, middle: 0.4706),
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
                  Pin(size: 31.0, start: 4.0),
                  Pin(start: 7.0, end: 7.0),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/busqueda1.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_q5ebjj =
    '<svg viewBox="0.0 640.8 412.0 98.0" ><path transform="translate(0.0, 640.85)" d="M 9 0 L 403 0 C 407.9705505371094 0 412 4.029437065124512 412 9 L 412 89 C 412 93.97056579589844 407.9705505371094 98 403 98 L 9 98 C 4.029437065124512 98 0 93.97056579589844 0 89 L 0 9 C 0 4.029437065124512 4.029437065124512 0 9 0 Z" fill="#ffffff" fill-opacity="0.83" stroke="#54d1e0" stroke-width="7" stroke-opacity="0.83" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_ygkusi =
    '<svg viewBox="0.0 747.8 412.0 67.0" ><path transform="translate(0.0, 747.85)" d="M 11 0 L 401 0 C 407.0751342773438 0 412 4.924867630004883 412 11 L 412 56 C 412 62.07513427734375 407.0751342773438 67 401 67 L 11 67 C 4.924867630004883 67 0 62.07513427734375 0 56 L 0 11 C 0 4.924867630004883 4.924867630004883 0 11 0 Z" fill="#ffffff" fill-opacity="0.83" stroke="#54d1e0" stroke-width="7" stroke-opacity="0.83" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_xc86eb =
    '<svg viewBox="137.8 766.3 30.0 30.0" ><path transform="translate(134.85, 763.34)" d="M 16.61100006103516 3.94950008392334 C 17.09099960327148 2.683500051498413 18.90749931335449 2.683500051498413 19.38899993896484 3.94950008392334 L 22.49399948120117 12.55049991607666 C 22.71574592590332 13.12406158447266 23.26806449890137 13.50161933898926 23.88299751281738 13.50000095367432 L 31.51350021362305 13.5 C 32.92350006103516 13.5 33.53850173950195 15.25500011444092 32.43000030517578 16.11450004577637 L 27 21 C 26.50099945068359 21.38360595703125 26.30596542358398 22.04502487182617 26.51700019836426 22.63800048828125 L 28.5 31.04249954223633 C 28.98299980163574 32.39249801635742 27.42000007629395 33.55199813842773 26.23799896240234 32.72100067138672 L 18.86249923706055 28.04100036621094 C 18.34500885009766 27.67730712890625 17.65498924255371 27.67730712890625 17.13749885559082 28.04100036621094 L 9.761999130249023 32.72100067138672 C 8.581499099731445 33.552001953125 7.016999244689941 32.39099884033203 7.499999046325684 31.04250144958496 L 9.482998847961426 22.63800048828125 C 9.694033622741699 22.04502487182617 9.499000549316406 21.38360595703125 9 21 L 3.570000171661377 16.11450004577637 C 2.460000038146973 15.25500011444092 3.078000068664551 13.5 4.485000133514404 13.5 L 12.11549949645996 13.5 C 12.73056507110596 13.50204849243164 13.28310298919678 13.12434196472168 13.50450038909912 12.55050086975098 L 16.60949897766113 3.94950008392334 Z" fill="none" stroke="#000000" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /></svg>';
const String _svg_jfqa =
    '<svg viewBox="189.7 766.3 30.0 30.0" ><path transform="translate(186.69, 763.34)" d="M 16.61100006103516 3.94950008392334 C 17.09099960327148 2.683500051498413 18.90749931335449 2.683500051498413 19.38899993896484 3.94950008392334 L 22.49399948120117 12.55049991607666 C 22.71574592590332 13.12406158447266 23.26806449890137 13.50161933898926 23.88299751281738 13.50000095367432 L 31.51350021362305 13.5 C 32.92350006103516 13.5 33.53850173950195 15.25500011444092 32.43000030517578 16.11450004577637 L 27 21 C 26.50099945068359 21.38360595703125 26.30596542358398 22.04502487182617 26.51700019836426 22.63800048828125 L 28.5 31.04249954223633 C 28.98299980163574 32.39249801635742 27.42000007629395 33.55199813842773 26.23799896240234 32.72100067138672 L 18.86249923706055 28.04100036621094 C 18.34500885009766 27.67730712890625 17.65498924255371 27.67730712890625 17.13749885559082 28.04100036621094 L 9.761999130249023 32.72100067138672 C 8.581499099731445 33.552001953125 7.016999244689941 32.39099884033203 7.499999046325684 31.04250144958496 L 9.482998847961426 22.63800048828125 C 9.694033622741699 22.04502487182617 9.499000549316406 21.38360595703125 9 21 L 3.570000171661377 16.11450004577637 C 2.460000038146973 15.25500011444092 3.078000068664551 13.5 4.485000133514404 13.5 L 12.11549949645996 13.5 C 12.73056507110596 13.50204849243164 13.28310298919678 13.12434196472168 13.50450038909912 12.55050086975098 L 16.60949897766113 3.94950008392334 Z" fill="none" stroke="#000000" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /></svg>';
const String _svg_hgbz8v =
    '<svg viewBox="241.5 766.3 30.0 30.0" ><path transform="translate(238.54, 763.34)" d="M 16.61100006103516 3.94950008392334 C 17.09099960327148 2.683500051498413 18.90749931335449 2.683500051498413 19.38899993896484 3.94950008392334 L 22.49399948120117 12.55049991607666 C 22.71574592590332 13.12406158447266 23.26806449890137 13.50161933898926 23.88299751281738 13.50000095367432 L 31.51350021362305 13.5 C 32.92350006103516 13.5 33.53850173950195 15.25500011444092 32.43000030517578 16.11450004577637 L 27 21 C 26.50099945068359 21.38360595703125 26.30596542358398 22.04502487182617 26.51700019836426 22.63800048828125 L 28.5 31.04249954223633 C 28.98299980163574 32.39249801635742 27.42000007629395 33.55199813842773 26.23799896240234 32.72100067138672 L 18.86249923706055 28.04100036621094 C 18.34500885009766 27.67730712890625 17.65498924255371 27.67730712890625 17.13749885559082 28.04100036621094 L 9.761999130249023 32.72100067138672 C 8.581499099731445 33.552001953125 7.016999244689941 32.39099884033203 7.499999046325684 31.04250144958496 L 9.482998847961426 22.63800048828125 C 9.694033622741699 22.04502487182617 9.499000549316406 21.38360595703125 9 21 L 3.570000171661377 16.11450004577637 C 2.460000038146973 15.25500011444092 3.078000068664551 13.5 4.485000133514404 13.5 L 12.11549949645996 13.5 C 12.73056507110596 13.50204849243164 13.28310298919678 13.12434196472168 13.50450038909912 12.55050086975098 L 16.60949897766113 3.94950008392334 Z" fill="none" stroke="#000000" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /></svg>';
const String _svg_xgg0y =
    '<svg viewBox="293.4 766.3 30.0 30.0" ><path transform="translate(290.39, 763.34)" d="M 16.61100006103516 3.94950008392334 C 17.09099960327148 2.683500051498413 18.90749931335449 2.683500051498413 19.38899993896484 3.94950008392334 L 22.49399948120117 12.55049991607666 C 22.71574592590332 13.12406158447266 23.26806449890137 13.50161933898926 23.88299751281738 13.50000095367432 L 31.51350021362305 13.5 C 32.92350006103516 13.5 33.53850173950195 15.25500011444092 32.43000030517578 16.11450004577637 L 27 21 C 26.50099945068359 21.38360595703125 26.30596542358398 22.04502487182617 26.51700019836426 22.63800048828125 L 28.5 31.04249954223633 C 28.98299980163574 32.39249801635742 27.42000007629395 33.55199813842773 26.23799896240234 32.72100067138672 L 18.86249923706055 28.04100036621094 C 18.34500885009766 27.67730712890625 17.65498924255371 27.67730712890625 17.13749885559082 28.04100036621094 L 9.761999130249023 32.72100067138672 C 8.581499099731445 33.552001953125 7.016999244689941 32.39099884033203 7.499999046325684 31.04250144958496 L 9.482998847961426 22.63800048828125 C 9.694033622741699 22.04502487182617 9.499000549316406 21.38360595703125 9 21 L 3.570000171661377 16.11450004577637 C 2.460000038146973 15.25500011444092 3.078000068664551 13.5 4.485000133514404 13.5 L 12.11549949645996 13.5 C 12.73056507110596 13.50204849243164 13.28310298919678 13.12434196472168 13.50450038909912 12.55050086975098 L 16.60949897766113 3.94950008392334 Z" fill="none" stroke="#000000" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /></svg>';
const String _svg_ww309w =
    '<svg viewBox="345.2 766.3 30.0 30.0" ><path transform="translate(342.24, 763.34)" d="M 16.61100006103516 3.94950008392334 C 17.09099960327148 2.683500051498413 18.90749931335449 2.683500051498413 19.38899993896484 3.94950008392334 L 22.49399948120117 12.55049991607666 C 22.71574592590332 13.12406158447266 23.26806449890137 13.50161933898926 23.88299751281738 13.50000095367432 L 31.51350021362305 13.5 C 32.92350006103516 13.5 33.53850173950195 15.25500011444092 32.43000030517578 16.11450004577637 L 27 21 C 26.50099945068359 21.38360595703125 26.30596542358398 22.04502487182617 26.51700019836426 22.63800048828125 L 28.5 31.04249954223633 C 28.98299980163574 32.39249801635742 27.42000007629395 33.55199813842773 26.23799896240234 32.72100067138672 L 18.86249923706055 28.04100036621094 C 18.34500885009766 27.67730712890625 17.65498924255371 27.67730712890625 17.13749885559082 28.04100036621094 L 9.761999130249023 32.72100067138672 C 8.581499099731445 33.552001953125 7.016999244689941 32.39099884033203 7.499999046325684 31.04250144958496 L 9.482998847961426 22.63800048828125 C 9.694033622741699 22.04502487182617 9.499000549316406 21.38360595703125 9 21 L 3.570000171661377 16.11450004577637 C 2.460000038146973 15.25500011444092 3.078000068664551 13.5 4.485000133514404 13.5 L 12.11549949645996 13.5 C 12.73056507110596 13.50204849243164 13.28310298919678 13.12434196472168 13.50450038909912 12.55050086975098 L 16.60949897766113 3.94950008392334 Z" fill="none" stroke="#000000" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /></svg>';
