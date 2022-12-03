#!/usr/bin/env ruby

lines = ARGF.readlines( chomp: true)

def score( common )
  common.ord >= 97 ? common.ord-96 : common.ord-38
end

p1sum, p2sum = 0,0

lines.each do |line|
  a,b = line.chars.each_slice(line.length/2).map(&:join)
  p1sum += score( ( a.chars & b.chars).first )
end


lines.each_slice(3) do |triple|
  p2sum += score( ( triple[0].chars & triple[1].chars & triple[2].chars).first )
end

p p1sum, p2sum


