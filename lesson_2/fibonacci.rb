fibonacci1 = 0
fibonacci2 = 1

new_fibonacci = 0

for i in 1..10
  new_fibonacci = fibonacci1 + fibonacci2
  fibonacci1 = fibonacci2
  fibonacci2 = new_fibonacci
puts new_fibonacci
end