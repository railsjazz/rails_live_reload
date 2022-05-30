module RailsLiveReload
  class Command
    attr_reader :dt, :files

    def initialize(params)
      @dt    = params["dt"].to_i
      @files = JSON.parse(params["files"])
    end

    def changes
      RailsLiveReload::Checker.scan(dt, files)
    end

    def reload?
      !changes.size.zero?
    end

    def command
      if reload?
        { command: "RELOAD" }
      else
        { command: "NO_CHANGES" }
      end
    end

  end
end
