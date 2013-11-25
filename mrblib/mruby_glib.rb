glib = {
  :namespace => :GLib,
  :prefix    => :g,
  # :version   => 2.0,
  
  :define => {
    # :methods => {
    #   :m_name => {
    #     :symbol => ... ,
    #     :alias  => ... ,
    #     
    #     :argument_types => [],
    #     :return_type    => ...
    #   }
    # },  
    
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
