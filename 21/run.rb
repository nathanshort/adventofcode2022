
monkeys = {}
original_numbers = {}

ARGF.each_line do |line|
  monkey, other = line.split(/: /)
  if number = other.match(/\d+/)
    monkeys[monkey] = { :number => number[0].to_i }
    original_numbers[monkey] = true
  else
    op1, operand, op2 = other.split
    l = case operand
        when '+'
          ->(a,b){a+b}
        when '-'
          ->(a,b){a-b}
        when '*'
          ->(a,b){a*b}
        when '/'
          ->(a,b){a/b}
    end
    monkeys[monkey] = { :op1 => op1, :op2 => op2, :operand => l }
  end
end

def doit( target, monkeys )

  return monkeys[target][:number] if monkeys[target][:number]
  o1 = doit(monkeys[target][:op1], monkeys )
  o2 = doit(monkeys[target][:op2], monkeys )
  monkeys[target][:number] = monkeys[target][:operand].call(o1,o2)
  return monkeys[target][:number]
end

# part 1
p doit( 'root', monkeys)

# part 2 - return a comparator of a and b.  then binary
# search until a == b
# This seems to return multiple possible values - for example
# 3509819803066 instead of 3509819803065 - probably because
# this is doing integer division.  so - try it a couple times
# to hone in on the actual value
monkeys['root'][:operand] = ->(a,b){ a <=> b }

low = 0
high = 1_000_000_000_000_000_000_000

while true
  mid = ( high + low  ) / 2
  monkeys['humn'][:number] = mid

  # reset to the original state each time
  monkeys.each { |k,_| monkeys[k].delete(:number) if ! original_numbers.key?(k)}
  r = doit( 'root', monkeys )
  if r == -1
    high = mid
  # lhs > rhs
  elsif r == 1
    low = mid
  else
    print mid
    break
  end
end
