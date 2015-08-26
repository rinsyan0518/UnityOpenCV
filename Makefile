ANDROID_VERSION = 10
PACKAGE_NAME = UnityOpenCV.jar
JAVA_DIR = java/
JAVA_SRC = ${JAVA_DIR}/UnityOpenCVLoader.java
ANDROID_NDK = /usr/local/Cellar/android-ndk/r10e/
OPENCV_SDK = ./sdk/opencv-sdk

CLASSES_DIR = ./classes
OUTPUT_DIR = ./build

UNITY_PLUGIN_DIR = ../UnityOpenCV/Assets/Plugins/
PLUGIN_NAME = UintyOpenCV
PACKAGE_NAME = ${PLUGIN_NAME}.jar

all: buildJNI buildJava

buildJNI:
	${ANDROID_NDK}/ndk-build NDK_PROJECT_PATH=./jni NDK_APPLICATION_MK=./jni/Application.mk NDK_APP_DST_DIR=./build/libs/\$${TARGET_ARCH_ABI} $*
	cp -rf ${OPENCV_SDK}/native/libs ${OUTPUT_DIR}

buildOpenCVJava:
	cd ${OPENCV_SDK}/java; \
	android update project -p ./; \
	ant debug;
	cp ${OPENCV_SDK}/java/bin/classes.jar ${OUTPUT_DIR}/opencv-android.jar

buildJava: buildOpenCVJava
	mkdir -p ${CLASSES_DIR}
	javac -sourcepath ${JAVA_DIR} -source 1.6 -target 1.6 -Xlint:deprecation -bootclasspath ${ANDROID_SDK}/platforms/android-${ANDROID_VERSION}/android.jar:${OUTPUT_DIR}/opencv-android.jar -d ${CLASSES_DIR} ${JAVA_SRC}
	jar cvfM ${OUTPUT_DIR}/${PACKAGE_NAME} -C ${CLASSES_DIR} .

clean:
	rm -rf ./jni/obj
	rm -rf ${CLASSES_DIR}
	rm -rf ${OUTPUT_DIR}/*

copy:
	mkdir -p ${UNITY_PLUGIN_DIR}/{Android,${PLUGIN_NAME}}
	cp ${OUTPUT_DIR}/opencv-android.jar ${UNITY_PLUGIN_DIR}/Android
	cp ${OUTPUT_DIR}/${PACKAGE_NAME} ${UNITY_PLUGIN_DIR}/Android
	cp unity_csharp/* ${UNITY_PLUGIN_DIR}/${PLUGIN_NAME}
	mkdir -p ${UNITY_PLUGIN_DIR}/Android/libs/{armeabi-v7a,x86}
	cp ${OUTPUT_DIR}/libs/armeabi-v7a/* ${UNITY_PLUGIN_DIR}/Android/libs/armeabi-v7a/
	cp ${OUTPUT_DIR}/libs/x86/* ${UNITY_PLUGIN_DIR}/Android/libs/x86/

