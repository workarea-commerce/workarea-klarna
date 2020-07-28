require 'test_helper'

module Workarea
  class Payment
    module Authorize
      class KlarnaTest < TestCase
        setup :create_supporting_data_for_klarna, :add_tender, :enable_klarna

        def add_tender
          # this auth token will need to be an active one if you want to
          # regenerate the VCR cassette.
          create_klarna_tender(
            payment: @payment,
            authorization_token: '31ae5ab6-d4d5-145f-b71b-36cd8404c5ba',
            payment_method_category: 'pay_later'
          )
        end

        def test_operation
          txn = @payment.klarna.build_transaction(action: 'authorize')
          operation = Authorize::Klarna.new(@payment.klarna, txn)

          VCR.use_cassette('klarna_authorize') do
            operation.complete!
          end

          assert(txn.success?)
          assert(txn.response.params['order_id'].present?)
          assert(txn.response.params['redirect_url'].present?)
        end
      end
    end
  end
end
