# frozen_string_literal: true

require "sql/composer/nodes/core"

module SQL
  module Composer
    module Nodes
      class From < Core
        track true

        type :from

        def source
          fetch(:source)
        end

        def to_s
          "FROM #{source.to_s}"
        end

        def to_ast
          [:from, source.to_ast]
        end
      end
    end
  end
end
