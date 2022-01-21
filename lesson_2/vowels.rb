alphabet = ('a'..'z').to_a
vowels = %w[a e i o u]
new_array = {}
alphabet.each.with_index(1) do |value, key|
  new_array[key] = value if vowels.include?(value)
end
puts new_array