require './util'
module Days 
  class Day9
    def self.run(test)
      sum_of_prediction = 0
      sum_of_history = 0

      Util.readlines("9#{test}").each do |line|
        sum_of_prediction += predict(line.split(' ').map(&:to_i))
        sum_of_history += history(line.split(' ').map(&:to_i))
      end

      puts "Sum of Prediction: #{sum_of_prediction}"
      puts "Sum of History: #{sum_of_history}"
    end

    private

    def self.history(sequence)
      previous_increment = get_previous_increment(sequence)

      sequence.first - previous_increment
    end

    def self.get_previous_increment(sequence)
      derived_sequence = []

      (1..(sequence.count - 1)).each do |i|
        derived_sequence << (sequence[i]- sequence[i-  1])
      end

      return derived_sequence.first if derived_sequence.uniq.count == 1
      puts "RECURSE: #{derived_sequence.inspect}"
      derived_sequence.first - get_previous_increment(derived_sequence)
    end

    def self.predict(sequence)
      next_increment = get_next_increment(sequence)

      sequence.last + next_increment
    end

    def self.get_next_increment(sequence)
      derived_sequence = []

      (1..(sequence.count - 1)).each do |i|
        derived_sequence << (sequence[i]- sequence[i-  1])
      end

      return derived_sequence.first if derived_sequence.uniq.count == 1
      derived_sequence.last + get_next_increment(derived_sequence)
    end
  end
end
