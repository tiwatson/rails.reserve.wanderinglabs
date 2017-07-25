module InitialImport::ReserveAmerica
  class Request
    def request
      request = Mechanize.new
      request.user_agent_alias = 'Windows Chrome'
      request
    end
  end
end
