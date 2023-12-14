require './util'
module Days 
  class Day13
    # 38575 is too high
    37975
    # 30500 is too low

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

    private

    def self.get_vert_possible_matches(line)
      (0..line.length).each do |i|
        next unless line[i] == line[i + 1]
      end
    end

    def self.get_vert_mirror(line, possible_matches)
      compare_count = 1
      current_possible_matches = possible_matches.dup

      loop do
        next_matches = []
        current_possible_matches.each do |test_match|
          left_index = test_match - compare_count
          right_index = test_match + 1 + compare_count
          next unless line[left_index] == line[right_index]

          next_matches << test_match
        end

        compare_count += 1
        current_possible_matches = next_matches.dup
        break if left_index == 0 or right_index == line.length
      end

      return current_possible_matches.first
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
