glib = {
  :namespace => :GLib,
  :prefix    => :g,
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
      
      :File => {
        :class_methods => {
          :get_contents => {
            :symbol => :file_get_contents
          },
          
          :set_contents => {
            :symbol => :file_set_contents
          }          
        }
      }
    }
  }
}

GirFFI.describe glib
