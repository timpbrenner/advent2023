require './util'

module Days 
  class Day2
    LIMITS = {
      red: 12,
      green: 13,
      blue: 14
    }

    def self.run
      valid_total = 0
      total_power = 0

      Util.readlines("2").each do |line|
        puts line
        res = process_game(line)
        valid_total += res[0]
        total_power += res[1]
      end

      puts "Valid Total: #{valid_total}"
      puts "Total Power: #{total_power}"
    end

    private

    def self.process_game(line)
      res = /Game (\d+): (.*)/.match(line)
      id = res[1].to_i

      min_count = {
        red: 0,
        green: 0,
        blue: 0
      }

      turns = res[2].split(';').map(&:strip)
      turns.each do |turn|
        # Uncomment this to do part one.
        # return [0, 0] unless handle_turn(turn)
        min_count = get_mins(turn, min_count)
      end

      [id, min_count.values.inject(:*)]
    end

    def self.get_mins(turn, min_count)
      turn.split(',').map(&:strip).each do |play|
        p = play.split(' ')
        color = p[1].to_sym
        count = p[0].to_i

        min_count[color] = count if count > min_count[color]
      end

      min_count
    end

    def self.handle_turn(turn)
      turn.split(',').map(&:strip).each do |play|
        p = play.split(' ')
        color = p[1].to_sym
        count = p[0].to_i

        return false if LIMITS[color] < count
      end

      true
    end
  end
end