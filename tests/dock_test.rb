require 'minitest/autorun'
require 'minitest/pride'
require './lib/boat'
require './lib/renter'
require './lib/dock'

class DockTest < Minitest::Test

  def setup
    @dock = Dock.new("The Rowing Dock", 3)
    @kayak_1 = Boat.new(:kayak, 20)
    @kayak_2 = Boat.new(:kayak, 20)
    @sup_1 = Boat.new(:standup_paddle_board, 15)
    @sup_2 = Boat.new(:standup_paddle_board, 15)
    @canoe = Boat.new(:canoe, 25)
    @patrick = Renter.new("Patrick Star", "4242424242424242")
    @eugene = Renter.new("Eugene Crabs", "1313131313131313")
  end

  def test_dock_has_name_and_max_rental_time
    assert_equal "The Rowing Dock", @dock.name
    assert_equal 3, @dock.max_rental_time
  end

  def test_dock_rental_log_tracks_boat_rentals
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)
    expected = { @kayak_1 => @patrick,
                 @kayak_2 => @patrick,
                 @sup_1 => @eugene }

    assert_equal expected, @dock.rental_log
  end

  def test_dock_charge_returns_hash_with_card_number_and_amount
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)
    @kayak_1.add_hour
    @kayak_1.add_hour
    expected = { :card_number => "4242424242424242",
                 :amount => 40 }
    assert_equal expected, @dock.charge(@kayak_1)

    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    expected_2 = { :card_number => "1313131313131313",
                   :amount => 45 }
    assert_equal expected_2, @dock.charge(@sup_1)
  end

  def test_log_hour_and_return_and_revenue
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    @dock.rent(@canoe, @patrick)
    @dock.log_hour
    # Revenue should not be generated until boats are returned
    assert_equal 0, @dock.revenue

    @dock.return(@kayak_1)
    @dock.return(@kayak_2)
    @dock.return(@canoe)

    assert_equal 105, @dock.revenue

    # Rent boats to a second Renter
    @dock.rent(@sup_1, @eugene)
    @dock.rent(@sup_2, @eugene)
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour
    # Any hours rented past the max rental time don't factor into revenue
    @dock.log_hour
    @dock.log_hour
    @dock.return(@sup_1)
    @dock.return(@sup_2)

    assert_equal 195, @dock.revenue
  end

end
