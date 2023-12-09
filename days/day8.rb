require './util'
module Days 
  class Day8
    def self.run(test)
      lines = Util.readlines("8#{test}")
    
      directions = lines.shift.chars
      lines.shift
      paths = parse_paths(lines)

      z_steps = []
      try_lcm=[]
      paths.keys.each do |p|
        next unless p.end_with?('A')

        z_step = get_steps_for_start(p, paths, directions)
        try_lcm << z_step[0]
        get_step_info(z_step)
        z_steps << z_step
      end

      puts "Final"
      puts try_lcm.inspect
      puts try_lcm.reduce(1) { |t, n| t.lcm(n) }
    end

    private


    def self.get_step_info(z_steps)
      puts z_steps[0]
      (1..(z_steps.count - 1)).each do |z|
        puts "#{z}:#{z_steps[z]} - #{z_steps[z] - z_steps[z - 1]}"
      end
    end

    def self.get_steps_for_start(start, paths, directions)
      z_steps = []
      current = start
      step = 0

      loop do
        break if z_steps.count > 20
        z_steps << step if current.end_with?('Z')

        index = step % (directions.count - 1)
        direction = directions[index]
        path = paths[current]

        step += 1
        current = direction == 'R' ? path[1] : path[0]
      end

      z_steps
    end

    def self.parse_paths(lines)
      paths = {}

      lines.each do |line|
        path_parts = line.split(' = ')

        directions = path_parts[1].strip.gsub('(', '').gsub(')', '').split(', ')
        paths[path_parts[0]] = directions
      end

      paths
    end
  end
end
