package com.exaple.unityplugin;

import org.opencv.android.BaseLoaderCallback;
import org.opencv.android.LoaderCallbackInterface;
import org.opencv.android.OpenCVLoader;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.os.Handler;

public class UnityOpenCVLoader {

    private final static String TAG = "UnityOpenCV";
    private static boolean mSuccess = false;

    public static boolean isSuccess() {
        return mSuccess == true;
    }

    public static void anync(Activity activity) {
        final Context context = activity;
        activity.runOnUiThread(new Runnable() {
            public void run() {
                OpenCVLoader.initAsync(
                        //OpenCVLoader.OPENCV_VERSION_3_0_0,
                        OpenCVLoader.OPENCV_VERSION_2_4_11,
                        context,
                        new BaseLoaderCallback(context) {
                            @Override
                            public void onManagerConnected(int status) {
                                switch (status) {
                                    case LoaderCallbackInterface.SUCCESS:
                                        {
                                            Log.i(TAG, "OpenCV loaded successfully");
                                            mSuccess = true;
                                        } break;
                                    default:
                                        {
                                            super.onManagerConnected(status);
                                        } break;
                                }
                            }
                        });
            }
        });
    }

}
