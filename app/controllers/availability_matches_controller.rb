class AvailabilityMatchesController < ApplicationController
  def index
    availability_request = AvailabilityRequest.find_by_uuid(params[:availability_request_id])
    @availability_matches = availability_request.availability_matches
    render json: @availability_matches
  end

  def click
    match = AvailabilityMatch.find_by_base62(params[:id])
    RecordClick.new(match, params[:from] || :w).perform
    render json: match
  end
end
