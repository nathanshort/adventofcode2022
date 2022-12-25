
State = Struct.new( :ore, :ore_robots, :clay, :clay_robots, :obsidian,
                    :obsidian_robots, :geodes, :geode_robots, :minutes,
                    keyword_init: true )


def search( starting_state, paths, ore_robot_cost, clay_robot_cost, obsidian_robot_cost, geode_robot_cost  )

  queue = []
  queue << starting_state

  visited = {}

  while state = queue.pop

    key = [state.ore, state.clay, state.ore_robots, state.clay_robots, state.obsidian_robots, state.obsidian, state.geode_robots, state.geodes, state.minutes ]
    if visited.key?(key)
      next
    end
    visited[key.dup] = true

    if state.minutes == 0
      paths << state.dup
      next
    end

    could_ore_robot = state.ore >= ore_robot_cost &&
                      state.ore_robots < [ore_robot_cost,clay_robot_cost,obsidian_robot_cost[0], geode_robot_cost[0]].max

    could_clay_robot =  state.ore >= clay_robot_cost && state.clay_robots < obsidian_robot_cost[1]
    could_obsidian_robot = state.clay >= obsidian_robot_cost[1] && state.ore >= obsidian_robot_cost[0]
    could_geode_robot = state.obsidian >= geode_robot_cost[1] && state.ore >= geode_robot_cost[0]

    if could_ore_robot && ! could_geode_robot && ! could_obsidian_robot
      new_state = state.dup
      new_state.minutes -= 1
      new_state.ore = ( new_state.ore - ore_robot_cost ) + new_state.ore_robots
      new_state.ore_robots += 1
      new_state.obsidian += new_state.obsidian_robots
      new_state.clay += new_state.clay_robots
      new_state.geodes += new_state.geode_robots
      queue << new_state
    end

    if could_clay_robot && ! could_geode_robot && ! could_obsidian_robot
      new_state = state.dup
      new_state.minutes-=1
      new_state.ore = ( new_state.ore - clay_robot_cost ) + new_state.ore_robots
      new_state.clay += new_state.clay_robots
      new_state.clay_robots += 1
      new_state.obsidian += new_state.obsidian_robots
      new_state.geodes += new_state.geode_robots
      queue << new_state
    end

    if could_obsidian_robot && ! could_geode_robot 
      new_state = state.dup
      new_state.minutes-=1
      new_state.clay = new_state.clay - obsidian_robot_cost[1] + new_state.clay_robots
      new_state.ore = new_state.ore - obsidian_robot_cost[0] + new_state.ore_robots
      new_state.obsidian += new_state.obsidian_robots
      new_state.obsidian_robots += 1
      new_state.geodes += new_state.geode_robots
      queue << new_state
    end

    if could_geode_robot 
      new_state = state.dup
      new_state.minutes-=1
      new_state.obsidian = new_state.obsidian - geode_robot_cost[1] + new_state.obsidian_robots
      new_state.ore = new_state.ore - geode_robot_cost[0] + new_state.ore_robots
      new_state.geodes += new_state.geode_robots
      new_state.clay += new_state.clay_robots
      new_state.geode_robots += 1
      queue << new_state
    end

    if ! could_geode_robot && ! could_obsidian_robot
      new_state = state.dup
      new_state.minutes-=1
      new_state.ore += state.ore_robots
      new_state.clay += state.clay_robots
      new_state.obsidian += state.obsidian_robots
      new_state.geodes += new_state.geode_robots
      queue << new_state
    end

  end
end



blueprints = ARGF.each_line(chomp:true).map { |line| line.scan(/\d+/).map( &:to_i ) }

qualities = []
blueprints.each do |data| 
  bp = data[0]
  p "bp:#{bp}"
  state = State.new( ore: 0, ore_robots: 1, clay:0, clay_robots:0, obsidian:0,
                     obsidian_robots:0, geodes:0, geode_robots:0, minutes:24 )
  ore_robot_cost = data[1]
  clay_robot_cost = data[2]
  obsidian_robot_cost = [data[3],data[4]]
  geode_robot_cost = [data[5],data[6]]
  paths = []
  search( state, paths, ore_robot_cost, clay_robot_cost, obsidian_robot_cost, geode_robot_cost )
  qualities << paths.map{ |x| x.geodes }.max * bp
end
p "part 1:#{qualities.sum}"

counts = []
blueprints[0..2].each do |data|
  bp = data[0]
  p bp
  state = State.new( ore: 0, ore_robots: 1, clay:0, clay_robots:0, obsidian:0,
                     obsidian_robots:0, geodes:0, geode_robots:0, minutes:32 )
  ore_robot_cost = data[1]
  clay_robot_cost = data[2]
  obsidian_robot_cost = [data[3],data[4]]
  geode_robot_cost = [data[5],data[6]]
  paths = []
  search( state, paths, ore_robot_cost, clay_robot_cost, obsidian_robot_cost, geode_robot_cost )
  counts << paths.map{ |x| x.geodes }.max
end
p "part 2:#{counts.reduce(:*)}"
