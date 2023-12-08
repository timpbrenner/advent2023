require './util'
module Days 
  class Day8
    def self.run(test)
      lines = Util.readlines("8#{test}")
    
      directions = lines.shift.chars
      lines.shift

      paths = parse_paths(lines)
       
      current = 'AAA'
      step = 0

      loop do
        break if current == 'ZZZ'

        index = step % (directions.count - 1)
        puts "Index: #{index}"
        direction = directions[index]
        path = paths[current]

        puts direction
        puts path.inspect

        step += 1
        current = direction == 'R' ? path[1] : path[0]
      end

      puts "Steps: #{step}"
    end

    private

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
