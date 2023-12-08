require 'fileutils'

day = ARGV[0]

File.open("days/day#{day}.rb", "w") do |f| 
  f.write <<-TEXT
require './util'
module Days 
  class Day#{day}
    def self.run(test)
      Util.readlines("#{day}\#{test}").each do |line|
      end
    end

    private
  end
end
TEXT
end

FileUtils.touch "input/day#{day}.txt"