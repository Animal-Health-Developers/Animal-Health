import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './Settings.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditarinfodeUsuario extends StatelessWidget {
  const EditarinfodeUsuario({
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
          Align(
            alignment: Alignment(-0.267, -0.258),
            child: SizedBox(
              width: 1.0,
              height: 1.0,
              child: SvgPicture.string(
                _svg_m4gmy,
                allowDrawingOutsideViewBox: true,
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
            Pin(start: 50.0, end: 47.0),
            Pin(size: 45.0, middle: 0.5478),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(width: 1.0, color: const Color(0xff000000)),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.14, 0.093),
            child: SizedBox(
              width: 212.0,
              height: 28.0,
              child: Text(
                'Fecha de Nacimiento ',
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
            Pin(start: 85.0, end: 85.0),
            Pin(size: 49.0, middle: 0.8019),
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
            alignment: Alignment(0.0, 0.588),
            child: SizedBox(
              width: 210.0,
              height: 28.0,
              child: Text(
                'Guardar Información ',
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
            Pin(start: 47.0, end: 50.0),
            Pin(size: 45.0, middle: 0.634),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(width: 1.0, color: const Color(0xff000000)),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.241, 0.262),
            child: SizedBox(
              width: 217.0,
              height: 28.0,
              child: Text(
                'Numero de Documento',
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
            Pin(start: 50.0, end: 47.0),
            Pin(size: 45.0, middle: 0.7202),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(width: 1.0, color: const Color(0xff000000)),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.159, 0.431),
            child: SizedBox(
              width: 198.0,
              height: 28.0,
              child: Text(
                'Numero de Contacto',
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
            Pin(size: 1.0, start: 16.5),
            Pin(size: 50.0, start: 78.0),
            child: SvgPicture.string(
              _svg_ur8h7u,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
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
          Align(
            alignment: Alignment(0.043, -0.182),
            child: SizedBox(
              width: 136.0,
              height: 56.0,
              child: Text(
                'Foto de perfil\n',
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
            Pin(start: 49.0, end: 48.0),
            Pin(size: 45.0, middle: 0.4604),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(width: 1.0, color: const Color(0xff000000)),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.111, -0.076),
            child: SizedBox(
              width: 169.0,
              height: 28.0,
              child: Text(
                'Nombre Completo',
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
            Pin(size: 42.0, start: 55.0),
            Pin(size: 39.0, middle: 0.4607),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/nombreusuario.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 40.2, start: 55.0),
            Pin(size: 40.0, middle: 0.5475),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/fechanacimientopersona.png'),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 38.6, start: 55.0),
            Pin(size: 40.0, middle: 0.6332),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/id.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 39.3, start: 55.0),
            Pin(size: 40.0, middle: 0.7189),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/numerocontacto.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.0, -0.482),
            child: Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/perfilusuario.jpeg'),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(25.0),
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
        ],
      ),
    );
  }
}

const String _svg_m4gmy =
    '<svg viewBox="150.6 330.5 1.0 1.0" ><path  d="M 150.5888214111328 330.5046081542969" fill="none" stroke="#4ec8dd" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_ur8h7u =
    '<svg viewBox="16.5 78.0 1.0 50.0" ><path transform="translate(16.55, 54.0)" d="M 9.090913408726919e-06 30.25 C 9.090913408726919e-06 29.09939575195312 8.887405783752911e-06 28.16665649414062 8.636367965664249e-06 28.16665649414062 L 1.363637011309038e-06 28.16665649414062 C 1.112598397412512e-06 28.16665649414062 9.090912840292731e-07 29.09939575195312 9.090913408726919e-07 30.25 L 9.090913408726919e-07 67.75 C 9.090913408726919e-07 68.90057373046875 1.112598397412512e-06 69.83331298828125 1.363637011309038e-06 69.83331298828125 L 8.636367965664249e-06 69.83331298828125 C 8.887405783752911e-06 69.83331298828125 9.090913408726919e-06 68.90057373046875 9.090913408726919e-06 67.75 L 9.090913408726919e-06 59.41665649414062 C 9.090913408726919e-06 58.26608276367188 9.294421033700928e-06 57.33331298828125 9.54545885178959e-06 57.33331298828125 C 9.796497579372954e-06 57.33331298828125 1.000000520434696e-05 58.26608276367188 1.000000520434696e-05 59.41665649414062 L 1.000000520434696e-05 67.75 C 1.000000520434696e-05 71.2017822265625 9.38948414841434e-06 74 8.636367965664249e-06 74 L 1.363637011309038e-06 74 C 6.105210559326224e-07 74 0 71.2017822265625 0 67.75 L 0 30.25 C 0 26.7982177734375 6.105212833062978e-07 24 1.363637352369551e-06 24 L 8.636367965664249e-06 24 C 9.38948414841434e-06 24 1.000000520434696e-05 26.7982177734375 1.000000520434696e-05 30.25 L 1.000000520434696e-05 38.58331298828125 C 1.000000520434696e-05 39.73393249511719 9.796497579372954e-06 40.66665649414062 9.54545885178959e-06 40.66665649414062 C 9.294421033700928e-06 40.66665649414062 9.090913408726919e-06 39.73391723632812 9.090913408726919e-06 38.58331298828125 L 9.090913408726919e-06 30.25 Z" fill="#fafafa" stroke="none" stroke-width="12" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_i3j02g =
    '<svg viewBox="-7.5 128.0 50.0 1.0" ><path transform="translate(-55.49, 74.01)" d="M 48.65689086914062 53.9924201965332 C 48.2294921875 53.9924201965332 47.98928833007812 53.9924201965332 47.98928833007812 53.9924201965332 C 47.98928833007812 53.9924201965332 48.2294921875 53.9924201965332 48.65689086914062 53.9924201965332 L 62.29214477539062 53.99241638183594 C 63.1807861328125 53.99241638183594 64.62149047851562 53.99241638183594 65.51007080078125 53.99241638183594 C 66.39871215820312 53.99241638183594 66.39871215820312 53.99241638183594 65.51007080078125 53.99241638183594 L 55.75177001953125 53.9924201965332 L 95.71670532226562 53.9924201965332 C 96.97183227539062 53.9924201965332 97.98928833007812 53.9924201965332 97.98928833007812 53.9924201965332 C 97.98928833007812 53.9924201965332 96.97183227539062 53.9924201965332 95.71670532226562 53.9924201965332 L 55.75177001953125 53.9924201965332 L 65.51007080078125 53.99242401123047 C 66.39871215820312 53.99242401123047 66.39871215820312 53.99242401123047 65.51007080078125 53.99242401123047 C 64.62149047851562 53.99242401123047 63.1807861328125 53.99242401123047 62.29220581054688 53.99242401123047 L 48.65689086914062 53.9924201965332 Z" fill="#fafafa" stroke="none" stroke-width="12" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
