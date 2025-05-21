pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        val localPropertiesFile = file("local.properties")
        if (localPropertiesFile.isFile) {
            localPropertiesFile.inputStream().use { properties.load(it) }
        }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) {
            """
            flutter.sdk not set in local.properties.
            Ensure you have a local.properties file in the 'android' directory with the
            flutter.sdk=path/to/your/flutter_sdk
            """.trimIndent()
        }
        flutterSdkPath
    }
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.3.2" apply false // VERSIÓN AJUSTADA
    // START: FlutterFire Configuration
    id("com.google.gms.google-services") version "4.3.15" apply false // Mantenemos esta por ahora
    // END: FlutterFire Configuration
    id("org.jetbrains.kotlin.android") version "1.9.24" apply false // VERSIÓN AJUSTADA
}
include(":app")