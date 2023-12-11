class Util
  def self.readlines(day)
    file_name = "input/day#{day}.txt"
    IO.readlines(file_name)
  end

  def self.get_grid(day)
    file_name = "input/day#{day}.txt"
    IO.readlines(file_name).map do |line|
      line.strip.chars
    end
  end
end