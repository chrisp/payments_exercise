class PaymentsController < ActionController::API

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render json: 'bad_request', status: :bad_request
  end

  def create
    payment = Payment.create!(
      create_params)
    render json: payment
  end

  private

  def create_params
    params.permit(:amount, :loan_id)
  end
end
