
data = []

ARGF.each_line.with_index do |line, index|
  data.append( [ line.to_i * 811589153, index ] )
end

10.times do
  data.count.times do |index|
  pos = data.index { |x| x.last == index }
  x = data.delete_at( pos )
  data.insert( (pos+x.first) % data.size, x )
  end
end

pos = data.index{ |x| x.first == 0 }
p data[(pos + 1000) % data.size].first +
  data[(pos + 2000) % data.size].first +
  data[(pos + 3000) % data.size].first

