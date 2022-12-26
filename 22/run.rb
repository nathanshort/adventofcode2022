
require 'scanf'
require_relative '../lib/common.rb'

def score( cursor )
  1000*(cursor.location.y+1) + 4*(cursor.location.x+1) + {'E'=>0,'W'=>2,'N'=>3,'S'=>1}[cursor.heading]
end


def part1( grid, instructions )
  cursor = Cursor.new( :heading => 'E', :x => 0, :y => 0, :ygrows => :south )
  cursor.forward(:by=>1) while grid[cursor.location] != '.'

  instructions.each do |instruction|
    num, turn = instruction.scanf( "%d%c")
    num.times do
      next_forward = cursor.next_forward( :by => 1 )

      if grid[next_forward] == '#'
        break
      elsif grid[next_forward] == '.'
        cursor.forward( :by => 1 )
        next
      end

      nnext = nil
      case cursor.heading
      when 'E'
        nnext = Cursor.new( :heading => 'E', :x => 0, :y => cursor.location.y, :ygrows => :south )
      when 'W'
        nnext = Cursor.new( :heading => 'W', :x => grid.xmax, :y => cursor.location.y, :ygrows => :south )
      when 'N'
        nnext = Cursor.new( :heading => 'N', :x => cursor.location.x, :y => grid.ymax, :ygrows => :south )
      when 'S'
        nnext = Cursor.new( :heading => 'S', :x => cursor.location.x, :y => grid.ymin, :ygrows => :south )
      end

      # we wrapped around, but hit whitespace.  gotta find the actual re-start of the grid
      # the input doesnt have spaces on rightmost emptyspace
      while grid[nnext.location] != '.' && grid[nnext.location] != '#'
        nnext.forward( :by => 1 )
      end

      if grid[nnext.location] == '.'
        cursor = nnext.dup
      else
        # tried to wrap around, but, first block was a wall - so stop moving
        break
      end
    end
    cursor.turn( :direction => turn )
  end

  score(cursor)
end

def yoff( cursor, ranges, index )
  cursor.location.y - ranges[index][:yr].first
end

def xoff( cursor, ranges, index )
  cursor.location.x - ranges[index][:xr].first
end

#
#   0 1
#   2
# 4 3
# 5
#
# 1. create the cube out of paper
# 2. map out all the direction changes
# 3. profit
def part2( grid, instructions )

  ranges =  [ { xr: (50..99), yr: (0..49) },
              { xr: (100..149), yr: (0..49) },
              { xr: (50..99), yr: (50..99) },
              { xr: (50..99), yr: (100..149) },
              { xr: (0..49), yr: (100..149) },
              { xr: (0..49), yr: (150..199) } ]

  transitions =
    [
      #0
      { 'E' => ->(c) {
          x=c.dup
          x.location.x += 1
          x.heading = 'E'
          return 1,x },
        'W' => ->(c) {
          x=c.dup
          x.location.x = ranges[4][:xr].first
          x.location.y = ranges[4][:yr].last - yoff( c, ranges, 0 )
          x.heading = 'E'
          return 4,x },
        'N' => ->(c) {
          x=c.dup
          x.location.x = ranges[5][:xr].first
          x.location.y = ranges[5][:yr].first + xoff( c, ranges, 0 )
          x.heading = 'E'
          return 5,x },
        'S' => ->(c) {
          x=c.dup
          x.location.y += 1
          x.heading = 'S'
          return 2,x },
      },
      #1
      { 'E' => ->(c) {
          x=c.dup
          x.location.x = ranges[3][:xr].last
          x.location.y = ranges[3][:yr].last - yoff( c, ranges, 1 )
          x.heading = 'W'
          return 3,x },
        'W' => ->(c) {
          x =c.dup
          x.location.x -= 1
          x.heading = 'W'
          return 0,x },
        'N' => ->(c) {
          x=c.dup
          x.location.x = ranges[5][:xr].first + xoff( c, ranges, 1 )
          x.location.y = ranges[5][:yr].last
          x.heading = 'N'
          return 5,x },
        'S' => ->(c) {
          x=c.dup;
          x.location.y = ranges[2][:yr].first + xoff( c, ranges, 1 )
          x.location.x = ranges[2][:xr].last
          x.heading = 'W'
          return 2,x },
      },
      #2 
      { 'E' => ->(c) {
          x=c.dup
          x.location.y = ranges[1][:yr].last
          x.location.x = ranges[1][:xr].first + yoff( c, ranges, 2 )
          x.heading = 'N'
          return 1,x },
        'W' => ->(c){
          x=c.dup;
          x.location.y = ranges[4][:yr].first
          x.location.x = ranges[4][:xr].first + yoff( c, ranges, 2 )
          x.heading = 'S'
          return 4,x },
        'N' => ->(c) {
          x=c.dup;
          x.location.y -= 1;
          x.heading = 'N';
          return 0,x },
        'S' => ->(c) {
          x=c.dup;
          x.location.y += 1;
          x.heading = 'S';
          return 3,x },
      },
      #3
      { 'E' => ->(c) {
          x=c.dup;
          x.location.x = ranges[1][:xr].last
          x.location.y = ranges[1][:yr].last - yoff( c, ranges, 3 )
          x.heading = 'W'
          return 1,x},
        'W' => ->(c) {
          x=c.dup
          x.location.x -= 1
          x.heading = 'W'
          return 4,x },
        'N' => ->(c) {
          x=c.dup
          x.location.y -= 1
          x.heading = 'N'
          return 2,x },
        'S' => ->(c) {
          x=c.dup
          x.location.x = ranges[5][:xr].last
          x.location.y = ranges[5][:yr].first + xoff(c,ranges,3)
          x.heading = 'W'
          return 5,x },
      },
      #4
      { 'E' => ->(c) {
          x=c.dup
          x.location.x += 1
          x.heading = 'E'
          return 3,x},
        'W' => ->(c) {
          x=c.dup
          x.location.x = ranges[0][:xr].first
          x.location.y = ranges[0][:yr].last - yoff(c,ranges,4)
          x.heading = 'E'
          return 0,x },
        'N' => ->(c) {
          x=c.dup
          x.location.x = ranges[2][:xr].first
          x.location.y = ranges[2][:yr].first + xoff(c,ranges,4)
          x.heading = 'E'
          return 2,x },
        'S' => ->(c) {
          x=c.dup
          x.location.y += 1
          x.heading = 'S'
          return 5,x },
      },
      #5
      { 'E' => ->(c) {
          x=c.dup
          x.location.y = ranges[3][:yr].last
          x.location.x = ranges[3][:xr].first + yoff(c,ranges,5)
          x.heading = 'N'
          return 3,x},
        'W' => ->(c) {
          x=c.dup
          x.location.y = ranges[0][:yr].first
          x.location.x = ranges[0][:xr].first + yoff(c,ranges,5)
          x.heading = 'S'
          return 0,x },
        'N' => ->(c) {
          x=c.dup
          x.location.y -= 1
          x.heading = 'N'
          return 4,x },
        'S' => ->(c) {
          x=c.dup
          x.location.y = ranges[1][:yr].first
          x.location.x = ranges[1][:xr].first + xoff(c,ranges,5)
          x.heading = 'S'
          return 1,x },
      },
    ]

  cursor = Cursor.new( :heading => 'E', :x => 0, :y => 0, :ygrows => :south )
  cursor.forward(:by=>1) while grid[cursor.location] != '.'

  current_face = 0
  instructions.each do |instruction|

    num, turn = instruction.scanf( "%d%c")
    num.times do
      next_forward = cursor.next_forward( :by => 1 )
      if ! ranges[current_face][:xr].cover?(next_forward.x) ||
         ! ranges[current_face][:yr].cover?(next_forward.y)

        next_face,next_cursor = transitions[current_face][cursor.heading].call(cursor)
        if grid[next_cursor.location] == '.'
          cursor = next_cursor
          current_face = next_face
        else
          # spot on new face is a wall
          break
        end
      elsif grid[next_forward] == '#'
        break
      else
        cursor.forward(:by=>1)
      end
    end
    cursor.turn( :direction => turn )
  end
  score(cursor)
end



bdata, i = ARGF.read.chomp.split(/\n\n/)
grid = Grid.new( :io => bdata )
instructions = i.scan(/\d+\w/)
p part1( grid, instructions )

grid2 = Grid.new( :io => bdata )
p part2( grid2, instructions )
