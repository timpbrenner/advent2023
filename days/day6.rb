require './util'
module Days 
  class Day6
    def self.run
      lines = Util.readlines("6")
      times = lines.shift[5..-1].strip.split(/\W+/).map(&:to_i)
      distances = lines.shift[9..-1].strip.split(/\W+/).map(&:to_i)

      win_counts = get_win_counts(times, distances)
      puts "Win Tolerance: #{win_counts.inject(&:*)}"

      lines = Util.readlines("6")
      time =  lines.shift[5..-1].strip.gsub(/\W+/, '').to_i
      distance = lines.shift[9..-1].strip.gsub(/\W+/, '').to_i
      puts "Combined Win Count: #{get_win_count(time, distance)}"
    end

    private

    def self.get_win_counts(times, distances)
      win_counts = []

      times.each_with_index do |time, i|
        distance = distances[i]

        win_counts << get_win_count(time, distance)
      end

      win_counts
    end

    def self.get_win_count(time, distance)
      win_count = 0
      time.times do |t|
        traveled = (time - t) * t

        win_count += 1 if traveled > distance
      end

      win_count
    end
  end
end
