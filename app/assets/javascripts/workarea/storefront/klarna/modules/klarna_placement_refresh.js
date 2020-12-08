/**
 * @namespace WORKAREA.klarnaPlacementRefresh
 */
WORKAREA.registerModule('klarnaPlacementRefresh', (function () {
    'use strict';

    /**
     * @method
     * @name init
     * @memberof WORKAREA.klarnaPlacementRefresh
     */
    var init = function () {
            var $placements = $('[data-klarna-placement-refresh]');

            if (_.isEmpty($placements)) { return; }

            window.KlarnaOnsiteService = window.KlarnaOnsiteService || [];
            window.KlarnaOnsiteService.push({ eventName: 'refresh-placements' });
        };

    return { init: init };
}()));
