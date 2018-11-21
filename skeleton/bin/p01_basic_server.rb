require 'rack'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  res['Content-Type'] = 'text/html'
  if req.path == "/i/love/app/academy"
    res.write("/i/love/app/academy")
  else
    res.write("Hello savio!")
  end
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)

# This is how we start a server; same as running 'rails server'
# class MyRackApp
  # def self.call(env)
#     req = Rack::Request.new(env)
#     res = Rack::Response.new
# 
#     if req.path == "/cats"
#       res.write("Hello cats!")
#     else
#       res.write("Hello world!")
#     end
#     res.finish
#   end
# end


# class MyController
# 
#   def execute(req, res)
#     if req.path == "/i/love/app/academy"
#       res.write("Not really")
#     else
#       res.write("Wrong input")
#     end
#   end
# 
# end
  