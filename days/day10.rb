require './util'
module Days 
  class Day10

    #     0
    #    __
    # 3 |  | 1
    #    __
    #    2


    # Count intersections withthe pipe going in the four directions. Odd means insidethe pipe,  even means outside
    # 351 is too high

    PIPES = {
      '|' =>  [0,2],
      '-' =>  [1,3],
      'L' =>  [0,1],
      'J' =>  [0,3],
      '7' =>  [2,3],
      'F' =>  [1,2],
    }

    def self.run(test)
      grid = Util.get_grid("10#{test}")
      grid.each do |row|
        puts row.join('')
      end

      start = find_start(grid)

      [
        [0,1],
        [0,-1],
        [-1,0],
        [1,0],
      ].each_with_index do |diffs, dir|
        try_x = start[0] + diffs[0]
        try_y = start[1] + diffs[1]
        path = [[try_x, try_y]]

        loop do 
          next_s = next_step(grid, [try_x, try_y], dir)
          break if next_s.nil?
          path << next_s

          # puts next_s.inspect

          try_x = next_s[0]
          try_y = next_s[1]
          dir = next_s[2]

          break if grid[try_y][try_x] == 'S'
        end

        next if path.count == 0
        puts "PATH COUNT(#{(path.count / 2.0).ceil})"

        pipe_grid = get_grid_with_only_pipe(grid, path)
        pipe_grid.each do |row|
          puts row.map { |r| r || ' ' }.join('')
        end
        puts '-----'

        pipe_grid.each do |row|
          puts row.map { |r| r.nil? ? 'X' : ' '  }.join('')
        end

        inner_count = get_inner_count(pipe_grid)
        puts "Inner Count #{inner_count}"

        return
      end
    end

    private

    def self.get_inner_count(grid)
      inner_count = 0
      inner_grid = Array.new(grid.count) { |i| Array.new(grid.first.count) }

      (0..grid.count - 1).each do |y|
        intersection_count = 0
        (0..grid[y].count - 1).each do |x|
          intersection_count += 1 if ['|', '7', 'F', 'S'].include?(grid[y][x])
          next unless grid[y][x].nil?

          inner_grid[y][x] = 'O' if intersection_count.odd?
          inner_count += 1 if intersection_count.odd? && intersection_count > 0
        end
      end

      inner_grid.each do |row|
        puts row.map { |r| r || ' '  }.join('')
      end

      inner_count
    end

    def self.get_grid_with_only_pipe(grid, path)
      pipe_grid = Array.new(grid.count) { |i| Array.new(grid.first.count) }

      path.each do |cell|
        x = cell[0]
        y = cell[1]

        pipe_grid[y][x] = grid[y][x] 
      end

      pipe_grid
    end

    def self.find_start(grid)
      (0..grid.count - 1).each do |y|
        row = grid[y]
        (0..row.count - 1).each do |x|
          return [x, y] if grid[y][x] == 'S'
        end
      end
    end

    def self.next_step(grid, current, from_dir)
      x = current[0]
      y = current[1]
      val = grid[y][x]

      # puts "(#{x}, #{y}) - #{val} From: #{from_dir}"
      return if val == '.' || x < 0 || y < 0 || y > grid.count || x > grid[y].count

      pipe_dirs = PIPES[val]
      # puts "PIPE DIRS: #{pipe_dirs.inspect}"
      return unless pipe_dirs.include?(from_dir)

      next_dir = pipe_dirs.reject { |d| d == from_dir }.first
      # puts "NEXT: #{next_dir}"
      
      diff = [
        [0,-1,2], # 0
        [1,0,3], # 1
        [0,1,0], # 2
        [-1,0,1] # 3
      ][next_dir]

      [x + diff[0], y + diff[1], diff[2]]
    end
  end
end
