require './util'

FIVE_OF_A_KIND = 9 * 10**14
FOUR_OF_A_KIND = 9 * 10**13
FULL_HOUSE = 9 * 10**12
THREE_OF_A_KIND = 9 * 10**11
TWO_PAIR = 9 * 10**10
ONE_PAIR = 9 * 10**9

module Days 
  class Day7
    def self.run(test)
      hands = []

      Util.readlines("7#{test}").each do |line|
        hands << parse_hand(line)
      end

      hands = sort_hands(hands)
      puts "Hand Score: #{score_hands(hands)}"
    end

    private

    def self.parse_hand(line)
      hand_parts = line.split(' ')
      hand_rank_score = hand_rank_score(hand_parts[0])

      {
        raw_hand: hand_parts[0],
        bid: hand_parts[1].to_i,
        hand_rank_score: hand_rank_score[0],
        class: hand_rank_score[1]
      }
    end

    def self.hand_rank_score(hand_string)
      cards = hand_string.chars
      card_counts = cards.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }
      rank_score = base_hand_score(cards)
      c = nil

      if cards.uniq.count == 1
        rank_score += FIVE_OF_A_KIND
        c = "5_OF_A_KIND"
      elsif card_counts.values.any? { |cc| cc == 4 }
        rank_score += FOUR_OF_A_KIND
        c = "4_OF_A_KIND"
      elsif card_counts.values.any? { |cc| cc == 3 } && card_counts.values.any? { |cc| cc == 2 }
        rank_score += FULL_HOUSE
        c = "FULL_HOUSE_"
      elsif card_counts.values.any? { |cc| cc == 3 }
        rank_score += THREE_OF_A_KIND
        c = "3_OF_A_KIND"
      elsif card_counts.values.select { |cc| cc == 2 }.count == 2
        rank_score += TWO_PAIR
        c = "TWO_PAIR___"
      elsif card_counts.values.any? { |cc| cc == 2 }
        rank_score += ONE_PAIR
        c = "ONE_PAIR___"
      end

      [rank_score, c]
    end

    SCORE_CONVERSIONS = {
      'A' => 14, 
      'K' => 13, 
      'Q' => 12, 
      'J' => 11, 
      'T' => 10, 
      '9' => 9, 
      '8' => 8, 
      '7' => 7, 
      '6' => 6, 
      '5' => 5, 
      '4' => 4, 
      '3' => 3,
      '2' => 2
    }

    def self.base_hand_score(cards)
      hand_score = ""
      cards.each_with_index do |c, pow|
        hand_score += SCORE_CONVERSIONS[c].to_s.rjust(2, "0")
      end

      hand_score.to_i
    end

    def self.sort_hands(hands)
      hands.sort_by { |card| card[:hand_rank_score] }
    end

    def self.score_hands(hands)
      total_score = 0

      hands.each_with_index do |h, i|
        rank = i + 1
        hand_score = h[:bid] * rank
        puts "#{rank.to_s.rjust(4, "0")}: #{h[:raw_hand]}(#{h[:class]})[#{h[:hand_rank_score].to_s.rjust(15, "0")})] - #{h[:bid]}(#{hand_score})"

        total_score += hand_score
      end

      total_score
    end
  end
end
