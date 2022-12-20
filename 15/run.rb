require 'scanf'

all_ranges = []


# keep track of all beacons keyed by the y pos
beaconpos = Hash.new { |h, k| h[k] = [] }

ARGF.each_line do |line|

  a,b,c,d = line.scanf("Sensor at x=%d, y=%d: closest beacon is at x=%d, y=%d")
  sensor = [a,b]
  beacon = [c,d]
  beaconpos[d] << c
  distance = (sensor[1]-beacon[1]).abs + (sensor[0]-beacon[0]).abs

  # for each row, define a range which is the (minx..maxx) that
  # another beacon cant be at.  basically - the left hand and right
  # hand side of the diamond - at that row
  (0..4_000_000).each do |target|
    all_ranges[target] ||= []

    # diamond is symmetrical around the sensor
    diff = (target - sensor[1]).abs
    next if distance < diff

    range = ( (sensor[0]-(distance-diff))..( sensor[0]+(distance-diff ) ) )
    all_ranges[target] << range
  end
end

# part 1
target_row = 2_000_000
p ( all_ranges[target_row].map{ |x| x.to_a }.flatten.uniq - beaconpos[target_row]).count

# part 2 - now that we have the ranges for every row, we will
# sort and consolidate those ranges into hopefully 1 range.  we will then find a row
# that has *more* than 1 range, meaning that there is a gap in the ranges.
# this is where the beacon is. 
all_ranges.each_with_index do |range,index|
  sorted = range.sort{|a,b| a.first <=> b.first }
  rr = [ [sorted.first.min, sorted.first.max ] ]

  sorted.each do |s|
    if rr.last.last+1 >= s.first && s.last > rr.last.last
      rr.last[1] = s.last
    elsif s.first > rr.last.last
      rr.append( [s.first, s.last ])
    end
  end

  if rr.count > 1
    p index + (rr[0].last+1) * 4000000
    break
  end

end
