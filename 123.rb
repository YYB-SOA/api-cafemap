require 'json'

input = 'hsinchu'
f = File.read(("app/domain/clustering/temp/#{input}_clustering_out.json"))
fh = JSON.parse(f)

return_array = []
fh.each do |key1, _value1|
  if key1 == 'id'

    fh[key1].each do |_key2, value2|
      temp = {}
      temp[key1] = value2
      return_array.append(temp)
    end
  else
    fh[key1].each do |_key2, value2|
      return_array.each do |each_h|
        each_h[key1] = value2
      end
    end
  end
end


puts return_array
