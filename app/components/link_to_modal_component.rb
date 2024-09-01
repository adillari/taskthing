class LinkToModalComponent < ApplicationComponent
  def initialize(path:, classes: "")
    @path = path
    @class = options[:classes] if options[:classes]
  end
end
