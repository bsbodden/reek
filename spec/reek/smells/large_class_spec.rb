require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'reek/code_parser'
require 'reek/report'
require 'reek/smells/large_class'

include Reek
include Reek::Smells

describe LargeClass do

  class BigOne
    26.times do |i|
      define_method "method#{i}".to_sym do
        @melting
      end
    end
  end

  before(:each) do
    @rpt = Report.new
    @cchk = CodeParser.new(@rpt)
  end

  it 'should not report short class' do
    class ShortClass
      def method1() @var1; end
      def method2() @var2; end
      def method3() @var3; end
      def method4() @var4; end
      def method5() @var5; end
      def method6() @var6; end
    end
    @cchk.check_object(ShortClass)
    @rpt.should be_empty
  end

  it 'should report large class' do
    @cchk.check_object(BigOne)
    @rpt.length.should == 1
  end

  it 'should report class name' do
    @cchk.check_object(BigOne)
    @rpt[0].report.should match(/BigOne/)
  end
end