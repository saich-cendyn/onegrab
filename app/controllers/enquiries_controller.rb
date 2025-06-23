class EnquiriesController < ApplicationController
  def index
    @pagy, @enquiries = pagy(Enquiry.order(created_at: :desc))
  end

  def show
    @enquiry = Enquiry.find(params.expect(:id))
  end
end
