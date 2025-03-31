import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'Home.dart';
import 'package:adobe_xd/page_link.dart';
import 'CrearCuenta.dart';
import 'Ayuda.dart';
import 'Settingsoutsesion.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimalHealth extends StatelessWidget {
  AnimalHealth({
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
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
          ),
          Align(
            alignment: Alignment(0.004, -0.567),
            child: Container(
              width: 177.0,
              height: 175.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(32.0),
                border: Border.all(width: 1.0, color: const Color(0xff000000)),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 43.0, end: 43.0),
            Pin(size: 45.0, middle: 0.5089),
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
            Pin(size: 45.0, middle: 0.5951),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(width: 1.0, color: const Color(0xff000000)),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 265.0, end: 54.0),
            Pin(size: 28.0, middle: 0.5093),

            child: Text(
              'Email o Nombre de Usuario',
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
            alignment: Alignment(0.0, 0.186),
            child: SizedBox(
              width: 106.0,
              height: 28.0,
              child: Text(
                'Contraseña',
                style: TextStyle(
                  fontFamily: 'Comic Sans MS',
                  fontSize: 20,
                  color: const Color(0xff000000),
                  fontWeight: FontWeight.w700,
                ),
                softWrap: false,
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 85.0, end: 85.0),
            Pin(size: 49.0, middle: 0.7272),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Home(),
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
            Pin(size: 220.0, start: 50.0),
            Pin(size: 28.0, middle: 0.6354),
            child: Text(
              '¿Olvido la contraseña?',
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
            alignment: Alignment(0.03, 0.443),
            child: SizedBox(
              width: 134.0,
              height: 28.0,
              child: PageLink(
                links: [
                  PageLinkInfo(
                    transition: LinkTransition.Fade,
                    ease: Curves.easeOut,
                    duration: 0.3,
                    pageBuilder: () => Home(),
                  ),
                ],
                child: Text(
                  'Iniciar Sesion',
                  style: TextStyle(
                    fontFamily: 'Comic Sans MS',
                    fontSize: 20,
                    color: const Color(0xff000000),
                    fontWeight: FontWeight.w700,
                  ),
                  softWrap: false,
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 25.2, end: 55.6),
            Pin(size: 20.8, middle: 0.593),
            child: Stack(
              children: <Widget>[
                SizedBox.expand(
                    child: SvgPicture.string(
                  _svg_mg6z50,
                  allowDrawingOutsideViewBox: true,
                  fit: BoxFit.fill,
                )),
                Pinned.fromPins(
                  Pin(size: 12.0, middle: 0.5),
                  Pin(start: 4.4, end: 4.4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff535553),
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Pinned.fromPins(
            Pin(size: 245.0, middle: 0.4641),
            Pin(size: 26.0, end: 76.2),
            child: SingleChildScrollView(
              primary: false,
              child: Text(
                '¿No tienes una cuenta?',
                style: TextStyle(
                  fontFamily: 'Comic Sans MS',
                  fontSize: 20,
                  color: const Color(0xff000000),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 85.0, end: 85.0),
            Pin(size: 49.0, end: 102.2),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => CrearCuenta(key: Key('CrearCuenta'),),
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
            Pin(size: 110.0, middle: 0.5),
            Pin(size: 28.0, end: 112.7),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => CrearCuenta(key: Key('CrearCuenta'),),
                ),
              ],
              child: Text(
                'Registrarse',
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
            Pin(size: 45.0, start: 45.0),
            Pin(size: 45.0, middle: 0.5094),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/@.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 39.2, start: 52.9),
            Pin(size: 40.0, middle: 0.5945),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/password.png'),
                  fit: BoxFit.fill,
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
                  pageBuilder: () => Settingsoutsesion(key: Key('Settingsoutsesion'),),
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
        ],
      ),
    );
  }
}

const String _svg_mg6z50 =
    '<svg viewBox="0.0 0.0 25.2 20.8" ><path transform="translate(-2.02, -11.0)" d="M 26.8043270111084 19.87293434143066 L 26.8043270111084 19.87293434143066 C 25.60179328918457 17.79458808898926 21.13524436950684 11 14.60720825195312 11 C 8.079174041748047 11 3.612624168395996 17.79458808898926 2.410091400146484 19.87293434143066 C 1.892152786254883 20.75639152526855 1.892152786254883 22.02705764770508 2.410091400146484 22.91051292419434 C 3.612624168395996 24.98885917663574 8.079174041748047 31.783447265625 14.60720825195312 31.783447265625 C 21.13524436950684 31.783447265625 25.60179328918457 24.98885917663574 26.8043270111084 22.91051292419434 C 27.322265625 22.02705574035645 27.322265625 20.75639152526855 26.8043270111084 19.87293434143066 Z M 14.60720825195312 28.58599472045898 C 9.568023681640625 28.58599472045898 5.845899105072021 23.62994003295898 4.471575736999512 21.3917236328125 C 5.845898628234863 19.15350723266602 9.568023681640625 14.19745445251465 14.60720825195312 14.19745445251465 C 19.64639472961426 14.19745445251465 23.3685188293457 19.15350723266602 24.74284172058105 21.3917236328125 C 23.3685188293457 23.62994003295898 19.64639472961426 28.58599472045898 14.60720825195312 28.58599472045898 Z" fill="#535553" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
