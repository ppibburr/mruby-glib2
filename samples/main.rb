path = "./glib_file_test.txt"
GirFFI::DEBUG[:VERBOSE] = false
loop = GLib::MainLoop.new(nil,false)

i = 0
GLib::Timeout.add 200,500 do
  p i += 1
  
  if i == 1
    contents = i.to_s
  else
    contents = GLib::File.get_contents(path)+"#{i}"
  end
  
  GLib::File.set_contents(path, contents)
  loop.quit() if i > 5
  true
end

ii = 0
GLib::Timeout.add -100,500 do
  ii += 1
  next false
end

loop.run()
