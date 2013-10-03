module Stylus
  module Helpers
    class AssetMixin
      attr_accessor :file

      def initialize(scope)
        @scope = scope
        @available_assets = Rails.application.assets.each_logical_path
      end

      # Public: Modifies data if modification allowed
      #
      # Returns modified data as string, or original data
      def self.prepend_import_directive(scope, data)
        self.new(scope).prepend_import_directive(data)
      end

      # Public: Prepends data with style import directive to support "asset_path" and "asset_url"
      #
      # Returns String
      def prepend_import_directive(data)
        data.prepend(mixin_body)
      end

      # Internal: Builds body of a mixin
      #
      # Returns string representation of a mixin
      def mixin_body
        @mixin_body ||= <<-STYL
asset-url(key)
  return pair[1] if pair[0] == key for pair in #{assets_hash}
asset-path(key)
  return pair[1] if pair[0] == key for pair in #{assets_hash(:relative => true)}
        STYL
      end

      # Internal: Construct Hash in stylus syntax, that consists of absolute and relative paths to assets
      #
      # Returns string representation of hash in Stylus syntax
      def assets_hash(options = {})
        assets_paths = @available_assets.map do |logical_path|
          unless logical_path =~ /.*\.(css|js)$/
            asset_path = resolve_path(logical_path, options) rescue nil
            asset_path ? %{("#{logical_path}" url('#{asset_path}'))} : nil
          end
        end.compact
        assets_paths << '()' if assets_paths.count < 2
        assets_paths.join(' ')
      end

      def resolve_path(path, options = {})
        if options[:relative]
          @scope.asset_path(path)
        else
          @scope.asset_url(path)
        end
      end

    end
  end
end