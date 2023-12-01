require './util'

class Day1
  NUMS = {
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9,
    "0" => 0,
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
  }

  def self.run
    a_total = 0
    Util.readlines("1").each do |line|
      a_first_digit = get_first_digit(line.chars)
      a_last_digit = get_first_digit(line.chars.reverse)

      a_total += "#{a_first_digit}#{a_last_digit}".to_i
    end
    puts "A Total: #{a_total}"

    b_total = 0
    Util.readlines("1").each do |line|
      b_total += get_number_from_text(line)
    end
    puts "B Total: #{b_total}"
  end

  private

  def self.get_first_digit(chars)
    chars.each do |c|
      return c if c.to_i.to_s == c
    end
  end

  def self.get_number_from_text(line)
    first_digit_index = line.length
    first_digit = ""
    last_digit_index = -1
    last_digit = ""

    puts line
    NUMS.each do |string_val, int_val|
      indices = line.enum_for(:scan, /#{string_val}/).map { Regexp.last_match.begin(0) }
      next if indices.empty?

      if indices.min < first_digit_index
        first_digit_index = indices.min
        first_digit = int_val
      end

      if indices.max > last_digit_index
        last_digit_index = indices.max
        last_digit = int_val
      end
    end

    puts "#{first_digit}#{last_digit}".to_i

    "#{first_digit}#{last_digit}".to_i
  end
end
