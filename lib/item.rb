class Item

  attr_reader :name,
              :price
  def initialize(attributes)
    @name = attributes[:name]
    @price = attributes[:price]
  end

  def convert_to_integer
    @price.to_i
  end
end
