plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.helpothon"
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
        applicationId = "com.helpothon.apps"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        
        release {
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    flavorDimensions += "default"
    productFlavors {
        create("helpothon") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "Helpothon")
            applicationIdSuffix = ".helpothon"
        }
        create("scanmeee") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "ScanMeee")
            applicationIdSuffix = ".scanmeee"
        }
        create("formatweaver") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "FormatWeaver")
            applicationIdSuffix = ".formatweaver"
        }
        create("snapcompress") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "SnapCompress")
            applicationIdSuffix = ".snapcompress"
        }
        create("pixelartz") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "PixelArtz")
            applicationIdSuffix = ".pixelartz"
        }
        create("allrandomtools") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "AllRandomTools")
            applicationIdSuffix = ".allrandomtools"
        }
        create("casualgamezone") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "CasualGameZone")
            applicationIdSuffix = ".casualgamezone"
        }
        create("calculatedaily") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "CalculateDaily")
            applicationIdSuffix = ".calculatedaily"
        }
        create("picxcraft") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "PicxCraft")
            applicationIdSuffix = ".picxcraft"
        }
        create("aimageasy") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "AImagEasy")
            applicationIdSuffix = ".aimageasy"
        }
        create("pichaverse") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "PichaVerse")
            applicationIdSuffix = ".pichaverse"
        }
        create("prettyparser") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "PrettyParser")
            applicationIdSuffix = ".prettyparser"
        }
        create("moodybuddy") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "MoodyBuddy")
            applicationIdSuffix = ".moodybuddy"
        }
    }
}

flutter {
    source = "../.."
}
