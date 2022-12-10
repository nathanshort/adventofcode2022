require 'scanf'

def movex( head, tail )
  tail[0] < head[0] ? tail[0] += 1 : tail[0] -= 1
end

def movey( head, tail )
  head[1] > tail[1] ? tail[1] += 1 : tail[1] -= 1
end

def run( instructions, knot_count )

  rope, visits = [],[]
  knot_count.times do |index|
    rope.append([0,0])
    visits[index] = {}
  end

  moves = {
    'R' => ->(pos){pos[0]+=1},
    'L' => ->(pos){pos[0]-=1},
    'U' => ->(pos){pos[1]+=1},
    'D' => ->(pos){pos[1]-=1},
  }

  instructions.each do |instruction|

    direction,count = instruction
    count.times do

      moves[direction].call(rope[0])
      (rope.count-1).times do |index|

        head = rope[index]
        tail = rope[index+1]

        if ((tail[1]-head[1]).abs == 2 && (tail[0] == head[0]) )
          movey( head, tail )
        elsif ((tail[0]-head[0]).abs == 2 && (tail[1] == head[1]) )
          movex( head, tail )
        elsif head != tail &&
          (( (head[0]-tail[0]).abs + (head[1]-tail[1]).abs ) > 2 ) 
          movey( head, tail )
          movex( head, tail )
        end
        visits[index+1][tail.dup]= true
      end
    end
  end
  visits.last.keys.count
end

instructions = ARGF.readlines(chomp:true).map { |line| line.scanf("%c %d")}
p run( instructions, 2 )
p run( instructions, 10 )

