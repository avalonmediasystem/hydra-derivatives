require 'active_encode'

module Hydra::Derivatives::Processors
  class ActiveEncodeProcessor < Hydra::Derivatives::Processors::Processor
    class_attribute :timeout

    def process
      execute(directives)
    end

    def execute(opts)
      context = {}
      if timeout
        execute_with_timeout(timeout, opts, context)
      else
        execute_without_timeout(opts, context)
      end
      encode = ActiveEncode::Base.find(context[:encode_id])
      encode.output.each {|output| output_file_service.call(output, opts[:output].find {|o| o[:format] == encode.output.first[:format]})}
    end

    def execute_with_timeout(timeout, opts, context)
      Timeout.timeout(timeout) do
        execute_without_timeout(opts, context)
      end
    rescue Timeout::Error
      id = context[:encode_id]
      ActiveEncode::Base.find(id).cancel! rescue nil
      raise Hydra::Derivatives::TimeoutError, "Unable to execute active-encode \"#{opts}\"\nThe encode took longer than #{timeout} seconds to execute"
    end

    def execute_without_timeout(opts, context)
      encode_job = ActiveEncode::Base.create(URI.join("file://", source_path).to_s, opts)
      context[:encode_id] = encode_job.id
      sleep(0.1) while encode_job.reload.running?
    end
  end
end
