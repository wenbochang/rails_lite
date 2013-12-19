require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  # setup the controller
  def initialize(req, res, route_params = {})
    @already_rendered = false

    @req, @res = req, res

    @params = Params.new(req)
  end

  # populate the response with content
  # set the responses content type to the given type
  # later raise an error if the developer tries to double render
  def render_content(content, type)
    self.check_and_set_built_response_flag
    @res.body = content
    @res.content_type = type
  end

  def check_and_set_built_response_flag
    raise "Already built response" if already_rendered?
    @already_rendered = true
  end

  # helper method to alias @already_rendered
  def already_rendered?
    @already_rendered
  end

  # set the response status code and header
  def redirect_to(url)
    self.check_and_set_built_response_flag
    @res.set_redirect(WEBrick::HTTPStatus::TemporaryRedirect, url)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    input = File.read("views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
    template = ERB.new(input)

    render_content(template.result(binding), "text/html")
    @session.store_session(@res)
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
