import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'Home.dart';
import 'package:adobe_xd/page_link.dart';
import 'Ayuda.dart';
import 'DetallesdelProducto.dart';
import 'Elejirmetododepagoparacomprar.dart';
import 'DirecciondeEnvio.dart';
import 'Pedidos.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './Settings.dart';

class Carritodecompras extends StatelessWidget {
  const Carritodecompras({
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
            Pin(size: 404.0, middle: 0.5),
            Pin(size: 668.0, end: 36.0),
            child: SingleChildScrollView(
              primary: false,
              child: SizedBox(
                width: 404.0,
                height: 1311.0,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, -643.0),
                      child: SingleChildScrollView(
                        primary: false,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 20,
                          runSpacing: 20,
                          children: [{}].map((itemData) {
                            return SizedBox(
                              width: 404.0,
                              height: 1280.0,
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0.0, 0.0, 0.0, 254.0),
                                    child: Stack(
                                      children: <Widget>[
                                        Pinned.fromPins(
                                          Pin(size: 0.0, end: 20.0),
                                          Pin(size: 0.0, middle: 0.5487),
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
                                        Align(
                                          alignment: Alignment(0.366, 0.135),
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
                                          Pin(size: 0.0, end: 20.0),
                                          Pin(size: 0.0, middle: 0.5487),
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
                                        Transform.translate(
                                          offset: Offset(192.0, 49.0),
                                          child: SizedBox(
                                            width: 384.0,
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
                                        SizedBox(
                                          width: 404.0,
                                          height: 513.0,
                                          child: Stack(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 404.0,
                                                height: 513.0,
                                                child: Stack(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 404.0,
                                                      height: 171.0,
                                                      child: SvgPicture.string(
                                                        _svg_o0ni4,
                                                        allowDrawingOutsideViewBox:
                                                            true,
                                                      ),
                                                    ),
                                                    Transform.translate(
                                                      offset:
                                                          Offset(0.0, 171.0),
                                                      child: Container(
                                                        width: 404.0,
                                                        height: 171.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0x8754d1e0),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                          border: Border.all(
                                                              width: 1.0,
                                                              color: const Color(
                                                                  0x87000000)),
                                                        ),
                                                      ),
                                                    ),
                                                    Transform.translate(
                                                      offset:
                                                          Offset(0.0, 342.0),
                                                      child: SizedBox(
                                                        width: 404.0,
                                                        height: 171.0,
                                                        child:
                                                            SvgPicture.string(
                                                          _svg_qto8s,
                                                          allowDrawingOutsideViewBox:
                                                              true,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(0.0, 513.0),
                                          child: SizedBox(
                                            width: 404.0,
                                            height: 513.0,
                                            child: Stack(
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 404.0,
                                                  height: 513.0,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 404.0,
                                                        height: 513.0,
                                                        child:
                                                            SvgPicture.string(
                                                          _svg_fa7yy,
                                                          allowDrawingOutsideViewBox:
                                                              true,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(9.0, 15.0),
                                          child: PageLink(
                                            links: [
                                              PageLinkInfo(
                                                transition: LinkTransition.Fade,
                                                ease: Curves.easeOut,
                                                duration: 0.3,
                                                pageBuilder: () =>
                                                    DetallesdelProducto(key: Key('DetallesdelProducto'),),
                                              ),
                                            ],
                                            child: Container(
                                              width: 141.0,
                                              height: 141.0,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: const AssetImage(''),
                                                  fit: BoxFit.fill,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(39.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(138.0, 68.0),
                                          child: SizedBox(
                                            width: 276.0,
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
                                        Transform.translate(
                                          offset: Offset(192.0, 49.0),
                                          child: SizedBox(
                                            width: 384.0,
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
                                        Transform.translate(
                                          offset: Offset(9.0, 186.0),
                                          child: PageLink(
                                            links: [
                                              PageLinkInfo(
                                                transition: LinkTransition.Fade,
                                                ease: Curves.easeOut,
                                                duration: 0.3,
                                                pageBuilder: () =>
                                                    DetallesdelProducto(key: Key('DetallesdelProducto'),),
                                              ),
                                            ],
                                            child: Container(
                                              width: 141.0,
                                              height: 141.0,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: const AssetImage(''),
                                                  fit: BoxFit.fill,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(39.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(9.0, 357.0),
                                          child: PageLink(
                                            links: [
                                              PageLinkInfo(
                                                transition: LinkTransition.Fade,
                                                ease: Curves.easeOut,
                                                duration: 0.3,
                                                pageBuilder: () =>
                                                    DetallesdelProducto(key: Key('DetallesdelProducto'),),
                                              ),
                                            ],
                                            child: Container(
                                              width: 141.0,
                                              height: 141.0,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: const AssetImage(''),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(36.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(192.0, 217.0),
                                          child: SizedBox(
                                            width: 384.0,
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
                                        Transform.translate(
                                          offset: Offset(138.0, 236.0),
                                          child: SizedBox(
                                            width: 276.0,
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
                                        Transform.translate(
                                          offset: Offset(192.0, 217.0),
                                          child: SizedBox(
                                            width: 384.0,
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
                                        Transform.translate(
                                          offset: Offset(192.0, 390.0),
                                          child: SizedBox(
                                            width: 384.0,
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
                                        Transform.translate(
                                          offset: Offset(138.0, 409.0),
                                          child: SizedBox(
                                            width: 276.0,
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
                                        Transform.translate(
                                          offset: Offset(192.0, 390.0),
                                          child: SizedBox(
                                            width: 384.0,
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
                                        Transform.translate(
                                          offset: Offset(163.5, 129.0),
                                          child: SizedBox(
                                            width: 327.0,
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
                                        Transform.translate(
                                          offset: Offset(215.0, 114.0),
                                          child: Container(
                                            width: 147.0,
                                            height: 34.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff4ec8dd),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      const Color(0xff080808),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(125.5, 117.0),
                                          child: SizedBox(
                                            width: 327.0,
                                            child: Text(
                                              'Eliminar',
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
                                        Transform.translate(
                                          offset: Offset(164.0, 297.0),
                                          child: SizedBox(
                                            width: 328.0,
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
                                        Transform.translate(
                                          offset: Offset(163.5, 470.0),
                                          child: SizedBox(
                                            width: 327.0,
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
                                        Transform.translate(
                                          offset: Offset(9.0, 528.0),
                                          child: PageLink(
                                            links: [
                                              PageLinkInfo(
                                                transition: LinkTransition.Fade,
                                                ease: Curves.easeOut,
                                                duration: 0.3,
                                                pageBuilder: () =>
                                                    DetallesdelProducto(key: Key('DetallesdelProducto'),),
                                              ),
                                            ],
                                            child: Container(
                                              width: 141.0,
                                              height: 141.0,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: const AssetImage(''),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(36.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(196.0, 69.0),
                                          child: Container(
                                            width: 185.0,
                                            height: 32.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff707070)),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(102.5, 71.0),
                                          child: SizedBox(
                                            width: 373.0,
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
                                        Transform.translate(
                                          offset: Offset(196.0, 23.0),
                                          child: Container(
                                            width: 185.0,
                                            height: 32.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff707070)),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(101.0, 24.0),
                                          child: SizedBox(
                                            width: 286.0,
                                            child: Text(
                                              'Cantidad',
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
                                        Transform.translate(
                                          offset: Offset(214.0, 285.0),
                                          child: Container(
                                            width: 147.0,
                                            height: 34.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff4ec8dd),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      const Color(0xff080808),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(125.0, 288.0),
                                          child: SizedBox(
                                            width: 326.0,
                                            child: Text(
                                              'Eliminar',
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
                                        Transform.translate(
                                          offset: Offset(195.0, 240.0),
                                          child: Container(
                                            width: 185.0,
                                            height: 32.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff707070)),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(101.0, 242.0),
                                          child: SizedBox(
                                            width: 370.0,
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
                                        Transform.translate(
                                          offset: Offset(195.0, 194.0),
                                          child: Container(
                                            width: 185.0,
                                            height: 32.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff707070)),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(100.5, 195.0),
                                          child: SizedBox(
                                            width: 285.0,
                                            child: Text(
                                              'Cantidad',
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
                                        Transform.translate(
                                          offset: Offset(214.0, 456.0),
                                          child: Container(
                                            width: 147.0,
                                            height: 34.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff4ec8dd),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      const Color(0xff080808),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(125.0, 459.0),
                                          child: SizedBox(
                                            width: 326.0,
                                            child: Text(
                                              'Eliminar',
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
                                        Transform.translate(
                                          offset: Offset(195.0, 411.0),
                                          child: Container(
                                            width: 185.0,
                                            height: 32.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff707070)),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(101.0, 413.0),
                                          child: SizedBox(
                                            width: 370.0,
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
                                        Transform.translate(
                                          offset: Offset(195.0, 365.0),
                                          child: Container(
                                            width: 185.0,
                                            height: 32.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff707070)),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(100.5, 366.0),
                                          child: SizedBox(
                                            width: 285.0,
                                            child: Text(
                                              'Cantidad',
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
                                          Pin(size: 34.0, end: 32.0),
                                          Pin(size: 28.0, start: 24.0),
                                          child: Stack(
                                            children: <Widget>[
                                              Pinned.fromPins(
                                                Pin(size: 8.0, start: 0.0),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '-',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xffff0000),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 12.0, middle: 0.4545),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '3',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 10.0, end: 0.0),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '+',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff00ff20),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 12.0, middle: 0.4545),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '3',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(214.0, 627.0),
                                          child: Container(
                                            width: 147.0,
                                            height: 34.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff4ec8dd),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      const Color(0xff080808),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(125.0, 630.0),
                                          child: SizedBox(
                                            width: 326.0,
                                            child: Text(
                                              'Eliminar',
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
                                        Transform.translate(
                                          offset: Offset(195.0, 582.0),
                                          child: Container(
                                            width: 185.0,
                                            height: 32.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff707070)),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(101.0, 584.0),
                                          child: SizedBox(
                                            width: 370.0,
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
                                        Transform.translate(
                                          offset: Offset(195.0, 536.0),
                                          child: Container(
                                            width: 185.0,
                                            height: 32.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff707070)),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(100.5, 537.0),
                                          child: SizedBox(
                                            width: 285.0,
                                            child: Text(
                                              'Cantidad',
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
                                          Pin(size: 34.0, end: 32.0),
                                          Pin(size: 28.0, middle: 0.1944),
                                          child: Stack(
                                            children: <Widget>[
                                              Pinned.fromPins(
                                                Pin(size: 8.0, start: 0.0),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '-',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xffff0000),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 12.0, middle: 0.4545),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '3',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 10.0, end: 0.0),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '+',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff00ff20),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 12.0, middle: 0.4545),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '3',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(9.0, 699.0),
                                          child: PageLink(
                                            links: [
                                              PageLinkInfo(
                                                transition: LinkTransition.Fade,
                                                ease: Curves.easeOut,
                                                duration: 0.3,
                                                pageBuilder: () =>
                                                    DetallesdelProducto(key: Key('DetallesdelProducto'),),
                                              ),
                                            ],
                                            child: Container(
                                              width: 141.0,
                                              height: 141.0,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: const AssetImage(''),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(36.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(9.0, 870.0),
                                          child: PageLink(
                                            links: [
                                              PageLinkInfo(
                                                transition: LinkTransition.Fade,
                                                ease: Curves.easeOut,
                                                duration: 0.3,
                                                pageBuilder: () =>
                                                    DetallesdelProducto(key: Key('DetallesdelProducto'),),
                                              ),
                                            ],
                                            child: Container(
                                              width: 141.0,
                                              height: 141.0,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: const AssetImage(''),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(36.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(214.0, 798.0),
                                          child: Container(
                                            width: 147.0,
                                            height: 34.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff4ec8dd),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      const Color(0xff080808),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(125.0, 801.0),
                                          child: SizedBox(
                                            width: 326.0,
                                            child: Text(
                                              'Eliminar',
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
                                        Transform.translate(
                                          offset: Offset(195.0, 753.0),
                                          child: Container(
                                            width: 185.0,
                                            height: 32.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff707070)),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(101.0, 755.0),
                                          child: SizedBox(
                                            width: 370.0,
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
                                        Transform.translate(
                                          offset: Offset(195.0, 707.0),
                                          child: Container(
                                            width: 185.0,
                                            height: 32.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff707070)),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(100.5, 708.0),
                                          child: SizedBox(
                                            width: 285.0,
                                            child: Text(
                                              'Cantidad',
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
                                        Transform.translate(
                                          offset: Offset(214.0, 969.0),
                                          child: Container(
                                            width: 147.0,
                                            height: 34.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff4ec8dd),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      const Color(0xff080808),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(125.0, 972.0),
                                          child: SizedBox(
                                            width: 326.0,
                                            child: Text(
                                              'Eliminar',
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
                                        Transform.translate(
                                          offset: Offset(195.0, 924.0),
                                          child: Container(
                                            width: 185.0,
                                            height: 32.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff707070)),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(101.0, 926.0),
                                          child: SizedBox(
                                            width: 370.0,
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
                                        Transform.translate(
                                          offset: Offset(195.0, 878.0),
                                          child: Container(
                                            width: 185.0,
                                            height: 32.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff707070)),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(100.5, 879.0),
                                          child: SizedBox(
                                            width: 285.0,
                                            child: Text(
                                              'Cantidad',
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
                                          Pin(size: 34.0, end: 32.0),
                                          Pin(size: 28.0, middle: 0.3687),
                                          child: Stack(
                                            children: <Widget>[
                                              Pinned.fromPins(
                                                Pin(size: 8.0, start: 0.0),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '-',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xffff0000),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 12.0, middle: 0.4545),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '3',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 10.0, end: 0.0),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '+',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff00ff20),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 12.0, middle: 0.4545),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '3',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 34.0, end: 32.0),
                                          Pin(size: 28.0, middle: 0.5381),
                                          child: Stack(
                                            children: <Widget>[
                                              Pinned.fromPins(
                                                Pin(size: 8.0, start: 0.0),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '-',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xffff0000),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 12.0, middle: 0.4545),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '3',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 10.0, end: 0.0),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '+',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff00ff20),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 12.0, middle: 0.4545),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '3',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 34.0, end: 32.0),
                                          Pin(size: 28.0, middle: 0.7094),
                                          child: Stack(
                                            children: <Widget>[
                                              Pinned.fromPins(
                                                Pin(size: 8.0, start: 0.0),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '-',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xffff0000),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 12.0, middle: 0.4545),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '3',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 10.0, end: 0.0),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '+',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff00ff20),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 12.0, middle: 0.4545),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '3',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 34.0, end: 32.0),
                                          Pin(size: 28.0, end: 119.0),
                                          child: Stack(
                                            children: <Widget>[
                                              Pinned.fromPins(
                                                Pin(size: 8.0, start: 0.0),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '-',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xffff0000),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 12.0, middle: 0.4545),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '3',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 10.0, end: 0.0),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '+',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff00ff20),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 12.0, middle: 0.4545),
                                                Pin(start: 0.0, end: 0.0),
                                                child: Text(
                                                  '3',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 20,
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 44.0, end: 45.0),
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
                                    Pin(start: 44.0, end: 45.0),
                                    Pin(size: 50.0, end: 79.0),
                                    child: PageLink(
                                      links: [
                                        PageLinkInfo(
                                          transition: LinkTransition.Fade,
                                          ease: Curves.easeOut,
                                          duration: 0.3,
                                          pageBuilder: () => DirecciondeEnvio(key: Key('DirecciondeEnvio'),),
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
                                    Pin(size: 178.0, middle: 0.4912),
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
                                    Pin(start: 45.0, end: 44.0),
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
        ],
      ),
    );
  }
}

const String _svg_o0ni4 =
    '<svg viewBox="-0.2 170.0 404.0 171.0" ><path transform="translate(-0.2, 170.0)" d="M 20 0 L 384 0 C 395.0456848144531 0 404 8.954304695129395 404 20 L 404 151 C 404 162.0457000732422 395.0456848144531 171 384 171 L 20 171 C 8.954304695129395 171 0 162.0457000732422 0 151 L 0 20 C 0 8.954304695129395 8.954304695129395 0 20 0 Z" fill="#54d1e0" fill-opacity="0.53" stroke="#000000" stroke-width="1" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_qto8s =
    '<svg viewBox="-0.2 512.0 404.0 171.0" ><path transform="translate(-0.2, 512.0)" d="M 20 0 L 384 0 C 395.0456848144531 0 404 8.954304695129395 404 20 L 404 151 C 404 162.0457000732422 395.0456848144531 171 384 171 L 20 171 C 8.954304695129395 171 0 162.0457000732422 0 151 L 0 20 C 0 8.954304695129395 8.954304695129395 0 20 0 Z" fill="#54d1e0" fill-opacity="0.53" stroke="#000000" stroke-width="1" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_fa7yy =
    '<svg viewBox="-0.2 170.0 404.0 513.0" ><path transform="translate(-0.2, 170.0)" d="M 20 0 L 384 0 C 395.0456848144531 0 404 8.954304695129395 404 20 L 404 151 C 404 162.0457000732422 395.0456848144531 171 384 171 L 20 171 C 8.954304695129395 171 0 162.0457000732422 0 151 L 0 20 C 0 8.954304695129395 8.954304695129395 0 20 0 Z" fill="#54d1e0" fill-opacity="0.28" stroke="#000000" stroke-width="1" stroke-opacity="0.28" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(-0.2, 341.0)" d="M 20 0 L 384 0 C 395.0456848144531 0 404 8.954304695129395 404 20 L 404 151 C 404 162.0457000732422 395.0456848144531 171 384 171 L 20 171 C 8.954304695129395 171 0 162.0457000732422 0 151 L 0 20 C 0 8.954304695129395 8.954304695129395 0 20 0 Z" fill="#54d1e0" fill-opacity="0.28" stroke="#000000" stroke-width="1" stroke-opacity="0.28" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(-0.2, 512.0)" d="M 20 0 L 384 0 C 395.0456848144531 0 404 8.954304695129395 404 20 L 404 151 C 404 162.0457000732422 395.0456848144531 171 384 171 L 20 171 C 8.954304695129395 171 0 162.0457000732422 0 151 L 0 20 C 0 8.954304695129395 8.954304695129395 0 20 0 Z" fill="#54d1e0" fill-opacity="0.28" stroke="#000000" stroke-width="1" stroke-opacity="0.28" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
