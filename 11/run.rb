
monkeys = []
mod = 1

ARGF.read.split(/\n\n/).each_with_index do |md,i|
  lines = md.split(/\n/)
  monkeys <<
  {
    :items => lines[1].scan(/\d+/).map( &:to_i ),
    :op => lines[2].match(/= (.*) (.*) (.*)/).to_a[1..],
    :test => lines[3].scan(/\d+/).first.to_i,
    :iftrue => lines[4].scan(/\d+/).first.to_i,
    :iffalse => lines[5].scan(/\d+/).first.to_i,
    :inspected => 0
  }
  mod *= monkeys.last[:test]
end

10000.times do |round|
  monkeys.each do |m| 
    while m[:items].count != 0
      m[:inspected] += 1
      item = m[:items].shift
      lhs = m[:op][0] == 'old' ? item : m[:op][0].to_i
      rhs = m[:op][2] == 'old' ? item : m[:op][2].to_i
      item = m[:op][1] == '+' ? ( lhs + rhs ) : ( lhs * rhs )
      #part1 item /= 3
      item %= mod
      if item % m[:test] == 0
        monkeys[m[:iftrue]][:items] << item
      else
        monkeys[m[:iffalse]][:items] << item
      end
    end
  end
end

p monkeys.map{ |x| x[:inspected]}.max(2).reduce(:*)
