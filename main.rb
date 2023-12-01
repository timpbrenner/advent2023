Dir["./days/*.rb"].each {|file| require file } 

Object.const_get("Days::Day#{ARGV[0]}").run