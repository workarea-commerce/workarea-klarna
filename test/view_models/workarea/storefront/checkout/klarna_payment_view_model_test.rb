require 'test_helper'

module Workarea
  module Storefront
    module Checkout
      class KlarnaPaymentViewModelTest < TestCase
        setup :configure_klarna_data
        delegate :order, :payment, to: :checkout

        def checkout
          @checkout ||= Workarea::Checkout.new(create_order)
        end

        def step
          Workarea::Checkout::Steps::Payment.new(checkout)
        end

        def view_model
          PaymentViewModel.new(step)
        end

        def test_offer_klarna_payments?
          refute(view_model.offer_klarna_payments?)

          payment.build_address(supported_eur_address)
          refute(view_model.offer_klarna_payments?)

          create_klarna_session(id: order.id)
          assert(view_model.offer_klarna_payments?)
        end

        def test_klarna_selected?
          refute(view_model.klarna_selected?)

          payment.set_klarna(authorization_token: '123')
          assert(view_model.klarna_selected?)
        end

        def test_klarna_payment_category_selected?
          refute(view_model.klarna_payment_category_selected?('pay_later'))

          payment.set_klarna(authorization_token: '123')
          refute(view_model.klarna_payment_category_selected?('pay_later'))

          payment.klarna.payment_method_category = 'pay_later'
          assert(view_model.klarna_payment_category_selected?('pay_later'))
          refute(view_model.klarna_payment_category_selected?('pay_now'))
        end

        def test_klarna_expired?
          refute(view_model.klarna_expired?)

          payment.set_klarna(authorization_token: '123')
          refute(view_model.klarna_expired?)

          payment.klarna.authorization_token_expires_at = 1.minutes.ago
          assert(view_model.klarna_expired?)
        end
      end
    end
  end
end
