#require "tetris/version"
module TetrisEngine

  class Tetris
    attr_reader :rows

    def initialize width=10, height=22
      @rows = Array.new
      @tops = Array.new(width, 0) # to keep track of the top cells per column that are filled  with tetrominoes
      height.times do
        add_row width
      end
    end

    def start
      until game_over?
        tetromino = Tetromino.new
        puts "\nTetromino color is #{tetromino.color}"
        tetromino.move gets.to_i
        play tetromino
        clear_lines.times { decrement_tops }
        print_play_field
      end
    end

    def play tetromino
      x = tetromino.location
      y = [@tops[x], @tops[x+1]].max
      @tops[x] = y + 2
      @tops[x + 1] = y + 2
      @rows[y][x] = tetromino.color
      @rows[y+1][x] = tetromino.color
      @rows[y][x+1] = tetromino.color
      @rows[y+1][x+1] = tetromino.color
    end

    def clear_lines
      index, cleared_lines_count = 0, 0
      @rows.length.times do
        if @rows[index].first!=' ' && @rows[index].uniq.length == 1
          @rows.delete_at index
          add_row @tops.length
          index -= 1
          cleared_lines_count += 1
        end
        index += 1
      end
      cleared_lines_count
    end

    def decrement_tops
      @tops.map! { |top| top -= 1}
    end

    def add_row width=10
      @rows << Array.new(width, ' ')
    end

    def print_play_field
      @rows.reverse.each do |row|
        puts row.join '|'
      end
      scale = Array.new
      @tops.length.times { |num| scale << num }
      puts scale.join '|'
    end

    def game_over?
      return @tops.include?(@rows.length)
    end
  end

  class Tetromino
    attr_accessor :location
    attr_reader :color

    COLORS = [ 'I', 'O', 'T', 'S', 'Z', 'J', 'L' ]

    # location argument specifies the x coordinate of the tetromino's leftmost cell'
    def initialize location = 4
      @color = COLORS[rand(COLORS.length)]
      @location = location
    end

     def move desired_coord
      displacement = desired_coord - @location
      displacement.abs.times { displacement < 0 ? move_left : move_right }
      @location
    end

    def move_left
      @location -= 1
    end

    def move_right
      @location += 1
    end
  end
end