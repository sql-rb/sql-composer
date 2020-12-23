# frozen_string_literal: true

require "sql/composer/nodes/core"

module SQL
  module Composer
    module Nodes
      class Select < Core
        type :select

        track true

        def self.args_ast(*args)
          args.map(&:to_ast)
        end

        def identifiers
          fetch(:identifiers)
        end

        def append(*args, &block)
          new_identifiers = args.map { |arg|
            case arg
            when Symbol, String then dsl.lit(arg)
            when Nodes::Identifier
              arg
            else
              raise UnsupportedArgumentError, "#{arg.inspect} in Select#append"
            end
          }

          if block
            new_identifiers << dsl.new(&block).().in_parens
          end

          with(identifiers: new_identifiers)
        end

        def with(new_options)
          super(identifiers: identifiers + new_options[:identifiers])
        end

        def to_s
          "SELECT #{identifiers.map(&:to_s).join(', ')}"
        end

        def to_ast
          [:select, identifiers.map(&:to_ast)]
        end
      end
    end
  end
end
