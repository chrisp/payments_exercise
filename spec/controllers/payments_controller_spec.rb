require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  describe '#show' do
    context 'with a valid payment' do
      let(:loan) { Loan.create!(
        funded_amount: 100.0) }
      let(:payment) { Payment.create!(
        amount: 10.0, loan: loan) }

      it 'responds with a 200 - OK' do
        get :show, params: { id: payment.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#all' do
    context 'with a valid payment' do
      let(:loan) { Loan.create!(
        funded_amount: 100.0) }
      let(:loan2) { Loan.create!(
        funded_amount: 80.0) }
      let(:payment) { Payment.create!(
        amount: 10.0, loan: loan) }

      it 'responds with a 200 - OK' do
        get :index
        expect(response).to have_http_status(:ok)
      end
    end
  end

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

      it 'deducts the paid amount' do
        post :create, params: {
          amount: '10',
          loan_id: loan.id }
        loan.reload
        expect(loan.remaining_amount).to eq(90)
      end

      it 'can not overpay' do
        post :create, params: {
          amount: '110',
          loan_id: loan.id }
        loan.reload
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq(
          "Validation failed: Amount over remaining amount")
      end
    end
  end
end
