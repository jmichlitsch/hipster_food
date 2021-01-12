require './lib/item'

class FoodTruck

  attr_reader :name,
              :inventory

  def initialize(name)
    @name = name
    @inventory = Hash.new { |hash, key| hash[key] = 0 }
  end

  def stock(item, value)
      @inventory[item] += value
  end

  def check_stock(item)
    @inventory.values
  end

#Need to fix this method with array to integer issue
  def potential_revenue
    @inventory.sum do |item, amount|
      item.convert_to_integer * amount
    end
  end

end
