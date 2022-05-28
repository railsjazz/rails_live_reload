module RailsLiveReload
  class Command
    attr_reader :dt, :files

    def initialize(params)
      @dt    = params["dt"].to_i
      @files = JSON.parse(params["files"])
    end

    def command
      result = []

      # from view
      files_to_check = RailsLiveReload.files.slice(*files)
      files_to_check.each do |file, fdt|
        result << file if fdt && fdt > dt
      end

      # from css
      RailsLiveReload.files.each do |file, fdt|
        result << file if fdt && fdt > dt && (file.ends_with?(".css") || file.ends_with?(".js"))
      end
      
      if result.size == 0
        { command: "NO_CHANGES" }
      else
        { command: "RELOAD" }
      end
    end

  end
end
