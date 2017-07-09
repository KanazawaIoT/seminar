require 'i2c'

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
    @dev.write(@addr, 0x00, 0xc0)
  end

  def write(str)
    @dev.write(@addr, 0x40, *str)
  end
end

lcd = LCD.new(0x3e, '/dev/i2c-1')
sleep 0.1

lcd.write('Hello,')
lcd.newline
lcd.write('World!')
