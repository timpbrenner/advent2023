require './util'
module Days 
  class Day4
    def self.run
      card_total = 0
      Util.readlines("4").each do |line|
        card_total += card_value(line)
      end

      puts "Card Total: #{card_total}"
    end

    private

    def self.card_value(line)
      card = parse_card(line)
      matches(card)
    end

    def self.parse_card(line)
      numbers = line.split(': ')[1].split('|').map(&:strip)
      {
        winners: numbers[0].split(' ').map(&:to_i),
        vals: numbers[1].split(' ').map(&:to_i)
      }
    end

    def self.matches(card)
      card_val = 0

      card[:vals].each do |val|
        next unless card[:winners].include?(val)

        card_val *= 2

        card_val = 1 if card_val.zero?
      end
      
      card_val
    end

  end
end
