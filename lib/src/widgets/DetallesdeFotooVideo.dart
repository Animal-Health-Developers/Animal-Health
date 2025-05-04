import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/auth_service.dart';
class DetallesdeFotooVideo extends StatelessWidget {
  DetallesdeFotooVideo({
    required Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000000),
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
            Pin(size: 412.0, middle: 0.5),
            Pin(start: 192.0, end: 0.0),
            child: SingleChildScrollView(
              primary: false,
              child: SizedBox(
                width: 412.0,
                height: 1298.0,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: SingleChildScrollView(
                        primary: false,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 20,
                          runSpacing: 20,
                          children: [{}].map((itemData) {
                            return SizedBox(
                              width: 412.0,
                              height: 1278.0,
                              child: Stack(
                                children: <Widget>[
                                  Pinned.fromPins(
                                    Pin(start: 0.0, end: 0.0),
                                    Pin(size: 682.0, start: 0.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xe3a0f4fe),
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        border: Border.all(
                                            width: 1.0,
                                            color: const Color(0xe3000000)),
                                      ),
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 0.0, end: 0.0),
                                    Pin(size: 588.0, end: 0.0),
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xe3a0f4fe),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xe3000000)),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 50.0, start: 7.0),
                                          Pin(size: 50.0, start: 10.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/perfilfoto.jpeg'),
                                                fit: BoxFit.fill,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 157.0, start: 60.0),
                                          Pin(size: 28.0, start: 21.0),
                                          child: Text(
                                            'Anderson Florez',
                                            style: TextStyle(
                                              fontFamily: 'Comic Sans MS',
                                              fontSize: 20,
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w700,
                                              height: 1.2,
                                            ),
                                            textHeightBehavior:
                                                TextHeightBehavior(
                                                    applyHeightToFirstAscent:
                                                        false),
                                            textAlign: TextAlign.right,
                                            softWrap: false,
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 206.0, start: 7.0),
                                          Pin(size: 28.0, start: 65.0),
                                          child: Text(
                                            'Quedó hermosa Kitty',
                                            style: TextStyle(
                                              fontFamily: 'Comic Sans MS',
                                              fontSize: 20,
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w700,
                                              height: 1.2,
                                            ),
                                            textHeightBehavior:
                                                TextHeightBehavior(
                                                    applyHeightToFirstAscent:
                                                        false),
                                            textAlign: TextAlign.right,
                                            softWrap: false,
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 157.0, start: 60.0),
                                          Pin(size: 28.0, middle: 0.2143),
                                          child: Text(
                                            'Anderson Florez',
                                            style: TextStyle(
                                              fontFamily: 'Comic Sans MS',
                                              fontSize: 20,
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w700,
                                              height: 1.2,
                                            ),
                                            textHeightBehavior:
                                                TextHeightBehavior(
                                                    applyHeightToFirstAscent:
                                                        false),
                                            textAlign: TextAlign.right,
                                            softWrap: false,
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 50.0, start: 7.0),
                                          Pin(size: 50.0, middle: 0.2026),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/perfilfoto.jpeg'),
                                                fit: BoxFit.fill,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 206.0, start: 7.0),
                                          Pin(size: 28.0, middle: 0.2929),
                                          child: Text(
                                            'Quedó hermosa Kitty',
                                            style: TextStyle(
                                              fontFamily: 'Comic Sans MS',
                                              fontSize: 20,
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w700,
                                              height: 1.2,
                                            ),
                                            textHeightBehavior:
                                                TextHeightBehavior(
                                                    applyHeightToFirstAscent:
                                                        false),
                                            textAlign: TextAlign.right,
                                            softWrap: false,
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 157.0, start: 60.0),
                                          Pin(size: 28.0, middle: 0.3982),
                                          child: Text(
                                            'Anderson Florez',
                                            style: TextStyle(
                                              fontFamily: 'Comic Sans MS',
                                              fontSize: 20,
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w700,
                                              height: 1.2,
                                            ),
                                            textHeightBehavior:
                                                TextHeightBehavior(
                                                    applyHeightToFirstAscent:
                                                        false),
                                            textAlign: TextAlign.right,
                                            softWrap: false,
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 50.0, start: 7.0),
                                          Pin(size: 50.0, middle: 0.3941),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/perfilfoto.jpeg'),
                                                fit: BoxFit.fill,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 206.0, start: 7.0),
                                          Pin(size: 28.0, middle: 0.4839),
                                          child: Text(
                                            'Quedó hermosa Kitty',
                                            style: TextStyle(
                                              fontFamily: 'Comic Sans MS',
                                              fontSize: 20,
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w700,
                                              height: 1.2,
                                            ),
                                            textHeightBehavior:
                                                TextHeightBehavior(
                                                    applyHeightToFirstAscent:
                                                        false),
                                            textAlign: TextAlign.right,
                                            softWrap: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 4.0, end: 3.0),
                                    Pin(size: 87.0, start: 5.0),
                                    child: Stack(
                                      children: <Widget>[
                                        Stack(
                                          children: <Widget>[
                                            Pinned.fromPins(
                                              Pin(size: 187.0, start: 47.0),
                                              Pin(size: 28.0, start: 3.0),
                                              child: Text(
                                                'Nombre de Usuario',
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
                                              Pin(start: 13.0, end: 0.0),
                                              Pin(size: 42.0, end: 0.0),
                                              child: Text(
                                                'Kitty estrenando sus nuevas orejeras que compramos \n#Amazon',
                                                style: TextStyle(
                                                  fontFamily: 'Comic Sans MS',
                                                  fontSize: 15,
                                                  color:
                                                      const Color(0xff000000),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                softWrap: false,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                width: 40.0,
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: const AssetImage('assets/images/perfilusuario.jpeg'),
                                                    fit: BoxFit.fill,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              ),
                                            ),
                                            Pinned.fromPins(
                                              Pin(size: 33.6, middle: 0.6641),
                                              Pin(size: 30.0, start: 2.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: const AssetImage('assets/images/comunidad.png'),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Pinned.fromPins(
                                    Pin(start: 0.0, end: 0.0),
                                    Pin(size: 578.0, start: 100.0),
                                    child: Stack(
                                      children: <Widget>[
                                        Pinned.fromPins(
                                          Pin(size: 37.0, start: 47.9),
                                          Pin(size: 28.0, end: 6.3),
                                          child: Stack(
                                            children: <Widget>[
                                              SizedBox.expand(
                                                  child: Text(
                                                '777',
                                                style: TextStyle(
                                                  fontFamily: 'Comic Sans MS',
                                                  fontSize: 20,
                                                  color:
                                                      const Color(0xff000000),
                                                  height: 1.2,
                                                ),
                                                textHeightBehavior:
                                                    TextHeightBehavior(
                                                        applyHeightToFirstAscent:
                                                            false),
                                                softWrap: false,
                                              )),
                                            ],
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 36.1, start: 7.7),
                                          Pin(size: 40.0, end: 0.8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/like.png'),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(-0.472, 0.999),
                                          child: Container(
                                            width: 38.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/comments.png'),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 40.4, end: 7.7),
                                          Pin(size: 40.0, end: 0.3),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/save.png'),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 54.0, end: 51.1),
                                          Pin(size: 28.0, end: 6.0),
                                          child: Stack(
                                            children: <Widget>[
                                              SizedBox.expand(
                                                  child: Text(
                                                'SAVE',
                                                style: TextStyle(
                                                  fontFamily: 'Comic Sans MS',
                                                  fontSize: 20,
                                                  color:
                                                      const Color(0xff000000),
                                                  height: 1.2,
                                                ),
                                                textHeightBehavior:
                                                    TextHeightBehavior(
                                                        applyHeightToFirstAscent:
                                                            false),
                                                textAlign: TextAlign.right,
                                                softWrap: false,
                                              )),
                                            ],
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 21.0, middle: 0.3501),
                                          Pin(size: 28.0, end: 6.0),
                                          child: Stack(
                                            children: <Widget>[
                                              SizedBox.expand(
                                                  child: Text(
                                                '13',
                                                style: TextStyle(
                                                  fontFamily: 'Comic Sans MS',
                                                  fontSize: 20,
                                                  color:
                                                      const Color(0xff000000),
                                                  height: 1.2,
                                                ),
                                                textHeightBehavior:
                                                    TextHeightBehavior(
                                                        applyHeightToFirstAscent:
                                                            false),
                                                softWrap: false,
                                              )),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: const AssetImage('assets/images/imagenpublicacion.jpg'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          margin: EdgeInsets.fromLTRB(
                                              0.0, 0.0, 0.0, 45.0),
                                        ),
                                        Align(
                                          alignment: Alignment(0.4, 1.0),
                                          child: Container(
                                            width: 35.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/share.png'),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 69.0, middle: 0.5594),
                                          Pin(size: 28.0, end: 6.0),
                                          child: Stack(
                                            children: <Widget>[
                                              SizedBox.expand(
                                                  child: Text(
                                                'SHARE',
                                                style: TextStyle(
                                                  fontFamily: 'Comic Sans MS',
                                                  fontSize: 20,
                                                  color:
                                                      const Color(0xff000000),
                                                  height: 1.2,
                                                ),
                                                textHeightBehavior:
                                                    TextHeightBehavior(
                                                        applyHeightToFirstAscent:
                                                            false),
                                                textAlign: TextAlign.right,
                                                softWrap: false,
                                              )),
                                            ],
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
        ],
      ),
    );
  }
}

const String _svg_a7p9a8 =
    '<svg viewBox="150.6 225.5 1.0 1.0" ><path transform="translate(0.0, -105.0)" d="M 150.5888214111328 330.5046081542969" fill="none" stroke="#4ec8dd" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
