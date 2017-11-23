class BaseImporter
  def fetch
    raise NotImplementedError
  end

  def import!
    filename = Rails.root.join('db', 'countries', self.class.to_s.underscore.gsub('_importer', '') + '.json')
    IO.write(filename, fetch.to_json)
  end

  private

  def request_get(url)
    response = Net::HTTP.get_response(URI.parse(url))
    response.body
  end

end
