/**
 * @namespace WORKAREA.klarnaWidget
 */
WORKAREA.registerModule('klarnaWidget', (function () {
    'use strict';

    var authorizePayment = function(session, event) {
            var $submitButton = $(event.target),
                $form = $submitButton.closest('form'),
                $selectedPayment = $form.find('input[name=payment]:checked'),
                paymentCategory = $selectedPayment.data('paymentCategory');

            if (_.isEmpty(paymentCategory)) { return; }

            event.preventDefault();

            Klarna.Payments.authorize(
                {
                    payment_method_category: paymentCategory
                },
                session.order,
                function(res) {
                    console.log(res);

                    if (res.approved && res.show_form) {
                        $form.find('#klarna_authorization_token').val(res.authorization_token);
                        $submitButton
                        .removeAttr('disabled')
                        .trigger('click');

                    } else if (res.show_form) {
                        setupListener($form, session);

                        $submitButton
                        .removeAttr('disabled')
                        .text(I18n.t('workarea.storefront.checkouts.place_order'));

                        // render message
                    } else {
                        setupListener($form, session);

                        // remove option and render message
                    }
                }
            )
        },

        setupWidget = function(session, payment) {
            var $payment = $(payment);

            Klarna.Payments.load(
                {
                    container: '#' + $payment.prop('id'),
                    payment_method_category: $payment.data('klarnaPayment')
                },
                _.omit(session.order, 'shipping_address', 'billing_address'),
                function(res) {
                    if ( ! res.show_form) {
                        $payment
                            .closest('.checkout-payment__primary-method')
                            .remove();
                    }
                }
            )
        },

        setupListener = function($form, session) {
            $form.one('click', '[type=submit]', _.partial(authorizePayment, session));
        },

        /**
         * @method
         * @name init
         * @memberof WORKAREA.klarnaWidget
         */
        init = function () {
            var $container = $('[data-klarna-session]'),
                session = $container.data('klarnaSession'),
                $payments = $('[data-klarna-payment]');

            if (session === undefined || _.isEmpty($payments)) {
                return;
            }

            Klarna.Payments.init({ client_token: session.client_token });

            _.each($payments, _.partial(setupWidget, session));

            setupListener($container.closest('form'), session);
        };


    window.klarnaAsyncCallback = init
}()));
