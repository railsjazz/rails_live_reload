module RailsLiveReload
  class Command
    attr_reader :dt, :files

    def initialize(params)
      @dt    = params["dt"].to_i
      @files = JSON.parse(params["files"])
    end

    def command
      changes = RailsLiveReload::Checker.scan(dt, files)

      if changes.size == 0
        { command: "NO_CHANGES" }
      else
        { command: "RELOAD" }
      end
    end

  end
end
