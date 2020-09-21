require 'test_helper'

module Workarea
  module Klarna
    class Gateway
      class RequestTest < TestCase
        setup :clear_env, :configure_klarna_data, :payment
        teardown :reset_env

        def clear_env
          @env_na_username = ENV['WORKAREA_KLARNA_NA_USERNAME']
          @env_na_password = ENV['WORKAREA_KLARNA_NA_PASSWORD']
          @env_eur_username = ENV['WORKAREA_KLARNA_EUR_USERNAME']
          @env_eur_password = ENV['WORKAREA_KLARNA_EUR_PASSWORD']

          ENV.delete('WORKAREA_KLARNA_NA_USERNAME')
          ENV.delete('WORKAREA_KLARNA_NA_PASSWORD')
          ENV.delete('WORKAREA_KLARNA_EUR_USERNAME')
          ENV.delete('WORKAREA_KLARNA_EUR_PASSWORD')
        end

        def reset_env
          ENV['WORKAREA_KLARNA_NA_USERNAME'] = @env_na_username
          ENV['WORKAREA_KLARNA_NA_PASSWORD'] = @env_na_password
          ENV['WORKAREA_KLARNA_EUR_USERNAME'] = @env_eur_username
          ENV['WORKAREA_KLARNA_EUR_PASSWORD'] = @env_eur_password
        end

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

          ENV['WORKAREA_KLARNA_EUR_USERNAME'] = 'env_eur_user'
          assert_equal('env_eur_user', request.username)
        end

        def test_password
          assert_nil(request.password)

          payment.set_address(unsupported_address)
          assert_nil(request.password)

          payment.set_address(supported_na_address)
          assert_equal(Workarea.config.klarna_na_password, request.password)

          payment.set_address(supported_eur_address)
          assert_equal(Workarea.config.klarna_eur_password, request.password)

          ENV['WORKAREA_KLARNA_EUR_PASSWORD'] = 'env_eur_user'
          assert_equal('env_eur_user', request.password)
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
