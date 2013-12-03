glib = {
  :namespace => :GLib,
  :prefix    => :g,
  # :version   => 2.0,
  
  :define => {
    :classes => {
      :Timeout => {
        :class_methods => {
          :add => {
            :symbol => :timeout_add
          },
          
          :add_seconds => {
            :symbol => :timeout_add_seconds
          }
        }
      },
      
      :Idle => {
        :class_methods => {
          :add => {
            :symbol => :timeout_add
          },
          
          :add_seconds => {
            :symbol => :timeout_add_seconds
          }
        }
      },
      
      :File => {
        :class_methods => {
          :get_contents => {
            :symbol => :file_get_contents
          },
          
          :set_contents => {
            :symbol => :file_set_contents
          }          
        }
      },
      
      :Spawn => {
        :class_methods => {
          :sync => {
            :symbol => :spawn_sync
          },
        
          :async => {
            :symbol => :spawn_async
          },
          
          :command_line_sync => {
            :symbol => :spawn_command_line_sync
          },
          
          :command_line_async => {
            :symbol => :spawn_command_line_async
          }
        }
      }
    }
  }
}

GirFFI.describe glib

GLib::SpawnFlags
GLib::Lib.attach_function :g_spawn_command_line_sync, [:string,:pointer,:pointer,:pointer,:pointer], :bool
GLib::Lib.attach_function :g_spawn_command_line_async, [:string,:pointer], :bool
GLib::Lib.attach_function :g_spawn_async, [:string, :pointer, :pointer, :SpawnFlags, :pointer, :pointer, :pointer, :pointer], :bool
GLib::Lib.attach_function :g_spawn_sync, [:string, :pointer, :pointer, :SpawnFlags, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :bool
GLib::Lib.attach_function :g_shell_parse_argv, [:string, :pointer, :pointer, :pointer], :bool
def GLib.shell_parse_argv str
  out = FFI::MemoryPointer.new(:pointer)
  
  self::Lib.g_shell_parse_argv(str, nil.to_ptr, out, nil.to_ptr)
  
  return out
end

# Executes a command +cmd+
#
# @param cmd [String], the command to execute
#
# @return [Boolean] on success
def GLib.spawn_command_line_async cmd
  error = FFI::MemoryPointer.new(:pointer)
  error.write_pointer FFI::Pointer::NULL

  bool = self::Lib.g_spawn_command_line_async(cmd, error.to_out(true))
  
  unless bool
    raise GLib::Error.new(error).message
  end
  
  return bool
end

# Executes a command
#
# @param cmd [String], the command to execute
#
# @return [Array]<Integer, String, String>, the exit status, stdout, stderr
def GLib.spawn_command_line_sync cmd
  error = FFI::MemoryPointer.new(:pointer)
  error.write_pointer FFI::Pointer::NULL

  status    = FFI::MemoryPointer.new(:pointer)
  out       = FFI::MemoryPointer.new(:pointer)
  err       = FFI::MemoryPointer.new(:pointer)

  bool = self::Lib.g_spawn_command_line_sync(cmd, out, err, status, error.to_out(true))
  
  unless bool
    raise GLib::Error.new(error).message
  end
  
  e = err.get_pointer(0).to_s
  o = out.get_pointer(0).to_s
  
  return status.get_pointer(0).read_int, o, e
end

def GLib.spawn_helper(*argv,&b)
  argvp = GLib::shell_parse_argv(argv.join(" "))
  
  cb_info = GirFFI::REPO.find_by_name("GLib", "SpawnChildSetupFunc")
  cb_info.extend GirFFI::Builder::MethodBuilder::Callable
  
  cb = cb_info.make_closure(&b)
  
  error = FFI::MemoryPointer.new(:pointer)
  error.write_pointer FFI::Pointer::NULL
  
  return argvp,cb,error
end

# Exectues a process asyncrously
#
# @param path [String], the path to execute in
# @param argv [Array]<String>, the argument vector
# @param flags [Integer], represents the GLib::SpawnFlags
# @param b [Proc], the block to call before execution
#
# @return Integer, Child PID
def GLib.spawn_async(argv, path="./", flags=0,&b)

  argvp, cb, error = spawn_helper(*argv,&b)

  status = FFI::MemoryPointer.new(:pointer)
  
  out    = FFI::MemoryPointer.new(:pointer)
  err    = FFI::MemoryPointer.new(:pointer)
  
  bool = self::Lib.g_spawn_sync path, argvp.get_pointer(0), nil.to_ptr, flags, cb, nil.to_ptr, pid, error.to_out(true)
  
  unless bool
    raise GLib::Error.new(error).message
  end
  
  return pid.get_pointer(0).read_int
end

# Exectues a process syncrously
#
# @param path [String], the path to execute in
# @param argv [Array]<String>, the argument vector
# @param flags [Integer], represents the GLib::SpawnFlags
# @param b [Proc], the block to call before execution
#
# @return [Array]<Integer, String, String>, Integer (exit code), String (stdout), String (stderr)
def GLib.spawn_sync(argv, path="./", flags=0,&b)

  argvp, cb, error = spawn_helper(*argv,&b)

  status = FFI::MemoryPointer.new(:pointer)
  
  out    = FFI::MemoryPointer.new(:pointer)
  err    = FFI::MemoryPointer.new(:pointer)
  
  bool = self::Lib.g_spawn_sync path, argvp.get_pointer(0), nil.to_ptr, flags, cb, nil.to_ptr, out, err, status, error.to_out(true)
  
  unless bool
    raise GLib::Error.new(error).message
  end
  
  e = err.get_pointer(0).to_s
  o = out.get_pointer(0).to_s
  
  return status.get_pointer(0).read_int, o, e
end
