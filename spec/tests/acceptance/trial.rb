require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'
require_relative '../../helpers/acceptance_helper'
require 'cgi'
require 'rack/test'
# abc = {'city'=> '新竹'}
PARAMS_DEFAULT = {'city'=> '新竹'}
abc = PARAMS_DEFAULT.dup
city_request = CafeMap::Request::EncodedCityName.new(abc)

puts "city_request: #{city_request}" # Success("新竹")
store_made = CafeMap::Service::AddCafe.new.call(city_request: city_request)

# puts   "\n store_mad: \n#{store_made}"
# puts "\n\n methods? \n #{store_made.methods}"
# [:success?, :inspect, :to_maybe, :to_s, :failure?, :to_validated, :success, 
# :result, :fmap, :either, :flip, :alt_map, :==, :eql?, :hash, :flatten, :deconstruct_keys, :deconstruct, :bind, 
# :discard, :apply, :===, :tee, :value!, :and, :or, :or_fmap, :|, :value_or, :to_result, :to_monad, :monad, :failure, 
#:fmap2, :fmap3, :pry, :__binding__, :stub, :to_yaml, :pretty_print_cycle, :pretty_print_inspect, :pretty_print, 
#:pretty_print_instance_variables, :must_be_empty, :must_equal, :must_be_close_to, :must_be_within_delta, :must_be_within_epsilon,
 #:must_include, :must_be_instance_of, :must_be_kind_of, :must_match, :must_be_nil, :must_be, :must_output, :must_raise,
  #:must_respond_to, :must_be_same_as, :must_be_silent, :must_throw, :path_must_exist, :path_wont_exist, :wont_be_empty,
   #:wont_equal, :wont_be_close_to, :wont_be_within_delta, :wont_be_within_epsilon, :wont_include, :wont_be_instance_of, 
   #:wont_be_kind_of, :wont_match, :wont_be_nil, :wont_be, :wont_respond_to, :wont_be_same_as, :to_json, :singleton_class, 
#:dup, :itself, :taint, :tainted?, :untaint, :untrust, :untrusted?, :trust, :methods, :singleton_methods, :protected_methods,
##:private_methods, :public_methods, :instance_variables, :instance_variable_get, :instance_variable_set, 
##:instance_variable_defined?, :remove_instance_variable, :instance_of?, :kind_of?, :is_a?, :display, :public_send, :class,
##:frozen?, :tap, :then, :extend, :yield_self, :clone, :pretty_inspect, :method, :public_method, :singleton_method, :<=>, :define_singleton_method, :=~, :!~, :nil?, :respond_to?, :freeze, 
# :object_id, :send, :to_enum, :enum_for, :__send__, :!, :__id__, :instance_eval, :instance_exec, :!=, :equal?]

puts "\n\n class? \n #{store_made.class}"
# # puts "\n\n value? \n #{store_made.value!}"

# # puts "\n\n success? \n #{store_made.success?}" #true

puts "\n\n method of  store_made.value!: \n #{store_made.value!.methods}"
# puts "\n\n store_made.status:  \n #{store_made.value!.status}"
# puts "\n\n store_made.message:  \n #{store_made.value!.message}" # error: Undefined method "message"

puts "\n\n\n"
puts "\n\n method of  store_made.value!: \n #{store_made.methods}"
puts "\n\n method of  store_made.nil?: \n #{store_made.nil?}" #false
puts "\n\n method of  store_made.frozen?: \n #{store_made.frozen?}" #false
