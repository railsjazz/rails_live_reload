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
          changed = (modified + added + removed).select do |file|
            files.dig(file, :hexdigest) != hexdigest(file)
          end

          changed.each { |file| files[file] = tree_node(file) }
        end
        listener.start
      end
    end

    private

    def build_tree
      Dir.glob(File.join(root, '**', '*')).select{|file| File.file?(file)}.each do |file|
        files[file] = tree_node(file)
      end
    end

    def tree_node(file)
      { timestamp: (File.mtime(file).to_i rescue nil), hexdigest: hexdigest(file) }
    end

    def hexdigest(file)
      Digest::MD5.hexdigest(File.read(file)).to_s rescue Errno::ENOENT nil
    end
  end
end
