require 'securerandom'

module Imprint
  class Tracer
    TRACER_HEADER    = 'HTTP_IMPRINTID'
    TRACER_KEY       = 'IMPRINTID'
    RAILS_REQUEST_ID = "action_dispatch.request_id"
    TRACE_ID_DEFAULT = "-1"
    TRACER_TIMESTAMP = "TIMESTAMP"

    def self.set_trace_id(id, rack_env = {})
      Thread.current[TRACER_TIMESTAMP] = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.%6N")
      Thread.current[TRACER_KEY] = id
      # setting to the rack_env, gives error tracking support in some systems
      rack_env[TRACER_KEY] = id
    end

    def self.get_trace_id
      if Thread.current.key?(TRACER_KEY)
        Thread.current[TRACER_KEY]
      else
        TRACE_ID_DEFAULT
      end
    end

    def self.get_trace_timestamp
      Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.%6N")
    end

    def self.get_pid
      "#{$$}"
    end

    def self.insert_trace_id_in_message(message, severity = nil)
      if message && message.is_a?(String) && message.length > 1 && !message.include?('trace_id=')
        trace_id = get_trace_id

        if trace_id && trace_id != TRACE_ID_DEFAULT
          message << " process_pid=#{get_pid} trace_id=#{trace_id}"
        end
      end
    end

    def self.rand_trace_id
      SecureRandom.uuid
    end

    def self.initiate_trace_id(logger = nil)
      trace_id = Imprint::Tracer.rand_trace_id
      logger.info("trace_status=initiated trace_id=#{trace_id}") if logger && logger.respond_to?(:info)
      Imprint::Tracer.set_trace_id(trace_id)
    end
  end
end

