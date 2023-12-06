require './util'
require "range_operations"

module Days 
  class Day5
    def self.run
      lines = Util.readlines("5")
      # part_1_seeds = lines.shift.split(': ')[1].split(' ').map(&:to_i)
      seed_ranges = get_seeds(lines.shift)
      lines.shift

      mappings = parse_mapping(lines)

      soils = convert_mappings(seed_ranges, mappings['seed-to-soil'])
      fertilizers = convert_mappings(soils, mappings['soil-to-fertilizer'])
      water = convert_mappings(fertilizers, mappings['fertilizer-to-water'])
      light = convert_mappings(water, mappings['water-to-light'])
      temp = convert_mappings(light, mappings['light-to-temperature'])
      hum = convert_mappings(temp, mappings['temperature-to-humidity'])
      location = convert_mappings(hum, mappings['humidity-to-location'])

      puts "Lowest Location: #{location.map(&:begin).min.inspect}"
    end

    private

    def self.get_seeds(line)
      nums = line.split(': ')[1].split(' ').map(&:to_i)

      seeds = []
      nums.each_slice(2) do |slice|
        seeds << (slice[0]..(slice[0] + slice[1]))
      end

      seeds
    end

    def self.convert_mappings(seed_ranges, mappings)
      new_ranges = []

      seed_ranges.map do |seed_range|
        overlap_ranges = []
        overlap_mappings = []

        mappings.each do |source_range, dest_range|
          next unless overlaps?(seed_range, source_range)


          # The largest start value
          overlap_start = [seed_range.begin, source_range.begin].max
          # The smalles end value
          overlap_end = [seed_range.end, source_range.end].min
          diff = dest_range.begin - source_range.begin
          overlap = (overlap_start + diff)..(overlap_end + diff)

          overlap_mappings << [source_range,dest_range]

          overlap_ranges << (overlap_start..overlap_end)
          new_ranges << overlap
        end

        new_ranges += RangeOperations::Array.subtract(seed_range, overlap_ranges)
      end

      new_ranges
    end

    def self.overlaps?(ra, rb)
      rb.begin <= ra.end && ra.begin <= rb.end 
    end

    def self.old_get_mapped_value(seed, mappings)
      mappings.each do |source_range, dest_range|
        next unless source_range.include?(seed)

        diff = seed - source_range.begin
        return dest_range.begin + diff
      end

      seed
    end

    def self.parse_mapping(lines)
      mappings = {}
      current_map = ""
      map_values = {}
      lines.each do |line|
        if line.include?('map:')
          mappings[current_map] = map_values if current_map != ''

          map_values = {}
          current_map = line.split(' ')[0]

          next
        end

        numbers = line.split(' ').map(&:to_i)
        next if numbers.count == 0

        dest_start = numbers[0]
        source_start = numbers[1]
        length = numbers[2]

        map_values[(source_start..source_start + length)] = (dest_start..dest_start + length)
      end

      mappings[current_map] = map_values

      mappings
    end
  end
end
