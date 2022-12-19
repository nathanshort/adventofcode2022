

# find min distances between all pairs
def min_distances( valves )
  dist = Hash.new{|h,k| h[k] = {}}
  valves.each do |v,vv|
    valves.keys.each { |k| dist[v][k] = 1_000_000 }
    dist[v][v] = 0
    vv[:neighbors].each { |n| dist[v][n] = 1 }
  end

  valves.each do |k,kv|
    valves.each do |i,iv|
      valves.each do |j,jv| 
        if dist[i][j] > dist[i][k] + dist[k][j]
          dist[i][j] = dist[i][k] + dist[k][j]
        end
      end
    end
  end
  dist
end



# find the path between current and all remaining valves that have non zero pressure
# remaining to open
def find_path( current, seconds_remaining, path, all_paths, with_pressure)

  path << { :v => current, :s => seconds_remaining }
  with_pressure_dup = with_pressure.dup
  with_pressure_dup.delete(current)
  move_possible = false

  if seconds_remaining > 0 || ! with_pressure_dup.empty?
    with_pressure_dup.keys.each do |wp|

      # -1 as we need 1 second to open the valve
      sr = seconds_remaining - $distances[current][wp] - 1
      next if sr <= 0
      next if wp == current
      move_possible = true
      find_path( wp, sr, path, all_paths, with_pressure_dup )
    end
  end

  all_paths << path.sum { |pi| $all_valves[pi[:v]][:rate] * pi[:s] } if ! move_possible
  path.pop
end


$all_valves = {}
valves_with_pressure = {}

ARGF.each_line.with_index do |line,index| 
  match = line.match(/Valve (.+) has flow rate=(.+); tunnels? leads? to valves? (.+)\Z/ )
  valve = match[1]
  rate = match[2].to_i
  neighbors = match[3].split(/, /)
  $all_valves[valve] = {:rate => rate, :neighbors => neighbors }
  valves_with_pressure[valve] = true if rate != 0
end

$distances = min_distances( $all_valves )
all_paths = []
find_path( 'AA', 30, [], all_paths, valves_with_pressure )

puts "part 1:#{all_paths.max}"


# not sure this works 100% of the time - expects that one person does half and the other person does
# the other half.  but ... it gets the right solution
scores = []
combos = valves_with_pressure.keys.combination( (valves_with_pressure.keys.count/2.to_f).ceil).to_a
combos.each do |combo|
  other = valves_with_pressure.keys - combo
  comboh = {}
  combo.each { |x| comboh[x] = true }
  otherh = {}
  other.each { |x| otherh[x] = true }

  paths1 = []
  find_path( 'AA', 26, [], paths1, comboh )

  paths2 = []
  find_path( 'AA', 26, [], paths2, otherh )

  scores << paths1.max + paths2.max
end

p "part 2: #{scores.max}"
