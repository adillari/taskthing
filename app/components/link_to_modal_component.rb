class LinkToModalComponent < ApplicationComponent
  def initialize(path:, classes: "")
    @path = path
    @class = classes
  end
end
