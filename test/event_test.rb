require 'minitest/autorun'
require 'minitest/pride'
require './lib/item'
require './lib/food_truck'
require './lib/event'

class FoodTruckTest < Minitest::Test

  def test_it_exists_and_has_attributes
    event = Event.new("South Pearl Street Farmers Market")
    assert_instance_of Event, event
    assert_equal "South Pearl Street Farmers Market", event.name
    assert_equal [], event.food_trucks
  end

  def test_can_add_food_truck
    event = Event.new("South Pearl Street Farmers Market")
    food_truck1 = FoodTruck.new("Rocky Mountain Pies")
    item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
    item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})
    food_truck1.stock(item1, 35)
    food_truck1.stock(item2, 7)
    event.add_food_truck(food_truck1)

    assert_equal [food_truck1], event.food_trucks
  end

  def test_it_can_read_truck_names
    event = Event.new("South Pearl Street Farmers Market")
    food_truck1 = FoodTruck.new("Rocky Mountain Pies")
    item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
    event.add_food_truck(food_truck1)
    assert_equal ["Rocky Mountain Pies"], event.food_truck_names
  end

  def test_trucks_that_can_sell
    event = Event.new("South Pearl Street Farmers Market")
    food_truck1 = FoodTruck.new("Rocky Mountain Pies")
    food_truck2 = FoodTruck.new("Ba-Nom-a-Nom")
    item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
    item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})
    item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    food_truck1.stock(item1, 35)
    food_truck1.stock(item2, 7)
    food_truck2.stock(item4, 50)
    food_truck2.stock(item3, 25)
    event.add_food_truck(food_truck1)
    event.add_food_truck(food_truck2)

    assert_equal [food_truck1], event.food_trucks_that_sell(item1)
  end

  def test_sorted_item_list
    event = Event.new("South Pearl Street Farmers Market")
    food_truck1 = FoodTruck.new("Rocky Mountain Pies")
    food_truck2 = FoodTruck.new("Ba-Nom-a-Nom")
    item1 = Item.new({name: 'A', price: "$3.75"})
    item2 = Item.new({name: 'B', price: '$2.50'})
    item3 = Item.new({name: 'C', price: "$5.30"})
    item4 = Item.new({name: 'D', price: "$4.25"})
    food_truck1.stock(item1, 35)
    food_truck1.stock(item2, 7)
    food_truck2.stock(item4, 50)
    food_truck2.stock(item3, 25)
    event.add_food_truck(food_truck1)
    event.add_food_truck(food_truck2)

    assert_equal ["A", "B", "C", "D"], event.sorted_item_list
  end

  def test_total_inventory
    event = Event.new("South Pearl Street Farmers Market")

    food_truck1 = FoodTruck.new("Rocky Mountain Pies")
    food_truck2 = FoodTruck.new("Ba-Nom-a-Nom")

    item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
    item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})
    item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})

    food_truck1.stock(item1, 35)
    food_truck1.stock(item2, 7)
    food_truck2.stock(item4, 50)
    food_truck2.stock(item3, 25)

    event.add_food_truck(food_truck1)
    event.add_food_truck(food_truck2)

    expected = {item1 => {quantity: 35, food_trucks: [food_truck1]}, item2 => {quantity: 7, food_trucks: [food_truck1]}, item3 => {quantity: 25, food_trucks: [food_truck2]}, item4 => {quantity: 50, food_trucks: [food_truck2]}}
    assert_equal expected, event.total_inventory
  end

  def test_overstocked_items
    event = Event.new("South Pearl Street Farmers Market")

    food_truck1 = FoodTruck.new("Rocky Mountain Pies")
    food_truck2 = FoodTruck.new("Ba-Nom-a-Nom")

    item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
    item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})
    item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})

    food_truck1.stock(item1, 35)
    food_truck1.stock(item2, 7)
    food_truck2.stock(item4, 51)
    food_truck2.stock(item3, 25)
    food_truck2.stock(item1, 65)

    event.add_food_truck(food_truck1)
    event.add_food_truck(food_truck2)

    assert_equal [item1], event.overstocked_items
  end

  def test_sell
    event = Event.new("South Pearl Street Farmers Market")

    food_truck1 = FoodTruck.new("Rocky Mountain Pies")
    food_truck2 = FoodTruck.new("Ba-Nom-a-Nom")

    item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
    item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})
    item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    item5 = Item.new({name: "Onion Pie", price: "$25.00"})
    food_truck1.stock(item1, 35)
    food_truck1.stock(item2, 7)
    food_truck2.stock(item4, 50)
    food_truck2.stock(item3, 25)
    food_truck2.stock(item1, 65)

    event.add_food_truck(food_truck1)
    event.add_food_truck(food_truck2)

    refute event.sell(item1, 200)
    refute event.sell(item5, 1)

    assert event.sell(item4, 5)
    assert_equal 45, food_truck2.check_stock(item4)

    assert event.sell(item1, 40)
    assert_equal 0, food_truck1.check_stock(item1)
    assert_equal 60, food_truck2.check_stock(item1)
  end
end
