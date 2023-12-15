require './util'
module Days 
  class Day14
    # 113424 is too high

    def self.run(test)
      grid = Util.get_grid("14#{test}")

      grid[0..3].each { |r| puts r.join('') }

      (0..grid.count - 1).each do |row_index|
        next if row_index == 0

        move_row(grid, row_index)

        puts row_index
        puts '-------'
        grid[0..3].each { |r| puts r.join('') }
        puts
      end

      load = get_load(grid)
      puts "Load: #{load}"
    end

    private

    def self.get_load(grid)
      load = 0
      (0..grid.count - 1).each do |row_index|
        rock_count = grid[row_index].select{ |g| g == 'O' }.count
        puts "#{grid.count - row_index}: #{grid[row_index].join('')} = #{rock_count}"

        load += (grid.count - row_index) * rock_count
      end

      load
    end

    def self.move_row(grid, row_index)
      (0..grid[row_index].count).each do |i|
        next unless grid[row_index][i] == 'O'

        # puts "FOUND ROCK: #{i},#{row_index}"

        new_rock_index = row_index
        (0..row_index).each do |diff|
          r_i = row_index - diff
          # puts "Checking:#{r_i}"
          val = grid[r_i][i]

          new_rock_index = r_i if val == '.'
          break if val == '0' || val == '#'
        end

        next if new_rock_index == row_index
        grid[new_rock_index][i] = 'O'
        grid[row_index][i] = '.'
      end
    end
  end
end
