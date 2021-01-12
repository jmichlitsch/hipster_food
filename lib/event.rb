require './lib/item'
require './lib/food_truck'

class Event

  attr_reader :name,
              :food_trucks

  def initialize(name)
    @name = name
    @food_trucks = []
  end

  def add_food_truck(food_truck)
    @food_trucks << food_truck
  end

  def food_truck_names
    truck_names = []
    @food_trucks.each do |food_truck|
      truck_names << food_truck.name
      end
      truck_names
    end

    def food_trucks_that_sell(item)
      trucks_that_sell = []
      @food_trucks.each do |food_truck|
        if food_truck.inventory.include?(item)
          trucks_that_sell << food_truck
        end
      end
      trucks_that_sell
    end

    def  total_inventory
      total = Hash.new { |hash, key| hash[key] = 0 }
      @food_trucks.each do |food_truck|
        total.merge(food_truck.inventory)
      end
      total
    end
end
