import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importar Firestore
import 'package:firebase_auth/firebase_auth.dart';     // Importar FirebaseAuth
import 'package:cached_network_image/cached_network_image.dart'; // Para imágenes de red
import 'package:intl/intl.dart'; // Para formatear fechas (necesitarás añadir esto al pubspec.yaml)

// Imports de Navegación y Servicios
import '../services/auth_service.dart';
import './Home.dart';
import './Ayuda.dart';
import './EditarPerfildeAnimal.dart';
import './CrearVacuna.dart'; // Donde creas nuevas vacunas
import './FuncionesdelaApp.dart';
import './Configuracion.dart';
import './ListadeAnimales.dart';
import '../models/animal.dart'; // Importar el modelo Animal
import '../models/carnetvacunacion.dart'; // ¡TU MODELO!

// --- CarnetdeVacunacin Class (StatefulWidget) ---
class CarnetdeVacunacin extends StatefulWidget {
  final String animalId;

  const CarnetdeVacunacin({
    required Key key,
    required this.animalId,
  }) : super(key: key);

  @override
  _CarnetdeVacunacinState createState() => _CarnetdeVacunacinState();
}

// --- _CarnetdeVacunacinState Class ---
class _CarnetdeVacunacinState extends State<CarnetdeVacunacin> {
  // `currentUser` es una propiedad de estado que puede ser nula.
  // La validación de su nulabilidad se hará en el método `build`.
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Constantes de posicionamiento, copiadas de FuncionesdelaApp para consistencia
  static const double logoBottomY = 115.0;
  static const double spaceAfterLogo = 25.0;
  static const double animalProfilePhotoTop = logoBottomY + spaceAfterLogo;
  static const double animalProfilePhotoHeight = 90.0;
  static const double animalNameHeight = 20.0; // Altura aproximada para el nombre
  static const double spaceAfterAnimalProfile = 15.0;
  static const double titleVaccineTop = animalProfilePhotoTop + animalProfilePhotoHeight + animalNameHeight + spaceAfterAnimalProfile;

  // Nueva función para mostrar el cuadro de diálogo de la próxima dosis
  void _showNextDoseDialog(BuildContext context, DateTime nextDoseDate) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          backgroundColor: const Color(0xe3a0f4fe), // Fondo del diálogo
          title: const Text(
            'Recordatorio de Dosis',
            style: TextStyle(
              fontFamily: 'Comic Sans MS',
              fontWeight: FontWeight.w700,
              color: Color(0xff000000),
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Para que el contenido ocupe el mínimo espacio
            children: [
              const Text(
                'La fecha agendada para la próxima dosis es:',
                style: TextStyle(
                  fontFamily: 'Comic Sans MS',
                  fontSize: 18,
                  color: Color(0xff000000),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                DateFormat('dd/MM/yyyy').format(nextDoseDate),
                style: const TextStyle(
                  fontFamily: 'Comic Sans MS',
                  fontSize: 22,
                  color: Color(0xFF0066FF), // Un color azul para la fecha
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cerrar el diálogo
              },
              child: const Text(
                'Entendido',
                style: TextStyle(
                  fontFamily: 'Comic Sans MS',
                  fontSize: 16,
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget para construir una sola tarjeta de vacuna
  Widget _buildVaccineCard(CarnetVacunacion vacuna) {
    // Determinar ícono y color de texto según el estado de la vacuna
    String statusText = 'Aplicada';
    String statusIconPath = 'assets/images/vacunaaplicada.png'; // Por defecto, para "Aplicada"
    Color statusTextColor = Colors.black;
    bool isNextDoseStatus = false; // Bandera para saber si es "Próxima Dosis"

    final now = DateTime.now();

    // Lógica para determinar el estado de la vacuna
    if (vacuna.proximaDosis.isAfter(now.subtract(const Duration(minutes: 1)))) {
      statusText = 'Próxima Dosis';
      statusIconPath = 'assets/images/proximadosis.png'; // <-- CAMBIO: Nuevo icono para próxima dosis
      statusTextColor = const Color(0xFFFFA500); // Naranja
      isNextDoseStatus = true; // Se activa la bandera
    } else if (vacuna.proximaDosis.isBefore(now.subtract(const Duration(days: 1)))) {
      statusText = 'Vencida';
      statusIconPath = 'assets/images/vacunavencida.png'; // ¡Asegúrate de tener esta imagen!
      statusTextColor = Colors.red;
    }
    // Si no entra en ninguna de las anteriores, se mantiene como "Aplicada" y sus colores por defecto.

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xe3a0f4fe), // Color de fondo de la tarjeta
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(width: 1.0, color: const Color(0xe3000000)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0), // Relleno interno para el contenido
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinear texto al inicio
        children: <Widget>[
          // Nombre de la Vacuna
          Text(
            'Vacuna: ${vacuna.nombreVacuna}', // Usar nombreVacuna
            style: const TextStyle(
              fontFamily: 'Comic Sans MS',
              fontSize: 20,
              color: Color(0xff000000),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.start, // Alinear al inicio, no al centro
          ),
          const SizedBox(height: 8), // Espaciado
          // Fecha de Vacunación
          Text(
            'Fecha de Vacunación: ${DateFormat('dd/MM/yyyy').format(vacuna.fechaVacunacion)}',
            style: const TextStyle(
              fontFamily: 'Comic Sans MS',
              fontSize: 18, // Ligeramente más pequeño para detalles
              color: Color(0xff000000),
            ),
          ),
          const SizedBox(height: 4),
          // Próxima Dosis
          Text(
            'Próxima Dosis: ${DateFormat('dd/MM/yyyy').format(vacuna.proximaDosis)}',
            style: const TextStyle(
              fontFamily: 'Comic Sans MS',
              fontSize: 18,
              color: Color(0xff000000),
            ),
          ),
          const SizedBox(height: 4),
          // Lote
          Text(
            'Lote: ${vacuna.lote}',
            style: const TextStyle(
              fontFamily: 'Comic Sans MS',
              fontSize: 18,
              color: Color(0xff000000),
            ),
          ),
          const SizedBox(height: 4),
          // Número de Dosis
          Text(
            'Número de Dosis: ${vacuna.numeroDosis}',
            style: const TextStyle(
              fontFamily: 'Comic Sans MS',
              fontSize: 18,
              color: Color(0xff000000),
            ),
          ),
          const SizedBox(height: 4),
          // Veterinario
          Text(
            'Veterinario: ${vacuna.veterinario}',
            style: const TextStyle(
              fontFamily: 'Comic Sans MS',
              fontSize: 18,
              color: Color(0xff000000),
            ),
          ),
          const Spacer(), // Empuja el icono y el estado hacia abajo
          // Icono y Texto de Estado
          Align(
            alignment: Alignment.center, // Centrar el icono y el texto de estado
            child: Column(
              children: [
                // Si es "Próxima Dosis", el icono es clickable
                isNextDoseStatus
                    ? GestureDetector( // <-- CAMBIO: GestureDetector para el icono
                  onTap: () => _showNextDoseDialog(context, vacuna.proximaDosis),
                  child: Image.asset(
                    statusIconPath,
                    width: 100.0, // Tamaño ajustado del ícono
                    height: 100.0,
                    fit: BoxFit.contain,
                  ),
                )
                    : Image.asset( // Si no, solo el icono sin GestureDetector
                  statusIconPath,
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.contain,
                ),
                Text(
                  statusText,
                  style: TextStyle(
                    fontFamily: 'Comic Sans MS',
                    fontSize: 20,
                    color: statusTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      // Manejar el caso donde no hay usuario autenticado
      return Scaffold(
        backgroundColor: const Color(0xff4ec8dd),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_off, size: 80, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'Usuario no autenticado. Por favor, inicia sesión.',
                style: TextStyle(
                  fontFamily: 'Comic Sans MS',
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Redirigir a la pantalla de inicio de sesión o Home
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Home(key: const Key('Home_NotAuthenticated'))),
                        (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xe3a0f4fe),
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  'Ir a Inicio',
                  style: TextStyle(
                    fontFamily: 'Comic Sans MS',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (widget.animalId.isEmpty) {
      // Manejar el caso donde no se proporcionó un animalId
      return Scaffold(
        backgroundColor: const Color(0xff4ec8dd),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.pets, size: 80, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'No se ha seleccionado un animal. Por favor, selecciona uno.',
                style: TextStyle(
                  fontFamily: 'Comic Sans MS',
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const ListadeAnimales(key: Key('ListaAnimales_NoAnimalId'))),
                        (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xe3a0f4fe),
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  'Ver mis Animales',
                  style: TextStyle(
                    fontFamily: 'Comic Sans MS',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // A partir de aquí, currentUser no puede ser nulo debido a las comprobaciones anteriores.
    // Creamos una variable local para usarlo de forma segura.
    final String currentUserId = currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xff4ec8dd),
      body: Stack(
        children: <Widget>[
          // --- Fondo de Pantalla ---
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // --- Logo de la App (Navega a Home) ---
          Pinned.fromPins(
            Pin(size: 74.0, middle: 0.5), Pin(size: 73.0, start: 42.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Home(key: const Key('Home_From_Carnet')),
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(image: AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 1.0, color: const Color(0xff000000)),
                ),
              ),
            ),
          ),
          // --- Botón de Retroceso (Vuelve a FuncionesdelaApp para este animal) ---
          Pinned.fromPins(
            Pin(size: 52.9, start: 15.0), Pin(size: 50.0, start: 49.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context); // Vuelve a la pantalla anterior
              },
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/back.png'), fit: BoxFit.fill))),
            ),
          ),
          // --- Botón de Ayuda ---
          Pinned.fromPins(
            Pin(size: 40.5, end: 15.0), Pin(size: 50.0, start: 49.0),
            child: PageLink(
              links: [PageLinkInfo(pageBuilder: () => Ayuda(key: const Key('Ayuda_From_Carnet')))],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill))),
            ),
          ),
          // --- Iconos Laterales (Configuración y Lista General de Animales) ---
          Pinned.fromPins(
            Pin(size: 47.2, end: 15.0), Pin(size: 50.0, start: 110.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  pageBuilder: () => Configuraciones(key: const Key('Settings_From_Carnet'), authService: AuthService()),
                ),
              ],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill))),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.1, start: 15.0), Pin(size: 60.0, start: 110.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  pageBuilder: () => const ListadeAnimales(key: Key('ListadeAnimales_From_Carnet')),
                ),
              ],
              child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/listaanimales.png'), fit: BoxFit.fill))),
            ),
          ),

          // --- Foto de Perfil y Nombre del Animal (Reutilizado de FuncionesdelaApp) ---
          Positioned(
            top: animalProfilePhotoTop,
            left: 0,
            right: 0,
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUserId)
                  .collection('animals')
                  .doc(widget.animalId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircleAvatar(radius: 45, backgroundColor: Colors.grey[300], child: const CircularProgressIndicator(strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)))));
                }
                if (snapshot.hasError) {
                  print("Error obteniendo datos del animal: ${snapshot.error}");
                  return Center(child: CircleAvatar(radius: 45, backgroundColor: Colors.red[100], child: Icon(Icons.error_outline, size: 50, color: Colors.red[700])));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  print("Documento del animal (ID: ${widget.animalId}) no encontrado.");
                  return Center(child: CircleAvatar(radius: 45, backgroundColor: Colors.grey[200], child: Icon(Icons.pets, size: 50, color: Colors.grey[400])));
                }

                Animal animalData;
                try {
                  animalData = Animal.fromFirestore(snapshot.data!);
                } catch (e) {
                  print("Error al deserializar datos del animal (ID: ${widget.animalId}): $e. Data: ${snapshot.data!.data()}");
                  return Center(child: CircleAvatar(radius: 45, backgroundColor: Colors.orange[100], child: Icon(Icons.report_problem_outlined, size: 50, color: Colors.orange[700])));
                }

                return Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarPerfildeAnimal(
                            key: Key('EditarPerfilDesdeCarnet_${widget.animalId}'),
                            animalId: widget.animalId,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 90.0, height: 90.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(25.0),
                              border: Border.all(color: Colors.white, width: 2.5),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: Offset(0,3))]
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22.5),
                            child: (animalData.fotoPerfilUrl != null && animalData.fotoPerfilUrl!.isNotEmpty)
                                ? CachedNetworkImage(
                                imageUrl: animalData.fotoPerfilUrl!, fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                                errorWidget: (context, url, error) => Icon(Icons.pets, size: 50, color: Colors.grey[600]))
                                : Icon(Icons.pets, size: 50, color: Colors.grey[600]),
                          ),
                        ),
                        if (animalData.nombre.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              animalData.nombre,
                              style: const TextStyle(
                                  fontFamily: 'Comic Sans MS',
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [Shadow(blurRadius: 1.0, color: Colors.black, offset: Offset(1.0,1.0))]
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // --- Título "Carnet de Vacunación" y Lista de Vacunas con Botón ---
          // Envuelve todo el contenido desplazable en SingleChildScrollView
          Positioned(
            top: titleVaccineTop, // Comienza debajo de la foto del animal
            left: 0,
            right: 0,
            bottom: 0, // Ocupa el resto del espacio disponible, permitiendo el scroll
            child: SingleChildScrollView( // <--- CAMBIO IMPORTANTE: Agregado SingleChildScrollView
              child: Column(
                children: <Widget>[
                  // Título
                  Container(
                    width: 300.0,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: const EdgeInsets.only(bottom: 25.0),
                    decoration: BoxDecoration(
                      color: const Color(0xe3a0f4fe),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                    ),
                    child: const Text(
                      'Carnet de Vacunación',
                      style: TextStyle(fontFamily: 'Comic Sans MS', fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Lista de Vacunas (StreamBuilder)
                  StreamBuilder<QuerySnapshot>( // <--- CAMBIO IMPORTANTE: Eliminado 'Expanded'
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUserId)
                        .collection('animals')
                        .doc(widget.animalId)
                        .collection('vaccinations')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: Padding(
                          padding: EdgeInsets.all(20.0), // Padding para el indicador
                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                        ));
                      }
                      if (snapshot.hasError) {
                        return Center(child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('Error al cargar vacunas: ${snapshot.error}', style: const TextStyle(color: Colors.white)),
                        ));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0), // Padding para el mensaje
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.vaccines, size: 80, color: Colors.grey[400]),
                                const SizedBox(height: 10),
                                const Text(
                                  'No hay vacunas registradas para este animal.',
                                  style: TextStyle(
                                    fontFamily: 'Comic Sans MS',
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final List<CarnetVacunacion> vaccines = snapshot.data!.docs
                          .map((doc) => CarnetVacunacion.fromMap(doc.data() as Map<String, dynamic>))
                          .toList();

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1, // Una columna para tarjetas largas
                          childAspectRatio: 0.9, // Ajusta esto según el tamaño deseado de la tarjeta
                          mainAxisSpacing: 20.0,
                          crossAxisSpacing: 20.0,
                        ),
                        itemCount: vaccines.length,
                        shrinkWrap: true, // <--- CAMBIO IMPORTANTE: Permite al GridView tomar solo el espacio que necesita
                        physics: const NeverScrollableScrollPhysics(), // <--- CAMBIO IMPORTANTE: Deshabilita el scroll propio del GridView
                        itemBuilder: (context, index) {
                          return _buildVaccineCard(vaccines[index]);
                        },
                      );
                    },
                  ),
                  // Botón "Agregar Vacuna"
                  Padding( // <--- CAMBIO IMPORTANTE: Eliminado 'Align', el padding es suficiente
                    padding: const EdgeInsets.only(bottom: 20.0, top: 20.0), // Espacio arriba y abajo para el botón
                    child: SizedBox(
                      width: 152.0,
                      height: 149.0, // Altura que incluye imagen y texto
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CrearVacuna(
                                key: const Key('CrearVacuna'),
                                animalId: widget.animalId,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Use min para ajustar al contenido
                          children: [
                            Image.asset(
                              'assets/images/agregarvacuna.png',
                              width: 120.0,
                              height: 120.0,
                              fit: BoxFit.fill,
                            ),
                            const Text(
                              'Agregar Vacuna',
                              style: TextStyle(
                                fontFamily: 'Comic Sans MS',
                                fontSize: 20,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}