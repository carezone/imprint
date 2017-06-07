require 'logger'
require 'imprint/tracer'

class Logger
  alias_method :original_add, :add

  def add(severity, message = nil, progname = nil, &block)
    message = (message || (block && block.call) || progname).to_s
    Imprint::Tracer.insert_trace_id_in_message(message)
    original_add(severity, message)
  end
end
