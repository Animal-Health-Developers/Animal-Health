import 'package:animal_health/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importar Firestore
import 'package:firebase_auth/firebase_auth.dart';     // Importar FirebaseAuth
import 'package:cached_network_image/cached_network_image.dart'; // Para imágenes de red
import 'package:intl/intl.dart'; // Para formatear fechas

// Imports de Navegación y Servicios
import './Home.dart';
import './Ayuda.dart';
import './EditarPerfildeAnimal.dart';
import './CrearVacuna.dart'; // Donde creas nuevas vacunas
import './Configuracion.dart';
import './ListadeAnimales.dart';
import '../models/animal.dart'; // Importar el modelo Animal
import '../models/carnetvacunacion.dart'; // ¡TU MODELO!
import 'dart:developer' as developer; // Para logs

// --- CarnetdeVacunacion Class (StatefulWidget) ---
class CarnetdeVacunacion extends StatefulWidget {
  final String animalId;

  const CarnetdeVacunacion({
    required Key key,
    required this.animalId,
  }) : super(key: key);

  @override
  _CarnetdeVacunacionState createState() => _CarnetdeVacunacionState();
}

// --- _CarnetdeVacunacionState Class (Esta es la definición correcta) ---
class _CarnetdeVacunacionState extends State<CarnetdeVacunacion> {
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

  // NUEVO: Función para eliminar una vacuna
  Future<void> _deleteVaccine(String vaccineId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario no autenticado. Por favor, inicie sesión.', style: TextStyle(fontFamily: 'Comic Sans MS'))),
        );
      }
      return;
    }

    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xe3a0f4fe),
          title: const Text('Confirmar Eliminación', style: TextStyle(fontFamily: 'Comic Sans MS', color: Colors.black)),
          content: const Text('¿Estás seguro de que quieres eliminar esta vacuna? Esta acción no se puede deshacer.', style: TextStyle(fontFamily: 'Comic Sans MS', color: Colors.black)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(fontFamily: 'Comic Sans MS', color: Colors.grey)),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar', style: TextStyle(fontFamily: 'Comic Sans MS')),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('animals')
            .doc(widget.animalId)
            .collection('vaccinations')
            .doc(vaccineId)
            .delete();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vacuna eliminada correctamente.', style: TextStyle(fontFamily: 'Comic Sans MS')), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        developer.log('Error al eliminar la vacuna: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar la vacuna: $e', style: const TextStyle(fontFamily: 'Comic Sans MS')), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  // NUEVO: Función para mostrar el modal de edición de vacuna
  Future<void> _showEditVaccineModal(String vaccineId, Map<String, dynamic> vaccineData) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Esto es clave para que el modal ocupe casi toda la pantalla
      backgroundColor: Colors.transparent, // Permite que el ClipRRect del modal tenga un fondo transparente
      builder: (BuildContext modalContext) {
        return _EditarVacunaModalWidget(
          key: Key('edit_vaccine_modal_$vaccineId'),
          animalId: widget.animalId,
          vaccineId: vaccineId,
          vaccineData: vaccineData,
        );
      },
    );

    if (result == true) {
      // Si el modal devuelve true (éxito al guardar), forzamos una actualización de la UI
      setState(() {});
    }
  }

  // Widget para construir una sola tarjeta de vacuna (MODIFICADO para incluir botones y Tooltips)
  Widget _buildVaccineCard(CarnetVacunacion vacuna, String vaccineId) {
    // Determinar ícono y color de texto según el estado de la vacuna
    String statusText = 'Aplicada';
    String statusIconPath = 'assets/images/vacunaaplicada.png'; // Por defecto, para "Aplicada"
    Color statusTextColor = Colors.black;
    bool isNextDoseStatus = false; // Bandera para saber si es "Próxima Dosis"
    String statusTooltipMessage = 'Vacuna aplicada con éxito'; // Tooltip por defecto

    final now = DateTime.now();

    // Lógica para determinar el estado de la vacuna
    if (vacuna.proximaDosis.isAfter(now.subtract(const Duration(minutes: 1)))) {
      statusText = 'Próxima Dosis';
      statusIconPath = 'assets/images/proximadosis.png';
      statusTextColor = const Color(0xFFFFA500); // Naranja
      isNextDoseStatus = true; // Se activa la bandera
      statusTooltipMessage = 'Toca para ver la fecha de la próxima dosis';
    } else if (vacuna.proximaDosis.isBefore(now.subtract(const Duration(days: 1)))) {
      statusText = 'Vencida';
      statusIconPath = 'assets/images/vacunavencida.png';
      statusTextColor = Colors.red;
      statusTooltipMessage = 'La vacuna está vencida';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      width: 404.0, // Tamaño similar a las tarjetas de visita
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
      child: Stack( // Usamos Stack para posicionar los botones
        children: <Widget>[
          Column( // El contenido existente va dentro de este Column
            crossAxisAlignment: CrossAxisAlignment.start, // Alinear texto al inicio
            children: <Widget>[
              // Nombre de la Vacuna
              Text(
                'Vacuna: ${vacuna.nombreVacuna}',
                style: const TextStyle(
                  fontFamily: 'Comic Sans MS',
                  fontSize: 20,
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 8),
              // Fecha de Vacunación
              Text(
                'Fecha de Vacunación: ${DateFormat('dd/MM/yyyy').format(vacuna.fechaVacunacion)}',
                style: const TextStyle(
                  fontFamily: 'Comic Sans MS',
                  fontSize: 18,
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
                    Tooltip( // Tooltip para el icono de estado de la vacuna
                      message: statusTooltipMessage,
                      child: isNextDoseStatus
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
          Positioned( // Posicionamos los botones en la esquina superior derecha
            top: 0,
            right: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min, // Para que la fila ocupe el mínimo espacio
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/images/editar.png', // Reutiliza el icono de editar
                    height: 35,
                    width: 35,
                  ),
                  tooltip: 'Editar vacuna',
                  onPressed: () => _showEditVaccineModal(vaccineId, vacuna.toMap()), // Pasa los datos como un mapa
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/images/eliminar.png', // Reutiliza el icono de eliminar
                    height: 35,
                    width: 35,
                  ),
                  tooltip: 'Eliminar vacuna',
                  onPressed: () => _deleteVaccine(vaccineId),
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
            child: Tooltip( // Tooltip añadido
              message: 'Ir a Inicio',
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
          ),
          // --- Botón de Retroceso (Vuelve a FuncionesdelaApp para este animal) ---
          Pinned.fromPins(
            Pin(size: 52.9, start: 15.0), Pin(size: 50.0, start: 49.0),
            child: Tooltip( // Tooltip añadido
              message: 'Volver a la pantalla anterior',
              child: InkWell(
                onTap: () {
                  Navigator.pop(context); // Vuelve a la pantalla anterior
                },
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/back.png'), fit: BoxFit.fill))),
              ),
            ),
          ),
          // --- Botón de Ayuda ---
          Pinned.fromPins(
            Pin(size: 40.5, end: 15.0), Pin(size: 50.0, start: 49.0),
            child: Tooltip( // Tooltip añadido
              message: 'Ayuda y Soporte',
              child: PageLink(
                links: [PageLinkInfo(pageBuilder: () => Ayuda(key: const Key('Ayuda_From_Carnet')))],
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/help.png'), fit: BoxFit.fill))),
              ),
            ),
          ),
          // --- Iconos Laterales (Configuración y Lista General de Animales) ---
          Pinned.fromPins(
            Pin(size: 47.2, end: 15.0), Pin(size: 50.0, start: 110.0),
            child: Tooltip( // Tooltip añadido
              message: 'Configuraciones de la Aplicación',
              child: PageLink(
                links: [
                  PageLinkInfo(
                    pageBuilder: () => Configuraciones(key: const Key('Settings_From_Carnet'), authService: AuthService()),
                  ),
                ],
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/settingsbutton.png'), fit: BoxFit.fill))),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 60.1, start: 15.0), Pin(size: 60.0, start: 110.0),
            child: Tooltip( // Tooltip añadido
              message: 'Ver todos mis animales',
              child: PageLink(
                links: [
                  PageLinkInfo(
                    pageBuilder: () => const ListadeAnimales(key: Key('ListadeAnimales_From_Carnet')),
                  ),
                ],
                child: Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/listaanimales.png'), fit: BoxFit.fill))),
              ),
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
                  developer.log("Error obteniendo datos del animal: ${snapshot.error}");
                  return Center(child: CircleAvatar(radius: 45, backgroundColor: Colors.red[100], child: Icon(Icons.error_outline, size: 50, color: Colors.red[700])));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  developer.log("Documento del animal (ID: ${widget.animalId}) no encontrado.");
                  return Center(child: CircleAvatar(radius: 45, backgroundColor: Colors.grey[200], child: Icon(Icons.pets, size: 50, color: Colors.grey[400])));
                }

                Animal animalData;
                try {
                  animalData = Animal.fromFirestore(snapshot.data!);
                } catch (e) {
                  developer.log("Error al deserializar datos del animal (ID: ${widget.animalId}): $e. Data: ${snapshot.data!.data()}");
                  return Center(child: CircleAvatar(radius: 45, backgroundColor: Colors.orange[100], child: Icon(Icons.report_problem_outlined, size: 50, color: Colors.orange[700])));
                }

                return Center(
                  child: Tooltip( // Tooltip añadido para la foto de perfil
                    message: 'Editar perfil de ${animalData.nombre}',
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
                              child: (animalData.fotoPerfilUrl.isNotEmpty)
                                  ? CachedNetworkImage(
                                imageUrl: animalData.fotoPerfilUrl, fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                                errorWidget: (context, url, error) => Icon(Icons.pets, size: 50, color: Colors.grey[600]),
                              )
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
            child: SingleChildScrollView(
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
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUserId) // current user ya es seguro aquí
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
                        developer.log('Error al cargar vacunas: ${snapshot.error}');
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
                                Tooltip( // Tooltip para el icono de vacunas
                                  message: 'No hay vacunas registradas',
                                  child: Icon(Icons.vaccines, size: 80, color: Colors.grey[400]),
                                ),
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

                      final List<Map<String, dynamic>> vaccinesWithIds = snapshot.data!.docs.map((doc) {
                        return {
                          'id': doc.id,
                          'data': doc.data(),
                        };
                      }).toList();


                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1, // Una columna para tarjetas largas
                          childAspectRatio: 0.9, // Ajusta esto según el tamaño deseado de la tarjeta
                          mainAxisSpacing: 20.0,
                          crossAxisSpacing: 20.0,
                        ),
                        itemCount: vaccinesWithIds.length,
                        shrinkWrap: true, // <--- CAMBIO IMPORTANTE: Permite al GridView tomar solo el espacio que necesita
                        physics: const NeverScrollableScrollPhysics(), // <--- CAMBIO IMPORTANTE: Deshabilita el scroll propio del GridView
                        itemBuilder: (context, index) {
                          var vaccineData = vaccinesWithIds[index]['data'];
                          var vaccineId = vaccinesWithIds[index]['id'];
                          CarnetVacunacion vaccine = CarnetVacunacion.fromMap(vaccineData);
                          return _buildVaccineCard(vaccine, vaccineId);
                        },
                      );
                    },
                  ),
                  // Botón "Agregar Vacuna"
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, top: 20.0), // Espacio arriba y abajo para el botón
                    child: SizedBox(
                      width: 152.0,
                      height: 149.0, // Altura que incluye imagen y texto
                      child: Tooltip( // Tooltip para el botón de agregar vacuna
                        message: 'Agregar una nueva vacuna',
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

// =============================================================================
// INICIO DEL WIDGET DE MODAL DE EDICIÓN DE VACUNAS
// (Copiado y adaptado de CrearVacuna y _EditarVisitaVeterinariaModalWidget)
// =============================================================================

class _EditarVacunaModalWidget extends StatefulWidget {
  final String animalId;
  final String vaccineId;
  final Map<String, dynamic> vaccineData; // Datos de la vacuna a editar

  const _EditarVacunaModalWidget({
    required Key key,
    required this.animalId,
    required this.vaccineId,
    required this.vaccineData,
  }) : super(key: key);

  @override
  __EditarVacunaModalWidgetState createState() => __EditarVacunaModalWidgetState();
}

class __EditarVacunaModalWidgetState extends State<_EditarVacunaModalWidget> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos del formulario de vacuna
  late TextEditingController _nombreVacunaController;
  late TextEditingController _loteController;
  late TextEditingController _veterinarioController;
  late TextEditingController _numeroDosisController;

  // Variables y controladores para Fecha y Hora
  late TextEditingController _fechaVacunacionController;
  late TextEditingController _proximaDosisController;

  DateTime? _selectedFechaVacunacion;
  DateTime? _selectedProximaDosis;

  bool _isLoadingAnimal = true; // Para la carga inicial de datos del animal
  bool _isSaving = false; // Para el estado de guardado

  Animal? _animalData; // Para almacenar los datos del animal para mostrar en el encabezado

  // Constantes de diseño para los campos del formulario, tomadas de VisitasalVeterinario/CrearVisitasVet

  // NUEVA FUNCIÓN: Helper para convertir dynamic a String de forma segura
  String _safeString(dynamic value) {
    if (value == null) {
      return '';
    }
    // Si ya es un String, úsalo directamente.
    if (value is String) {
      return value;
    }
    // Si es un número (int, double), conviértelo a String.
    if (value is num) {
      return value.toString();
    }
    // Si es un Timestamp (o cualquier otro tipo inesperado), conviértelo a String.
    // Esto es crucial para manejar el error de Timestamp.
    return value.toString();
  }


  @override
  void initState() {
    super.initState();
    _initializeControllers(); // Inicializar los controladores con los datos existentes
    _loadAnimalData(); // Cargar los datos del animal para mostrar en el encabezado
  }

  // Método para inicializar todos los TextEditingController y variables de estado
  void _initializeControllers() {
    // Helper para parsear la fecha de forma robusta
    DateTime? parseIncomingDate(dynamic rawDate) {
      if (rawDate is Timestamp) {
        return rawDate.toDate(); // Convierte Timestamp a DateTime
      } else if (rawDate is DateTime) {
        return rawDate; // Si ya es DateTime, úsalo directamente
      }
      // Manejar el caso en que rawDate sea nulo o de un tipo inesperado
      developer.log('Advertencia: Valor de fecha inesperado para inicializar controlador: $rawDate. Usando DateTime.now()');
      return DateTime.now(); // Fallback seguro
    }

    // 1. Inicializar las fechas a partir de widget.vaccineData (más robusto)
    _selectedFechaVacunacion = parseIncomingDate(widget.vaccineData['fechaVacunacion']) ?? DateTime.now();
    _selectedProximaDosis = parseIncomingDate(widget.vaccineData['proximaDosis']) ?? DateTime.now().add(const Duration(days: 365));

    // 2. Inicializar TextEditingControllers con los valores pre-existentes
    // CAMBIO AQUI: Utiliza _safeString() para asegurar que siempre se asigne un String al TextEditingController.
    _nombreVacunaController = TextEditingController(text: _safeString(widget.vaccineData['nombreVacuna']));
    _loteController = TextEditingController(text: _safeString(widget.vaccineData['lote']));
    _veterinarioController = TextEditingController(text: _safeString(widget.vaccineData['veterinario']));
    _numeroDosisController = TextEditingController(text: _safeString(widget.vaccineData['numeroDosis'])); // num to String

    // Inicializar controladores de fecha (Estos ya eran correctos porque formatean DateTime a String)
    _fechaVacunacionController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(_selectedFechaVacunacion!));
    _proximaDosisController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(_selectedProximaDosis!));
  }

  // Carga los datos del animal para mostrar su foto y nombre en el modal
  Future<void> _loadAnimalData() async {
    setState(() {
      _isLoadingAnimal = true;
    });
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null && widget.animalId.isNotEmpty) {
        final animalDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('animals')
            .doc(widget.animalId)
            .get();
        if (animalDoc.exists) {
          _animalData = Animal.fromFirestore(animalDoc);
        } else {
          developer.log("Documento del animal con ID ${widget.animalId} no encontrado.");
        }
      } else {
        developer.log("Usuario no autenticado o animalId vacío.");
      }
    } catch (e) {
      developer.log("Error cargando datos del animal para editar vacuna: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAnimal = false;
        });
      }
    }
  }

  // Método para seleccionar fecha (adaptado al estilo de CrearVisitasVet)
  Future<void> _selectDate(BuildContext context, {required bool isVaccinationDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isVaccinationDate ? (_selectedFechaVacunacion ?? DateTime.now()) : (_selectedProximaDosis ?? DateTime.now().add(const Duration(days: 365))),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff4ec8dd),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isVaccinationDate) {
          _selectedFechaVacunacion = picked;
          _fechaVacunacionController.text = DateFormat('dd/MM/yyyy').format(picked);
        } else {
          _selectedProximaDosis = picked;
          _proximaDosisController.text = DateFormat('dd/MM/yyyy').format(picked);
        }
      });
    }
  }

  // Lógica para actualizar la vacuna en Firestore
  Future<void> _updateVacuna() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!mounted) return;
    setState(() {
      _isSaving = true;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario no autenticado. Por favor, inicie sesión.')));
        Navigator.pop(context);
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('animals')
          .doc(widget.animalId)
          .collection('vaccinations')
          .doc(widget.vaccineId) // Especificamos el documento a actualizar
          .update({ // Usamos update en lugar de add
        'nombreVacuna': _nombreVacunaController.text.trim(),
        'fechaVacunacion': _selectedFechaVacunacion,
        'lote': _loteController.text.trim(),
        'veterinario': _veterinarioController.text.trim(),
        'numeroDosis': int.tryParse(_numeroDosisController.text.trim()) ?? 1,
        'proximaDosis': _selectedProximaDosis,
        'lastUpdated': FieldValue.serverTimestamp(), // Añadir un timestamp de última actualización
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vacuna actualizada con éxito!')));
        Navigator.pop(context, true); // Cerramos el modal indicando éxito
      }
    } catch (e) {
      developer.log("Error al actualizar vacuna: $e");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar vacuna: $e')));
    } finally {
      if (mounted) {
        setState(() {
        _isSaving = false;
      });
      }
    }
  }

  @override
  void dispose() {
    _nombreVacunaController.dispose();
    _loteController.dispose();
    _veterinarioController.dispose();
    _numeroDosisController.dispose();
    _fechaVacunacionController.dispose();
    _proximaDosisController.dispose();
    super.dispose();
  }

  // Helper para construir campos de formulario (Copiado de _EditarVisitaVeterinariaModalWidget para consistencia)
  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String iconAsset,
    required String tooltipMessage, // Nuevo parámetro para el Tooltip
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    int? maxLines = 1,
    Widget? suffixIcon,
  }) {
    const double iconSize = 42.0;
    const double iconLeftPadding = 10.0;
    const double textFieldLeftPadding = iconLeftPadding + iconSize + 10.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 18.0),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(fontFamily: 'Comic Sans MS', fontSize: 15, color: Colors.black87),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(fontFamily: 'Comic Sans MS', color: Colors.black54, fontSize: 15),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade400)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade500)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5)),
              filled: true,
              fillColor: readOnly ? Colors.grey[200] : Colors.white.withOpacity(0.9),
              contentPadding: EdgeInsets.only(left: textFieldLeftPadding, top: maxLines! > 1 ? 18 : 18, bottom: maxLines > 1 ? 18 : 18, right: 15),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffixIcon: suffixIcon,
            ),
            validator: validator,
          ),
          Padding(
            padding: EdgeInsets.only(left: iconLeftPadding),
            child: Tooltip( // Tooltip para el icono del campo de formulario
              message: tooltipMessage,
              child: Image.asset(
                iconAsset,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  developer.log("Error cargando icono de formulario: $iconAsset, $error");
                  return Icon(Icons.error_outline, color: Colors.red, size: iconSize - 10);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Función para mostrar imagen grande (reutilizada de VisitasalVeterinario)
  void _showLargeImage(String imageUrl) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff4ec8dd)))),
      errorWidget: (context, url, error) =>
      const Icon(Icons.error, size: 100, color: Colors.grey),
    );

    showDialog(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.9),
                  child: imageWidget,
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double animalPhotoSize = 90.0;
    const double animalNameHeight = 20.0;
    const double spaceAfterAnimalPhoto = 20.0;
    // La altura que ocupa la foto del animal y su nombre dentro del modal
    final double headerHeight = animalPhotoSize + animalNameHeight + spaceAfterAnimalPhoto;
    // Posición superior del formulario principal, dejando espacio para el AppBar y el encabezado del animal
    final double mainContentTopPadding = AppBar().preferredSize.height + headerHeight + 20; // 20 es un margen adicional

    return FractionallySizedBox(
      heightFactor: 0.92, // Ocupar 92% de la altura de la pantalla
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent, // Fondo transparente para que se vea la imagen de fondo
          appBar: AppBar(
            title: const Text('Editar Vacuna', style: TextStyle(fontFamily: 'Comic Sans MS', color: Colors.white)),
            backgroundColor: const Color(0xff4ec8dd),
            elevation: 1,
            automaticallyImplyLeading: false, // No mostrar el botón de retroceso por defecto de AppBar
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(), // Botón para cerrar el modal
              )
            ],
          ),
          body: Stack(
            children: <Widget>[
              // Imagen de fondo (reutilizada de tus pantallas)
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Animal Health Fondo de Pantalla.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Foto y Nombre del Animal (similar a CrearVacuna y _EditarVisitaVeterinariaModalWidget)
              Positioned(
                // Posicionado justo debajo del AppBar del modal
                top: 0,
                left: 0,
                right: 0,
                child: _isLoadingAnimal
                    ? Center(child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(const Color(0xff4ec8dd))),
                ))
                    : _animalData != null
                    ? Center(
                  child: Tooltip( // Tooltip para la foto del animal en el modal
                    message: 'Ver perfil de ${_animalData!.nombre}',
                    child: GestureDetector(
                      onTap: (_animalData!.fotoPerfilUrl.isNotEmpty)
                          ? () => _showLargeImage(_animalData!.fotoPerfilUrl)
                          : null,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: animalPhotoSize, height: animalPhotoSize,
                            margin: const EdgeInsets.only(top: 20.0), // Margen desde el AppBar del modal
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(color: Colors.white, width: 2.5),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: Offset(0,3))]
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(22.5),
                              child: (_animalData!.fotoPerfilUrl.isNotEmpty)
                                  ? CachedNetworkImage(
                                imageUrl: _animalData!.fotoPerfilUrl, fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                                errorWidget: (context, url, error) => Icon(Icons.pets, size: 50, color: Colors.grey[600]),
                              )
                                  : const Icon(Icons.pets, size: 50, color: Colors.grey),
                            ),
                          ),
                          if (_animalData!.nombre.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _animalData!.nombre,
                                style: TextStyle(
                                    fontFamily: 'Comic Sans MS',
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [Shadow(blurRadius: 1.0, color: Colors.black.withOpacity(0.5), offset: Offset(1.0,1.0))]
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
                    : const SizedBox.shrink(), // O un placeholder mientras carga
              ),

              // Área de contenido principal para el formulario
              Positioned(
                top: mainContentTopPadding, // Posición superior ajustada debajo de la foto del animal y el AppBar
                left: 20,
                right: 20,
                bottom: 0, // Ocupar todo el espacio restante hacia abajo
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        // Título del formulario
                        Container(
                          width: 229.0,
                          height: 35.0,
                          decoration: BoxDecoration(
                            color: const Color(0xe3a0f4fe),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 1.0, color: const Color(0xe3000000)),
                          ),
                          child: const Center(
                            child: Text(
                              'Editar Vacuna',
                              style: TextStyle(
                                fontFamily: 'Comic Sans MS',
                                fontSize: 20,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: false,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Nombre de Vacuna
                        _buildFormField(
                          controller: _nombreVacunaController,
                          label: 'Nombre de Vacuna',
                          iconAsset: 'assets/images/nombrevacuna.png',
                          validator: (value) => value!.isEmpty ? 'Por favor ingrese el nombre de la vacuna' : null,
                          tooltipMessage: 'Nombre de la vacuna aplicada',
                        ),
                        // Fecha de Vacunación
                        _buildFormField(
                          controller: _fechaVacunacionController,
                          label: 'Fecha de Vacunación',
                          iconAsset: 'assets/images/edad.png', // Corrected icon
                          readOnly: true,
                          onTap: () => _selectDate(context, isVaccinationDate: true),
                          suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                          tooltipMessage: 'Fecha en la que se aplicó la vacuna',
                        ),
                        // Próxima Dosis
                        _buildFormField(
                          controller: _proximaDosisController,
                          label: 'Próxima Dosis',
                          iconAsset: 'assets/images/edad.png', // Corrected icon
                          readOnly: true,
                          onTap: () => _selectDate(context, isVaccinationDate: false),
                          suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                          tooltipMessage: 'Fecha estimada para la próxima dosis de la vacuna',
                        ),
                        // Lote
                        _buildFormField(
                          controller: _loteController,
                          label: 'Lote',
                          iconAsset: 'assets/images/lote.png',
                          validator: (value) => value!.isEmpty ? 'Por favor ingrese el lote' : null,
                          tooltipMessage: 'Número de lote de la vacuna',
                        ),
                        // Número de Dosis
                        _buildFormField(
                          controller: _numeroDosisController,
                          label: 'Número de Dosis',
                          iconAsset: 'assets/images/dosis.png',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) return 'Por favor ingrese el número de dosis';
                            if (int.tryParse(value) == null || int.parse(value) <= 0) return 'Ingrese un número válido (mayor a 0)';
                            return null;
                          },
                          tooltipMessage: 'Número de dosis aplicada (ej: 1, 2, 3)',
                        ),
                        // Veterinario
                        _buildFormField(
                          controller: _veterinarioController,
                          label: 'Veterinario',
                          iconAsset: 'assets/images/veterinario.png',
                          validator: (value) => value!.isEmpty ? 'Por favor ingrese el nombre del veterinario' : null,
                          tooltipMessage: 'Nombre del veterinario que aplicó la vacuna',
                        ),
                        const SizedBox(height: 30),

                        // Botón Guardar Vacuna
                        Tooltip( // Tooltip para el botón de guardar
                          message: 'Guardar los cambios de la vacuna',
                          child: GestureDetector(
                            onTap: _isSaving ? null : _updateVacuna,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/agregarvacuna.png', // Reutilizando el icono de agregar vacuna
                                  width: 120.0,
                                  height: 120.0,
                                  fit: BoxFit.fill,
                                ),
                                if (_isSaving) const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30), // Espacio al final
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}