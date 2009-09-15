def current_controller
  Thread.current[:current_controller]
end

module CurrentController
  def self.included(base)
    base.class_eval do
      before_filter :set_current_controller
    end
  end

  def set_current_controller
    Thread.current[:current_controller] = self
  end
end

