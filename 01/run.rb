#!/usr/bin/env ruby

data = ARGF.read.split(/\n\n/).map{ |x| x.split(/\n/).map( &:to_i) }
sums = data.map( &:sum )
p sums.max
p sums.max(3).sum


