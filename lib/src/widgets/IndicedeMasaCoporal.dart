import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './EditarPerfildeAnimal.dart';
import './FuncionesdelaApp.dart';
import 'dart:ui' as ui;
import 'package:flutter_svg/flutter_svg.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';

class IndicedeMasaCoporal extends StatelessWidget {
  const IndicedeMasaCoporal({
    required Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
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
          Align(
            alignment: Alignment(0.0, -0.549),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => EditarPerfildeAnimal(key: Key('EditarPerfildeAnimalesdeCompaia'), animalId: '',),
                ),
              ],
              child: Container(
                width: 90.0,
                height: 90.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/kitty.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 62.7, start: 6.7),
            Pin(size: 70.0, middle: 0.2324),
            child: PageLink(
              links: [
                PageLinkInfo(
                  duration: 0.3,
                  pageBuilder: () => FuncionesdelaApp(key: Key('FuncionesdelaApp'),),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/funciones.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: -9.0, end: -9.0),
            Pin(size: 557.0, end: 42.0),
            child: Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(size: 430.0, middle: 0.5),
                  Pin(start: 0.0, end: 0.0),
                  child: SingleChildScrollView(
                    primary: false,
                    child: SizedBox(
                      width: 430.0,
                      height: 1262.0,
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
                                    height: 1230.0,
                                    child: Stack(
                                      children: <Widget>[
                                        Pinned.fromPins(
                                          Pin(start: 49.0, end: 48.0),
                                          Pin(size: 45.0, start: 0.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(start: 49.0, end: 48.0),
                                          Pin(size: 45.0, start: 59.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 42.0, middle: 0.4973),
                                          Pin(size: 28.0, start: 10.0),
                                          child: Text(
                                            'Peso',
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
                                          Pin(size: 166.0, middle: 0.5285),
                                          Pin(size: 28.0, start: 69.0),
                                          child: Text(
                                            'Ancho del Animal',
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
                                          Pin(size: 30.0, start: 60.0),
                                          Pin(size: 30.0, start: 124.0),
                                          child: SvgPicture.string(
                                            _svg_skj7th,
                                            allowDrawingOutsideViewBox: true,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(start: 49.0, end: 48.0),
                                          Pin(size: 45.0, start: 118.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xff000000)),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 161.0, middle: 0.5259),
                                          Pin(size: 28.0, start: 126.0),
                                          child: Text(
                                            'Largo del Animal',
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
                                          Pin(size: 40.7, start: 55.1),
                                          Pin(size: 40.0, start: 2.5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/peso.png'),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 35.8, start: 55.4),
                                          Pin(size: 40.0, start: 61.5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/ancho.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(size: 35.8, start: 55.4),
                                          Pin(size: 40.0, start: 120.5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: const AssetImage('assets/images/largo.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(start: 85.0, end: 85.0),
                                          Pin(size: 49.0, start: 175.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xff4ec8dd),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
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
                                        Pinned.fromPins(
                                          Pin(size: 136.0, middle: 0.5),
                                          Pin(size: 28.0, start: 185.0),
                                          child: Text(
                                            'Ver Resultado',
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
                                          Pin(size: 321.0, middle: 0.2574),
                                          child: ClipRect(
                                            child: BackdropFilter(
                                              filter: ui.ImageFilter.blur(
                                                  sigmaX: 2.0, sigmaY: 2.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0x5e4ec8dd),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: const Color(
                                                          0xff000000)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(
                                                          0x29000000),
                                                      offset: Offset(0, 3),
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(0.0, -0.599),
                                          child: SizedBox(
                                            width: 118.0,
                                            height: 24.0,
                                            child: Text(
                                              'Resultado IMC',
                                              style: TextStyle(
                                                fontFamily: 'Comic Sans MS',
                                                fontSize: 17,
                                                color: const Color(0xff000000),
                                                height: 0.8823529411764706,
                                              ),
                                              textHeightBehavior:
                                                  TextHeightBehavior(
                                                      applyHeightToFirstAscent:
                                                          false),
                                              textAlign: TextAlign.center,
                                              softWrap: false,
                                            ),
                                          ),
                                        ),
                                        Pinned.fromPins(
                                          Pin(start: 0.0, end: 0.0),
                                          Pin(size: 632.0, end: 0.0),
                                          child: ClipRect(
                                            child: BackdropFilter(
                                              filter: ui.ImageFilter.blur(
                                                  sigmaX: 2.0, sigmaY: 2.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0x5e4ec8dd),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: const Color(
                                                          0xff000000)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(
                                                          0x29000000),
                                                      offset: Offset(0, 3),
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(0.0, 0.022),
                                          child: SizedBox(
                                            width: 268.0,
                                            height: 24.0,
                                            child: Text(
                                              'Recomendaciones de Alimentación',
                                              style: TextStyle(
                                                fontFamily: 'Comic Sans MS',
                                                fontSize: 17,
                                                color: const Color(0xff000000),
                                                height: 0.8823529411764706,
                                              ),
                                              textHeightBehavior:
                                                  TextHeightBehavior(
                                                      applyHeightToFirstAscent:
                                                          false),
                                              textAlign: TextAlign.center,
                                              softWrap: false,
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
              ],
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
                  pageBuilder: () => Configuraciones(key: Key('Settings'),),
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
        ],
      ),
    );
  }
}

const String _svg_skj7th =
    '<svg viewBox="60.0 417.0 30.0 30.0" ><path transform="translate(-6.64, 339.79)" d="M 88.74252319335938 87.763916015625 L 87.18894958496094 86.11825561523438 L 89.05659484863281 84.14011383056641 L 88.04324340820312 83.06681060791016 L 92.8997802734375 77.92287445068359 L 92.22758483886719 77.21099853515625 L 87.37105560302734 82.3548583984375 L 86.35769653320312 81.28155517578125 L 84.48997497558594 83.25969696044922 L 82.93631744384766 81.61412048339844 L 69.54340362548828 95.79930114746094 L 68.57440948486328 94.77297973632812 L 67.90229797363281 95.48485565185547 L 70.84492492675781 98.60148620605469 L 68.04765319824219 101.5642547607422 L 67.30710601806641 100.7798919677734 L 66.63499450683594 101.4917678833008 L 69.97518157958984 105.0295715332031 L 70.64729309082031 104.3176956176758 L 69.90674591064453 103.5333404541016 L 72.70401763916016 100.5705718994141 L 75.64664459228516 103.6872100830078 L 76.31875610351562 102.9754180908203 L 75.34976196289062 101.9490127563477 L 88.74252319335938 87.763916015625 Z M 86.35769653320312 82.70529937744141 L 87.71237182617188 84.14012145996094 L 86.53607940673828 85.38600158691406 L 85.18132781982422 83.95117950439453 L 86.35769653320312 82.70529937744141 Z M 76.22006225585938 90.15147399902344 L 77.19419860839844 91.18325042724609 L 77.86631011962891 90.47137451171875 L 76.89216613769531 89.43960571289062 L 78.40130615234375 87.8411865234375 L 79.37545013427734 88.87295532226562 L 80.04755401611328 88.16108703613281 L 79.07341003417969 87.12931060791016 L 80.58262634277344 85.53089141845703 L 81.55677032470703 86.56266784667969 L 82.2288818359375 85.85079193115234 L 81.25473785400391 84.81901550292969 L 82.93631744384766 83.03803253173828 L 87.39830017089844 87.76408386230469 L 79.18605041503906 96.46201324462891 L 74.72399139404297 91.73596954345703 L 76.22006225585938 90.15147399902344 Z M 70.22898101806641 96.49691772460938 L 72.13013458251953 94.48328399658203 L 73.10427856445312 95.51514434814453 L 73.77638244628906 94.80326843261719 L 72.80223846435547 93.77149963378906 L 74.05180358886719 92.44792175292969 L 75.35332489013672 93.82637023925781 L 71.53041839599609 97.87544250488281 L 70.22898101806641 96.49691772460938 Z M 69.26053619384766 102.7941131591797 L 68.74558258056641 102.248779296875 L 71.51695251464844 99.31344604492188 L 72.03182983398438 99.85887145996094 L 69.26053619384766 102.7941131591797 Z M 72.20261383056641 98.58722686767578 L 76.01925659179688 94.54470062255859 L 76.53421020507812 95.09011840820312 L 72.71748352050781 99.132568359375 L 72.20261383056641 98.58722686767578 Z M 73.38959503173828 99.84452056884766 L 77.21250152587891 95.79544830322266 L 78.51394653320312 97.17388916015625 L 74.6910400390625 101.2229614257812 L 73.38959503173828 99.84452056884766 Z M 94.22434997558594 101.1151580810547 C 93.61846160888672 100.6650390625 93.07102966308594 100.0446166992188 92.59757995605469 99.27133178710938 C 92.00904083251953 98.31020355224609 91.01628112792969 97.73641967773438 89.94194030761719 97.73641967773438 C 88.86759948730469 97.73641967773438 87.87483215332031 98.31019592285156 87.286376953125 99.27133178710938 C 86.81277465820312 100.0447006225586 86.2655029296875 100.6649627685547 85.65960693359375 101.1151580810547 C 84.81221008300781 101.7447204589844 84.30620574951172 102.7704620361328 84.30620574951172 103.8593673706055 C 84.30620574951172 105.7074737548828 85.725830078125 107.2109985351562 87.47062683105469 107.2109985351562 L 92.41333770751953 107.2109985351562 C 94.15821075439453 107.2109985351562 95.57768249511719 105.7074737548828 95.57768249511719 103.8593673706055 C 95.57767486572266 102.7704544067383 95.07175445556641 101.7447204589844 94.22434997558594 101.1151580810547 Z M 92.41326141357422 106.2042236328125 L 87.47054290771484 106.2042236328125 C 86.24989318847656 106.2042236328125 85.25666046142578 105.1523132324219 85.25666046142578 103.8593597412109 C 85.25666046142578 103.0984954833984 85.61137390136719 102.3806686401367 86.20537567138672 101.9393615722656 C 86.91162872314453 101.4147491455078 87.54365539550781 100.7013702392578 88.08387756347656 99.81918334960938 C 88.49649047851562 99.14548492431641 89.19109344482422 98.74327850341797 89.94194030761719 98.74327850341797 C 90.69286346435547 98.74327850341797 91.38755035400391 99.14548492431641 91.80007934570312 99.81918334960938 C 92.34022521972656 100.7013702392578 92.97233581542969 101.4147491455078 93.67858123779297 101.9393615722656 C 94.27259063720703 102.3806686401367 94.62722015380859 103.0983276367188 94.62722015380859 103.8593597412109 C 94.62713623046875 105.1523132324219 93.63398742675781 106.2042236328125 92.41326141357422 106.2042236328125 Z M 86.17202758789062 98.69948577880859 L 86.17202758789062 97.46408843994141 C 86.17202758789062 96.59398651123047 85.50363922119141 95.88597106933594 84.68206024169922 95.88597106933594 C 83.8604736328125 95.88597106933594 83.19209289550781 96.59390258789062 83.19209289550781 97.46408843994141 L 83.19209289550781 98.69948577880859 C 83.19209289550781 99.56967163085938 83.8604736328125 100.2776031494141 84.68206024169922 100.2776031494141 C 85.50363922119141 100.2776031494141 86.17202758789062 99.56967163085938 86.17202758789062 98.69948577880859 Z M 84.14270782470703 98.69948577880859 L 84.14270782470703 97.46408843994141 C 84.14270782470703 97.14913940429688 84.38470458984375 96.89274597167969 84.68214416503906 96.89274597167969 C 84.97958374023438 96.89274597167969 85.22157287597656 97.14913940429688 85.22157287597656 97.46408843994141 L 85.22157287597656 98.69948577880859 C 85.22157287597656 99.01460266113281 84.97958374023438 99.27082824707031 84.68214416503906 99.27082824707031 C 84.38470458984375 99.27082824707031 84.14270782470703 99.01460266113281 84.14270782470703 98.69948577880859 Z M 95.14494323730469 95.88605499267578 C 94.32344055175781 95.88605499267578 93.65505981445312 96.59397888183594 93.65505981445312 97.46417236328125 L 93.65505981445312 98.69956970214844 C 93.65505981445312 99.56975555419922 94.32344055175781 100.2776794433594 95.14494323730469 100.2776794433594 C 95.96652221679688 100.2776794433594 96.63499450683594 99.56975555419922 96.63499450683594 98.69956970214844 L 96.63499450683594 97.46417236328125 C 96.63491058349609 96.59398651123047 95.96652221679688 95.88605499267578 95.14494323730469 95.88605499267578 Z M 95.68437194824219 98.69948577880859 C 95.68437194824219 99.01460266113281 95.4423828125 99.27082824707031 95.14486694335938 99.27082824707031 C 94.84750366210938 99.27082824707031 94.60551452636719 99.01460266113281 94.60551452636719 98.69948577880859 L 94.60551452636719 97.46408843994141 C 94.60551452636719 97.14913940429688 94.84750366210938 96.89274597167969 95.14486694335938 96.89274597167969 C 95.4423828125 96.89274597167969 95.68437194824219 97.14913940429688 95.68437194824219 97.46408843994141 L 95.68437194824219 98.69948577880859 Z M 87.98193359375 92.90248107910156 C 87.16034698486328 92.90248107910156 86.49195861816406 93.61041259765625 86.49195861816406 94.48051452636719 L 86.49195861816406 95.71599578857422 C 86.49195861816406 96.58609771728516 87.16034698486328 97.29402923583984 87.98193359375 97.29402923583984 C 88.80351257324219 97.29402923583984 89.47189331054688 96.58609771728516 89.47189331054688 95.71599578857422 L 89.47189331054688 94.48051452636719 C 89.47189331054688 93.61041259765625 88.80351257324219 92.90248107910156 87.98193359375 92.90248107910156 Z M 88.5213623046875 95.71591186523438 C 88.5213623046875 96.03094482421875 88.27937316894531 96.28717041015625 87.98193359375 96.28717041015625 C 87.68449401855469 96.28717041015625 87.44249725341797 96.03094482421875 87.44249725341797 95.71591186523438 L 87.44249725341797 94.48043060302734 C 87.44249725341797 94.16548156738281 87.68449401855469 93.90917205810547 87.98193359375 93.90917205810547 C 88.27937316894531 93.90917205810547 88.5213623046875 94.16548156738281 88.5213623046875 94.48043060302734 L 88.5213623046875 95.71591186523438 Z M 91.84507751464844 92.90248107910156 C 91.02357482910156 92.90248107910156 90.35518646240234 93.61041259765625 90.35518646240234 94.48051452636719 L 90.35518646240234 95.71599578857422 C 90.35518646240234 96.58609771728516 91.02357482910156 97.29402923583984 91.84507751464844 97.29402923583984 C 92.66665649414062 97.29402923583984 93.33512115478516 96.58609771728516 93.33512115478516 95.71599578857422 L 93.33512115478516 94.48051452636719 C 93.33512115478516 93.61041259765625 92.66673278808594 92.90248107910156 91.84507751464844 92.90248107910156 Z M 92.38458251953125 95.71591186523438 C 92.38458251953125 96.03094482421875 92.14259338378906 96.28717041015625 91.84507751464844 96.28717041015625 C 91.54771423339844 96.28717041015625 91.30572509765625 96.03094482421875 91.30572509765625 95.71591186523438 L 91.30572509765625 94.48043060302734 C 91.30572509765625 94.16548156738281 91.54771423339844 93.90917205810547 91.84507751464844 93.90917205810547 C 92.14259338378906 93.90917205810547 92.38458251953125 94.16548156738281 92.38458251953125 94.48043060302734 L 92.38458251953125 95.71591186523438 Z" fill="#4ec8dd" stroke="#4ec8dd" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_a7p9a8 =
    '<svg viewBox="150.6 225.5 1.0 1.0" ><path transform="translate(0.0, -105.0)" d="M 150.5888214111328 330.5046081542969" fill="none" stroke="#4ec8dd" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_i3j02g =
    '<svg viewBox="-7.5 128.0 50.0 1.0" ><path transform="translate(-55.49, 74.01)" d="M 48.65689086914062 53.9924201965332 C 48.2294921875 53.9924201965332 47.98928833007812 53.9924201965332 47.98928833007812 53.9924201965332 C 47.98928833007812 53.9924201965332 48.2294921875 53.9924201965332 48.65689086914062 53.9924201965332 L 62.29214477539062 53.99241638183594 C 63.1807861328125 53.99241638183594 64.62149047851562 53.99241638183594 65.51007080078125 53.99241638183594 C 66.39871215820312 53.99241638183594 66.39871215820312 53.99241638183594 65.51007080078125 53.99241638183594 L 55.75177001953125 53.9924201965332 L 95.71670532226562 53.9924201965332 C 96.97183227539062 53.9924201965332 97.98928833007812 53.9924201965332 97.98928833007812 53.9924201965332 C 97.98928833007812 53.9924201965332 96.97183227539062 53.9924201965332 95.71670532226562 53.9924201965332 L 55.75177001953125 53.9924201965332 L 65.51007080078125 53.99242401123047 C 66.39871215820312 53.99242401123047 66.39871215820312 53.99242401123047 65.51007080078125 53.99242401123047 C 64.62149047851562 53.99242401123047 63.1807861328125 53.99242401123047 62.29220581054688 53.99242401123047 L 48.65689086914062 53.9924201965332 Z" fill="#fafafa" stroke="none" stroke-width="12" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
