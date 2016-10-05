# ハードウェア編

## センサーの作成

センサーは、BME280 を TWELite DIP に接続します。

回路図は以下。

![回路図](images/BME280_TWELite.jpg  "回路図")


ブレッドボード上の配置は以下。

![ブレッドボード1](images/breadboard1.jpg  "ブレッドボード1")

![ブレッドボード2](images/breadboard2.jpg  "ブレッドボード2")

## TWELiteのファーム書き換え

モノワイヤレス(株)の公式ページに記載の通り、TWELiteには様々なファームが提供されています。
[TWE-APPS アプリ各種](http://mono-wireless.com/jp/products/TWE-APPS/index.html)

製品にはデフォルトで「超簡単！TWEアプリ」がインストールされて出荷され
ています。
今回は
「
[無線タグアプリ](http://mono-wireless.com/jp/products/TWE-APPS/Samp_monitor/index.html)
」を利用するため、ファームを書き換える必要があります。

### ファーム書き込み環境準備

ファームの書き込みは、Windows環境が必要。
(Linuxでの書き込み方法もあったはずなので、要調査)


#### ファーム書き込みソフト(Windows)を公式からダウンロードして来てインストールする。

[TWE-LITE用プログラマ公式ページ](http://mono-wireless.com/jp/tech/misc/LiteProg/index.html)
から TWE-LITE プログラマ 0.3.4.3 をダウンロードしてインストールする。


#### ファームを公式からダウンロードしてきて、展開する。

[無線タグアプリ （Samp_Monitor）ダウンロード](http://mono-wireless.com/jp/products/TWE-APPS/Samp_monitor/download.html)
から、ファームウェア v1.5.5 βをダウンロードして、展開する。

ソースコードも含まれているが、実際に機器へ書き込むファイルは、子機・親機それぞれzip中の以下のファイルを利用する。

子機(TWELite)
Samp_Monitor/EndDevice_Input/Build/Samp_Monitor_EndDevice_Input_JN5164_1_5_5.bin

親機(MonoStick)
Samp_Monitor/Parent/Build/Samp_Monitor_Parent_JN5164_1_5_5.bin

or

Samp_Monitor/Parent/Build/Samp_Monitor_Parent_JN5164_ToCoStick_1_5_5.bin

### TWELite PCBの書き換え

1. Win機とTWELITE-RをUSBケーブルで接続する。
2. TWELITE-RにTWELiteをセットする。
3. 書き込みソフトを使って書き込む。


### MonoStickの書き換え

1. Win機とTWELITE-RをUSBケーブルで接続する。
2. MonoStickをWin機にUSB接続する。
3. 書き込みソフトを使って書き込む。

## 子機・親機ともにシリアル接続して設定する。

### 子機の設定

1. Win機とTWELITE-RをUSBケーブルで接続する。
2. TWELITE-RにTWELiteをセットする。
3. M2 ピンを GND に落とし、TWELITE-Rのリセットスイッチを押す。
4. teratermでシリアル接続する。
5. リターンキーを押すと設定画面が表示される。
6. 各項目を入力し、最後に'S'で設定書き込み。

### 親の設定

1. Win機のUSBにMonoStickを差し込む
4. teratermでシリアル接続する。
5. +++ を入力すると設定画面が表示される。
6. 各項目を入力し、最後に'S'で設定書き込み。

