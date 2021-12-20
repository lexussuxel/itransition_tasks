require "securerandom"
require "sha3"
require "openssl"

class Menu
  attr_reader :menu
  def initialize
    @menu = {}
    n = 1
    ARGV.each do |a|
      @menu[n.to_s] = a
      n += 1
    end
    @menu["0"] = "exit"
    @menu["?"] = "help"
  end

  def show
    @menu.each do |index, value|
      p index + " - " + value
    end
  end
end

class Table

  attr_reader :menu, :table

  def initialize(menu)
    menu.delete("0")
    menu.delete("?")
    @menu = menu
  end

  def create
    @table = []
    # @table << []
    @table << @menu.values.unshift(0)
    n = 0
    @menu.values.each do |value|
      @table << Array.new(@menu.length){|i| n==i ? "draw":( if (((0..@menu.length/2)).include?(n-i) or (-@menu.length + 1..-@menu.length/2).include?(n-i)) then "lose" else "win" end)}.unshift(value)
      n += 1
    end
  end

  def show
    @table.each do |line|
      line.each do |position|
        print position.to_s + "|"
      end
      print "\n---------------------------------\n"
    end
  end
end

def main
  return "Try to enter odd count of arguments" unless ARGV.length.odd?
  return "Try not to repeat your moves" if ARGV.length - ARGV.uniq.length != 0
  menu = Menu.new
  table = Table.new(menu.menu.clone)
  table.create
  ymove = 0
  while ymove != "0" do
    key = SecureRandom.hex(256)
    data = rand(1..ARGV.length)
    data = data.to_s
    hmac = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), key, data)
    p "HMAC:"
    p "#{hmac}"
    p "Available moves:"
    menu.show
    print "Enter your move: "
    p
    ymove = STDIN.gets.chomp
    p "Your move: #{menu.menu[ymove]}"
    unless menu.menu.keys.include?(ymove)
      next
    else
      if ymove == "?"
        table.show
      end
      if ymove == "0"
        break
      else
      p "Computer move: #{menu.menu[data]}"
      p "You #{table.table[ymove.to_i][data.to_i]}!"
      p "HMAC key: #{key}"
      end
    end
  end
  return "Thank you for game!"
end


p main