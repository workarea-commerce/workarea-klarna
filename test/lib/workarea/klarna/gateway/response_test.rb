require 'test_helper'

module Workarea
  module Klarna
    class Gateway
      class ResponseTest < TestCase
        def order
          @order ||= create_order
        end

        def request
          Request.new(order)
        end

        def test_body
          response = Response.new(request, nil)
          assert_equal({}, response.body)
          assert_equal({}, response.params)

          response = Response.new(
            request,
            OpenStruct.new(body: { foo: 'bar' }.to_json)
          )
          assert_equal({ 'foo' => 'bar' }, response.body)
          assert_equal({ 'foo' => 'bar' }, response.params)
        end

        def test_success?
          response = Response.new(request, nil)
          refute(response.success?)

          response = Response.new(request, OpenStruct.new(status: 404))
          refute(response.success?)

          response = Response.new(request, OpenStruct.new(status: 200))
          assert(response.success?)
        end

        def test_message
          response = Response.new(request, nil)
          assert_equal(
            t('workarea.klarna.gateway.response.failure', summary: ''),
            response.message
          )

          response = Response.new(
            request,
            OpenStruct.new(
              status: 500,
              body: {
                error_messages: ['address is invalid', 'tax rate missing']
              }.to_json
            )
          )
          assert_equal(
            t(
              'workarea.klarna.gateway.response.failure',
              summary: 'address is invalid. tax rate missing'
            ),
            response.message
          )

          response = Response.new(request, OpenStruct.new(status: 204))
          assert_equal(
            t(
              'workarea.klarna.gateway.response.success',
              summary: t('workarea.klarna.gateway.request.base')
            ),
            response.message
          )
        end
      end
    end
  end
end
