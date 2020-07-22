require 'test_helper'

module Workarea
  class Payment
    class Tender
      class KlarnaTest < TestCase
        def test_authorization_token_expired?
          tender = Klarna.new
          refute(tender.authorization_token_expired?)

          tender.authorization_token = '123'
          refute(tender.authorization_token_expired?)

          travel_to 61.minutes.from_now

          assert(tender.authorization_token_expired?)

          tender.authorization_token = '123'
          assert(tender.authorization_token_expired?)

          tender.authorization_token = '456'
          refute(tender.authorization_token_expired?)
        ensure
          travel_back
        end

        def test_clear_authorization!
          payment = Payment.new(klarna: { authorization_token: '123' })
          tender = payment.klarna

          assert(tender.authorization_token.present?)
          assert(tender.authorization_token_expires_at.present?)

          tender.clear_authorization!

          refute(tender.authorization_token.present?)
          refute(tender.authorization_token_expires_at.present?)
        end

        def test_placed_order_data
          payment = Payment.new(
            klarna: { authorization_token: '123', amount: 5.to_m }
          )
          tender = payment.klarna

          refute(tender.placed_order_data.present?)
          assert_nil(tender.order_id)
          assert_nil(tender.redirect_url)

          txn = payment.klarna.build_transaction(action: 'purchase')
          txn.update!(
            success: true,
            response: ActiveMerchant::Billing::Response.new(
              true,
              'foo bar',
              { 'order_id' => '111', 'redirect_url' => '/test-purchase' }
            )
          )

          assert(tender.placed_order_data.present?)
          assert_equal('111', tender.order_id)
          assert_equal('/test-purchase', tender.redirect_url)

          txn = payment.klarna.build_transaction(action: 'authorize')
          txn.update!(
            success: true,
            response: ActiveMerchant::Billing::Response.new(
              true,
              'foo bar',
              { 'order_id' => '222', 'redirect_url' => '/test-capture' }
            )
          )

          assert(tender.placed_order_data.present?)
          assert_equal('222', tender.order_id)
          assert_equal('/test-capture', tender.redirect_url)
        end
      end
    end
  end
end
