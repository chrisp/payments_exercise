require 'rails_helper'

RSpec.describe LoansController, type: :controller do
  describe '#index' do
    context 'without data' do
      it 'responds with a 200' do
        get :index
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with loans and payment' do
      let!(:loan) { Loan.create!(
        funded_amount: 100.0) }
      let!(:payment) { Payment.create!(
        amount: 10.0, loan: loan) }

      it 'should contain loans with payment data' do
        get :index
        parsed_loans = JSON.parse(response.body)
        expect(parsed_loans[0]['funded_amount']).
          to eq(loan.funded_amount.to_s)
      end
    end

    context 'with loans and payment' do
      let!(:loan) { Loan.create!(
        funded_amount: 100.0) }
      let!(:loan2) { Loan.create!(
        funded_amount: 80.0) }

      it 'should contain loans with payment data' do
        get :index
        parsed_loans = JSON.parse(response.body)
        expect(parsed_loans.length).to eq(2)
      end
    end
  end

  describe '#show' do
    context 'without payment' do
      let(:loan) { Loan.create!(
        funded_amount: 100.0) }
  
      it 'responds with a 200' do
        get :show, params: { id: loan.id }
        expect(response).to have_http_status(:ok)
      end
  
      context 'if the loan is not found' do
        it 'responds with a 404' do
          get :show, params: { id: 10000 }
          expect(response).
            to have_http_status(:not_found)
        end
      end
    end

    context 'with payment' do
      let(:loan) { Loan.create!(
        funded_amount: 100.0) }
      let(:payment) { Payment.create!(
        amount: 10.0, loan: loan) }
      
      it 'sould return a balance of 90' do
        # be sure to get the loan attached to payment
        get :show, params: { id: payment.loan.id }

        loan_response = JSON.parse(response.body)
        expect(loan_response['remaining_amount']).
          to eq('90.0')
      end
    end
  end
end
