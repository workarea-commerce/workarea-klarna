require 'test_helper'

module Workarea
  class Payment
    class Capture
      class KlarnaTest < TestCase
        setup :enable_klarna

        def test_operation
          payment = create_payment(
            address: supported_na_address,
            klarna: { amount: 10.to_m }
          )

          # You will need a valid order_id if you want to regenerate the
          # VCR cassettes for this test.
          payment.klarna.stubs(:order_id).returns('1dab0505-d1d5-1041-ac57-5ffda5af139c')

          txn = payment.klarna.build_transaction(amount: 5.to_m, action: 'capture')
          operation = Capture::Klarna.new(payment.klarna, txn)

          VCR.use_cassette('klarna_capture') do
            operation.complete!
          end

          assert(txn.success?)
          assert_equal(
            t(
              'workarea.klarna.gateway.response.success',
              summary: t('workarea.klarna.gateway.request.capture', amount: 5.to_m.format)
            ),
            txn.response.message
          )

          VCR.use_cassette('klarna_refund') do
            operation.cancel!
          end

          assert(txn.cancellation.success?)
          assert_equal(
            t(
              'workarea.klarna.gateway.response.success',
              summary: t('workarea.klarna.gateway.request.refund', amount: 5.to_m.format)
            ),
            txn.cancellation.message
          )
        end
      end
    end
  end
end
