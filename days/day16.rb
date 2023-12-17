require 'set'
require './util'
module Days 
  class Day16
    def self.run(test)
      grid = Util.get_grid("16#{test}")

      grid.each { |row| puts row.join('') }
      puts

      max_energized = 0

      (0..grid[0].count - 1).each do |x|
        puts "#{x},0"
        visited = move_light(grid, [x,0], "d", Set.new, Set.new)
        display_visited(grid, visited)
        puts "Energized Count: #{visited.count}"
        puts

        max_energized = visited.count if visited.count > max_energized

        max_y = grid.count - 1
        puts "#{x},#{max_y}"
        visited = move_light(grid, [x,max_y], "u", Set.new, Set.new)
        display_visited(grid, visited)
        puts "Energized Count: #{visited.count}"
        puts

        max_energized = visited.count if visited.count > max_energized
      end

      (0..grid.count - 1).each do |y|
        visited = move_light(grid, [0,y], "r", Set.new, Set.new)
        display_visited(grid, visited)
        puts "Energized Count: #{visited.count}"
        puts

        max_energized = visited.count if visited.count > max_energized

        max_x = grid[0].count - 1
        visited = move_light(grid, [max_x,y], "l", Set.new, Set.new)
        display_visited(grid, visited)
        puts "Energized Count: #{visited.count}"
        puts

        max_energized = visited.count if visited.count > max_energized
      end

      puts "Max Energized Count: #{max_energized}"
    end

    private

    def self.display_visited(grid, visited)
      grid.each_with_index do |row, y| 
        row_string = ""

        row.each_with_index do |v, x|
          if v == '.' && visited.include?([x,y])
            row_string << '#'
            next
          end

          row_string << v
        end

        puts row_string
      end
    end

    def self.move_light(grid, current, dir, visited, visited_w_dir)
      #puts "#{dir}: #{current.inspect}"
      x = current[0]
      y = current[1]

      return visited if current[0] < 0 || current[0] > grid[0].count - 1 ||
        current[1] < 0 || current[1] > grid.count - 1 || visited_w_dir.include?([x,y,dir])

      val = grid[y][x]

      movement = get_movement(val, dir)
      if movement[2] && !visited.include?([x,y])
        split_diff = movement[2][0]
        visited << current
        visited_w_dir << [x,y,dir]
        visited += move_light(grid, [x + split_diff[0], y + split_diff[1]], movement[2][1], visited, visited_w_dir)
      else
        visited << current
        visited_w_dir << [x,y,dir]
      end

      diff = movement[0]

      # puts
      # puts "#{dir} - #{current.inspect}"
      # display_visited(grid, visited)
      # puts
      move_light(grid, [x + diff[0], y + diff[1]], movement[1], visited, visited_w_dir)
    end

    LEFT_HASH_MAP = {
      'r' => 'd',
      'l' => 'u',
      'u' => 'l',
      'd' => 'r'
    }

    RIGHT_HASH_MAP = {
      'r' => 'u',
      'l' => 'd',
      'u' => 'r',
      'd' => 'l'
    }

    def self.get_movement(val, dir)
      split_movement = nil
      case val
      when '.'
        # do nothing
      when '|'
        if dir == 'r' || dir =='l' 
          dir = 'd'

          split_movement = [[0,-1], 'u']
        end
      when '-'
        if dir == 'u' || dir =='d' 
          dir = 'r'

          split_movement = [[-1,0], 'l']
        end
      when '\\'
        dir = LEFT_HASH_MAP[dir]
      when '/'
        dir = RIGHT_HASH_MAP[dir]
      end 

      diff = nil
      case dir
      when 'r'
        diff = [1,0]
      when 'l'
        diff = [-1,0]
      when 'u'
        diff = [0,-1]
      when 'd'
        diff = [0,1]
      end

      [diff, dir, split_movement]
    end
  end
end
