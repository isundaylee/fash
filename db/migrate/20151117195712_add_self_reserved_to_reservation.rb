class AddSelfReservedToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :self_reserved, :boolean
  end
end
