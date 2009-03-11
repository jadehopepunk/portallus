require 'test/unit'
require File.dirname(__FILE__) + '/../../lib/active_support/core_ext/exception'

class ExceptionExtTests < Test::Unit::TestCase
  
  def get_exception(cls = RuntimeError, msg = nil, trace = nil)
    begin raise cls, msg, (trace || caller)
    rescue Object => e
      return e
    end
  end
  
  def setup
    Exception::TraceSubstitutions.clear
  end
  
  def test_clean_backtrace
    Exception::TraceSubstitutions << [/\s*hidden.*/, '']
    e = get_exception RuntimeError, 'RAWR', ['bhal.rb', 'rawh hid den stuff is not here', 'almost all']
    assert_kind_of Exception, e
    assert_equal ['bhal.rb', 'rawh hid den stuff is not here', 'almost all'], e.clean_backtrace
  end
  
  def test_app_backtrace
    Exception::TraceSubstitutions << [/\s*hidden.*/, '']
    e = get_exception RuntimeError, 'RAWR', ['bhal.rb', ' vendor/file.rb some stuff', 'almost all']
    assert_kind_of Exception, e
    assert_equal ['bhal.rb', 'almost all'], e.application_backtrace
  end
  
  def test_app_backtrace_with_before
    Exception::TraceSubstitutions << [/\s*hidden.*/, '']
    e = get_exception RuntimeError, 'RAWR', ['vendor/file.rb some stuff', 'bhal.rb', ' vendor/file.rb some stuff', 'almost all']
    assert_kind_of Exception, e
    assert_equal ['vendor/file.rb some stuff', 'bhal.rb', 'almost all'], e.application_backtrace
  end

  def test_framework_backtrace_with_before
    Exception::TraceSubstitutions << [/\s*hidden.*/, '']
    e = get_exception RuntimeError, 'RAWR', ['vendor/file.rb some stuff', 'bhal.rb', ' vendor/file.rb some stuff', 'almost all']
    assert_kind_of Exception, e
    assert_equal ['vendor/file.rb some stuff', ' vendor/file.rb some stuff'], e.framework_backtrace
  end

  
end