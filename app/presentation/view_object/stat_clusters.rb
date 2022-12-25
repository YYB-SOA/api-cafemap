# frozen_string_literal: true

module Views
  # View for a single info entity
  class Cluster
    def initialize(filtered_info)
      @info = filtered_info
    end

    def entity
      @info
    end

  end
end
