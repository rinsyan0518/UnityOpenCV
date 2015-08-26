(1)OenCV-2.4.11-android-sdk.zipをダウンロード( http://sourceforge.net/projects/opencvlibrary/files/opencv-android/ )
(2)ダウンロードしたファイルを展開し、OpenCV-android-sdkの中のsdkディレクトリをopencv-sdkに名前を変更。
(3)ここに置く

<注意>
Android SDKとAndroid NDKの設定は必要です。
MakefileにAndroid NDKのパスを書く必要があります。

UnityOpenCVLoader.javaをビルドしてますが、使ってないです。

2015/08/27時点で、OpenCV3.0.0にはlibnative_camera_r*.soが入っていないので
2.4.*もしくは3.0.0-rc1をダウンロードする必要があるようです。

