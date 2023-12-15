require './util'
module Days 
  class Day15
    def self.run(test)
      Util.readlines("15#{test}").each do |line|
        boxes = {}

        line.strip.split(',').each do |com|
          puts com
          puts '----------'
          if com.include?('=')
            command_parts = com.split('=')
            label = command_parts[0]
            box = hash_word(label)
            length = command_parts[1]

            boxes[box] ||= []
            if lens_index = boxes[box].index { |l| l[:label] == label }
              boxes[box][lens_index][:length] = length
            else
              boxes[box] << { label: label, length: length}
            end
          else
            command_parts = com.split('-')
            label = command_parts[0]
            box = hash_word(label)

            boxes[box]&.reject! { |l| l[:label] == label }
          end
          boxes.each do |k,v|
            next if v.empty?
            puts "Box #{k}: #{v.map { |l| "[#{l[:label]} #{l[:length]}]"}.join(' ')}"
          end
          puts
        end

        lens_total = 0
        boxes.each do |k, v|
          v.each_with_index do |lens,i|
            puts "#{k.to_i + 1} * #{i + 1} * #{lens[:length]}"
            lens_total += (k.to_i + 1) * (i + 1) * lens[:length].to_i
          end
        end

        puts "Lens Total: #{lens_total}"
      end

      puts 
    end

    private

    def self.hash_word(word)
      current_val = 0

      word.chars.each do |c|
        current_val += c.ord
        current_val *= 17
        current_val = current_val % 256
      end

      current_val
    end
  end
end
