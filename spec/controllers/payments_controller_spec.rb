require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  describe '#create' do
    context 'with invalid data' do 
      it 'responds with 400 - Bad Request' do
        post :create, params: { 
          amount: '10',
          loan_id: 0 }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'with valid data' do 
      let(:loan) { Loan.create!(funded_amount: 100.0) }

      it 'responds with 200 - OK' do
        post :create, params: {
          amount: '10',
          loan_id: loan.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
