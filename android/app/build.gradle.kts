import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()

android {
    namespace = "com.example.secondapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.theragame.okamisapp"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val androidAppKeyPropertiesFile = file("key.properties")
            val flutterRootKeyPropertiesFile = rootProject.file("../key.properties")
            val androidRootKeyPropertiesFile = rootProject.file("key.properties")
            val keystorePropertiesFile = listOf(
                androidAppKeyPropertiesFile,
                flutterRootKeyPropertiesFile,
                androidRootKeyPropertiesFile
            ).firstOrNull { it.exists() && it.length() > 0 }

            if (keystorePropertiesFile != null) {
                Properties().apply {
                    keystorePropertiesFile.forEachLine { line ->
                        val trimmed = line.trim()
                        if (trimmed.isEmpty() || trimmed.startsWith("#")) return@forEachLine
                        val parts = trimmed.split("=", limit = 2)
                        if (parts.size == 2) {
                            setProperty(parts[0].trim(), parts[1].trim())
                        }
                    }
                }.let { keystoreProperties ->
                    keystoreProperties.getProperty("keyAlias")?.let { keyAlias = it }
                    keystoreProperties.getProperty("keyPassword")?.let { keyPassword = it }
                    keystoreProperties.getProperty("storeFile")?.let { storeFile = file(it) }
                    keystoreProperties.getProperty("storePassword")?.let { storePassword = it }
                }
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

}



flutter {
    source = "../.."
}

dependencies {
    // ...
    implementation("com.google.android.material:material:1.14.0-alpha08")
    // ...
}

