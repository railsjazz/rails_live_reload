module RailsLiveReload
  class Watcher
    attr_reader :root, :files

    def Watcher.init
      watcher = new
      RailsLiveReload.watcher = watcher
    end

    def initialize
      @root = ::Rails.application.root
      @files = {}

      puts "Watching: #{root}"
      RailsLiveReload.patterns.each do |pattern, rule|
        puts "  #{pattern} => #{rule}" 
      end

      build_tree
      start_listener
    end

    def start_listener
      Thread.new do
        listener = Listen.to(root) do |modified, added, removed|
          all = modified + added + removed
          all.each do |file|
            files[file] = File.mtime(file).to_i rescue nil
          end
          Connection.connections.each(&:reload)
        end
        listener.start
      end
    end

    def build_tree
      Dir.glob(File.join(root, '**', '*')).select{|file| File.file?(file)}.each do |file|
        files[file] = File.mtime(file).to_i rescue nil
      end
    end
  end
end
