# Public: A Tilt template to compile Stylus stylesheets with asset helpers.
module Tilt
  class StylusRailsTemplate < StylusTemplate
    def evaluate(scope, locals, &block)
      self.data = MixinBody.new(scope).render + self.data
      super
    end
  end
end

Tilt.register Tilt::StylusRailsTemplate, 'styl'
