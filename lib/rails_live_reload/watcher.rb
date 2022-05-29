module RailsLiveReload
  class Watcher
    attr_reader :root

    def Watcher.init
      watcher = new
      RailsLiveReload.watcher = watcher
    end

    def initialize
      @root = ::Rails.application.root
      puts "Watching: #{root}"
      RailsLiveReload.patterns.each do |pattern, rule|
        puts "  #{pattern} => #{rule}" 
      end
      self.build_tree
      self.start_listener
    end

    def start_listener
      Thread.new do
        listener = Listen.to(root) do |modified, added, removed|
          all = modified + added + removed
          all.each do |file|
            RailsLiveReload.files[file] = File.mtime(file).to_i rescue nil
          end
        end
        listener.start
      end
    end

    def build_tree
      Dir.glob(File.join(root, '**', '*')).select{|file| File.file?(file)}.each do |file|
        RailsLiveReload.files[file] = File.mtime(file).to_i rescue nil
      end
    end
  end
end