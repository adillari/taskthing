class AddEmailAddressToInvites < ActiveRecord::Migration[8.0]
  def change
    add_column(:invites, :email_address, :string)
  end
end
