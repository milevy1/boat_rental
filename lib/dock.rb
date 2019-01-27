class Dock
  attr_reader :name, :max_rental_time, :rental_log

  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @rental_log = {}
  end

  def rent(boat, renter)
    @rental_log[boat] = renter
  end

  def charge(boat)
    result = {}
    renter = @rental_log[boat]
    result[:card_number] = renter.credit_card_number
    result[:amount] = boat.price_per_hour * boat.hours_rented
    return result
  end

end
