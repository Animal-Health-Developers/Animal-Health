import 'package:animal_health/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './Home.dart';
import 'package:adobe_xd/page_link.dart';
import './Ayuda.dart';
import './PerfilPublico.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import './CompradeProductos.dart';
import './CuidadosyRecomendaciones.dart';
import './Emergencias.dart';
import './Comunidad.dart';
import './Crearpublicaciones.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:developer' as developer;


class GoogleMaps extends StatefulWidget {
  const GoogleMaps({
    required Key key,
  }) : super(key: key);

  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  LatLng? _currentPosition;
  bool _isLoadingLocation = true;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    setState(() {
      _isLoadingLocation = true;
    });

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      developer.log('Location services are disabled.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Los servicios de ubicación están desactivados. Por favor, actívalos.')),
        );
        setState(() { _isLoadingLocation = false; });
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        developer.log('Location permissions are denied');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Los permisos de ubicación fueron denegados.')),
          );
          setState(() { _isLoadingLocation = false; });
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      developer.log('Location permissions are permanently denied, we cannot request permissions.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Los permisos de ubicación están permanentemente denegados. No podemos solicitar permisos.')),
        );
        setState(() { _isLoadingLocation = false; });
      }
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
          _addMarker(_currentPosition!, "Mi Ubicación", "Estás aquí");
        });
        _goToCurrentLocation();
      }
    } catch (e) {
      developer.log("Error obteniendo ubicación: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener la ubicación: $e')),
        );
        setState(() { _isLoadingLocation = false; });
      }
    }
  }

  void _addMarker(LatLng position, String markerId, String snippet) {
    final Marker marker = Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(
        title: markerId,
        snippet: snippet,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );
    if (mounted) {
      setState(() {
        _markers.add(marker);
      });
    }
  }

  Future<void> _goToCurrentLocation() async {
    if (_currentPosition == null) return;
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: _currentPosition!,
        zoom: 15.0,
      ),
    ));
  }

  Widget _buildNavigationButtonItem({
    required String imagePath,
    bool isHighlighted = false,
    double? fixedWidth,
    double height = 60.0,
  }) {
    double itemWidth;
    if (fixedWidth != null) {
      itemWidth = fixedWidth;
    } else {
      if (imagePath.contains('noticias')) itemWidth = 54.3;
      else if (imagePath.contains('cuidadosrecomendaciones')) itemWidth = 63.0;
      else if (imagePath.contains('emergencias')) itemWidth = 65.0;
      else if (imagePath.contains('comunidad')) itemWidth = 67.0;
      else if (imagePath.contains('crearpublicacion')) itemWidth = 53.6;
      else itemWidth = 60.0;
    }

    return Container(
      width: itemWidth,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.fill,
        ),
        boxShadow: isHighlighted
            ? const [BoxShadow(color: Color(0xffa3f0fb), offset: Offset(0, 3), blurRadius: 6)]
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double navBarTopPosition = 200.0;
    const double navBarHeight = 60.0;
    const double spaceBelowNavBar = 20.0;
    final double topOffsetForMapContainer = navBarTopPosition + navBarHeight + spaceBelowNavBar;

    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'assets/images/Animal Health Fondo de Pantalla.png',
              fit: BoxFit.cover,
            ),
          ),
          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5),
            Pin(size: 73.0, start: 42.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Home(key: Key('Home')))],
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: const AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 1.0, color: const Color(0xff000000)),
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 40.5, middle: 0.8328),
            Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Ayuda(key: Key('Ayuda')))],
              child: Container(
                decoration: BoxDecoration(image: DecorationImage(image: const AssetImage('assets/images/help.png'), fit: BoxFit.fill)),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 307.0, middle: 0.5),
            Pin(size: 45.0, start: 150.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Image.asset('assets/images/busqueda1.png', width: 24.0, height: 24.0),
                  ),
                  const Expanded(
                    child: TextField(
                      style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Color(0xff000000)),
                      decoration: InputDecoration(
                        hintText: 'Buscar lugares...',
                        hintStyle: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 18, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.0, start: 6.0),
            Pin(size: 60.0, middle: 0.1947),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
              builder: (context, snapshot) {
                final profilePhotoUrl = snapshot.data?['profilePhotoUrl'] as String?;
                return PageLink(
                  links: [PageLinkInfo(pageBuilder: () => PerfilPublico(key: Key('PerfilPublico')))],
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.grey[200]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: profilePhotoUrl != null && profilePhotoUrl.isNotEmpty
                          ? CachedNetworkImage(
                        imageUrl: profilePhotoUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)))),
                        errorWidget: (context, url, error) => const Icon(Icons.person, size: 30, color: Colors.grey),
                      )
                          : const Icon(Icons.person, size: 30, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
          // Botón de configuración
          Pinned.fromPins(
            Pin(size: 47.2, end: 7.6),
            Pin(size: 50.0, start: 49.0), // Su posición original
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Configuraciones(key: const Key('Settings'), authService: AuthService()))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill))),
            ),
          ),
          // Botón de lista de animales
          Pinned.fromPins(
            Pin(size: 60.1, start: 6.0),
            Pin(size: 60.0, start: 44.0), // Su posición original
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const ListadeAnimales(key: Key('ListadeAnimales')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/listaanimales.png'), fit: BoxFit.fill))),
            ),
          ),
          // Botón de tienda
          Pinned.fromPins(
            Pin(size: 58.5, end: 2.0),
            Pin(size: 60.0, start: 105.0), // Su posición original
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => const CompradeProductos(key: Key('CompradeProductos')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/store.png'), fit: BoxFit.fill))),
            ),
          ),
          // --- FIN DE BOTONES RESTAURADOS ---

          // Botones de navegación superior
          Positioned(
            top: navBarTopPosition,
            left: 16.0,
            right: 16.0,
            height: navBarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                PageLink(
                  links: [PageLinkInfo(pageBuilder: () => Home(key: const Key('Home')))],
                  child: _buildNavigationButtonItem(imagePath: 'assets/images/noticias.png', fixedWidth: 54.3),
                ),
                PageLink(
                  links: [PageLinkInfo(pageBuilder: () => CuidadosyRecomendaciones(key: const Key('CuidadosyRecomendaciones')))],
                  child: _buildNavigationButtonItem(imagePath: 'assets/images/cuidadosrecomendaciones.png', fixedWidth: 63.0),
                ),
                PageLink(
                  links: [PageLinkInfo(pageBuilder: () => const Emergencias(key: Key('Emergencias')))],
                  child: _buildNavigationButtonItem(imagePath: 'assets/images/emergencias.png', isHighlighted: true, fixedWidth: 65.0),
                ),
                PageLink(
                  links: [PageLinkInfo(pageBuilder: () => Comunidad(key: const Key('Comunidad')))],
                  child: _buildNavigationButtonItem(imagePath: 'assets/images/comunidad.png', fixedWidth: 67.0),
                ),
                PageLink(
                  links: [PageLinkInfo(pageBuilder: () => Crearpublicaciones(key: const Key('Crearpublicaciones')))],
                  child: _buildNavigationButtonItem(imagePath: 'assets/images/crearpublicacion.png', fixedWidth: 53.6),
                ),
              ],
            ),
          ),
          Positioned(
            top: topOffsetForMapContainer,
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Column(
              children: [
                Container(
                  width: 143.0,
                  height: 30.0,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xe3a0f4fe),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                  ),
                  child: const Center(
                    child: Text(
                      'Google Maps',
                      style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 15, color: Color(0xff000000), fontWeight: FontWeight.w700),
                      softWrap: false,
                    ),
                  ),
                ),
                Expanded(
                  child: _isLoadingLocation
                      ? const Center(child: CircularProgressIndicator())
                      : GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _currentPosition != null
                        ? CameraPosition(target: _currentPosition!, zoom: 15)
                        : _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      if (!_controller.isCompleted) {
                        _controller.complete(controller);
                      }
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    markers: _markers,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Image.asset('assets/images/buscargoogle.png', width: 50, height: 50),
                        tooltip: "Buscar en mapa",
                        onPressed: () { /* Lógica para buscar en el mapa */ },
                      ),
                      IconButton(
                        icon: Image.asset('assets/images/agregarubicacion.png', width: 50, height: 50),
                        tooltip: "Agregar Ubicación",
                        onPressed: () { /* Lógica para agregar un lugar */ },
                      ),
                      IconButton(
                        icon: Image.asset('assets/images/agregarfotosgooglemaps.png', width: 50, height: 50),
                        tooltip: "Agregar Fotos",
                        onPressed: () { /* Lógica para agregar fotos al mapa/lugar */ },
                      ),
                      IconButton(
                        icon: Image.asset('assets/images/enviarubicacionamigos.png', width: 50, height: 50),
                        tooltip: "Compartir Ubicación",
                        onPressed: () { /* Lógica para compartir ubicación */ },
                      ),
                    ],
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