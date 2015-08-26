#include <jni.h>
#include <android/log.h>

#include <cstdio>
#include <cstdlib>

#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>

#define DEBUG

#define LOG_TAG ("UnityOpenCV")
#ifdef DEBUG
#define LOGD(...) ((void)__android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__))
#else
#define LOGD(...) (0)
#endif
#define LOGI(...) ((void)__android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__))
#define LOGW(...) ((void)__android_log_print(ANDROID_LOG_WARN, LOG_TAG, __VA_ARGS__))
#define LOGE(...) ((void)__android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__))

extern "C" void* CreateCameraInstance() {
    cv::VideoCapture *vc = new cv::VideoCapture();
    void* camera_instance =  static_cast<void*>(vc);
    return camera_instance;
}

extern "C" void DestoryCameraInstance(void* _camera_instance) {
    cv::VideoCapture* vc = static_cast<cv::VideoCapture*>(_camera_instance);
    delete vc;
}

extern "C" bool Open(void* _camera_instance, int _camera_id, int _width, int _height) {
    cv::VideoCapture* vc = static_cast<cv::VideoCapture*>(_camera_instance);
    bool is_success = vc->open(CV_CAP_ANDROID + _camera_id);//CV_CAP_ANDROID + _camera_id);
    if (is_success) {
        LOGI("Success");
    } else {
        LOGI("Failed");
    }
    vc->set(CV_CAP_PROP_FRAME_WIDTH, _width);
    vc->set(CV_CAP_PROP_FRAME_HEIGHT, _height);
    //    vc->set(CV_CAP_PROP_ANDROID_FOCUS_MODE, CAP_ANDROID_FOCUS_MODE_INFINITY);
    //    vc->set(CV_CAP_PROP_ANDROID_EXPOSE_LOCK, 1);
    //vc->set(CV_CAP_PROP_ANDROID_WHITEBALANCE_LOCK, 1);
    //vc->set(ANDROID_CAMERA_PROPERTY_FPS, 15);
    return is_success;
}

extern "C" void getCameraTexture(void* _camera_instance, unsigned int* _data, int _width, int _height) {
    cv::VideoCapture* vc = static_cast<cv::VideoCapture*>(_camera_instance);
    cv::Mat image;

    //*vc >> image;
    if (vc->grab()) {
        vc->retrieve(image);
    } else {
        image.release();
    }
    cv::Mat resized_img(_height, _width, image.type());
    cv::resize(image, resized_img, resized_img.size(), cv::INTER_CUBIC);

    cv::cvtColor(resized_img, image, CV_RGB2BGRA);
    memcpy(_data, image.data, image.total() * image.elemSize());
}

