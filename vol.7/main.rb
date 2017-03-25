# coding: utf-8

namespace = ENV['MYNAME'] || 'kato'
device_id = 'BME280'

require 'rubygems'
gem 'serialport','>=1.0.4'
require 'serialport'
require 'time'

def send_to_aws(metric_name, v, position) do
  time = Time.now.xmlschema # iso8601 型式で現在を取得
  tm = v[position].split('=')[1].to_i/100.0
  cmd = "aws cloudwatch put-metric-data --namespace #{namespace} --dimensions DeviceId=#{device_id} --metric-name #{metric_name} --timestamp #{time} --value #{tm}"
  puts cmd # コマンド表示
  puts system cmd # 実行 & 結果表示(成功すると true 失敗すると false が表示される)
end
  
sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) # 115200, 8bit, stopbit 1, parity none
loop do
  line = sp.gets # read
  values = line.to_s.strip.split(':')
  next if values.length < 10
  send_to_aws('Temp', values, 10)
  send_to_aws('Hum', values, 11)
  send_to_aws('At', values, 12)
end
