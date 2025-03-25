import '../models/animal.dart';
import '../models/carnetvacunacion.dart';
import '../models/historia_clinica.dart';
import '../models/products.dart';
class Objects {
    Animal  nuevoAnimal = Animal(
      nombre: "onyx",
      especie: "Gato",
      fechaNacimiento: DateTime(2019, 03, 13),
      peso: 6.0,
      largo: 0.47,
      ancho: 0.17,
      carnetVacunacion: CarnetVacunacion(
          nombreVacuna: 'PENTA',
          fechaVacunacion: DateTime(2023, 11, 15),
          lote: "67890",
          veterinario: 'Dra. Gómez',
          numeroDosis: 2,
          proximaDosis: DateTime(2024, 2, 15)),
      historia_clinica: HistoriaClinica(
          vacunas: [CarnetVacunacion(
              nombreVacuna: 'AntiRabica',
              fechaVacunacion: DateTime(2024, 06, 15),
              lote: '61327',
              veterinario: 'Dra. Gómez',
              numeroDosis: 1,
              proximaDosis: DateTime(2024, 12, 15))],
          enfermedades: ['Otitis'],
          tratamientos: ['Antibiótico amoxicilina','Desametasona'],
          alergias: ['Polen'],
          visitas: {
            DateTime(2023, 10, 20): 'Revisión anual',
            DateTime(2023, 12, 5): 'Consulta por otitis',
          },
          examenes: {
            'Hemograma': {
              'Fecha': DateTime(2023, 11, 15),
              'Resultados': 'Dentro de los parámetros normales'
            }
          }),
      fotoperfil: "foto_Onyx"
  );
  Animal updateAnimal = Animal(
      nombre: "onyx",
      especie: "Gato",
      fechaNacimiento: DateTime(2019, 03, 13),
      peso: 6.0,
      largo: 0.47,
      ancho: 0.17,
      carnetVacunacion: CarnetVacunacion(
          nombreVacuna: 'PENTA',
          fechaVacunacion: DateTime(2023, 11, 15),
          lote: "67890",
          veterinario: 'Dra. Gómez',
          numeroDosis: 2,
          proximaDosis: DateTime(2024, 2, 15)),
      historia_clinica: HistoriaClinica(
          vacunas: [CarnetVacunacion(
              nombreVacuna: 'AntiRabica',
              fechaVacunacion: DateTime(2024, 06, 15),
              lote: '61327',
              veterinario: 'Dra. Gómez',
              numeroDosis: 1,
              proximaDosis: DateTime(2024, 12, 15))],
          enfermedades: ['Otitis', 'Dermatitis'],
          tratamientos: ['Antibiótico amoxicilina','Desametasona'],
          alergias: ['Polen','Mani'],
          visitas: {
            DateTime(2023, 10, 20): 'Revisión anual',
            DateTime(2023, 12, 5): 'Consulta por otitis',
          },
          examenes: {
            'Hemograma': {
              'Fecha': DateTime(2023, 11, 15),
              'Resultados': 'Dentro de los parámetros normales'
            }
          }),
      fotoperfil: "foto_Onyx"
  );

  Product product = Product(
    name: 'shampoo',
    price: 10.0,
    description: 'shampoo para perros y gatos con olor a te verde',
    images: [ProductImage(publicId: 'id1', url: 'url1')],
    category: 'salud',
    seller: 'Andy WhiteMouse',
    stock: 100,
    userId: 'Andy WhiteMouse',
  );
    Animal obtenerNuevoAnimal() => nuevoAnimal;
    Animal obtenerAnimalActualizado() => updateAnimal;
    Product obtenerProducto() => product;
}