module Broadcasts::Board
  extend ActiveSupport::Concern

  included do
    after_commit :broadcast_board_update
  end

private

  def broadcast_board_update
    broadcast_replace_to(board, target: :board, html: "this is a stub")
  end
end
