# セットアップ

## AWS CLI

( @aibax さんの手順でセットアップして、コマンドが正しく実行できることを確認しておくこと)

## ミドルウェアとエディタインストール

``` shell
$ sudo apt-get install vim ruby-dev wget
$ sudo gem install serialport
```

##  Monostick を読めるように

(以下は非推奨方式、 @izawa さんのプレセットアップイメージなら不要な予定)

``` shell
$ sudo chmode og+rw /dev/ttyUSB0
```

# プログラムを書く

## サンプルソースコード

`vim main.rb` で作成開始。もしくは `wget https://bit.ly/k-iot-code -O main.rb` でダウンロードしてください。

``` ruby
# coding: utf-8

require 'rubygems'
gem 'serialport','>=1.0.4'
require 'serialport'
require 'time'

sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) # 115200, 8bit, stopbit 1, parity none
loop do
  line = sp.gets # read
  v = line.to_s.strip.split(':')
  next if v.length < 10
  time = Time.now.xmlschema # iso8601 型式で現在を取得
  tm = v[10].split('=')[1].to_i/100.0 # 温度は100倍されてくるので割る。
  v = "aws cloudwatch put-metric-data --namespace kato --dimensions DeviceId=Terumo --metric-name BodyTemp --timestamp #{time} --value #{tm}"
  puts v # コマンド表示
  puts system v # 実行 & 結果表示(成功すると true 失敗すると false が表示される)
end
```

# 実行

止めたいときは `Ctrl + c`

``` shell
$ ruby main.rb
```
