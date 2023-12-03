require 'fileutils'

day = ARGV[0]

File.open("days/day#{day}.rb", "w") do |f| 
  f.write <<-TEXT
require './util'
module Days 
  class Day#{day}
    def self.run
      Util.readlines("#{day}").each do |line|
      end
    end

    private
  end
end
TEXT
end

FileUtils.touch "input/day#{day}.txt"