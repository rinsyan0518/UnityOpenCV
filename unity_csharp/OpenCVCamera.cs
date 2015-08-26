using UnityEngine;
using System;
using System.Collections;
using System.Runtime.InteropServices;

public class OpenCVCamera : MonoBehaviour {
	public int width = 1920;
	public int height = 1080;
	public int fps = 30;

	private Texture2D texture;
	private Color32[] pixels;
	private GCHandle pixelsHandle;
	private IntPtr pixelsPtr;

	// 0 : no ready, 1 : ready, 2 : opened
	private int state = 0;

	// Use this for initialization
	void Start () {
		var devices = WebCamTexture.devices;
		if (devices.Length == 0) {
			Debug.LogError("not found device");
			return;
		}
		/*
		AndroidJavaClass UnityPlayerJava = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
		AndroidJavaObject currentActivityJava = UnityPlayerJava.GetStatic<AndroidJavaObject>("currentActivity");
		AndroidJavaClass UnityOpenCVLoaderJava = new AndroidJavaClass(UNITY_OPENCV_LOADER);
		UnityOpenCVLoaderJava.CallStatic("anync", currentActivityJava);
		*/
		state = 1;
	}

	void Update() {

		if (state == 0) {
			AndroidJavaClass UnityOpenCVLoaderJava = new AndroidJavaClass(UNITY_OPENCV_LOADER);
			var b = UnityOpenCVLoaderJava.CallStatic<Boolean>("isSuccess");
			if (b) {
				state = 1;
			}
		} else if (state == 1) {
			if (cameraInstance == IntPtr.Zero) cameraInstance = CreateCameraInstance ();

			if (Open (cameraInstance, 0, width, height)) {
				texture = new Texture2D (width, height, TextureFormat.ARGB32, false);
				pixels = texture.GetPixels32 ();
				pixelsHandle = GCHandle.Alloc (pixels, GCHandleType.Pinned);
				pixelsPtr = pixelsHandle.AddrOfPinnedObject ();
				GetComponent<Renderer>().material.mainTexture = texture;
				state = 2;
			} else {
				state = -1;
			}
		} else if (state == 2) {
			getCameraTexture (cameraInstance, pixelsPtr, width, height);
			texture.SetPixels32 (pixels);
			texture.Apply ();
		}
	}

	void OnApplicationQuit() {
		if (state > 0) {
			DestoryCameraInstance (cameraInstance);
			pixelsHandle.Free ();
		}
	}

	private IntPtr cameraInstance;
	private const string UNITY_OPENCV_LOADER = "com.exaple.unityplugin.UnityOpenCVLoader";

	[DllImport("unityopencv")]
	private static extern IntPtr CreateCameraInstance ();
	[DllImport("unityopencv")]
	private static extern bool Open(IntPtr cameraInstance, int cameraId, int width, int height);
	[DllImport("unityopencv")]
	private static extern void DestoryCameraInstance (IntPtr cameraInstance);
	[DllImport("unityopencv")]
	private static extern void getCameraTexture (IntPtr cameraInstance, IntPtr data, int width, int height);

}
