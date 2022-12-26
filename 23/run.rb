require_relative '../lib/common.rb'

elves = {}
grid = Grid.new( :io=>ARGF.read.chomp)
grid.each do |point,v|
  elves[point] = true if v == '#'
end

options =
  [
    {
      :o => [
        ->(p){Point.new( p.x, p.y-1 )},
        ->(p){Point.new( p.x+1, p.y-1 )},
        ->(p){Point.new( p.x-1, p.y-1 )}
      ],
      :r => ->(p){ Point.new(p.x,p.y-1)}
    },
    {
      :o => [
      ->(p){Point.new( p.x, p.y+1 )},
      ->(p){Point.new( p.x+1, p.y+1 )},
      ->(p){Point.new( p.x-1, p.y+1 )}
      ],
      :r => ->(p){ Point.new(p.x,p.y+1)}
    },
    {
      :o =>  [
      ->(p){Point.new( p.x-1, p.y )},
      ->(p){Point.new( p.x-1, p.y-1 )},
      ->(p){Point.new( p.x-1, p.y+1 )}
      ],
      :r => ->(p){Point.new(p.x-1,p.y)}
    },
    {
      :o => [
      ->(p){Point.new( p.x+1, p.y )},
      ->(p){Point.new( p.x+1, p.y+1 )},
      ->(p){Point.new( p.x+1, p.y-1 )}
      ],
      :r => ->(p){Point.new(p.x+1,p.y)}
    }
  ]
option_index = 0

# part 1
#10.times do |iter| 

#part 2
1_000_000.times do |iter|

  proposed = Hash.new { |h, k| h[k] = [] }

  elves.each do |e,_|
    adj = e.adjacent.count { |x| grid[x] == '#' }
    next if adj == 0

    options.count.times do |time|
      i = (option_index+time)%options.count
      sum = options[i][:o].count { |p| grid[p.call(e)] != '#' }
      if sum == 3
        pp = options[i][:r].call(e)
        proposed[pp] << e
        break
      end
    end
  end

  moves = 0
  proposed.each do |destination,targets|
    next if targets.count > 1
    moves += 1
    grid[destination] = '#'
    elves[destination] = true
    grid[targets.first] = '.'
    elves.delete(targets.first)
  end

  # for part 2
  if moves == 0
    p iter+1
    exit
  end

  option_index = ( option_index + 1 ) % options.count
end

xsort = elves.keys.sort { |a,b| a.x <=> b.x }
ysort = elves.keys.sort { |a,b| a.y <=> b.y }

# area of bounding rectangle minus number of elves
p (xsort.last.x-xsort.first.x+1)*(ysort.last.y-ysort.first.y+1) - elves.count

