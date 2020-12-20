# frozen_string_literal: true

module SQL
  module Builder
    module Nodes
      class Core
        attr_reader :options

        def initialize(options)
          @options = options
        end

        def fetch(name)
          @options.fetch(name)
        end

        def backend
          fetch(:backend)
        rescue => err
          byebug
        end

        def quote(identifier)
          backend.quote(identifier)
        end
      end
    end
  end
end
