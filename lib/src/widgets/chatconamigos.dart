import 'package:animal_health/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import 'package:flutter_svg/flutter_svg.dart';

class chatconamigos extends StatelessWidget {
  const chatconamigos({
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
            Pin(start: 0.0, end: 0.0),
            Pin(size: 663.0, end: 44.0),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: SizedBox.expand(
                      child: SvgPicture.string(
                    _svg_inupy,
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.fill,
                  )),
                ),
                Pinned.fromPins(
                  Pin(start: 4.0, end: 4.0),
                  Pin(size: 1.0, start: 80.5),
                  child: SvgPicture.string(
                    _svg_uzpewl,
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.fill,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 71.0, middle: 0.2875),
                  Pin(size: 42.0, start: 19.2),
                  child: Text(
                    'Kitty',
                    style: TextStyle(
                      fontFamily: 'Comic Sans MS',
                      fontSize: 30,
                      color: const Color(0xff000000),
                    ),
                    softWrap: false,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 48.0, end: 15.0),
                  Pin(size: 48.0, start: 11.0),
                  child: Stack(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 40.4, middle: 0.6889),
                  Pin(size: 50.0, start: 16.2),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/llamadachat.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 34.9, middle: 0.8274),
                  Pin(size: 50.0, start: 16.2),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/videollamada.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(start: 0.0, end: 0.0),
                  Pin(size: 63.0, end: 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0x8754d1e0),
                      borderRadius: BorderRadius.circular(9.0),
                      border: Border.all(
                          width: 1.0, color: const Color(0x87000000)),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 190.0, end: 42.0),
                  Pin(size: 56.0, end: 3.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xd654d1e0),
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                              width: 1.0, color: const Color(0xd6000000)),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 48.9, end: 9.1),
                        Pin(start: 5.0, end: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: const AssetImage('assets/images/emoji.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 88.0, start: 7.0),
                        Pin(size: 28.0, middle: 0.5),
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontFamily: 'Comic Sans MS',
                              fontSize: 20,
                              color: const Color(0xff000000),
                            ),
                            children: [
                              TextSpan(
                                text: 'Mensaje',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: '...',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          textHeightBehavior: TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 42.9, start: 1.9),
                  Pin(size: 45.0, end: 8.5),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/clip.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 37.9, end: 11.6),
                  Pin(size: 50.0, start: 15.3),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/i.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 42.1, start: 47.8),
                  Pin(size: 45.0, end: 8.5),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/camara.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 40.5, middle: 0.25),
                  Pin(size: 45.0, end: 8.5),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/enviarfoto.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 41.2, middle: 0.3677),
                  Pin(size: 45.0, end: 8.5),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/mensajevoz.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 60.0, start: 19.0),
                  Pin(size: 60.0, start: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/kitty.jpg'),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 388.7, middle: 0.3861),
                  Pin(start: 80.7, end: 63.0),
                  child: SingleChildScrollView(
                    primary: false,
                    child: SizedBox(
                      width: 389.0,
                      height: 504.0,
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
                                children: [{}, {}].map((itemData) {
                                  return SizedBox(
                                    width: 389.0,
                                    height: 285.0,
                                    child: Stack(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              42.1, 0.0, 0.0, 0.0),
                                          child: Stack(
                                            children: <Widget>[
                                              Pinned.fromPins(
                                                Pin(size: 261.0, end: 0.0),
                                                Pin(size: 69.7, end: 16.1),
                                                child: SvgPicture.string(
                                                  _svg_alle2b,
                                                  allowDrawingOutsideViewBox:
                                                      true,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(start: 0.0, end: 32.2),
                                                Pin(size: 91.7, start: 0.0),
                                                child: SvgPicture.string(
                                                  _svg_vtifg,
                                                  allowDrawingOutsideViewBox:
                                                      true,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(start: 32.2, end: 0.0),
                                                Pin(size: 69.7, middle: 0.5244),
                                                child: SvgPicture.string(
                                                  _svg_w1r48,
                                                  allowDrawingOutsideViewBox:
                                                      true,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment(-0.359, 0.658),
                                                child: SizedBox(
                                                  width: 26.0,
                                                  height: 28.0,
                                                  child: Text(
                                                    '...',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Comic Sans MS',
                                                      fontSize: 20,
                                                      color: const Color(
                                                          0xff000000),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    softWrap: false,
                                                  ),
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 32.0, end: 8.4),
                                                Pin(size: 18.0, middle: 0.6791),
                                                child: Text(
                                                  'Leído',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 13,
                                                    color:
                                                        const Color(0xff000000),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 32.0, end: 8.4),
                                                Pin(size: 18.0, end: 0.0),
                                                child: Text(
                                                  'Leído',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 13,
                                                    color:
                                                        const Color(0xff000000),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(start: 22.2, end: 50.4),
                                                Pin(size: 72.0, start: 6.1),
                                                child: Text(
                                                  'Bienvenido al asistente virtual soy \nDogBot. A continuación, escriba su\nsolicitud.',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 17,
                                                    color:
                                                        const Color(0xff000000),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                              Pinned.fromPins(
                                                Pin(size: 279.0, end: 15.2),
                                                Pin(size: 48.0, middle: 0.5113),
                                                child: Text(
                                                  'Tengo dudas, sobre como hago para\neditar mis datos.',
                                                  style: TextStyle(
                                                    fontFamily: 'Comic Sans MS',
                                                    fontSize: 17,
                                                    color:
                                                        const Color(0xff000000),
                                                  ),
                                                  softWrap: false,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            width: 40.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/kitty.jpg'),
                                                fit: BoxFit.fill,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(9.0),
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
                  Pin(size: 33.8, end: 6.2),
                  Pin(size: 45.0, end: 8.5),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/likechat.png'),
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

const String _svg_alle2b =
    '<svg viewBox="142.4 465.4 261.0 69.7" ><path transform="translate(142.39, 465.41)" d="M 5.701456546783447 0 L 255.2985534667969 0 C 258.4473876953125 0 261 2.864627599716187 261 6.398325443267822 L 261 63.2723274230957 C 261 66.8060302734375 258.4473876953125 69.670654296875 255.2985534667969 69.670654296875 L 5.701456546783447 69.670654296875 C 2.552628993988037 69.670654296875 0 66.8060302734375 0 63.2723274230957 L 0 6.398325443267822 C 0 2.864627599716187 2.552628993988037 0 5.701456546783447 0 Z" fill="#ffffff" fill-opacity="0.53" stroke="#54d1e0" stroke-width="7" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_vtifg =
    '<svg viewBox="56.8 265.9 314.3 91.7" ><path transform="translate(56.83, 265.85)" d="M 6.866647243499756 0 L 307.4732055664062 0 C 311.2655639648438 0 314.33984375 3.77031421661377 314.33984375 8.421233177185059 L 314.33984375 83.27664184570312 C 314.33984375 87.92756652832031 311.2655639648438 91.6978759765625 307.4732055664062 91.6978759765625 L 6.866647243499756 91.6978759765625 C 3.074302673339844 91.6978759765625 0 87.92756652832031 0 83.27664184570312 L 0 8.421233177185059 C 0 3.77031421661377 3.074302673339844 0 6.866647243499756 0 Z" fill="#ffffff" fill-opacity="0.53" stroke="#54d1e0" stroke-width="7" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_w1r48 =
    '<svg viewBox="89.0 379.0 314.3 69.7" ><path transform="translate(89.05, 378.95)" d="M 6.866647243499756 0 L 307.4732055664062 0 C 311.2655639648438 0 314.33984375 2.864627599716187 314.33984375 6.398325443267822 L 314.33984375 63.2723274230957 C 314.33984375 66.8060302734375 311.2655639648438 69.670654296875 307.4732055664062 69.670654296875 L 6.866647243499756 69.670654296875 C 3.074302673339844 69.670654296875 0 66.8060302734375 0 63.2723274230957 L 0 6.398325443267822 C 0 2.864627599716187 3.074302673339844 0 6.866647243499756 0 Z" fill="#ffffff" fill-opacity="0.53" stroke="#54d1e0" stroke-width="7" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_inupy =
    '<svg viewBox="0.0 185.0 412.0 600.0" ><path transform="translate(0.0, 185.0)" d="M 20.39603996276855 0 L 391.6039733886719 0 C 402.868408203125 0 412.0000305175781 8.954304695129395 412.0000305175781 20 L 412.0000305175781 580 C 412.0000305175781 591.0457153320312 402.868408203125 600 391.6039733886719 600 L 20.39603996276855 600 C 9.131618499755859 600 0 591.0457153320312 0 580 L 0 20 C 0 8.954304695129395 9.131618499755859 0 20.39603996276855 0 Z" fill="#54d1e0" fill-opacity="0.53" stroke="#000000" stroke-width="1" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_uzpewl =
    '<svg viewBox="4.0 265.5 404.0 1.0" ><path transform="translate(4.0, 265.5)" d="M 0 0 L 404 0" fill="none" stroke="#000000" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
