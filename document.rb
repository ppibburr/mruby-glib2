require "fileutils"

if ARGV.length > 0
  puts "Writes YARD documentation to ./doc"
  exit(1)
end

FileUtils.mkdir_p d="./tmp/dummy_source"

Dir.chdir d

File.open "document.rb", "w" do |f|
  f.puts DATA.read
end

system "mruby document.rb"
system "yard doc glib*.rb"

# FileUtils.rm_f "../../doc"
`rm -rf ../../doc`
FileUtils.mv "doc", "../../"

Dir.chdir "../../"
`rm -rf tmp`

__END__
DocGen.overide GLib, :file_set_contents do
  param :path     => [String, "the file to write to"]
  param :contents => [String, "the contents"]
  error!
  returns TrueClass, "true on success, raises on error"
end

DocGen.overide GLib, :file_get_contents do
  param :path => [String, "the file to read from"]
  error!
  returns String, "the file's contents"
end

DocGen.overide GLib, :spawn_command_line_async do
  param :command_line => [String, "the command"]
  error!
  returns TrueClass, "on success, raises on error"
end

DocGen.overide GLib, :spawn_command_line_sync do
  param :command_line => [String, "the command"]
  error!
  returns [Integer,String,String], "Exit status, stdout, stderr"
end

DocGen.overide GLib, :spawn_async do
  error!
  
  param :argv  => [[String], "the argument vector"]
  
  a = param :path  => [String, "The path to execute in"]
  a[:default] = "'./'"
  
  a = param :flags => [Integer, "The GLib::SpawnFlags to use"]
  a[:default] = 0
  
  yieldparam :o => ["void"]
  yieldreturns "void"
  
  returns Integer, "The Childs PID"
end

DocGen.overide GLib, :spawn_sync do
  error!

  param :argv  => [[String], "the arguemnt vector"]
  
  a = param :path  => [String, "The path to execute in"]
  a[:default] = "'./'"
  
  a = param :flags => [Integer, "The GLib::SpawnFlags to use"]
  a[:default] = 0
  
  yieldparam   :o => ["void"]
  yieldreturns "void"
  
  returns [Integer, String, String], "Exit status, stdout, stderr"
end

dg = DocGen.new(GLib)
ns = dg.document()

YARDGenerator.generate(ns)
