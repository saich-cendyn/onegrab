class Api::V1::EnquiriesController < Api::ApiController
  skip_before_action :authenticate_user!

  def create
    enquiry = Enquiry.new(enquiry_params)
    if enquiry.save
      render json: { message: "Enquiry received successfully." }, status: :created
    else
      render json: { errors: enquiry.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def enquiry_params
    params.require(:enquiry).permit(:name, :email, :phone, :subject, :message)
  end
end
