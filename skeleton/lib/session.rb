require 'json'
require 'byebug'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    if req.cookies['_rails_lite_app'] 
      @cookie = JSON.parse(req.cookies['_rails_lite_app'])
    else
      @cookie = {}
    end
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
    # session[:session_token] = self.reset_session_token!
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie('_rails_lite_app', @cookie.to_json)
  end
  
  # def set_cookie(_rails_lite_app, attribute_hash)
  # 
  # end
end


