module InitialImport::ReserveAmerica
  class FacilitiesListings
    attr_accessor :url

    def initialize(url)
      @url = url
    end

    def doc
      get.parser
    end

    def get
      request.get(url)
    end

    def listings
      doc.css('tr.br')
    end

    def facilities
      listings.map { |listing| FacilityParse.new(listing).details }
    end

    def request
      @resquest ||= Request.new.request
    end
  end
end
