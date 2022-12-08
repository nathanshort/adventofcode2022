# maps dir to size of files in dir
dirs = Hash.new(0)

pwd = []
ARGF.each_line( chomp: true ) do |line|
  case line
  when /\$ cd \.\./
    pwd.pop
  when /\$ cd (.+)/
    pwd << $1
  when /\A(\d+) (.+)\Z/
    pwd.each_with_index do |_,i| 
      dirs[pwd[0..i].join("/")] += $1.to_i
    end
  end
end

unused = 70_000_000 - dirs['/']
needed = 30_000_000 - unused
p dirs.select { |k,v| v <= 100_000 }.values.sum
p dirs.select { |k,v| v >= needed }.values.min
