require 'test_helper'

module Workarea
  class KlarnaTest < TestCase
    def test_plugin
      assert(Workarea.const_defined?('Klarna'))
    end
  end
end
