
require_relative '../lib/common.rb'

def piece_overlaps_board?( piece, board )
  piece.each do |point,val|
    return true if val == '#' && board[point] == '#' 
  end
  return false
end


def run( board, jet_data, piece_offset, jet_offset, iterations, do_signature )

  pieces = [
    ShiftedGrid.new(:io => "####"),
    ShiftedGrid.new(:io => ".#.\n###\n.#."),
    ShiftedGrid.new(:io => "..#\n..#\n###"),
    ShiftedGrid.new(:io => "#\n#\n#\n#"),
    ShiftedGrid.new(:io => "##\n##")
  ]

  piece_counter = piece_offset
  jet_counter = jet_offset

  signatures = {}
  iterations.times do |time| 

    piece = pieces[piece_counter].dup
    piece_counter = ( piece_counter + 1 ) % pieces.count

    piece.xoff = 2

    # for the Grid class, down is positive y - so we adjust here
    piece.yoff = board.ymin - 3 - piece.height

    can_drop = true
    while can_drop

      jet = jet_data[jet_counter]
      jet_counter = ( jet_counter + 1 ) % jet_data.count

      if jet == '>'
        if piece.xmax + 1 <= board.xmax
          piece.xoff += 1
          piece.xoff -=1 if piece_overlaps_board?( piece, board)
        end
      else
        if piece.xmin - 1 >= board.xmin
          piece.xoff -= 1
          piece.xoff +=1 if piece_overlaps_board?( piece, board)
        end
      end

      # see if we can drop
      piece.yoff += 1
      if piece_overlaps_board?( piece, board )
        piece.yoff -= 1
        can_drop = false
        piece.each { |point,val| board[point] = '#' if val == '#' }
      end
    end

    # Used to detect the cycle.  if the piece, jet position, and
    # board are the same state as has already been seen - then we have a
    # cycle.  the board state is the distance from the top of the board, for each column.
    if do_signature
      signature = [piece_counter, jet_counter]
      7.times do |x|
        ymin = board.ymin
        while true
          if board[Point.new(x,ymin)] == '#'
            signature << (ymin - board.ymin)
            break
          end
          ymin += 1
        end
      end

      if signatures.key?(signature)
        p "cycle at:#{time+1} prev:#{signatures[signature]} signature:#{signature} height:#{board.ymin}"
        board.show
        exit
      else
        signatures[signature] = {:time => time+1, :height => board.ymin}
      end
    end
  end
end


jet_data = ARGF.read.chomp.chars
board = Grid.new(:io => "#######")
run( board, jet_data, piece_offset=0, jet_offset=0, iterations=2022, do_signature=false)
p "part 1:#{board.ymin}"


# For part 2, we run the loop above with the cycle detection enabled ( and a larger number of iterations).
# This shows the cycle as follows
#
# "cycle at:2182 prev:{:time=>442, :height=>-654} signature:[2, 2613, 1, 0, 1, 3, 3, 4, 10] height:-3320"
#
# So a cycle every (2182-442)=1740 drops, starting at drop 442, and that cycle adds a height
# of 3320-654 = 2666
#
# (1000000000000-442)/1740 gets us 574712643 full cycles, so that would end
# at 442+574712643*1740 = 999999999262.   The height at this point is
# 654+2666*574712643 = 1532183906892.  But we still need to run 1000000000000-999999999262 = 738 cycles
#
# so - lets construct the state of the grid at the time that a cycle is hit, then run another 738 cycles
# we get the state of the board from the signature above

board2 = Grid.new( :io => ".#.....\n###....\n.#.....\n.####..\n...###.\n...###.\n.###.#.\n..#..#.\n.###.#.\n..#..#.\n..#####\n")
run( board2, jet_data, piece_offset=2, jet_offset=2613, iterations=738, do_signature=false )
p "part 2:#{board2.ymin.abs+1532183906892}"


