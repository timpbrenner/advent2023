require './util'
module Days 
  class Day11
    def self.run(test)
      grid = Util.get_grid("11#{test}")

      grid.each do |row|
        puts row.join('')
      end
      puts '=' * 10

      expanded = expand_grid(grid)
      expanded.each do |row|
        puts row.join('')
      end

      galaxies = get_galaxies(expanded)
      puts galaxies.inspect

      total_distance = 0
      galaxies.each do |s|
        galaxies.each do |e|
          next if s[0] == e[0] && s[1] == e[1]
          total_distance += get_distance(s,e)
          puts "#{s.inspect} - #{e.inspect} = #{get_distance(s,e)}"
        end
      end

      puts "Total Distance: #{total_distance / 2}"
    end


    private

    def self.get_distance(s, e)
      (s[0] - e[0]).abs + (s[1] - e[1]).abs;
    end

    def self.get_galaxies(grid)
      galaxies = []

      (0...grid.count).each do |y|
        (0...grid[y].count).each do |x|
          next unless grid[y][x] == '#'
          galaxies << [x,y]
        end
      end 

      galaxies
    end

    def self.expand_grid(grid)
      empty_rows = []
      grid.each_with_index do |row, i|
        next unless row.all? { |c| c == '.' }
        empty_rows << i + empty_rows.count
      end

      empty_rows.each do |row|
        grid.insert(row, Array.new(grid[0].count) { |t| '.'})
      end

      empty_cols = []
      (0..grid[0].count).each do |y|
        next unless grid.all? { |row| row[y] == '.'}
        empty_cols << y + empty_cols.count
      end

      empty_cols.each do |col|
        grid.each do |row|
          row.insert(col, '.')
        end
      end

      grid
    end
  end
end
