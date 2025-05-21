plugins {
    id("com.android.application")        // Correcto: La versión se toma de settings.gradle.kts
    id("kotlin-android")                // Correcto: La versión se toma de settings.gradle.kts
    // (A veces se usa "org.jetbrains.kotlin.android"; si "kotlin-android" funciona, está bien)
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin") // Correcto: La versión la maneja el SDK de Flutter
    // Add the Google services Gradle plugin
    id("com.google.gms.google-services") // Correcto: La versión se toma de settings.gradle.kts
}
dependencies {
    // Import the Firebase BoM
    // La versión 33.11.0 es reciente (para Mayo 2025). Verifica que sea la deseada.
    implementation(platform("com.google.firebase:firebase-bom:33.11.0"))
    // TODO: Add the dependencies for Firebase products you want to use
    // When using the BoM, don't specify versions in Firebase dependencies
    implementation("com.google.firebase:firebase-analytics")
    // Add the dependencies for any other desired Firebase products
    // https://firebase.google.com/docs/android/setup#available-libraries
}
android {
    namespace = "com.MouseInc.animal_health"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_21.toString()
    }
    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.MouseInc.animal_health" // Este es tu ID de aplicación
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            // Considerar habilitar R8/ProGuard para ofuscación y reducción de tamaño:
            // isMinifyEnabled = true
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}
flutter {
    source = "../.."
}