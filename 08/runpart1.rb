
visible = {}
max_top = Array.new( 99 )
bottom = []
ARGF.each_line.with_index do |line,y|

  max_left_this_row = nil
  right = Array.new( 9 )
  line.chomp.chars.each_with_index do |c,x|
    val = c.to_i
    bottom[x] ||= Array.new(9)

    # do the row
    if max_left_this_row.nil? || val > max_left_this_row
      max_left_this_row = val
      visible[[x,y]] = true
    end
    (0..val).each { |v| right[v] = nil }
    right[val] = [x,y]

    #do the col
    if max_top[x].nil? || val > max_top[x]
      max_top[x] = val
      visible[[x,y]] = true
    end
    (0..val).each do |v|
      bottom[x][v] = nil
    end
    bottom[x][val] = [x,y] 
  end
  right.each { |coord| visible[coord] = true if ! coord.nil? }
end

bottom.each do |x|
  x.each { |coord| visible[coord] = true if ! coord.nil? }
end

p visible.count




