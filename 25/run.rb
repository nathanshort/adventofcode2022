
sum = 0
ARGF.each_line(chomp:true) do |line|
  line.chars.reverse.each_with_index do |c,i|
    num = case c
          when '='
            -2
          when '-'
            -1
          else
            c.to_i
          end
    sum += (5**i)*num
  end
end

as_snafu = ""
while sum > 0
  case sum%5
  when 0
    as_snafu.prepend( '0' )
  when 1
    as_snafu.prepend( '1' )
    sum -= 1
  when 2
    as_snafu.prepend( '2' )
    sum -= 2
  when 3
    as_snafu.prepend( "=" )
    sum -= -2
  when 4
    as_snafu.prepend( "-" )
    sum -= -1
  end
  sum /= 5
end

puts as_snafu
