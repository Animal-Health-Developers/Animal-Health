import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'Chatenlnea.dart';
import 'package:adobe_xd/page_link.dart';
import 'Home.dart';
import 'PerfilPublico.dart';
import 'Ayuda.dart';
import 'Settings.dart';
import 'ListadeAnimales.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SoporteTcnico extends StatelessWidget {
  const SoporteTcnico({
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
            Pin(start: 73.0, end: 72.0),
            Pin(size: 49.0, end: 44.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Chatenlnea(key: Key('Chatenlnea'),),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff4ec8dd),
                  borderRadius: BorderRadius.circular(15.0),
                  border:
                      Border.all(width: 1.0, color: const Color(0xff000000)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff080808),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 128.0, middle: 0.507),
            Pin(size: 28.0, end: 55.0),
            child: Text(
              'Chat en linea',
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
            Pin(start: 92.0, end: 91.0),
            Pin(size: 35.0, middle: 0.2637),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xe3a0f4fe),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(width: 1.0, color: const Color(0xe3000000)),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.0, -0.468),
            child: SizedBox(
              width: 156.0,
              height: 28.0,
              child: Text(
                'Soporte Técnico',
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
            Pin(start: 10.0, end: 10.0),
            Pin(size: 498.0, end: 101.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0x8754d1e0),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(width: 1.0, color: const Color(0x87000000)),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 17.0, end: 17.0),
            Pin(size: 480.0, end: 111.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0x8754d1e0),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(width: 1.0, color: const Color(0x87000000)),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 49.0, end: 48.0),
            Pin(size: 45.0, middle: 0.4109),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(width: 1.0, color: const Color(0xff000000)),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 75.0, start: 49.0),
            Pin(size: 28.0, middle: 0.3646),
            child: Text(
              'Nombre',
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
            Pin(start: 49.0, end: 48.0),
            Pin(size: 45.0, middle: 0.5195),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(width: 1.0, color: const Color(0xff000000)),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 49.0, end: 48.0),
            Pin(size: 45.0, middle: 0.6281),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(width: 1.0, color: const Color(0xff000000)),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 49.0, end: 48.0),
            Pin(size: 160.0, end: 118.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(width: 1.0, color: const Color(0xff000000)),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 166.0, start: 49.0),
            Pin(size: 28.0, middle: 0.4711),
            child: Text(
              'Número Teléfono',
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
            Pin(size: 177.0, start: 54.0),
            Pin(size: 28.0, middle: 0.5775),
            child: Text(
              'Correo electrónico',
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
            Pin(size: 240.0, start: 54.0),
            Pin(size: 28.0, middle: 0.6736),
            child: Text(
              'Descripción del problema',
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
                    image: const AssetImage(''),
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
                    image: const AssetImage(''),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
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
