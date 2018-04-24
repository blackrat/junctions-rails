require 'test_helper'

class Junctions::Rails::Test < MiniTest::Spec
  describe Junctions::Rails do
    it 'is a module' do
      assert_kind_of Module, Junctions::Rails
    end
  end
end
