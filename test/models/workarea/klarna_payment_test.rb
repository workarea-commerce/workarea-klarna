require 'test_helper'

module Workarea
  class KlarnaPaymentTest < TestCase
    setup :configure_klarna_countries

    def test_set_klarna
      payment = Payment.new

      assert_nil(payment.klarna)

      payment.set_klarna(
        authorization_token: '234',
        authorization_token_expires_at: 1.hour.from_now,
        payment_method_category: 'pay_later',
        amount: 10000000.to_m
      )

      assert(payment.klarna.present?)
      assert_equal('234', payment.klarna.authorization_token)
      assert(payment.klarna.authorization_token_expires_at.present?)
      assert_equal('pay_later', payment.klarna.payment_method_category)
      assert_equal(0.to_m, payment.klarna.amount)

      payment.clear_klarna
      assert_nil(payment.klarna)
    end

    def test_eligible_for_klarna?
      payment = Payment.new

      refute(payment.eligible_for_klarna?)

      payment.build_address(brazilian_address)

      assert(payment.address.valid?)
      refute(payment.eligible_for_klarna?)

      payment.address.attributes = german_address

      assert(payment.address.valid?)
      assert(payment.eligible_for_klarna?)
    end
  end
end
