require './util'
module Days 
  class Day11
    def self.run(test)
      grid = Util.get_grid("11#{test}")

      grid.each do |row|
        puts row.join('')
      end
      puts '=' * 10

      expansions = get_expansions(grid)
      # expanded = expand_grid(grid)
      # expanded.each do |row|
      #   puts row.join('')
      # end
      puts expansions.inspect

      galaxies = get_galaxies(grid)
      puts galaxies.inspect

      total_distance = 0
      galaxies.each do |s|
        galaxies.each do |e|
          next if s[0] == e[0] && s[1] == e[1]
          distance = get_distance(s, e, expansions)

          total_distance += distance
          puts "#{s.inspect} - #{e.inspect} = #{distance}"
        end
      end

      puts "Total Distance: #{total_distance / 2}"
    end


    private

    EXPANSION_METRIC = 1_000_000

    def self.get_distance(s, e, expansions)
      xs = [s[0], e[0]].sort
      ys = [s[1], e[1]].sort

      passing_blank_rows = 0
      passing_blank_col = 0

      expansions[0].each do |blank_row|
        next unless (ys[0] < blank_row && blank_row < ys[1])

        passing_blank_rows += EXPANSION_METRIC - 1
      end

      expansions[1].each do |blank_col|
        next unless (xs[0] < blank_col && blank_col < xs[1])

        passing_blank_col += EXPANSION_METRIC - 1
      end

      (s[0] - e[0]).abs + (s[1] - e[1]).abs + passing_blank_rows + passing_blank_col

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

    def self.get_expansions(grid)
      empty_rows = []
      grid.each_with_index do |row, i|
        next unless row.all? { |c| c == '.' }
        empty_rows << i
      end

      empty_cols = []
      (0..grid[0].count).each do |y|
        next unless grid.all? { |row| row[y] == '.'}
        empty_cols << y
      end

      [empty_rows, empty_cols]
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
