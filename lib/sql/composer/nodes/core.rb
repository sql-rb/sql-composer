# frozen_string_literal: true

require "dry/core/class_attributes"
require "dry/effects"

module SQL
  module Composer
    module Nodes
      class Core
        include Dry::Effects.State(:tokens)
        extend Dry::Core::ClassAttributes

        defines :type

        defines :track

        track false

        attr_reader :id

        attr_reader :options

        def initialize(options)
          @options = options
          @id = track? ? (options[:id] || tokens.next_id) : nil
        end

        def track?
          self.class.track.equal?(true)
        end

        def fetch(name, default = nil)
          @options.fetch(name, default)
        end

        def with(new_options)
          self.class.new(options.merge(id: id).merge(new_options))
        end

        def backend
          fetch(:backend)
        end

        def dsl
          fetch(:dsl)
        end

        def quote(identifier)
          backend.quote(identifier)
        end

        def type
          self.class.type
        end
      end
    end
  end
end
