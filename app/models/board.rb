class Board < ApplicationRecord
  belongs_to :user
  has_many :lanes, dependent: :destroy
  after_save_commit :create_default_lanes

private

  def create_default_lanes
    lanes.create!([
      { name: "Not Started", position: 1 },
      { name: "In Progress", position: 2 },
      { name: "Done 🎉", position: 3 }
    ])
  end
end
