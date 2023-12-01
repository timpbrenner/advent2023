class Util
  def self.readlines(day)
    file_name = "input/day#{day}.txt"
    IO.readlines(file_name)
  end
end