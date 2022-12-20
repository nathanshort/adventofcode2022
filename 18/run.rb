

def neighbors(node)
  offsets = [[1,0,0],  #right
             [-1,0,0], #left
             [0,1,0],  #up
             [0,-1,0], #down
             [0,0,1],  #forward
             [0,0,-1], #backward
            ]
  offsets.map{ |offset| [node[0]+offset[0], node[1]+offset[1], node[2]+offset[2]] }
end


# visit all cubes outside of the droplet.  constrained by a bounding cube
# larger than the droplet range
def visit_all( point, visited, all_cubes )

  xr = (all_cubes.keys.map{ |k| k[0] }.min - 1 .. all_cubes.keys.map{ |k| k[0] }.max + 1 )
  yr = (all_cubes.keys.map{ |k| k[1] }.min - 1 .. all_cubes.keys.map{ |k| k[1] }.max + 1 )
  zr = (all_cubes.keys.map{ |k| k[2] }.min - 1 .. all_cubes.keys.map{ |k| k[2] }.max + 1 )

  visited[point] = true
  queue = []
  queue.append(point)

  while node = queue.pop
    neighbors(node).each do |n|

      next if all_cubes.key?(n) ||
              ! xr.cover?(n[0]) ||
              ! yr.cover?(n[1]) ||
              ! zr.cover?(n[2]) ||
              visited.key?(n)

      queue.append(n)
      visited[n] = true
    end
  end
end

sides = []
cubes = {}

ARGF.each_line(chomp:true) do |line|
  x,y,z = line.scan(/\d+/).map( &:to_i )
  cubes[[x,y,z]] = true
  sides.append([[x,y,z],[x,y+1,z],[x+1,y+1,z],[x+1,y,z]].sort,  #front
               [[x,y+1,z],[x+1,y+1,z],[x+1,y+1,z+1],[x,y+1,z+1]].sort, #top
               [[x,y,z],[x+1,y,z],[x+1,y,z+1],[x,y,z+1]].sort, #bottom
               [[x,y,z+1],[x,y+1,z+1],[x+1,y+1,z+1],[x+1,y,z+1]].sort, #back
               [[x,y,z],[x,y+1,z],[x,y+1,z+1],[x,y,z+1]].sort, #left
               [[x+1,y,z],[x+1,y+1,z],[x+1,y+1,z+1],[x+1,y,z+1]].sort, #right
              )
end

# seems excessively complicated.  find all sides in the loop above, then, any side
# that is seen exactly once - is not sharing with anyone else
h = Hash.new(0)
sides.each { |side| h[side]+=1 }
part1 = h.select{ |k,v| v == 1 }.count

visited = {}
visit_all([0,0,0], visited, cubes )

# any cube in the droplet that has a face that touches a cube outside of the droplet - will
# have surface area n times - once per adjacent outside of droplet cube
part2 = cubes.keys.each.inject(0) { |memo,c| memo + neighbors(c).count { |n| visited.key?(n)  } }

p part1
p part2



