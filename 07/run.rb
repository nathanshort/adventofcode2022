
# maps dir to size of files in dir
dirs = {}

pwd = []
ARGF.each_line( chomp: true ) do |line|
  case line
  when /\$ cd \.\./
    pwd.pop
  when /\$ cd (.+)/
    pwd << $1
  when /\A(\d+) (.+)\Z/
    dupped = pwd.dup
    while dupped.count != 0
      path = dupped.join("/")
      dupped.pop
      dirs[path] ||= 0
      # assumes that the input isnt going to the same dir multiple times
      dirs[path] += $1.to_i
    end
  end
end

unused = 70_000_000 - dirs['/']
needed = 30_000_000 - unused
p dirs.select { |k,v| v <= 100_000 }.values.sum
p dirs.select { |k,v| v >= needed }.values.min
