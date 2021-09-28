# frozen_string_literal: true

require 'rack/test'
require 'json'
require_relative '../../app/api'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API' do
    include Rack::Test::Methods

    def app
      ExpenseTracker::API.new
    end

    def post_expense(_espense)
      post '/expenses', JSON.generate(coffee)
      expect(last_response.status).to eq(200)

      parsed = JSON.parse(last_response.body)

      expect(parsed).to include('expense_id' => a_kind_of(Integer))
    end

    context 'testing' do
      let(:coffee) do
        {
          'payee' => 'Starbucks',
          'amount' => 5.75,
          'date' => '2017-06-10'
        }
      end
      let(:zoo) do
        {
          'payee' => 'Mugs',
          'amount' => 15.75,
          'date' => '2017-06-10'
        }
      end

      it 'records submitted expenses' do
        post_expense(coffee)
        post_expense(zoo)
        get '/expenses/2017-06-10'
		
		pending 'Need to persist expenses'
        expect(last_response.status).to eq(200)
        expect(last_response.body).to contain_exactly(zoo, coffee)

        # expect(response)
      end
    end
  end
end
