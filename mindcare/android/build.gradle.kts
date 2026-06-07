allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    project.extensions.extraProperties["javaVersion"] = JavaVersion.VERSION_11
    project.extensions.extraProperties["compileSdk"] = 34
    project.extensions.extraProperties["minSdk"] = 21
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
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