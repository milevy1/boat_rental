require 'minitest/autorun'
require 'minitest/pride'
require './lib/boat'
require './lib/renter'
require './lib/dock'

class DockTest < Minitest::Test

  def setup
    @dock = Dock.new("The Rowing Dock", 3)
  end

  def test_dock_has_name_and_max_rental_time
    assert_equal "The Rowing Dock", @dock.name
    assert_equal 3, @dock.max_rental_time
  end

end
