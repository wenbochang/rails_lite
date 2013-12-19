require 'active_support/core_ext'

def arr_to_hash(arr, h)
  return { arr[0] => h } unless arr[0].class == Array
  return { arr[0][0] => h } if arr[0].length == 1

  new_h = { arr[0].pop => h }

  arr_to_hash(arr, new_h)
end

nested_arr = [["a", "1"], ["b", "2"]]
#nested_arr = [[["cat", "name"], "spot"], [["cat", "owner"], "c2"]]

#h = {}

# str_arr.each do |arr|
#   keys, value = arr[0], arr[1]
#   0...keys.length do |i|
#     h[keys[i]] => {} if h[keys[i]].nil?
#   end
# end

a = {}

nested_arr.each do |arr|
  a = a.deep_merge(arr_to_hash(arr, arr[1]))
end

p a