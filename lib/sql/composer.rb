# frozen_string_literal: true

require "sql/composer/dsl"

module SQL
  def self.compose(options = {}, &block)
    backend = Composer.backends[options[:backend] || :postgres]
    args = options[:args]
    Composer::DSL.new(args: args, backend: backend, &block).()
  end

  module Composer
    def self.backends
      @backends ||= {}
    end

    module Backends
      InputTypeNotSupported = Class.new(StandardError)

      class Postgres
        def quote(identifier)
          %("#{identifier}")
        end

        def escape(input)
          case input
          when String
            %('#{input}')
          when Integer
            input
          else
            raise InputTypeNotSupported, input.class
          end
        end
      end
    end

    backends[:postgres] = Backends::Postgres.new
  end
end
