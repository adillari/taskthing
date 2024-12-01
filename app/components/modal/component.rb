module Modal
  class Component < Application::Component
    def initialize(title:)
      super
      @title = title
    end
  end
end
