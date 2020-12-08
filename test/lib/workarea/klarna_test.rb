require 'test_helper'

module Workarea
  class KlarnaTest < TestCase
    def test_on_site_messaging_client_id
      @_kosm_env = ENV['WORKAREA_KLARNA_ON_SITE_MESSAGING_CLIENT_ID']
      @_kosm_cred = Rails.application.credentials.klarna

      ENV['WORKAREA_KLARNA_ON_SITE_MESSAGING_CLIENT_ID'] = nil
      Rails.application.credentials.klarna = nil
      Workarea.config.klarna_on_site_messaging_client_id = nil

      assert_nil(Klarna.on_site_messaging_client_id)
      refute(Klarna.on_site_messaging?)

      Workarea.config.klarna_on_site_messaging_client_id = 'config_123'
      assert_equal('config_123', Klarna.on_site_messaging_client_id)
      assert(Klarna.on_site_messaging?)

      Rails.application.credentials.klarna = { on_site_messaging_client_id: 'cred_123' }
      assert_equal('cred_123', Klarna.on_site_messaging_client_id)
      assert(Klarna.on_site_messaging?)

      ENV['WORKAREA_KLARNA_ON_SITE_MESSAGING_CLIENT_ID'] = 'env_123'
      assert_equal('env_123', Klarna.on_site_messaging_client_id)
      assert(Klarna.on_site_messaging?)
    ensure
      ENV['WORKAREA_KLARNA_ON_SITE_MESSAGING_CLIENT_ID'] = @_kosm_env
      Rails.application.credentials.klarna = @_kosm_cred
    end
  end
end
