require 'test_helper'

module Workarea
  module Klarna
    class Gateway
      class RequestTest < TestCase
        setup :configure_klarna_data, :payment

        def order
          @order ||= create_order
        end

        def payment
          @payment ||= create_payment(id: order.id)
        end

        def request
          Request.new(order)
        end

        def test_validate!
          assert_raises(Gateway::ContinentNotSupported) { request.validate! }

          payment.set_address(unsupported_address)
          assert_raises(Gateway::ContinentNotSupported) { request.validate! }

          payment.set_address(supported_na_address)
          assert_nothing_raised { request.validate! }

          Workarea.config.klarna_na_password = nil
          assert_raises(Gateway::ContinentNotSupported) { request.validate! }
        end

        def test_username
          assert_nil(request.username)

          payment.set_address(unsupported_address)
          assert_nil(request.username)

          payment.set_address(supported_na_address)
          assert_equal(Workarea.config.klarna_na_username, request.username)

          payment.set_address(supported_eur_address)
          assert_equal(Workarea.config.klarna_eur_username, request.username)

          @env_eur_user = ENV['WORKAREA_KLARNA_EUR_USERNAME']
          ENV['WORKAREA_KLARNA_EUR_USERNAME'] = 'env_eur_user'
          assert_equal('env_eur_user', request.username)
        ensure
          ENV['WORKAREA_KLARNA_EUR_USERNAME'] = @env_eur_user
        end

        def test_password
          assert_nil(request.password)

          payment.set_address(unsupported_address)
          assert_nil(request.password)

          payment.set_address(supported_na_address)
          assert_equal(Workarea.config.klarna_na_password, request.password)

          payment.set_address(supported_eur_address)
          assert_equal(Workarea.config.klarna_eur_password, request.password)

          @env_eur_pass = ENV['WORKAREA_KLARNA_EUR_PASSWORD']
          ENV['WORKAREA_KLARNA_EUR_PASSWORD'] = 'env_eur_user'
          assert_equal('env_eur_user', request.password)
        ensure
          ENV['WORKAREA_KLARNA_EUR_PASSWORD'] = @env_eur_pass
        end

        def test_continent_key
          assert_nil(request.continent_key)

          payment.set_address(unsupported_address)
          assert_nil(request.continent_key)

          payment.set_address(supported_na_address)
          assert_equal('NA', request.continent_key)

          payment.set_address(supported_eur_address)
          assert_equal('EUR', request.continent_key)
        end
      end
    end
  end
end
