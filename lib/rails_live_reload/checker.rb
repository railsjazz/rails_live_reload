module RailsLiveReload
  class Checker

    def self.scan(dt, rendered_files)
      temp = []

      # all changed files
      RailsLiveReload.files.each do |file, fdt|
        temp << file if fdt && fdt > dt
      end

     # ::Rails.logger.info "Changed: #{temp}"

      result = []

      temp.each do |file|
       # ::Rails.logger.info "Checking: #{file}"
        RailsLiveReload.patterns.each do |pattern, rule|
          #puts "pattern = #{pattern} & rule = #{rule}"
          # 1. CSS, JS, yaml, helper .rb
          # 2. checking if rendered file
          rule_1 = file.match(pattern) && rule == :always
          rule_2 = file.match(pattern) && rendered_files.include?(file)

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