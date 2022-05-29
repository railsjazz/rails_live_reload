module RailsLiveReload
  class CurrentRequest
    attr_accessor :data, :record
    attr_reader :request_id

    def CurrentRequest.init
      Thread.current[:rc_current_request] ||= CurrentRequest.new(SecureRandom.hex(16))
    end

    def CurrentRequest.current
      CurrentRequest.init
    end

    def CurrentRequest.cleanup
      Thread.current[:rc_current_request] = nil
    end

    def initialize(request_id)
      @request_id = request_id
      @data       = Set.new
    end
  end
end
