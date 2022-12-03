#!/usr/bin/env ruby

LOSE = 0
DRAW = 3
WIN = 6

loses_to = { 'X' => 'Z', 'Y' => 'X', 'Z' => 'Y' }
beats = loses_to.invert
normalize = { 'A' => 'X', 'B' => 'Y', 'C' => 'Z' }
points = { 'X' => 1, 'Y' => 2, 'Z' => 3 }

p1score,p2score = 0,0

ARGF.each_line do |line|
  opp, me = line.split(/\s/).map{ |v| normalize[v] || v }
  p1score += points[me] + ( opp == me ? DRAW : loses_to[opp] == me ? LOSE : WIN )
  p2score += me == 'X' ? points[loses_to[opp]] : me == 'Y' ? DRAW+points[opp] : WIN+points[beats[opp]]
end

p p1score, p2score
