loop = GLib::MainLoop.new(false)

cnt = 0
GLib::Idle::add 200 do
  puts "idle"
  
  (cnt += 1) != 1000
end

GLib::Idle::add 200 do
  if cnt >= 1000
    loop.quit()
  end
  
  true
end

loop.run
