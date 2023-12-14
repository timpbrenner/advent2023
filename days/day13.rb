require './util'
module Days 
  class Day13
    # 33200 is too high

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
        puts '----------------'
        g.each {|l| puts l }
        puts
        mirrors = get_mirror_with_smudge(g)
        puts "Mirrors: #{mirrors.inspect}"
        total += mirrors.first + 1 if mirrors.count > 0 
        puts
      end

      puts "Smudge Total: #{total * 100}"
      return

      # mirror_vals = get_mirror_vals(groups[0])
      # puts mirror_vals.inspect
      # return

      total = 0
      groups.each_with_index do |g, i|
        puts i
        mirror_vals = get_mirror_vals(g)
        total += mirror_vals[0] * 100
        total += mirror_vals[1]
        puts mirror_vals.inspect
      end

      puts "Total: #{total}"
    end

    private

    def self.get_smudge_possible_matches(lines)
      possible_matches = []
      (0..lines.count - 2).each do |i|
        differences = line_difference_count(lines[i], lines[i + 1])
        puts lines[i]
        puts lines[i + 1]
        puts differences
        next unless differences <= 1

        possible_matches << i
      end

      possible_matches
    end

    def self.line_difference_count(line, line_1)
      line_chars = line.chars
      line_1_chars = line_1.chars

      differences = 0
      line_chars.each_with_index do |l, c_i|
        differences += 1 if l != line_1_chars[c_i]
      end
      differences
    end

    def self.get_mirror_with_smudge(lines)
      possible_matches = get_smudge_possible_matches(lines)
      puts possible_matches.inspect

      matches = []
      possible_matches.each do |test_match|
        smudge_used = false

        (0..lines.count).each do |compare_count|
          top_index = test_match - compare_count
          bottom_index = test_match + 1 + compare_count

          top = lines[top_index]&.strip
          bottom = lines[bottom_index]&.strip

          differences = line_difference_count(top, bottom)
          valid_match = differences == 0 || (differences == 1 && !smudge_used)
          smudge_used = true if differences == 1

          if (top_index <= 0 || bottom_index >= lines.count - 1) && valid_match
            matches << test_match
            break
          end

          break unless valid_match
        end
      end
    end

    def self.get_mirror_vals(lines)
      puts "Lines___________"
      lines.each { |l| puts l }
      puts

      hor_mirror = get_mirror(lines)

      vert_lines = turn_contents(lines)
      puts "Vert Lines___________"
      vert_lines.each { |l| puts l }
      puts
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
        next unless line == lines[i + 1]

        possible_matches << i
      end

      possible_matches
    end

    def self.get_mirror(lines)
      matches = []

      get_possible_matches(lines).each do |test_match|
        puts test_match
        (0..lines.count).each do |compare_count|
          top_index = test_match - compare_count
          bottom_index = test_match + 1 + compare_count

          top = lines[top_index]&.strip
          bottom = lines[bottom_index]&.strip

          if test_match == 4
            puts top_index
            puts "#{bottom_index} -> #{lines.count - 1}"
            puts top
            puts bottom
          end

          if (top_index <= 0 || bottom_index >= lines.count - 1) && top == bottom
            matches << test_match
            break
          end

          break if top != bottom
        end
      end

      raise matches.inspect if matches.count > 1
      return matches.first
    end
  end
end
