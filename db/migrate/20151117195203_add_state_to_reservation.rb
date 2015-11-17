class AddStateToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :state, :integer
  end
end
