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
      @food_trucks.find_all do |food_truck|
        food_truck.check_stock(item) > 0
      end
    end

    def sorted_item_list
      items = @food_trucks.map do |food_truck|
        food_truck.inventory.keys
      end.flatten

      items.map do |item|
        item.name
      end.sort
    end

    def  total_inventory
      total_inventory = {}

      @food_trucks.each do |food_truck|
        food_truck.inventory.each do |item, quantity|
          if total_inventory[item].nil?
            total_inventory[item] = {quantity: 0, food_trucks: []}
        end

        total_inventory[item][:quantity] += quantity
        total_inventory[item][:food_trucks].push(food_truck)
      end
    end
    total_inventory
  end

  def overstocked_items
    overstocked= []
    total_inventory.each do |item, info|
      overstocked << item if info[:quantity] > 50 && info[:food_trucks].length > 1
    end
    overstocked
  end

  def sell(item, quantity)
    if total_inventory[item].nil? || total_inventory[item][:quantity] < quantity
      return false
    end
    
    food_trucks_that_sell(item).each do |truck|
        if truck.check_stock(item) >= quantity
          truck.sell(item, quantity)
          quantity = 0
        else
          quantity -= truck.check_stock(item)
          truck.sell(item, truck.check_stock(item))
        end
    end
  end
end
