import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'PRIVACIDAD.dart';
import 'package:adobe_xd/page_link.dart';
import 'EditarinfodeUsuario.dart';
import 'AgregarMetodosdePago.dart';
import 'Idiomas.dart';
import 'AnimalHealth.dart';
import 'Suscripcion.dart';
import 'Home.dart';
import 'Ayuda.dart';
import 'PerfilPublico.dart';
import 'ListadeAnimales.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Settings extends StatelessWidget {
  const Settings({
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
            Pin(size: 50.0, start: -7.5),
            Pin(size: 1.0, start: 128.0),
            child: SvgPicture.string(
              _svg_i3j02g,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Pinned.fromPins(
            Pin(size: 284.0, end: 56.0),
            Pin(size: 49.0, middle: 0.2112),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => PRIVACIDAD(key: Key('PRIVACIDAD'),),
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
          Align(
            alignment: Alignment(0.054, -0.565),
            child: SizedBox(
              width: 98.0,
              height: 28.0,
              child: Text(
                'Privacidad',
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
            Pin(size: 284.0, end: 55.0),
            Pin(size: 49.0, middle: 0.4057),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => EditarinfodeUsuario(key: Key('EditarinfodeUsuario'),),
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
          Align(
            alignment: Alignment(0.09, -0.185),
            child: SizedBox(
              width: 202.0,
              height: 28.0,
              child: Text(
                'Información Personal',
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
            Pin(size: 284.0, end: 55.0),
            Pin(size: 49.0, middle: 0.503),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => AgregarMetodosdePago(key: Key('AgregarMetodosdePago'),),
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
          Align(
            alignment: Alignment(0.077, 0.007),
            child: SizedBox(
              width: 164.0,
              height: 28.0,
              child: Text(
                'Métodos de Pago',
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
            Pin(size: 284.0, end: 56.0),
            Pin(size: 49.0, middle: 0.6014),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Idiomas(key: Key('Idiomas'),),
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
          Align(
            alignment: Alignment(0.049, 0.199),
            child: SizedBox(
              width: 66.0,
              height: 28.0,
              child: Text(
                'Idioma',
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
            Pin(size: 284.0, end: 56.0),
            Pin(size: 49.0, middle: 0.7972),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => AnimalHealth(key: Key('AnimalHealth'),),
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
          Align(
            alignment: Alignment(0.058, 0.579),
            child: SizedBox(
              width: 134.0,
              height: 28.0,
              child: Text(
                'Cerrar Sesion',
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
            Pin(start: 37.0, end: 37.0),
            Pin(size: 49.0, middle: 0.6999),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff4ec8dd),
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(width: 1.0, color: const Color(0xff000000)),
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
          Pinned.fromPins(
            Pin(size: 238.0, start: 49.0),
            Pin(size: 28.0, middle: 0.695),
            child: Text(
              'Discapacidad Audiovisual',
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
            Pin(size: 284.0, end: 55.0),
            Pin(size: 49.0, middle: 0.3084),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Suscripcion(key: Key('Suscripcion'),),
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
          Align(
            alignment: Alignment(0.063, -0.375),
            child: SizedBox(
              width: 108.0,
              height: 28.0,
              child: Text(
                'Suscripción',
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
          Container(),
        ],
      ),
    );
  }
}

const String _svg_i3j02g =
    '<svg viewBox="-7.5 128.0 50.0 1.0" ><path transform="translate(-55.49, 74.01)" d="M 48.65689086914062 53.9924201965332 C 48.2294921875 53.9924201965332 47.98928833007812 53.9924201965332 47.98928833007812 53.9924201965332 C 47.98928833007812 53.9924201965332 48.2294921875 53.9924201965332 48.65689086914062 53.9924201965332 L 62.29214477539062 53.99241638183594 C 63.1807861328125 53.99241638183594 64.62149047851562 53.99241638183594 65.51007080078125 53.99241638183594 C 66.39871215820312 53.99241638183594 66.39871215820312 53.99241638183594 65.51007080078125 53.99241638183594 L 55.75177001953125 53.9924201965332 L 95.71670532226562 53.9924201965332 C 96.97183227539062 53.9924201965332 97.98928833007812 53.9924201965332 97.98928833007812 53.9924201965332 C 97.98928833007812 53.9924201965332 96.97183227539062 53.9924201965332 95.71670532226562 53.9924201965332 L 55.75177001953125 53.9924201965332 L 65.51007080078125 53.99242401123047 C 66.39871215820312 53.99242401123047 66.39871215820312 53.99242401123047 65.51007080078125 53.99242401123047 C 64.62149047851562 53.99242401123047 63.1807861328125 53.99242401123047 62.29220581054688 53.99242401123047 L 48.65689086914062 53.9924201965332 Z" fill="#fafafa" stroke="none" stroke-width="12" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
