# frozen_string_literal: true

require "sql/builder/dsl"

module SQL
  def self.build(options, &block)
    backend = Builder.backends[options[:backend]]
    args = options[:args]
    Builder::DSL.new(args: args, backend: backend, &block).()
  end

  module Builder
    def self.backends
      @backends ||= {}
    end

    module Backends
      InputTypeNotSupported = Class.new(StandardError)

      class Postgres
        def quote(identifier)
          %("#{identifier.to_s}")
        end

        def escape(input)
          case input
          when String
            %('#{input}')
          else
            raise InputTypeNotSupported, input.class
          end
        end
      end
    end

    backends[:postgres] = Backends::Postgres.new
  end
end
