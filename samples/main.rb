GirFFI::DEBUG[:VERBOSE] = 0==1

def at_exit!(loop)
  puts "Since this Timeout was called only once: @ii is 1; #{@ii == 1}"
  puts "The test file contents should be: 123456; #{GLib::File.get_contents(PATH) == "123456"}"
  
  loop.quit()
end

PATH = "./glib_file_test.txt"
loop = GLib::MainLoop.new(nil,false)

i = 0
GLib::Timeout.add 200,500 do
  i += 1
  
  if i == 1
    contents = i.to_s
  else
    contents = GLib::File.get_contents(PATH)+"#{i}"
  end
  
  GLib::File.set_contents(PATH, contents)
  
  at_exit!(loop) if i > 5
  
  next true
end

@ii = 0
GLib::Timeout.add(-100,500) do
  @ii += 1
  
  next false
end

loop.run()
