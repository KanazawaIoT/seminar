# coding: utf-8

NAMESPACE = ENV['MYNAME'] || 'kato'
DEVICE_ID = 'BME280'

require 'bigdecimal'
require 'rubygems'
gem 'serialport','>=1.0.4'
require 'serialport'
require 'time'

def parse(line)
  values = {}
  line.to_s.strip.split(':').each{|item|
    set = item.split("=", 2)
    key = set[0]
    value = set[1]
    next if key.nil?
    values[key] = value
  }
  return values
end

def put_metric_data(metric_name, timestamp, value)
  cmd = "aws cloudwatch put-metric-data --namespace \"#{NAMESPACE}\" --dimensions DeviceId=#{DEVICE_ID} --metric-name \"#{metric_name}\" --timestamp #{timestamp} --value #{value}"
  puts cmd # コマンド表示
  puts system cmd # 実行 & 結果表示(成功すると true 失敗すると false が表示される)
end

serialport = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) # 115200, 8bit, stopbit 1, parity none
loop do
  timestamp = Time.now.xmlschema # iso8601 型式で現在時刻を取得

  line = serialport.gets # read
  values = parse(line)

  next if values['tm'].nil? && values['hu'].nil? && values['at'].nil?

  # 温度
  unless values['tm'].nil?
    tm = BigDecimal(values['tm']) * 0.01
    put_metric_data('Temperature', timestamp, tm.floor(2).to_f)
  end

  # 湿度
  unless values['hu'].nil?
    hu = BigDecimal(values['hu']) * 0.01
    put_metric_data('Humidity', timestamp, hu.floor(2).to_f)
  end

  # 気圧
  unless values['at'].nil?
    at = values['at']
    put_metric_data('Atmospheric Pressure', timestamp, at)
  end

  break

end
