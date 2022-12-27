require_relative '../lib/common.rb'

grid = Grid.new( :io=>ARGF.read.chomp )

blizzards = Hash.new { |h, k| h[k] = [] }
grid.each do |point,v|
  if v != '#' && v != '.'
    blizzards[point] << v
  end
end


def search( thestart, theend, blizzards, grid )

  minute = 0
  possible = {}
  possible[thestart] = true

  while true

    break if possible.key?(theend)
    minute += 1

    new_blizzards = Hash.new { |h, k| h[k] = [] }
    blizzards.each do |bpoint,bs|
      bs.each do |b|
        newpoint = bpoint.dup
        case b
        when '>'
          newpoint.x += 1
        when '<'
          newpoint.x -= 1
        when '^'
          newpoint.y -= 1
        when 'v'
          newpoint.y += 1
        end

        newpoint.x = 1 if newpoint.x == grid.xmax
        newpoint.x = grid.xmax - 1 if newpoint.x == 0
        newpoint.y = 1 if newpoint.y == grid.ymax
        newpoint.y = grid.ymax - 1 if newpoint.y == 0
        new_blizzards[newpoint] << b
      end
    end

   blizzards = new_blizzards

   new_possible =  {}
   possible.keys.each do |k|
     ( k.hvadjacent| [k] ).each do |adj|
       if ( ! new_blizzards.key?(adj) ) && grid.covers?(adj) && grid[adj] != '#'
         new_possible[adj] = true
       end
     end
   end

   possible = new_possible
  end

  [minute,blizzards]
end


xstart = (0..grid.xmax).find { |x| grid[Point.new(x,0)] == '.' }
thestart = Point.new( xstart, 0 )

xend = (0..grid.xmax).find { |x| grid[Point.new(x,grid.ymax)] == '.' }
theend = Point.new( xend, grid.ymax )

part1,blizzards =  search( thestart, theend, blizzards, grid )
part2,blizzards =  search( theend, thestart, blizzards, grid )
part3,blizzards =  search( thestart, theend, blizzards, grid )

p part1
p part1 + part2 + part3
