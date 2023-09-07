module ControllerHelpers
  def parsed_response
    JSON.parse(response.body)
  end

  def sign_in(resource)
    super
  end

  def set_headers
    headers = {
      "accept"       => "application/json",
      "content-type" => "application/json"
    }
    subject.request.headers.merge(headers)
  end
end
