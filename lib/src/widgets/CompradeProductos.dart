import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'Home.dart';
import 'package:adobe_xd/page_link.dart';
import 'Ayuda.dart';
import 'PerfilPublico.dart';
import 'Settings.dart';
import 'ListadeAnimales.dart';
import 'VenderProductos.dart';
import 'Carritodecompras.dart';
import 'DetallesdelProducto.dart';
import 'ComprarAhora.dart';

class CompradeProductos extends StatelessWidget {
  const CompradeProductos({
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
            Pin(size: 307.0, start: 16.0),
            Pin(size: 45.0, middle: 0.2137),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 226.0, start: 60.0),
            Pin(size: 28.0, middle: 0.2188),
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
            Pin(size: 31.0, start: 20.0),
            Pin(size: 31.0, middle: 0.2184),
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
          Pinned.fromPins(
            Pin(size: 65.0, end: 7.6),
            Pin(size: 60.0, middle: 0.2127),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => VenderProductos(key: Key('VenderProductos'),),
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
          Pinned.fromPins(
            Pin(size: 412.0, middle: 0.5),
            Pin(start: 244.0, end: 0.0),
            child: SingleChildScrollView(
              primary: false,
              child: SizedBox(
                width: 412.0,
                height: 971.0,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, -323.0),
                      child: GridView.count(
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        crossAxisCount: 1,
                        childAspectRatio: 0.43,
                        children: [{}].map((itemData) {
                          return Stack(
                            children: <Widget>[
                              Pinned.fromPins(
                                Pin(size: 0.0, middle: 0.6796),
                                Pin(size: 0.0, start: 68.0),
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
                                Pin(size: 0.0, end: 24.0),
                                Pin(size: 0.0, start: 49.0),
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
                              SingleChildScrollView(
                                primary: false,
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 19,
                                  runSpacing: 20,
                                  children: [
                                    {
                                      'text': 'Precio  \$ 17.761',
                                    },
                                    {
                                      'text': 'Precio  \$ 70.000',
                                    },
                                    {
                                      'text': 'Precio  \$ 24.000',
                                    },
                                    {
                                      'text': 'Precio  \$ 40.000',
                                    },
                                    {
                                      'text': 'Precio  \$ 50.000',
                                    }
                                  ].map((itemData) {
                                    final text = itemData['text'];
                                    return SizedBox(
                                      width: 412.0,
                                      height: 171.0,
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
                                          ),
                                          Pinned.fromPins(
                                            Pin(size: 150.0, start: 9.0),
                                            Pin(start: 10.0, end: 11.0),
                                            child: PageLink(
                                              links: [
                                                PageLinkInfo(
                                                  transition:
                                                      LinkTransition.Fade,
                                                  ease: Curves.easeOut,
                                                  duration: 0.3,
                                                  pageBuilder: () =>
                                                      DetallesdelProducto(key: Key('DetallesdelProducto'),),
                                                ),
                                              ],
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: const AssetImage(''),
                                                    fit: BoxFit.fill,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Pinned.fromPins(
                                            Pin(size: 185.0, end: 28.0),
                                            Pin(size: 36.0, end: 15.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xffffffff),
                                                borderRadius:
                                                    BorderRadius.circular(11.0),
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: const Color(
                                                        0xff707070)),
                                              ),
                                            ),
                                          ),
                                          Pinned.fromPins(
                                            Pin(size: 168.0, end: 37.0),
                                            Pin(size: 28.0, end: 20.0),
                                            child: Text(
                                              text!,
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
                                            Pin(size: 224.0, end: 8.0),
                                            Pin(size: 44.0, start: 24.0),
                                            child: PageLink(
                                              links: [
                                                PageLinkInfo(
                                                  transition:
                                                      LinkTransition.Fade,
                                                  ease: Curves.easeOut,
                                                  duration: 0.3,
                                                  pageBuilder: () =>
                                                      Carritodecompras(key: Key('Carritodecompras'),),
                                                ),
                                              ],
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffffffff),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: const Color(
                                                          0xff707070)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(
                                                          0xff51b5e0),
                                                      offset: Offset(0, 3),
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Pinned.fromPins(
                                            Pin(size: 178.0, end: 12.2),
                                            Pin(size: 28.0, middle: 0.2238),
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
                                            Pin(size: 215.0, end: 13.0),
                                            Pin(size: 38.0, middle: 0.5639),
                                            child: PageLink(
                                              links: [
                                                PageLinkInfo(
                                                  transition:
                                                      LinkTransition.Fade,
                                                  ease: Curves.easeOut,
                                                  duration: 0.3,
                                                  pageBuilder: () =>
                                                      ComprarAhora(key: Key('ComprarAhora'),),
                                                ),
                                              ],
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffffffff),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: const Color(
                                                          0xff707070)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(
                                                          0xff51b5e0),
                                                      offset: Offset(0, 3),
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Pinned.fromPins(
                                            Pin(size: 146.0, end: 51.0),
                                            Pin(size: 28.0, middle: 0.5594),
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
                                          Align(
                                            alignment:
                                                Alignment(-0.017, -0.603),
                                            child: Container(
                                              width: 38.0,
                                              height: 40.0,
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
        ],
      ),
    );
  }
}
