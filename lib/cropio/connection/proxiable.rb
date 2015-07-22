module Cropio::Connection::Proxiable
  def get(resource, query)
    JSON.parse RestClient.get(url_for(resource), query, headers)
  end
  authenticate_before :get

  def post(resource, data)
    JSON.parse RestClient.post(url_for(resource), data.to_json, headers)
  end
  authenticate_before :post

  def patch(resource, data)
    JSON.parse RestClient.patch(url_for(resource), data.to_json, headers)
  end
  authenticate_before :patch

  def delete(resource)
    JSON.parse RestClient.delete(url_for(resource), headers)
  end
  authenticate_before :delete

  protected

  def url_for(resource)
    "#{BASE_URL}/resource"
  end
end
