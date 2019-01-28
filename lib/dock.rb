class Dock
  attr_reader :name,
              :max_rental_time,
              :rental_log,
              :return_log

  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @rental_log = {}
    @return_log = []
  end

  def rent(boat, renter)
    # Check boat is not currently rented
    if !@rental_log[boat].nil?
      puts "Error, boat is currently rented"
    else
      @rental_log[boat] = renter
    end
  end

  def charge(boat)
    result = {}
    renter = @rental_log[boat]
    if boat.hours_rented < @max_rental_time
      hours_billable = boat.hours_rented
    else
      hours_billable = @max_rental_time
    end

    result[:card_number] = renter.credit_card_number
    result[:amount] = boat.price_per_hour * hours_billable
    return result
  end

  def return(boat)
    @return_log << charge(boat)
    @rental_log[boat] = nil
  end

  def log_hour
    @rental_log.each { |boat, renter| boat.add_hour }
  end

  def revenue
    # Sum all charges stored in the return_log array
    result = 0
    @return_log.each { |charge| result += charge[:amount] }
    return result
  end

end
