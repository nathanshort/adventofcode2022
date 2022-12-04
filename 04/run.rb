#!/usr/bin/env ruby

require 'scanf'

covers, overlaps = 0,0

ARGF.each_line do |line| 

  a,b,c,d = line.scanf('%d-%d,%d-%d')
  r1 = (a..b)
  r2 = (c..d)

  covers += 1 if r1.cover?(r2) || r2.cover?(r1)
  overlaps += 1 if ( r1.to_a & r2.to_a ).count != 0 
end

p covers, overlaps
