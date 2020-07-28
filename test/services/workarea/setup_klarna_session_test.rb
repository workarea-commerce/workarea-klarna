require 'test_helper'

module Workarea
  class SetupKlarnaSessionTest < TestCase
    setup :configure_klarna_data

    def test_perform
      klarna_gateway_class.any_instance.expects(:create_session).never

      order = create_order
      checkout = Checkout.new(order)

      SetupKlarnaSession.new(checkout).perform

      checkout.payment.build_address(unsupported_address)
      assert(checkout.payment.address.valid?)

      SetupKlarnaSession.new(checkout).perform

      checkout.payment.address.attributes = supported_eur_address

      klarna_gateway_class
        .any_instance
        .expects(:create_session)
        .once
        .returns(OpenStruct.new(success?: true, body: { session_id: '123' }))

      SetupKlarnaSession.new(checkout).perform

      session = Payment::KlarnaSession.find(order.id)
      assert_equal('123', session.session_id)

      klarna_gateway_class
        .any_instance
        .expects(:update_session)
        .once
        .with(order, session.session_id)

      SetupKlarnaSession.new(checkout).perform
    end
  end
end
