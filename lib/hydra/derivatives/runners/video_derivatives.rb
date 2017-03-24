module Hydra::Derivatives
  class VideoDerivatives < Runner
    # @param [String, ActiveFedora::Base] object_or_filename path to the source file, or an object
    # @param [Hash] options options to pass to the encoder
    # @options options [Array] :outputs a list of desired outputs, each entry is a hash that has :label (optional), :format and :url
    def self.create(object_or_filename, options)
      source_file(object_or_filename, options) do |f|
	processor_class.new(f.path,
			    transform_directives(options.delete(:outputs)).merge(source_file_service: source_file_service),
			    output_file_service: output_file_service).process
      end
    end

    def self.transform_directives(options)
      options.each do |directive|
        # TODO: munge options for active-encode
      end
      # Make sure to return only a single object that doesn't create a more than one activenecode request
      outputs = options.collect { |directive| directive.slice(:format, :label, :url) }
      { output: outputs }
    end

    def self.processor_class
      Processors::ActiveEncodeProcessor
      # Processors::Video::Processor
    end
  end
end
