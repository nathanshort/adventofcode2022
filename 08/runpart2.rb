
data = []
ARGF.each_line.with_index do |line,y|
  row = []
  line.chomp.chars.each_with_index{ |c,x| row << c.to_i }
  data << row
end

all_distances = []
(0..98).each do |y|
  (0..98).each do |x|

    distances = []

    distance = 0
    data[y].slice(x+1..).each do |v|
      distance += 1
      break if data[y][x] <= v
    end
    distances << distance

    distance = 0
    data[y].slice(0,x).reverse.each do |v| 
      distance += 1
      break if data[y][x] <= v
    end
    distances << distance

    distance = 0
    (y-1).downto(0).each do |v|
      distance += 1
      break if data[y][x] <= data[v][x]
    end
    distances << distance

    distance = 0
    (y+1).upto(98).each do |v|
      distance += 1
      break if data[y][x] <= data[v][x] 
    end
    distances << distance

    all_distances <<  distances.reduce(:*)
  end
end

p all_distances.max
