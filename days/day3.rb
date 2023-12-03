require './util'

module Days 
  class Day3
    def self.run
      numbers = []
      gears = []
      symbols = []

      Util.readlines("3").each_with_index do |line, row|
        numbers += get_numbers(line, row)
        gears += get_gears(line, row)

        symbols << get_symbols(line)
      end

      puts gears.inspect

      num_total = 0
      numbers.each do |number|
        num_total += number[:val] if check_number(number, symbols)
      end

      gear_ratio = 0
      gears.each do |gear|
        gear_ratio += get_gear_ratio(gear, numbers)
      end

      puts "Num Total: #{num_total}"
      puts "Gear Ratio: #{gear_ratio}"
    end

    private
    
    def self.get_numbers(line, row)
      numbers = []
      current_number = ""

      line.chars.each_with_index do |c, col|
        if c.to_i.to_s == c
          current_number << c
        elsif current_number.length > 0
          numbers << {
            val: current_number.to_i,
            row: row,
            col: (col - current_number.length)..(col - 1)
          }

          current_number = ""
        end
      end

      numbers
    end

    def self.get_gears(line, row)
      gears = []

      line.chars.each_with_index do |c, col|
        next if c != '*'

        gears << [row,col]
      end

      gears
    end

    def self.get_symbols(line)
      row = []

      line.chars.each do |c|
        next if c == "\n"

        if c == '.' || c.to_i.to_s == c
          row << false
          next
        end

        row << true
      end

      row
    end

    def self.check_number(number, symbols)
      ((number[:row] - 1)..(number[:row] + 1)).each do |row|
        next if row < 0 || symbols.count == row

        ((number[:col].first - 1)..(number[:col].last + 1)).each do |c|
          return true if symbols[row][c]
        end
      end

      false
    end

    def self.get_gear_ratio(gear, numbers)
      row = (gear[0] - 1)..(gear[0] + 1)
      col = (gear[1] - 1)..(gear[1] + 1)
      adjacent_numbers = []

      numbers.each do |number|
        next unless row.include?(number[:row])
        next unless overlap?(col, number[:col])

        adjacent_numbers << number[:val]
        puts "#{gear[0]},#{gear[1]} -> #{number[:row]},#{number[:col]}"
      end

      return 0 if adjacent_numbers.count != 2
      adjacent_numbers[0] * adjacent_numbers[1]
    end

    def self.overlap?(r1,r2)
      !(r1.first > r2.last || r1.last < r2.first)
    end
  end
end
