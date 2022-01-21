cart = {}
sum = 0
billing = 0

loop do
  print "Enter product name: "
  name = gets.chomp
  if name == "stop"
    break
  elsif cart.include?(name)
    puts "Already presence"
    redo
  end

  print"Enter product price: "
  price = gets.to_f

  print "Enter quantity of goods: "
  quantity = gets.to_f

  sum = price * quantity
  cart[name] = {price: price, quantity: quantity}
  billing += sum

  puts "sum = #{sum}"
  puts "cart = #{cart}"
  puts "billing = #{billing}"

end

puts cart
puts sum