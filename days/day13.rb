require './util'
module Days 
  class Day13
    # 33200 is too high
    # 11560 is too low

    def self.run(test)
      groups = []
      current_group = []
      Util.readlines("13#{test}").each do |line|
        if line.strip == ''
          groups << current_group.dup
          current_group = []
          next
        end

        current_group << line.strip
      end
      groups << current_group.dup

      total = 0
      groups.each_with_index do |g, i|
        puts i
        puts '--------'
        mirror_vals = get_mirror_vals(g)
        total += mirror_vals[0] * 100
        total += mirror_vals[1]
        puts "Mirror: #{mirror_vals.inspect}"
      end

      puts "Total: #{total}"
    end

    private

    def self.line_difference_count(line, line_1)
      line_chars = line.chars
      line_1_chars = line_1.chars

      differences = 0
      line_chars.each_with_index do |l, c_i|
        differences += 1 if l != line_1_chars[c_i]
      end
      differences
    end

    def self.get_mirror_vals(lines)
      #   puts "Lines___________"
      #   lines.each { |l| puts l }
      #   puts

      hor_mirror = get_mirror(lines)

      vert_lines = turn_contents(lines)
      # puts "Vert Lines___________"
      # vert_lines.each { |l| puts l }
      # puts
      vert_mirror = get_mirror(vert_lines)

      [
        hor_mirror.nil? ? 0 : hor_mirror + 1, 
        vert_mirror.nil? ? 0 : vert_mirror + 1
      ]
    end

    def self.turn_contents(lines)
      (0..lines[0].length - 1).map do |i|
        lines.map { |l| l[i] }.reverse.join('')
      end
    end

    def self.get_possible_matches(lines)
      possible_matches = []
      lines.each_with_index do |line, i|
        next if i == lines.count - 1
        differences = line_difference_count(line, lines[i + 1])
        next unless differences <= 1

        possible_matches << i
      end

      possible_matches
    end

    def self.get_mirror(lines)
      matches = []

      get_possible_matches(lines).each do |test_match|
        differences = 0
        (0..lines.count).each do |compare_count|
          top_index = test_match - compare_count
          bottom_index = test_match + 1 + compare_count

          top = lines[top_index]&.strip
          bottom = lines[bottom_index]&.strip

          differences += line_difference_count(top, bottom)

          if (top_index <= 0 || bottom_index >= lines.count - 1)
            puts "#{test_match}: #{differences}"
            matches << test_match if differences == 1
            break
          end

          break if differences > 1
        end
      end

      raise matches.inspect if matches.count > 1
      return matches.first
    end
  end
end
