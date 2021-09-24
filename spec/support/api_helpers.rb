module ApiHelpers
  def json_response
    @json ||= JSON.parse(response.body)
  end

  def do_request(method, path, options={})
    send method, path, options
  end
end