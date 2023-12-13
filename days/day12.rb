require './util'
module Days 
  class Day12
    CHAR_OPTIONS = ['.', '#']
    MULTIPLE = 5

    def self.run(test)
      iterations = 0

      total_lines = Util.readlines("12#{test}")
      total_lines.each_with_index do |line, i|
        puts "#{i}/#{total_lines.count}"
        iterations += get_iterations(line)
      end

      puts "Total Iterations: #{iterations}"
    end

    private

    def self.get_iterations(line)
      line_config = parse_line(line)

      # puts line_config[:spring_segments].inspect
      count = recurse_iterations(line_config[:spring_conditions], line_config[:spring_segments], {})
      puts "#{line_config[:spring_conditions]}: #{count}"
      count
    end

    def self.parse_line(line)
      line_parts = line.split(' ')

      conditions = []
      segments = []
      MULTIPLE.times do |i|
        conditions << line_parts[0]

        segments += (line_parts[1]).split(',').map(&:to_i)
      end

      {
        spring_conditions: conditions.join('?'),
        spring_segments: segments
      }
    end

    def self.count_iterations(config)
      itertaion_count = 0

      unknown_count = config[:spring_conditions].count('?')
      (2 ** unknown_count).times do |i|
        iteration = config[:spring_conditions].clone
        bin_string = i.to_s(2).reverse

        unknown_count.times do |q_i|
          char_index = (bin_string[q_i] || '0').to_i
          iteration.sub!('?', CHAR_OPTIONS[char_index])
        end

        itertaion_count += 1 if match?(iteration, config[:spring_segments])
      end

      puts "#{config[:spring_conditions]}(#{config[:spring_segments].inspect}): #{itertaion_count.inspect}"

      itertaion_count
    end


    def self.recurse_iterations(spring_string, key, cache)
      unless spring_string.include? '?'
        return match?(spring_string, key) ? 1 : 0
      end

      return 0 if early_return?(spring_string, key)


      completed = get_completed_sections(spring_string, key)
      remaining = key[completed.count..-1]

      key_parts = []
      spring_string.split('.').each do |p|
        break if p.include?('?')

        key_parts << p
      end

      base = spring_string[key_parts.join('.').length..-1]
      # puts "MAKING THE CACHE KEY"
      # puts spring_string
      # puts key_parts.join('.')
      # puts base
      # puts "-" * 10

      cache_key = "#{base}||#{remaining.join(',')}"
      cache_val = cache[cache_key]

      unless cache_val.nil?
        # puts "CACHE HIT: #{cache_key} - #{cache_val}"
        return cache_val 
      end

      result = recurse_iterations(spring_string.sub('?', '.'), key, cache) +
        recurse_iterations(spring_string.sub('?', '#'), key, cache)

      cache[cache_key] = result

      result
    end

    def self.get_completed_sections(t, key)
      group_counts = t.split(/\.+/).reject { |f| f == '' }
      completed = []

      group_counts.each_with_index do |g, i|
        break if g.include?('?')

        completed << g.length if key[i] == g.length
      end

      completed
    end


    def self.early_return?(spring_string, key)
      spring_string.split(/\.+/).reject { |f| f == '' }.each_with_index do |g, i|
        if g.include? '?'
          break if g.start_with? '?'

          return true if key[i].nil?
          if key[i] < g.split('?')[0].length
            # puts "EARLY RETURN: 1 - #{spring_string}"
            return true 
          end

          return false
        end

        next if key[i] == g.length

        # puts "EARLY RETURN: 2 - #{spring_string}"
        return true
      end

      # puts spring_string

      false
    end

    def self.match?(t, key)
      group_counts = t.split(/\.+/).reject { |f| f == '' }.map(&:length)

      # puts t.inspect
      # puts "#{group_counts} - #{key} : #{group_counts == key}"
      # puts t.inspect if group_counts == key

      group_counts == key
    end
  end
end
