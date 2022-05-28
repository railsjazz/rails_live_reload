require "listen"
require "rails_live_reload/version"
require "rails_live_reload/helper"
require "rails_live_reload/rails/middleware"
require "rails_live_reload/instrument/metrics_collector"
require "rails_live_reload/thread/current_request"
require "rails_live_reload/command"
require "rails_live_reload/engine"

module RailsLiveReload
  mattr_accessor :files
  @@files = {}

  mattr_accessor :watcher
  @@watcher = nil

  class Watcher

    def initialize(folder:)
      #checker = ActiveSupport::EventedFileUpdateChecker.new([folder]) { puts  }
      puts "Watching: #{folder}"

      Dir.glob(File.join(folder, '**', '*')).select{|file| File.file?(file)}.each do |file|
        RailsLiveReload.files[file] = File.mtime(file).to_i rescue nil
      end

      @thread = Thread.new do
        listener = Listen.to(folder) do |modified, added, removed|
          all = modified + added + removed
          all.each do |file|
            RailsLiveReload.files[file] = File.mtime(file).to_i rescue nil
          end
        end
        listener.start
      end

      RailsLiveReload.watcher = self
    end

  end

end
