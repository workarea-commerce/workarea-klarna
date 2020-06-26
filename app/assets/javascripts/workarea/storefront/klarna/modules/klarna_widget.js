/**
 * @namespace WORKAREA.klarnaWidget
 */
WORKAREA.registerModule('klarnaWidget', (function () {
    'use strict';

    var setupWidget = function(session, payment) {
            var $payment = $(payment);

            Klarna.Payments.load(
                {
                    container: '#' + $payment.prop('id'),
                    payment_method_category: $payment.data('klarnaPayment')
                },
                // session.order,
                function(res) {
                    if ( ! res.show_form) {
                        $payment
                            .closest('.checkout-payment__primary-method')
                            .remove();
                    }
                }
            )
        },

        /**
         * @method
         * @name init
         * @memberof WORKAREA.klarnaWidget
         */
        init = function () {
            var session = $('[data-klarna-session]').data('klarnaSession'),
                $payments = $('[data-klarna-payment]');

            if (_.isEmpty(session.client_token) || _.isEmpty($payments)) {
                return;
            }

            Klarna.Payments.init({ client_token: session.client_token });

            _.each($payments, _.partial(setupWidget, session));
        };


    window.klarnaAsyncCallback = init
}()));
