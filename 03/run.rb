#!/usr/bin/env ruby

lines = ARGF.readlines( chomp: true)

def score( common )
  common.ord >= 97 ? common.ord-96 : common.ord-38
end

p1sum, p2sum = 0,0

lines.each do |line|
  p1sum += score( line.chars.each_slice(line.length/2).reduce(:&).first )
end


lines.each_slice(3) do |triple|
  p2sum += score( triple.map(&:chars).reduce(:&).first )
end

p p1sum, p2sum


