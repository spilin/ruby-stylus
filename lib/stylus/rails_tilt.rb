# Public: A Tilt template to compile Stylus stylesheets with asset helpers.
module Stylus
  module Rails
    class StylusTemplate < ::Tilt::StylusTemplate

      # Public: The default mime type for stylesheets.
      self.default_mime_type = 'text/css'

      # Internal: Appends stylus mixin for asset_url and asset_path support
      def evaluate(scope, locals, &block)
        @data = build_mixin_body(scope) + data
        super
      end

      protected

      # Internal: Builds body of a mixin
      #
      # Returns string representation of a mixin with asset helper functions
      def build_mixin_body(scope)
        @mixin_body ||= <<-STYL
asset-url(key)
  return pair[1] if pair[0] == key for pair in #{assets_hash(scope)} ()
asset-path(key)
  return pair[1] if pair[0] == key for pair in #{assets_hash(scope, :protocol => :request)} ()
        STYL
      end

      # Internal: Construct Hash in stylus syntax, that consists of absolute and relative paths to assets
      #
      # Returns string representation of hash in Stylus syntax
      def assets_hash(scope, options = {})
        scope.environment.each_logical_path.each_with_object([]) do |logical_path, resolved_path|
          resolved_path << "('#{logical_path}' url('#{scope.path_to_asset(logical_path, options)}'))" unless logical_path =~ /.*\.(css|js)$/
        end.join(' ')
      end

    end
  end
end

Tilt.register ::Stylus::Rails::StylusTemplate, 'styl'
