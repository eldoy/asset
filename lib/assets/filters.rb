# Naming convenience for use with Liquid templates
# Usage: Liquid::Template.register_filter(::Asset::Filters)

module Asset
  module Filters

    include ::Asset::Helpers

  end
end
