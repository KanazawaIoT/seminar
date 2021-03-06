# coding: utf-8

NAMESPACE = ENV['MYNAME'] || 'kato'
DEVICE_ID = 'BME280'

require 'rubygems'
gem 'serialport','>=1.0.4'
require 'serialport'
require 'time'

class AWSSender
  def initialize(device_id = DEVICE_ID)
    @device_id = device_id
  end
  def send_to_aws(metric_name, v, position)
    time = Time.now.xmlschema # iso8601 型式で現在を取得
    tm = v[position].split('=')[1].to_i/100.0
    cmd = "aws cloudwatch put-metric-data --namespace #{NAMESPACE} --dimensions DeviceId=#{@device_id} --metric-name #{metric_name} --timestamp #{time} --value #{tm}"
    puts cmd # コマンド表示
    puts system cmd # 実行 & 結果表示(成功すると true 失敗すると false が表示される)
  end
end


sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) # 115200, 8bit, stopbit 1, parity none
loop do
  line = sp.gets # read
  values = line.to_s.strip.split(':')
  next if values.length < 10
  id = values[6].split('=')
  next unless id[0] == 'id'
  s = AWSSender.new(values[6].split('=')[1])
  s.send_to_aws('Temp', values, 10)
  s.send_to_aws('Hum', values, 11)
  s. send_to_aws('At', values, 12)
end
