
require_relative '../lib/common.rb'


def part1( grid )

  iter = 0
  while true

    sand = Point.new(500,0)
    can_drop = true
    while can_drop do

      down = Point.new( sand.x, sand.y+1)
      dl = Point.new( sand.x-1, sand.y+1)
      dr = Point.new( sand.x+1, sand.y+1)

      if grid[down].nil?
        sand = down
      elsif grid[dl].nil?
        sand = dl
      elsif grid[dr].nil?
        sand = dr
      else
        can_drop = false
      end

      if ! can_drop
        iter += 1
        grid[sand] = 'o'
      elsif ! grid.covers?(sand)
        return iter
      end
    end
  end
  iter
end


def part2( grid )

  oo = grid.ymax
  can_sand = true
  iter = 1

  while can_sand

    sand = Point.new(500,0)
    can_drop = true

    while can_drop do

      down = Point.new( sand.x, sand.y+1)
      dl = Point.new( sand.x-1, sand.y+1)
      dr = Point.new( sand.x+1, sand.y+1)
      can_move = false

      if grid[down].nil?
        sand = down
        can_move  = true
      elsif grid[dl].nil?
        sand = dl
        can_move = true
      elsif grid[dr].nil?
        sand = dr
        can_move = true
      end

      if sand == Point.new(500,0)
        can_drop = false
        can_sand = false
        break
      end

      if (! can_move || sand.y == oo + 1)
        grid[sand] = 'o'
        iter += 1
        can_drop = false
      elsif sand == Point.new(500,0)
        can_drop = false
        can_sand = false
      end
    end
  end
  iter
end


gridp1 = Grid.new( :nooriginx => true )
gridp2 = Grid.new

ARGF.each_line(chomp:true) do |line|
  data = []
  line.split(/->/).each do |pair|
    x,y = pair.scan(/\d+/).map( &:to_i)
    data << [x,y]
  end

  data.each_cons(2) do |a|
    sx = [a[0][0], a[1][0]].minmax
    rx = (sx.first..sx.last)
    sy = [a[0][1], a[1][1]].minmax
    ry = (sy.first..sy.last)

    ry.each do |y|
      rx.each do |x|
        gridp1[Point.new(x,y)] = '#'
        gridp2[Point.new(x,y)] = '#'
      end
    end
  end
end

p part1( gridp1 )
p part2( gridp2 )

