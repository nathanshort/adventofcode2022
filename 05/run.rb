#!/usr/bin/env ruby

c,i = ARGF.read.split(/\n\n/)

crates = []
c.split(/\n/).each do |line|
  line.scan(/.{3}\s?/).each_with_index do |val,index| 
    if matches = val.match(/\[(.)\]/)
      crates[index+1] ||= []
      crates[index+1].unshift( matches[1] )
    end
  end
end

crates9001 = Marshal.load(Marshal.dump(crates))

i.split(/\n/).each do |line|
  count,source,destination = line.scan(/\d+/).map(&:to_i)
  count.times { crates[destination] << crates[source].pop }
  crates9001[destination] += crates9001[source].pop(count)
end

puts crates[1..].collect(&:last).join
puts crates9001[1..].collect(&:last).join

