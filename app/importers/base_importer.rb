class BaseImporter
  def fetch
    raise NotImplementedError
  end

  def import!
    IO.write(filename, fetch.to_json)
  end

  def read
    IO.read(filename)
  end

  private

  def filename
    Rails.root.join('db', 'countries', self.class.to_s.underscore.gsub('_importer', '') + '.json')
  end

  def request_get(url)
    response = Net::HTTP.get_response(URI.parse(url))
    response.body
  end

end
