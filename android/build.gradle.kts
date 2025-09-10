buildscript {
    repositories {
        google() // Google's Maven repository
        mavenCentral() // Central Maven repository
    }
    dependencies {
        // Add the Android Gradle Plugin (AGP) classpath
        classpath("com.android.tools.build:gradle:8.8.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.23") 
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
