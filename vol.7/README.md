# もくもく会 データ送信手順

# AWS側事前準備（済）
- AWSアカウント取得
- IAMユーザー作成


# Raspberry Pi のセットアップ

## 前提事項
- Python >=2.7.9
- インターネット接続

## pipのインストール
```
$ wget https://bootstrap.pypa.io/get-pip.py
$ sudo python get-pip.py
```

## AWS CLI のインストール
```
$ sudo pip install awscli
$ aws --version ←動作確認
```

(2016-12-25 現在、 `raspberrypi` での動作確認・バージョン番号は以下です)
```
pi@raspberrypi:~ $ aws --version
aws-cli/1.11.34 Python/2.7.9 Linux/4.4.34-v7+ botocore/1.4.91
```

## AWS CLI の初期設定
```
$ aws configure
AWS Access Key ID [None]: （アクセスキー） ←当日お伝えします
AWS Secret Access Key [None]: （シークレットキー） ←当日お伝えします
Default region name [None]: ap-northeast-1
Default output format [None]: json
```

## CloudWatch にデータを送るコマンド

```
$ aws cloudwatch put-metric-data --namespace (NameSpace) --dimensions (Dimension) --metric-name (Metrics) --timestamp (計測時刻) --value (計測値)
```

- NameSpace : 拠点、グループ
- Dimension : センサーID、デバイスID、ユーザーID
- Metrics : 気温、湿度、気圧、体温、心拍数
- TimeStamp : 計測時刻（ISO 8601） ※指定しない場合はサーバの受信時刻
- Value : 計測値

### 実行例
```
$ aws cloudwatch put-metric-data --namespace aiba/test --dimensions DeviceId=Terumo --metric-name BodyTemp --timestamp 2016-12-24T22:34:10.024+09:00 --value 36.6
```

### 注意事項
- 最短1分間単位でデータは集約
- JSON形式で複数の計測値をまとめて送信可能（1リクエストに最大20データまで）
- JSON形式のファイルを出力するプロセスとCloudWatchに転送するプロセスを分ける事も可能  

### ドキュメント
[put-metric-data - AWS CLI 1.11.34 Command Reference](http://docs.aws.amazon.com/cli/latest/reference/cloudwatch/put-metric-data.html)


# 計測値を表示する画面
[https://173822656103.signin.aws.amazon.com/console](https://173822656103.signin.aws.amazon.com/console)  
※ログインIDとパスワードは当日お伝えします
