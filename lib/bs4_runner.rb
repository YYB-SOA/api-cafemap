# result = exec("python lib/script.py params")
# result
# params1 = 1
# params2 = 2
# system 'python script.py', *[params1, params2] 

store_name = "那家咖啡廳"
output = %x[python lib/bs4_scraper.ipynb store_name]
puts output