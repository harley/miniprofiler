module Rack
  class MiniProfiler
    module ProfilingMethods 
     
		  def record_sql(query, elapsed_ms)
        c = current
        return unless c
			  c.current_timer.add_sql(query, elapsed_ms, c.page_struct, c.skip_backtrace, c.full_backtrace) if (c && c.current_timer)
		  end

      # perform a profiling step on given block
      def step(name)
        if current
          parent_timer = current.current_timer
          result = nil
          current.current_timer = current_timer = current.current_timer.add_child(name) 
          begin 
            result = yield if block_given?
          ensure
            current_timer.record_time
            current.current_timer = parent_timer
          end
          result
        else
          yield if block_given?
        end
      end

      def unprofile_method(klass, method)
        with_profiling = (method.to_s + "_with_mini_profiler").intern
        without_profiling = (method.to_s + "_without_mini_profiler").intern
        
        if klass.send :method_defined?, with_profiling
          klass.send :alias_method, method, without_profiling
          klass.send :remove_method, with_profiling
          klass.send :remove_method, without_profiling
        end
      end

      def profile_method(klass, method, &blk)
        default_name = klass.to_s + " " + method.to_s
        with_profiling = (method.to_s + "_with_mini_profiler").intern
        without_profiling = (method.to_s + "_without_mini_profiler").intern
        
        if klass.send :method_defined?, with_profiling
          return # dont double profile
        end
          
        klass.send :alias_method, without_profiling, method
        klass.send :define_method, with_profiling do |*args, &orig|
          return self.send without_profiling, *args, &orig unless Rack::MiniProfiler.current

          name = default_name 
          name = blk.bind(self).call(*args) if blk
          
          parent_timer = Rack::MiniProfiler.current.current_timer
          page_struct = Rack::MiniProfiler.current.page_struct
          result = nil

          Rack::MiniProfiler.current.current_timer = current_timer = parent_timer.add_child(name) 
          begin 
            result = self.send without_profiling, *args, &orig
          ensure
            current_timer.record_time
            Rack::MiniProfiler.current.current_timer = parent_timer
          end 
          result 
        end
        klass.send :alias_method, method, with_profiling
      end
    end
  end
end
