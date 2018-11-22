require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'byebug'
require 'active_support/inflector'

require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
    @already_built_response = false
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url, status_code = 302)
    if already_built_response?
      raise 'cannot have two redirects'
    else
      @res['Location'] = url
      @res.status = status_code
      @already_built_response = true
      session.store_session(@res)
    end
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type = 'text/html')
    if already_built_response?
      raise 'cannot have two renders'
    else
      @res['Content-Type'] = content_type
      @res.write(content)
      @already_built_response = true
      session.store_session(@res)
    end
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    if already_built_response?
      raise 'cannot render twice'
    else
      dir_path = File.dirname(__FILE__)
      template_path = File.join(
        dir_path, "../views/#{self.class.name.underscore}/#{template_name}.html.erb"
      )

      template_code = File.read(template_path)

      render_content(
        ERB.new(template_code).result(binding),
        "text/html"
      )
      @already_built_response = true
    end
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

