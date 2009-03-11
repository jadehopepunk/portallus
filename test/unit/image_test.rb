require File.dirname(__FILE__) + '/../test_helper'

class ImageTest < Test::Unit::TestCase
  fixtures :images

  def setup
    @image = Image.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Image,  @image
  end
end
