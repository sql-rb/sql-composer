# frozen_string_literal: true

require "dry/effects"

module SQL
  module Composer
    module Nodes
      class Core
        include Dry::Effects.State(:tokens)

        attr_reader :id

        attr_reader :options

        def initialize(options)
          @options = options
          @id = tokens.next_id
        end

        def fetch(name, default = nil)
          @options.fetch(name, default)
        end

        def backend
          fetch(:backend)
        end

        def quote(identifier)
          backend.quote(identifier)
        end
      end
    end
  end
end
