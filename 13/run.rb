
def compare( lhs, rhs )
  while true
    l = lhs.shift
    r = rhs.shift

    return 0 if r.nil? && l.nil?
    return -1 if l.nil?
    return 1 if r.nil?

    if l.kind_of?(Numeric) && r.kind_of?(Numeric)
      return -1 if l < r
      return 1 if l > r 
    elsif l.kind_of?(Array) && r.kind_of?(Array)
      rr = compare( l.dup,r.dup )
      return rr if rr != 0
    elsif
      l.kind_of?(Numeric) ^ r.kind_of?(Numeric)
      l = l.kind_of?(Numeric) ? [l] : l
      r = r.kind_of?(Numeric) ? [r] : r
      rr = compare( l.dup, r.dup )
      return rr if rr != 0
    end
  end
  -1
end

all_packets = []
ARGF.read.split(/\n\n/).each do |split|
  split.split(/\n/).map{ |x| eval(x) }.each { |x| all_packets.append(x) }
end

compares = []
index = 1
all_packets.each_slice(2) do |l,r|
  compares << index if compare( l.dup, r.dup ) == -1
  index += 1
end


all_packets << [[2]]
all_packets << [[6]]

sorted = all_packets.sort { |a,b| compare(a.dup,b.dup) }

p "part 1: #{compares.sum}"
p "part 2: #{(sorted.index([[2]]) +1 )* (sorted.index([[6]])+1)}"
