class Board < ApplicationRecord
  has_many :board_users, dependent: :destroy
  has_many :users, through: :board_users
  has_many :lanes, dependent: :destroy
  after_create_commit :create_default_lanes

  private

  def create_default_lanes
    return if lanes.any?

    lanes.create!([
      { name: "Not Started", position: 1 },
      { name: "In Progress", position: 2 },
      { name: "Done 🎉", position: 3 },
    ])
  end
end
