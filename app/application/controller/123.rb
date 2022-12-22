require "roda"

# class App < Roda
#     route do |r|
#       # GET /
#       r.root do
#         "Home"
#       end
  
#       # GET /about
#       r.get "about" do
#         "About"
#       end
  
#       # GET /post/2011/02/16/hello
#       r.get "post", Integer, Integer, Integer, String do |year, month, day, slug|
#         "#{year}-#{month}-#{day} #{slug}" #=> "2011-02-16 hello"
#       end
  
#       # GET /username/foobar branch
#       r.on "username", String, method: :get do |username|
#         user = User.find_by_username(username)
  
#         # GET /username/foobar/posts
#         r.is "posts" do
#           # You can access user here, because the blocks are closures.
#           "Total Posts: #{user.posts.size}" #=> "Total Posts: 6"
#         end
  
#         # GET /username/foobar/following
#         r.is "following" do
#           user.following.size.to_s #=> "1301"
#         end
#       end
  
#       # /search?q=barbaz
#       r.get "search" do
#         "Searched for #{r.params['q']}" #=> "Searched for barbaz"
#       end
  
#       r.is "login" do
#         # GET /login
#         r.get do
#           "Login"
#         end
  
#         # POST /login?user=foo&password=baz
#         r.post do
#           "#{r.params['user']}:#{r.params['password']}" #=> "foo:baz"
#         end
#       end
#     end
#   end
