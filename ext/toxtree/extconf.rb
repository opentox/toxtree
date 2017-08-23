require 'mkmf'

main_dir = File.expand_path(File.join(File.dirname(__FILE__),"..",".."))

# check for required programs
programs = ["wget","unzip","java"]
programs.each do |program|
  abort "Please install #{program} on your system." unless find_executable program
end

# get Toxtree
puts `cd #{main_dir} && wget https://sourceforge.net/projects/toxtree/files/toxtree/Toxtree-v.2.6.13/Toxtree-v2.6.13.zip`
# unzip
puts `cd #{main_dir} && unzip Toxtree-v2.6.13.zip`

# create a fake Makefile
File.open(File.join(File.dirname(__FILE__),"Makefile"),"w+") do |makefile|
  makefile.puts "all:\n\ttrue\n\ninstall:\n\ttrue\n"
end

$makefile_created = true
