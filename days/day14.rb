module Days 
  class Day14
    # 113424 is too high
    113424

    def self.run(test)
      grid = Util.get_grid("14#{test}")

      seen = {}
      repeat_len = 0
      c_i = 0

      1_000_000_000.times do |i|
        roll_north(grid)
        roll_west(grid)
        roll_south(grid)
        roll_east(grid)

        key = grid.map { |row| row.join('') }.join('')
        if prev_iter = seen[key]
          repeat_len = i - prev_iter
          c_i = i
          puts "Current iteration #{i}; Last Seen: #{prev_iter} - #{repeat_len}"
          break
        end

        seen[key] = i
      end

      remaining_cycles = 1_000_000_000 - (c_i+1)
      additional_cycles = remaining_cycles % repeat_len
      puts "Current iteration #{c_i}; #{repeat_len}"

      additional_cycles.times do
        roll_north(grid)
        roll_west(grid)
        roll_south(grid)
        roll_east(grid)
      end

      load = get_load(grid)
      puts "Load: #{load}"
    end

    private

    def self.roll_north(grid)
      (0..grid[0].count).each do |col|
        highest_occupied = -1
        (0..grid.count - 1).each do |r_i|
          val = grid[r_i][col]
          if val == '#'
            highest_occupied = r_i
          elsif val == 'O' 
            if r_i > highest_occupied + 1
              grid[highest_occupied + 1][col] = 'O'
              grid[r_i][col] = '.'
            end
            highest_occupied = highest_occupied + 1
          end
        end
      end
    end

    def self.roll_west(grid)
      (0..grid.count - 1).each do |row_i|
        highest_occupied = -1
        (0..grid[0].count - 1).each do |col|
          val = grid[row_i][col]
          if val == '#'
            highest_occupied = col
          elsif val == 'O' 
            if col > highest_occupied + 1
              grid[row_i][highest_occupied + 1] = 'O'
              grid[row_i][col] = '.'
            end
            highest_occupied = highest_occupied + 1
          end
        end
      end
    end

    def self.roll_south(grid)
      (0..grid[0].count).each do |col|
        highest_occupied = grid.count
        (0..grid.count - 1).each do |diff|
          row_i = grid.count - diff - 1
          val = grid[row_i][col]
          if val == '#'
            highest_occupied = row_i
          elsif val == 'O' 
            if row_i < highest_occupied - 1
              grid[highest_occupied - 1][col] = 'O'
              grid[row_i][col] = '.'
            end
            highest_occupied = highest_occupied - 1
          end
        end
      end
    end

    def self.roll_east(grid)
      (0..grid.count - 1).each do |row_i|
        highest_occupied = grid[0].count
        (0..grid[0].count - 1).each do |diff|
          col = grid[0].count - diff -1
          val = grid[row_i][col]
          if val == '#'
            highest_occupied = col
          elsif val == 'O' 
            if col < highest_occupied - 1
              grid[row_i][highest_occupied - 1] = 'O'
              grid[row_i][col] = '.'
            end
            highest_occupied = highest_occupied - 1
          end
        end
      end
    end

    def self.get_load(grid)
      total_rocks = 0
      load = 0
      (0..grid.count - 1).each do |row_index|
        rock_count = grid[row_index].select{ |g| g == 'O' }.count
        puts "#{(grid.count - row_index).to_s.rjust(3, '0')}: #{grid[row_index].join('')} = #{rock_count}"

        total_rocks += rock_count
        load += (grid.count - row_index) * rock_count
      end

      puts "Rock Count: #{total_rocks}"

      load
    end
  end
end