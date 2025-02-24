class Board < ApplicationRecord
  has_many :board_users, dependent: :destroy
  has_many :users, through: :board_users
  has_many :invites, dependent: :destroy
  has_many :lanes, dependent: :destroy
  has_many :tasks, through: :lanes
  after_create_commit :create_default_lanes
  accepts_nested_attributes_for :lanes, allow_destroy: true

  def bump_version!
    update!(version: version + 1)
  end

  private

  def create_default_lanes
    return if lanes.any?

    lanes.create!([
      { name: "Not Started", position: 0 },
      { name: "In Progress", position: 1 },
      { name: "Done 🎉", position: 2 },
    ])
  end
end
