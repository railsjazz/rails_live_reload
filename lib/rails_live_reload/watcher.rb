module RailsLiveReload
  class Watcher
    attr_reader :files, :sockets

    def root
      RailsLiveReload.config.root_path
    end

    def Watcher.init
      watcher = new
      RailsLiveReload.watcher = watcher
    end

    def initialize
      @files = {}
      @sockets = []

      puts "Watching: #{root}"
      RailsLiveReload.patterns.each do |pattern, rule|
        puts "  #{pattern} => #{rule}"
      end

      build_tree
      start_socket
      start_listener
    end

    def start_listener
      Thread.new do
        listener = Listen.to(root) do |modified, added, removed|
          all = modified + added + removed
          all.each do |file|
            files[file] = File.mtime(file).to_i rescue nil
          end
          reload_all
        end
        listener.start
      end
    end

    def build_tree
      Dir.glob(File.join(root, '**', '*')).select{|file| File.file?(file)}.each do |file|
        files[file] = File.mtime(file).to_i rescue nil
      end
    end

    def reload_all
      data = {
        event: RailsLiveReload::INTERNAL[:socket_events][:reload],
        files: files
      }.to_json

      @sockets.each do |socket, _|
        socket.puts data
      end
    end

    def start_socket
      Thread.new do
        Socket.unix_server_socket(RailsLiveReload.config.socket_path.to_s) do |sock|
          loop do
            socket, _ = sock.accept
            sockets << socket
            Thread.new do
              begin
                socket.eof
              ensure
                socket.close
                sockets.delete socket
              end
            end
          end
        end
      end
    end
  end
end
