allprojects {
    repositories {
        google()
        mavenCentral()
    }
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

subprojects {
    if (project.name != "app") {
        val configureAndroid = {
            val android = project.extensions.findByName("android")
            if (android != null) {
                try {
                    val method = android.javaClass.methods.firstOrNull { 
                        it.name == "compileSdkVersion" && it.parameterTypes.size == 1 && (it.parameterTypes[0] == Int::class.javaPrimitiveType || it.parameterTypes[0] == java.lang.Integer::class.java)
                    }
                    method?.invoke(android, 36)
                } catch (_: Exception) {}
                try {
                    val setCompileSdk = android.javaClass.methods.firstOrNull { 
                        it.name == "setCompileSdk" && it.parameterTypes.size == 1 && (it.parameterTypes[0] == Int::class.javaPrimitiveType || it.parameterTypes[0] == java.lang.Integer::class.java)
                    }
                    setCompileSdk?.invoke(android, 36)
                } catch (_: Exception) {}
            }
        }
        if (project.state.executed) {
            configureAndroid()
        } else {
            project.afterEvaluate {
                configureAndroid()
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
