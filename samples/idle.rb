GLib::Idle::add -1 do
  puts "idle"
  true
end

loop = GLib::MainLoop.new(false)
loop.run
