module Stylus
  class MixinBody

    def initialize(scope)
      @scope = scope
    end

    # Internal: Builds body of a mixin
    #
    # Returns string representation of a mixin
    def render
      @mixin_body ||= <<-STYL
asset-url(key)
  return pair[1] if pair[0] == key for pair in #{assets_hash}
asset-path(key)
  return pair[1] if pair[0] == key for pair in #{assets_hash(:protocol => :request)}
      STYL
    end

    # Internal: Construct Hash in stylus syntax, that consists of absolute and relative paths to assets
    #
    # Returns string representation of hash in Stylus syntax
    def assets_hash(options = {})
      assets_paths = available_assets.each_with_object([]) do |logical_path, resolved_path|
        resolved_path << "{ ('#{logical_path}' url('#{path_to_asset(logical_path, options)}')) }" unless logical_path =~ /.*\.(css|js)$/
      end
      assets_paths << '()' if assets_paths.count < 2
      assets_paths.join(' ')
    end

    def available_assets
      @available_assets ||= Rails.application.assets.each_logical_path
    end

  end
end
