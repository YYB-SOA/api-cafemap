# frozen_string_literal: true

folders = %w[cafenomad googleplace clustering]
folders.each do |folder|
  Dir.glob("#{__dir__}/#{folder}/**/*.rb").each do |file|
    require_relative file
  end
end
