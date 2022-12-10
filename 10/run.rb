
require 'scanf'

class Cpu

  attr_accessor :x, :cycle, :strengths
  def initialize
    @x,@cycle  = 1,0
    @strengths = []
  end

  def execute( operator, operand, crt )
    tick
    crt.draw( self )

    if operator == 'addx'
      tick
      crt.draw( self )
      @x += operand
    end
  end

  def tick
    @cycle += 1
    @strengths << [@cycle,@x] if (@cycle % 20) == 0
  end
end


class Crt

  def initialize
    @width,@height = 40,6
    @data = {}
  end

  def draw( cpu )
    x = cpu.cycle % @width - 1
    y = cpu.cycle / @width
    @data[[x,y]] = (x-cpu.x).abs <= 1 ? '#' : '.'
  end

  def render
    (0..@height-1).each do |y|
      (0..@width-1).each  do |x|
        print @data[[x,y]]
      end
      puts "\n"
    end
  end
end

cpu = Cpu.new
crt = Crt.new

ARGF.each_line do |line|
  operator,operand = line.scanf('%s %d')
  cpu.execute( operator, operand, crt )
end

p cpu.strengths.sum{ |x| [20,60,100,140,180,220].include?(x[0]) ? x[0]*x[1] : 0  }
crt.render
