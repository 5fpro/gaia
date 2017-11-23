class TaiwanImporter < BaseImporter
  attr_accessor :content

  def fetch
    @fetch ||= cities_with_dists
  end

  private

  def cities_with_dists
    cities = []
    array_cities.each do |city|
      dists = array_dists(city)
      cities << { city: city, dists: dists}
    end
    cities
  end

  def array_dists(city)
    city_name = city[:name]
    tmps = content.scan(/<tr align="center">.*?<td><b><a href="\/wiki\/[^"]+?" title="[^"]+">(.+?)<\/a>.+?<\/a>(.+?)<\/tr>/m)
    content = ''
    tmps.each { |tmp| content = tmp[1] if tmp[0] == city_name }
    if content.present?
      dists = []
      content.scan(/title="([^"]+)"( class="mw\-redirect")*>([^<]+)<\/a>/m).each do |tmp|
        dist_name = clean_name(tmp[2].force_encoding("UTF-8"))
        data = parse_dist_type_and_zip_code(city_name, dist_name)
        dists << { name: dist_name }.merge(data)
      end
      dists
    else
      raise "Dists not found: #{city[:name]}"
    end
  end

  def array_cities
    cities = []
    scans = content.scan(/<td><b><a href="\/wiki\/[^"]+?" title="([^"]+)"( class="mw\-redirect")*>/m)
    scans.each do |tmp|
      city_name = clean_name(ActiveSupport::JSON.decode("[\"#{tmp[0]}\"]").pop.force_encoding('UTF-8'))
      cities << {
        name: city_name,
        type_name: parse_city_type_name(city_name)
      }
    end
    cities
  end

  def parse_dist_type_and_zip_code(city_name, dist_name)
    res = content.scan(/<tr align="center">.+?<small>#{city_name}<\/small>.+?>#{dist_name}<.+?title="[^"]+">([^<]+)<\/a>.+?<td>([0-9]+)<\/td>[\n\r]+<\/tr>/m).first
    { type_name: res[0], zip_code: res[1] }
  end

  def parse_city_type_name(city_name)
    begin
      content.scan(/<h2><span id="([^"]+)">.+?<\/h2>.+?<table class="wikitable">.+?<th width="80">名稱<.+?>#{city_name}<.+?<\/table>/m).first.first
    rescue
      raise "Parse city type name fail: #{city_name}"
    end
  end

  def content
    @content ||= -> do
      url = "https://zh.wikipedia.org/wiki/%E4%B8%AD%E8%8F%AF%E6%B0%91%E5%9C%8B%E5%8F%B0%E7%81%A3%E5%9C%B0%E5%8D%80%E9%84%89%E9%8E%AE%E5%B8%82%E5%8D%80%E5%88%97%E8%A1%A8"
      c = request_get(url).force_encoding('UTF-8')
      c[c.index('id="行政區數量"')..(c.index('id="参考文献"'))]
    end.call
  end

  def clean_name(name)
    name.scan(/([^ \(]+)/)[0][0]
  end
end
