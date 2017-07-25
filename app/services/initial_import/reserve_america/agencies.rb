module InitialImport::ReserveAmerica
  class Agencies
    BASE_URL = 'http://www.reserveamerica.com'.freeze
    DIRECTORY_URL = 'http://www.reserveamerica.com/campgroundDirectory.do'.freeze

    def self.import
      new.import
    end

    def import
      list.each do |agency|
        attrs = {
          name: agency[0],
          details: {
            provider: 'Reserve America',
            url: BASE_URL + agency[1],
          },
        }
        Agency.where(name: attrs[:name]).first_or_create(attrs)
      end
    end

    def list
      directory_page.css('a')
        .select { |a| a['href'].include?('contractCode') && !a['href'].include?('NRSO') }
        .map { |a| [a.text, a['href']] }
    end

    def directory_page
      request.get(DIRECTORY_URL)
      request.page.parser
    end

    def request
      @resquest ||= Request.new.request
    end
  end
end
