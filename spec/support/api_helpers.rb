module ApiHelpers
  def json_response
    @json ||= JSON.parse(response.body)
  end
end