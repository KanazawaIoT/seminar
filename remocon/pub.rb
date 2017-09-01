# coding: utf-8

NAMESPACE = ENV['MYNAME'] || 'kato'
DEVICE_ID = 'BME280'

require "mqtt"
require 'rubygems'
gem 'serialport','>=1.0.4'
require 'serialport'
require 'time'

@client = MQTT::Client.connect(host: "a1f18lql3l5z0z.iot.ap-northeast-1.amazonaws.com",
                     port: 8883,
                     ssl: true,
                     cert_file: "cert.pem",
                     key_file: "private-key.pem",
                     ca_file: "rootCA.pem")


def send_to_aws(metric_name, v, position)
  tm = v[position].split('=')[1].to_i/100.0
  @client.publish("topic/test", "#{tm}")
end
  
sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) # 115200, 8bit, stopbit 1, parity none
loop do
  line = sp.gets # read
  values = line.to_s.strip.split(':')
  next if values.length < 10
  send_to_aws('Temp', values, 10)
  # send_to_aws('Hum', values, 11)
  # send_to_aws('At', values, 12)
end
