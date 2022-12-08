
def find( input, len )
  input.chars.each_cons(len) do |c|
    if c.uniq.count == c.length
      return input.index(c.join) + len
    end
  end
end

input = ARGF.read
p find(input,4)
p find(input,14)

