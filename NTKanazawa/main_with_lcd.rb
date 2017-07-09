# coding: utf-8

NAMESPACE = ENV['MYNAME'] || 'kato'
DEVICE_ID = 'BME280'

require 'rubygems'
gem 'serialport','>=1.0.4'
require 'serialport'
require 'time'
require 'i2c'
require 'open3'


class AWSSender
  def initialize(device_id = DEVICE_ID)
    @device_id = device_id
  end
  def send_to_aws(metric_name, v)
    time = Time.now.xmlschema # iso8601 型式で現在を取得
    cmd = "aws cloudwatch put-metric-data --namespace #{NAMESPACE} --dimensions DeviceId=#{@device_id} --metric-name #{metric_name} --timestamp #{time} --value #{v}"
    puts cmd # コマンド表示
    # puts system cmd # 実行 & 結果表示(成功すると true 失敗すると false が表示される)
    Open3.popen3("#{cmd} > /dev/null 2>&1") 
  end
end

class SensorData
  def initialize(data)
    @values = data.to_s.strip.split(':')
    @id = @values[6].split('=') if @values.length > 7
  end

  def invalid?
    return true if @values.length < 10
    return true unless @id[0] == 'id'
  end

  def id
    @id[1]
  end

  def temp
    @values[10].split('=')[1].to_i/100.0
  end

  def hum
    @values[11].split('=')[1].to_i/100.0
  end

  def at
    @values[12].split('=')[1].to_i/100.0
  end
end

class LCD
  def initialize(addr, path)
    @addr = addr
    begin
      @dev = I2C.create(path)
    rescue => e
      puts e.to_s
      exit 1
    end
    #initialize lcd mode
    @dev.write(@addr, 0x38, 0x39, 0x14, 0x78, 0x5f, 0x6b)
    #clear
    @dev.write(@addr, 0x38, 0x0d, 0x01)
  end

  def clear
    @dev.write(@addr, 0x38, 0x0d, 0x01)
  end

  def newline
    @dev.write(0x3e, 0x00, 0xc0)
  end

  def write(str)
    @dev.write(@addr, 0x40, *str)
  end
end

sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) # 115200, 8bit, stopbit 1, parity none
loop do
  line = sp.gets # read
  data = SensorData.new(line)
  next if data.invalid?

  s = AWSSender.new(data.id)
  lcd = LCD.new(0x3e, '/dev/i2c-1')
  sleep 0.1

  lcd.write("Temp=#{data.temp.round(2)}")
  lcd.newline
  lcd.write("Hum=#{data.hum.round(2)}")

  s.send_to_aws('Temp', data.temp)
  s.send_to_aws('Hum', data.hum)
  s.send_to_aws('At', data.at)
end
