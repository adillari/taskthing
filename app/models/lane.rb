class Lane < ApplicationRecord
  include BroadcastsBoard

  has_many :tasks, dependent: :destroy
  belongs_to :board
  default_scope { order(:position) }
end
