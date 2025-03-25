import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'Home.dart';
import 'package:adobe_xd/page_link.dart';
import 'PerfilPublico.dart';
import 'Ayuda.dart';
import 'ListadeAnimales.dart';
import 'Settings.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PRIVACIDAD extends StatelessWidget {
  const PRIVACIDAD({
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
            Pin(start: 0.0, end: 0.0),
            Pin(size: 42.0, middle: 0.2282),
            child: Stack(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xe3a0f4fe),
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(
                            width: 1.0, color: const Color(0xe3000000)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(151.0, 201.0),
            child: Text(
              'PRIVACIDAD',
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
            Pin(start: 14.0, end: 13.0),
            Pin(size: 525.0, end: 107.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xe3a0f4fe),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(width: 1.0, color: const Color(0xe3000000)),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 14.0, end: 13.6),
            Pin(size: 75.5, middle: 0.3184),
            child: SvgPicture.string(
              _svg_x68tk,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Transform.translate(
            offset: Offset(132.0, 273.5),
            child: Text(
              'Datos de Perfil',
              style: TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 20,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w700,
              ),
              softWrap: false,
            ),
          ),
          Transform.translate(
            offset: Offset(24.0, 307.5),
            child: Text(
              'Información personal del usuario',
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
            Pin(start: 14.0, end: 13.6),
            Pin(size: 102.7, middle: 0.4251),
            child: SvgPicture.string(
              _svg_nn2fn,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Transform.translate(
            offset: Offset(157.5, 350.0),
            child: Text(
              'Anuncios',
              style: TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 20,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w700,
              ),
              softWrap: false,
            ),
          ),
          Transform.translate(
            offset: Offset(21.0, 378.0),
            child: Text(
              'Gestionar anuncios para mostrar en el\ndispositivo',
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
            Pin(start: 14.0, end: 13.6),
            Pin(size: 95.7, middle: 0.5545),
            child: SvgPicture.string(
              _svg_ngd42,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Transform.translate(
            offset: Offset(164.5, 453.8),
            child: Text(
              'Permisos',
              style: TextStyle(
                fontFamily: 'Comic Sans MS',
                fontSize: 20,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w700,
              ),
              softWrap: false,
            ),
          ),
          Transform.translate(
            offset: Offset(24.0, 481.8),
            child: Text(
              'Controla el acceso a los datos de la\naplicacione',
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
        ],
      ),
    );
  }
}

const String _svg_i3j02g =
    '<svg viewBox="-7.5 128.0 50.0 1.0" ><path transform="translate(-55.49, 74.01)" d="M 48.65689086914062 53.9924201965332 C 48.2294921875 53.9924201965332 47.98928833007812 53.9924201965332 47.98928833007812 53.9924201965332 C 47.98928833007812 53.9924201965332 48.2294921875 53.9924201965332 48.65689086914062 53.9924201965332 L 62.29214477539062 53.99241638183594 C 63.1807861328125 53.99241638183594 64.62149047851562 53.99241638183594 65.51007080078125 53.99241638183594 C 66.39871215820312 53.99241638183594 66.39871215820312 53.99241638183594 65.51007080078125 53.99241638183594 L 55.75177001953125 53.9924201965332 L 95.71670532226562 53.9924201965332 C 96.97183227539062 53.9924201965332 97.98928833007812 53.9924201965332 97.98928833007812 53.9924201965332 C 97.98928833007812 53.9924201965332 96.97183227539062 53.9924201965332 95.71670532226562 53.9924201965332 L 55.75177001953125 53.9924201965332 L 65.51007080078125 53.99242401123047 C 66.39871215820312 53.99242401123047 66.39871215820312 53.99242401123047 65.51007080078125 53.99242401123047 C 64.62149047851562 53.99242401123047 63.1807861328125 53.99242401123047 62.29220581054688 53.99242401123047 L 48.65689086914062 53.9924201965332 Z" fill="#fafafa" stroke="none" stroke-width="12" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_x68tk =
    '<svg viewBox="14.0 260.0 384.4 75.5" ><path transform="translate(14.0, 260.0)" d="M 21.23768615722656 0 L 363.1644287109375 0 C 374.8936462402344 0 384.402099609375 3.149661064147949 384.402099609375 21.681884765625 L 384.402099609375 54.19091796875 C 384.402099609375 72.72314453125 374.8936462402344 75.5 363.1644287109375 75.5 L 21.23768615722656 75.5 C 9.508435249328613 75.5 0 72.72314453125 0 54.19091796875 L 0 17.61083984375 C 0 -0.9213838577270508 9.508435249328613 0 21.23768615722656 0 Z" fill="#4ec8dd" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_nn2fn =
    '<svg viewBox="14.0 335.5 384.4 102.7" ><path transform="translate(14.0, 335.57)" d="M 21.23768424987793 0.005021080374717712 L 363.1643981933594 0.005021080374717712 C 374.8936462402344 0.005021080374717712 384.402099609375 -2.572370529174805 384.402099609375 22.6098690032959 L 384.402099609375 79.59455108642578 C 384.402099609375 104.7768020629883 374.8936462402344 102.5970840454102 363.1643981933594 102.5970840454102 L 21.23768424987793 102.5970840454102 C 9.508434295654297 102.5970840454102 0 104.7768020629883 0 79.59455108642578 L 0 22.6098690032959 C 0 -2.572370529174805 9.508434295654297 0.005021080374717712 21.23768424987793 0.005021080374717712 Z" fill="#4ec8dd" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_ngd42 =
    '<svg viewBox="14.0 441.5 384.4 95.7" ><path transform="translate(14.0, 441.5)" d="M 21.23768615722656 0 L 363.1644287109375 0 C 374.8936462402344 0 384.402099609375 -0.1682529449462891 384.402099609375 23.3148193359375 L 384.402099609375 74.3643798828125 C 384.402099609375 97.84745788574219 374.8936462402344 95.669677734375 363.1644287109375 95.669677734375 L 21.23768615722656 95.669677734375 C 9.508435249328613 95.669677734375 0 97.84745788574219 0 74.3643798828125 L 0 23.3148193359375 C 0 -0.1682529449462891 9.508435249328613 0 21.23768615722656 0 Z" fill="#4ec8dd" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="round" /></svg>';
