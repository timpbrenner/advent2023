require './util'
module Days 
  class Day4
    def self.run
      card_total = 0
      cards = []

      Util.readlines("4").each do |line|
        cards << card_value(line)
      end

      extra_cards = {}
      cards.each do |card|
        card_number = card[:card_number]
        card_count = (extra_cards[card_number] || 0) + 1

        card[:match_count].times do |i|
          card_index = card_number + i + 1

          extra_cards[card_index] ||= 0
          extra_cards[card_index] += (1 * card_count)
        end
      end

      puts "Total Cards: #{cards.count + extra_cards.values.sum}"
    end

    private

    def self.card_value(line)
      card = parse_card(line)

      card = matches(card)
    end

    def self.parse_card(line)
      numbers = line.split(': ')[1].split('|').map(&:strip)

      res = /Card[ ]*(\d+): .*/.match(line)
      card_number = res[1].to_i

      {
        card_number: card_number,
        winners: numbers[0].split(' ').map(&:to_i),
        vals: numbers[1].split(' ').map(&:to_i)
      }
    end

    def self.matches(card)
      match_count = 0

      card[:vals].each do |val|
        next unless card[:winners].include?(val)
        match_count += 1
      end
      
      card.merge(match_count: match_count)
    end

  end
end
