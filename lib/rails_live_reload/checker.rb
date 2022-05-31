module RailsLiveReload
  class Checker

    def self.scan(dt, rendered_files)
      temp = []

      # all changed files
      RailsLiveReload.watcher.files.each do |file, fdt|
        temp << file if fdt[:timestamp] && fdt[:timestamp] > dt
      end

      result = []

      temp.each do |file|
        RailsLiveReload.patterns.each do |pattern, rule|
          rule_1 = file.match(pattern) && rule == :always # Used for CSS, JS, yaml, helpers, etc.
          rule_2 = file.match(pattern) && rendered_files.include?(file) # Used to check if view was rendered

          if rule_1 || rule_2
            result << file
            break
          end
        end
      end

      result
    end

  end
end