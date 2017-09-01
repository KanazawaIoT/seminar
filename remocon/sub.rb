require "mqtt"
require "i2c"

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

MQTT::Client.connect(host: "a1f18lql3l5z0z.iot.ap-northeast-1.amazonaws.com", 
                     port: 8883,
                     ssl: true,
                     cert_file: "cert.pem",
                     key_file: "private-key.pem",
                     ca_file: "rootCA.pem") do |client|

  client.subscribe("topic/test")
  begin
    topic,message = client.get #ここでブロックする
    p [topic, message]
    lcd = LCD.new(0x3e, '/dev/i2c-1')
    sleep 0.1

    lcd.write("#{topic}")
    lcd.newline
    lcd.write("#{message}")
    if message.to_f > 30.0
      # 30度を超えたらビームを出す
      # system 'irsend SEND_ONCE LIGHT ON'
    end
  end while true
end
