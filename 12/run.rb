require_relative '../lib/common'
require_relative '../lib/pqueue'

def find_path( grid, the_start, the_end )

  visited, distances, prev = {},{},{}
  pq = PQueue.new {|x,y| distances[x] < distances[y] }
  pq.push(the_start)
  visited[the_start] = true
  distances[the_start] = 0

  while ! pq.empty?
    current = pq.pop
    visited[current] = true

    current.hvadjacent.each do |a|
      next if ! grid[a] || visited.key?(a) || ( (grid[a].ord-grid[current].ord) > 1 )
      distance = 1
      if ! distances.key?(a) || distances[a] > distance
        distances[a] = distance
        prev[a] = current
        pq.push(a)
      end
    end

    break if current == the_end
  end

  path = grid[the_end]
  pprev = prev[the_end]
  return 1000000 if ! pprev

  while pprev != the_start
    path += grid[pprev]
    pprev = prev[pprev]
  end

  path.chars.count
end


the_start, the_end = nil,nil
grid = Grid.new( :io => ARGF )
grid.each do |pp|
  if grid[pp] == 'S'
    the_start = pp
  elsif grid[pp] == 'E'
    the_end = pp
  end
end

grid[the_start] = 'a'
grid[the_end] = 'z'
p "part1: #{find_path( grid, the_start, the_end )}"

starts = []
grid.each do |pp|
  starts << pp if grid[pp] == 'a'
end


p "part 2: #{starts.map{ |s| find_path(grid, s, the_end ) }.min}"



